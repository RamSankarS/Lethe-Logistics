import sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
from supabase import create_client

URL = "https://pvfbxhorkihgmldzlfkv.supabase.co"
KEY = "sb_publishable_Qpa2po0RC3uofGsQsVlVjA_KnUZYhwU"
client = create_client(URL, KEY)

def check_access(email, password, label):
    print(f"\n--- {label} ({email}) ---")
    try:
        r = client.auth.sign_in_with_password({"email": email, "password": password})
        uid = r.user.id
        p = client.schema("identity_mod").table("users") \
            .select("organisations(org_type, org_name), roles(role_name)") \
            .eq("user_id", uid).single().execute()
        org      = p.data.get("organisations", {})
        role     = p.data.get("roles", {})
        org_type = org.get("org_type")
        role_name = role.get("role_name")

        print(f"  org_type  = {org_type}")
        print(f"  role      = {role_name}")

        # Simulate page guards (matching actual code in each page)
        mfr_access   = (org_type == "Manufacturer" and role_name != "Admin")
        sys_access   = (role_name == "Admin")
        dist_access  = (org_type == "Distributor")
        ret_access   = (org_type == "Retailer")
        comp_access  = (org_type == "Regulatory_Body")

        print(f"  Manufacturer page : {'ALLOWED' if mfr_access  else 'BLOCKED'}")
        print(f"  SysAdmin page     : {'ALLOWED' if sys_access  else 'BLOCKED'}")
        print(f"  Distributor page  : {'ALLOWED' if dist_access else 'BLOCKED'}")
        print(f"  Retailer page     : {'ALLOWED' if ret_access  else 'BLOCKED'}")
        print(f"  Compliance page   : {'ALLOWED' if comp_access else 'BLOCKED'}")
        client.auth.sign_out()
    except Exception as e:
        print(f"  FAILED: {e}")

check_access("adminsys@gmail.com", "testenv",      "MANUFACTURER USER")
check_access("sysadmin@lethe.com", "Lethe@Admin1", "SYSADMIN USER")
check_access("retailer@lethe.com", "Lethe@Retail1","RETAILER USER")
check_access("distributor@lethe.com", "Lethe@Dist1","DISTRIBUTOR USER")
check_access("compliance@lethe.com", "Lethe@Audit1","COMPLIANCE USER")
