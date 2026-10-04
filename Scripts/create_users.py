import os
from supabase import create_client

url = "https://pvfbxhorkihgmldzlfkv.supabase.co"
key = "sb_publishable_Qpa2po0RC3uofGsQsVlVjA_KnUZYhwU"
client = create_client(url, key)

print("Checking for Regulatory_Body org...")
res = client.schema("identity_mod").table("organisations").select("*").eq("org_type", "Regulatory_Body").execute()
if len(res.data) == 0:
    print("Creating Regulatory_Body org...")
    org_res = client.schema("identity_mod").table("organisations").insert({
        "org_name": "Federal Compliance Office",
        "org_type": "Regulatory_Body",
        "reg_no": "FED-COMP-001",
        "contact_email": "auditor@fedcomp.gov"
    }).execute()
    auditor_org_id = org_res.data[0]["org_id"]
else:
    auditor_org_id = res.data[0]["org_id"]
    print(f"Found Regulatory_Body org: {auditor_org_id}")

users_to_create = [
    {
        "email": "retailer@lethe.com",
        "password": "Password123!",
        "org_id": "f8e303d0-608f-48ef-832f-02c848a68232", # Retailer Org
        "role_id": "f88bd8b8-4cae-4c43-adb2-763c4fbcbb04", # Inventory Controller
        "first_name": "Rita",
        "last_name": "Retail"
    },
    {
        "email": "distributor@lethe.com",
        "password": "Password123!",
        "org_id": "0b9979ed-8caa-4d22-82be-b997e2509252", # Distributor Org
        "role_id": "d454b48e-c74f-4ac1-b87b-e52bdeeddee7", # Logistics Director
        "first_name": "Dan",
        "last_name": "Distrib"
    },
    {
        "email": "auditor@lethe.com",
        "password": "Password123!",
        "org_id": auditor_org_id,
        "role_id": "024cd197-2e09-497d-8b1d-53221abe2961", # Revenue_Audit_Officer
        "first_name": "Alice",
        "last_name": "Auditor"
    }
]

for u in users_to_create:
    try:
        print(f"Signing up {u['email']}...")
        auth_res = client.auth.sign_up({"email": u["email"], "password": u["password"]})
        if auth_res.user is None:
            print(f"Failed to sign up {u['email']} (No user returned). Already exists?")
            continue
            
        user_id = auth_res.user.id
        print(f"User created in auth with ID: {user_id}. Inserting to identity_mod...")
        
        client.schema("identity_mod").table("users").insert({
            "user_id": user_id,
            "org_id": u["org_id"],
            "role_id": u["role_id"],
            "first_name": u["first_name"],
            "last_name": u["last_name"],
            "password_hash": "argon2_hashed_secret",
            "is_active": True
        }).execute()
        print(f"Successfully fully provisioned {u['email']}")
    except Exception as e:
        print(f"Failed to fully provision {u['email']}: {e}")
