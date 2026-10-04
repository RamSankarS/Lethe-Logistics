import sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
from supabase import create_client

URL = "https://pvfbxhorkihgmldzlfkv.supabase.co"
KEY = "sb_publishable_Qpa2po0RC3uofGsQsVlVjA_KnUZYhwU"
client = create_client(URL, KEY)

ADMINSYS_ID       = "de32288b-25e0-44e1-98af-1d06f6a0a325"
AVANT_GARDE_ORG   = "96a73ed7-bc75-48de-abb6-b1eab134fb26"  # Avant-Garde LifeSciences (has 18 batches)

print("Moving adminsys@gmail.com to Avant-Garde LifeSciences...")
res = client.schema("identity_mod").table("users") \
    .update({"org_id": AVANT_GARDE_ORG}) \
    .eq("user_id", ADMINSYS_ID) \
    .execute()

print("  Updated:", res.data[0].get("org_id"))

# Verify
print("\nVerification:")
r = client.auth.sign_in_with_password({"email": "adminsys@gmail.com", "password": "testenv"})
uid = r.user.id
p = client.schema("identity_mod").table("users") \
    .select("organisations(org_name, org_type), roles(role_name)") \
    .eq("user_id", uid).single().execute()
org  = p.data.get("organisations", {})
role = p.data.get("roles", {})
print(f"  org:  {org.get('org_name')} | type={org.get('org_type')}")
print(f"  role: {role.get('role_name')}")

# Check batch count for this org
batches = client.schema("product_and_batch_intelligence").table("batch_master") \
    .select("batch_id").eq("manufacturer_id", AVANT_GARDE_ORG).execute()
print(f"  Batches visible: {len(batches.data)}")
client.auth.sign_out()
