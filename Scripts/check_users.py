import sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
from supabase import create_client

URL = "https://pvfbxhorkihgmldzlfkv.supabase.co"
KEY = "sb_publishable_Qpa2po0RC3uofGsQsVlVjA_KnUZYhwU"
client = create_client(URL, KEY)

# Sign in as adminsys to get user_id
print("Checking adminsys@gmail.com...")
r1 = client.auth.sign_in_with_password({"email": "adminsys@gmail.com", "password": "testenv"})
adminsys_id = r1.user.id
print(f"  auth user_id: {adminsys_id}")
p1 = client.schema("identity_mod").table("users").select("user_id, org_id, role_id, organisations(org_name, org_type), roles(role_name)").eq("user_id", adminsys_id).single().execute()
print(f"  profile: {p1.data}")
client.auth.sign_out()

print("\nChecking sysadmin@lethe.com...")
r2 = client.auth.sign_in_with_password({"email": "sysadmin@lethe.com", "password": "Lethe@Admin1"})
sysadmin_id = r2.user.id
print(f"  auth user_id: {sysadmin_id}")
p2 = client.schema("identity_mod").table("users").select("user_id, org_id, role_id, organisations(org_name, org_type), roles(role_name)").eq("user_id", sysadmin_id).single().execute()
print(f"  profile: {p2.data}")
client.auth.sign_out()

# Show all roles
print("\nAll roles:")
roles = client.schema("identity_mod").table("roles").select("*").execute()
for r in roles.data:
    print(f"  {r['role_name']} = {r['role_id']}")
