"""Quick check: verify the service_role key gives admin access."""
import sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

from supabase import create_client
import json, base64

SERVICE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB2ZmJ4aG9ya2loZ21sZHpsZmt2Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3NTUzMzg5NSwiZXhwIjoyMDkxMTA5ODk1fQ.TBjDReeZeykTwpbvLer0fRhP_fUh4nmmX8bzUq47djg"

URL = "https://pvfbxhorkihgmldzlfkv.supabase.co"
client = create_client(URL, SERVICE_KEY)

print("Testing admin.list_users() with service_role key...")
try:
    users = client.auth.admin.list_users()
    print(f"  [OK] Admin API works! Found {len(users)} auth users:")
    for u in users:
        print(f"    - {u.email} (id: {u.id})")
except Exception as e:
    print(f"  [FAIL] Admin API failed: {e}")

print("\nTesting identity_mod schema access with service_role...")
try:
    res = client.schema("identity_mod").table("organisations").select("*").limit(1).execute()
    print(f"  [OK] identity_mod access works: {res.data}")
except Exception as e:
    print(f"  [FAIL] identity_mod access failed: {e}")
    print("  The service_role key cannot access identity_mod via PostgREST.")
    print("  We need to GRANT USAGE on identity_mod to service_role in SQL.")
    print("  Workaround: Use the publishable key for DB ops + service key for Auth admin ops.")
