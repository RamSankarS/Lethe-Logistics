import os
from supabase import create_client
import time

url = "https://pvfbxhorkihgmldzlfkv.supabase.co"
key = "sb_publishable_Qpa2po0RC3uofGsQsVlVjA_KnUZYhwU"
client = create_client(url, key)

print("Fetching Regulatory_Body org...")
res = client.schema("identity_mod").table("organisations").select("*").eq("org_type", "Regulatory_Body").execute()
auditor_org_id = res.data[0]["org_id"]

u = {
    "email": "compliance@lethe.com",
    "password": "Password123!",
    "org_id": auditor_org_id,
    "role_id": "024cd197-2e09-497d-8b1d-53221abe2961", # Revenue_Audit_Officer
    "first_name": "Alice",
    "last_name": "Auditor"
}

try:
    print(f"Signing up {u['email']}...")
    auth_res = client.auth.sign_up({"email": u["email"], "password": u["password"]})
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
