import sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
from supabase import create_client

URL = "https://pvfbxhorkihgmldzlfkv.supabase.co"
KEY = "sb_publishable_Qpa2po0RC3uofGsQsVlVjA_KnUZYhwU"
client = create_client(URL, KEY)

# Check adminsys org_id
print("adminsys org_id:")
r = client.auth.sign_in_with_password({"email": "adminsys@gmail.com", "password": "testenv"})
uid = r.user.id
p = client.schema("identity_mod").table("users").select("org_id, organisations(org_name, org_type)").eq("user_id", uid).single().execute()
print(f"  org_id: {p.data['org_id']}")
print(f"  org:    {p.data['organisations']}")
client.auth.sign_out()

# Check which manufacturer_ids have batch records
print("\nBatch counts per manufacturer_id:")
batches = client.schema("product_and_batch_intelligence").table("batch_master").select("batch_id, manufacturer_id").execute().data
counts = {}
for b in batches:
    mid = b["manufacturer_id"]
    counts[mid] = counts.get(mid, 0) + 1
for mid, cnt in counts.items():
    print(f"  manufacturer_id={mid} -> {cnt} batches")

# Check orgs
print("\nAll Manufacturer orgs:")
orgs = client.schema("identity_mod").table("organisations").select("org_id, org_name, org_type").eq("org_type", "Manufacturer").execute().data
for o in orgs:
    print(f"  {o['org_name']} ({o['org_id']})")
