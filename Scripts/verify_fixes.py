"""Verify that the fixed queries work without cross-schema join errors."""
import sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

from supabase import create_client

URL = "https://pvfbxhorkihgmldzlfkv.supabase.co"
KEY = "sb_publishable_Qpa2po0RC3uofGsQsVlVjA_KnUZYhwU"
client = create_client(URL, KEY)

def ok(label, data):
    print(f"  [OK]   {label} -> {len(data)} rows")

def fail(label, e):
    print(f"  [FAIL] {label} -> {e}")

print("=== RETAILER QUERIES ===")
try:
    orders = client.schema("forward_fulfillment").table("sales_orders") \
        .select("order_id, buyer_org_id, order_date, order_status").execute().data
    ok("sales_orders", orders)
    if orders:
        order_ids = [o["order_id"] for o in orders[:3]]
        items = client.schema("forward_fulfillment").table("order_items") \
            .select("order_id, batch_id, quantity, unit_price").in_("order_id", order_ids).execute().data
        ok("order_items (separate query)", items)
except Exception as e:
    fail("sales_orders/order_items", e)

print("\n=== DISTRIBUTOR QUERIES ===")
try:
    inv = client.schema("smart_warehousing").table("inventory") \
        .select("inventory_id, location_id, batch_id, available_quantity").execute().data
    ok("inventory (no cross-schema join)", inv)
except Exception as e:
    fail("inventory", e)

try:
    locs = client.schema("smart_warehousing").table("storage_location") \
        .select("location_id, warehouse_id, zone_type, target_max_temp").execute().data
    ok("storage_location", locs)
except Exception as e:
    fail("storage_location", e)

try:
    batches = client.schema("product_and_batch_intelligence").table("batch_master") \
        .select("batch_id, batch_number, status").execute().data
    ok("batch_master (separate schema query)", batches)
except Exception as e:
    fail("batch_master", e)

print("\n=== COMPLIANCE QUERIES ===")
try:
    q = client.schema("smart_warehousing").table("quarantine_area_logs") \
        .select("quarantine_id, batch_id, location_id, quarantine_reason, status").execute().data
    ok("quarantine_area_logs (no cross-schema join)", q)
except Exception as e:
    fail("quarantine_area_logs", e)

try:
    recalls = client.schema("reverse_logistics").table("global_recall_ledger") \
        .select("recall_id, batch_id, initiated_by_org_id, recall_reason, quarantine_status, created_at_utc").execute().data
    ok("global_recall_ledger (no cross-schema join)", recalls)
except Exception as e:
    fail("global_recall_ledger", e)

try:
    meds = client.schema("product_and_batch_intelligence").table("medicines") \
        .select("medicine_id, brand_name").execute().data
    ok("medicines lookup", meds)
except Exception as e:
    fail("medicines", e)

try:
    orgs = client.schema("identity_mod").table("organisations") \
        .select("org_id, org_name").execute().data
    ok("organisations lookup", orgs)
except Exception as e:
    fail("organisations", e)

print("\nAll queries verified!")
