"""
Lethe Logistics - User Provisioning Script
Uses service_role key for Auth Admin API + publishable key for DB access.
Creates REAL Supabase Auth users for: Retailer, Distributor, Compliance, SysAdmin.
"""
import sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

from supabase import create_client

URL = "https://pvfbxhorkihgmldzlfkv.supabase.co"
SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB2ZmJ4aG9ya2loZ21sZHpsZmt2Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3NTUzMzg5NSwiZXhwIjoyMDkxMTA5ODk1fQ.TBjDReeZeykTwpbvLer0fRhP_fUh4nmmX8bzUq47djg"
PUBLISHABLE_KEY = "sb_publishable_Qpa2po0RC3uofGsQsVlVjA_KnUZYhwU"

# Admin client -> for auth.admin operations (create user, confirm email)
admin_client = create_client(URL, SERVICE_KEY)
# DB client -> for identity_mod schema reads/writes
db_client = create_client(URL, PUBLISHABLE_KEY)

# ──────────────────────────────────────────────
# Step 1: Fetch reference data from DB
# ──────────────────────────────────────────────
print("=" * 60)
print("STEP 1: Fetching Organizations & Roles")
print("=" * 60)

orgs = db_client.schema("identity_mod").table("organisations").select("*").execute().data
roles = db_client.schema("identity_mod").table("roles").select("*").execute().data

print("\n  Organizations:")
for o in orgs:
    status = "[ACTIVE]" if o["is_active"] else "[INACTIVE]"
    print(f"    {status:10s} {o['org_name']:<40s} type={o['org_type']}")

print("\n  Roles:")
for r in roles:
    print(f"    {r['role_name']:<30s} id={r['role_id']}")

role_map = {r["role_name"]: r["role_id"] for r in roles}

# ──────────────────────────────────────────────
# Step 2: Ensure Regulatory_Body org exists
# ──────────────────────────────────────────────
print("\n" + "=" * 60)
print("STEP 2: Checking Regulatory_Body org")
print("=" * 60)

reg_body_orgs = [o for o in orgs if o["org_type"] == "Regulatory_Body"]
if reg_body_orgs:
    compliance_org_id = reg_body_orgs[0]["org_id"]
    print(f"  Found: {reg_body_orgs[0]['org_name']} ({compliance_org_id})")
else:
    print("  Creating Regulatory_Body org...")
    res = db_client.schema("identity_mod").table("organisations").insert({
        "org_name": "National Drug Regulatory Authority",
        "org_type": "Regulatory_Body",
        "reg_no": "NDRA-GOV-001",
        "contact_email": "audit@ndra.gov.in",
        "is_active": True
    }).execute()
    compliance_org_id = res.data[0]["org_id"]
    print(f"  Created: ({compliance_org_id})")

# Find specific orgs for each user type
retailer_org = next((o for o in orgs if o["org_type"] == "Retailer" and o["is_active"]), None)
distributor_org = next((o for o in orgs if o["org_type"] == "Distributor" and o["is_active"]), None)
lethe_hub = next((o for o in orgs if o["org_name"] == "Lethe Master Hub"), None)

print(f"  Retailer org:     {retailer_org['org_name']}")
print(f"  Distributor org:  {distributor_org['org_name']}")
print(f"  SysAdmin org:     {lethe_hub['org_name']}")

# ──────────────────────────────────────────────
# Step 3: List existing auth users
# ──────────────────────────────────────────────
print("\n" + "=" * 60)
print("STEP 3: Current Auth Users")
print("=" * 60)

existing_auth_users = admin_client.auth.admin.list_users()
existing_emails = {}
for u in existing_auth_users:
    existing_emails[u.email] = u.id
    print(f"  {u.email:<30s} id={u.id}")

# ──────────────────────────────────────────────
# Step 4: Define the 4 users
# ──────────────────────────────────────────────
users_to_create = [
    {
        "email": "retailer@lethe.com",
        "password": "Lethe@Retail1",
        "first_name": "Priya",
        "last_name": "Sharma",
        "org_id": retailer_org["org_id"],
        "role_id": role_map["Inventory_Controller"],
        "label": "RETAILER"
    },
    {
        "email": "distributor@lethe.com",
        "password": "Lethe@Dist1",
        "first_name": "Rajesh",
        "last_name": "Verma",
        "org_id": distributor_org["org_id"],
        "role_id": role_map["Logistics_Director"],
        "label": "DISTRIBUTOR"
    },
    {
        "email": "compliance@lethe.com",
        "password": "Lethe@Audit1",
        "first_name": "Meera",
        "last_name": "Iyer",
        "org_id": compliance_org_id,
        "role_id": role_map["Revenue_Audit_Officer"],
        "label": "COMPLIANCE AUDITOR"
    },
    {
        "email": "sysadmin@lethe.com",
        "password": "Lethe@Admin1",
        "first_name": "Vikram",
        "last_name": "Singh",
        "org_id": lethe_hub["org_id"],
        "role_id": role_map["Admin"],
        "label": "SYSADMIN"
    },
]

