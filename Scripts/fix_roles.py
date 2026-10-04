import sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
from supabase import create_client

URL = "https://pvfbxhorkihgmldzlfkv.supabase.co"
KEY = "sb_publishable_Qpa2po0RC3uofGsQsVlVjA_KnUZYhwU"
client = create_client(URL, KEY)

ADMINSYS_ID  = "de32288b-25e0-44e1-98af-1d06f6a0a325"
PRODUCTION_ROLE_ID = "0cf74603-ff8b-41f1-9458-a47b6ed15a08"  # Production_Superintendent

print("Changing adminsys@gmail.com role -> Production_Superintendent...")
res = client.schema("identity_mod").table("users") \
    .update({"role_id": PRODUCTION_ROLE_ID}) \
    .eq("user_id", ADMINSYS_ID) \
    .execute()
print(f"  Updated: {res.data}")

# Verify
print("\nVerifying...")
p = client.schema("identity_mod").table("users") \
    .select("user_id, organisations(org_name, org_type), roles(role_name)") \
    .eq("user_id", ADMINSYS_ID).single().execute()

org  = p.data.get("organisations", {})
role = p.data.get("roles", {})
print(f"  adminsys@gmail.com -> org_type={org.get('org_type')} | role={role.get('role_name')}")
print("  Expected: org_type=Manufacturer | role=Production_Superintendent")