# ──────────────────────────────────────────────
# Step 5: Provision each user
# ──────────────────────────────────────────────
print("\n" + "=" * 60)
print("STEP 4: Provisioning Users")
print("=" * 60)

results = []

for u in users_to_create:
    print(f"\n  --- [{u['label']}] {u['email']} ---")
    user_id = None

    # 5a. Auth layer: create or update
    if u["email"] in existing_emails:
        user_id = existing_emails[u["email"]]
        print(f"    [AUTH] Already exists: {user_id}")
        # Update password and confirm email
        try:
            admin_client.auth.admin.update_user_by_id(
                str(user_id),
                {"password": u["password"], "email_confirm": True}
            )
            print(f"    [AUTH] Password updated + email confirmed")
        except Exception as e:
            print(f"    [AUTH] Update warning: {e}")
    else:
        try:
            auth_res = admin_client.auth.admin.create_user({
                "email": u["email"],
                "password": u["password"],
                "email_confirm": True
            })
            user_id = auth_res.user.id
            print(f"    [AUTH] Created: {user_id}")
        except Exception as e:
            print(f"    [AUTH] FAILED: {e}")
            continue

    # 5b. identity_mod layer: create or update
    try:
        check = db_client.schema("identity_mod").table("users") \
            .select("user_id") \
            .eq("user_id", str(user_id)) \
            .execute()

        if check.data:
            db_client.schema("identity_mod").table("users") \
                .update({
                    "org_id": u["org_id"],
                    "role_id": u["role_id"],
                    "first_name": u["first_name"],
                    "last_name": u["last_name"],
                    "is_active": True
                }) \
                .eq("user_id", str(user_id)) \
                .execute()
            print(f"    [DB]   identity_mod.users UPDATED")
        else:
            db_client.schema("identity_mod").table("users").insert({
                "user_id": str(user_id),
                "org_id": u["org_id"],
                "role_id": u["role_id"],
                "first_name": u["first_name"],
                "last_name": u["last_name"],
                "password_hash": "supabase_managed",
                "is_active": True
            }).execute()
            print(f"    [DB]   identity_mod.users CREATED")

        results.append({"label": u["label"], "email": u["email"], "password": u["password"], "status": "OK"})
    except Exception as e:
        print(f"    [DB]   FAILED: {e}")
        results.append({"label": u["label"], "email": u["email"], "password": u["password"], "status": f"PARTIAL: {e}"})

# ──────────────────────────────────────────────
# Step 6: Verify sign-in for every user
# ──────────────────────────────────────────────
print("\n" + "=" * 60)
print("STEP 5: Sign-in Verification")
print("=" * 60)

# Use a fresh client for sign-in tests
test_client = create_client(URL, PUBLISHABLE_KEY)

for u in users_to_create:
    try:
        sign_in = test_client.auth.sign_in_with_password({
            "email": u["email"],
            "password": u["password"]
        })
        uid = sign_in.user.id

        profile = test_client.schema("identity_mod").table("users") \
            .select("org_id, organisations(org_type, org_name), roles(role_name)") \
            .eq("user_id", uid) \
            .single() \
            .execute()

        org_info = profile.data.get("organisations") or {}
        role_info = profile.data.get("roles") or {}
        print(f"  [OK]   {u['label']:<20s} org_type={org_info.get('org_type','?'):<18s} role={role_info.get('role_name','?')}")
        test_client.auth.sign_out()
    except Exception as e:
        print(f"  [FAIL] {u['label']:<20s} {e}")

# ──────────────────────────────────────────────
# Final Summary
# ──────────────────────────────────────────────
print("\n" + "=" * 60)
print("CREDENTIALS SUMMARY")
print("=" * 60)
print(f"  {'Portal':<22} {'Email':<28} {'Password':<18} {'Status'}")
print(f"  {'---'*8:<22} {'---'*10:<28} {'---'*6:<18} {'---'*4}")
for r in results:
    print(f"  {r['label']:<22} {r['email']:<28} {r['password']:<18} {r['status']}")
print()
print(f"  {'MANUFACTURER':<22} {'adminsys@gmail.com':<28} {'(unchanged)':<18} existing")
print("=" * 60)
