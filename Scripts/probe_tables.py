"""Probe table structures across schemas to understand cross-schema FK issues."""
import sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

from supabase import create_client

URL = "https://pvfbxhorkihgmldzlfkv.supabase.co"
KEY = "sb_publishable_Qpa2po0RC3uofGsQsVlVjA_KnUZYhwU"
client = create_client(URL, KEY)

schemas_tables = [
    # Forward Fulfillment
    ("forward_fulfillment", "sales_orders"),
    ("forward_fulfillment", "order_items"),
    ("forward_fulfillment", "shipments"),
    ("forward_fulfillment", "delivery_proof_receipt"),
    # Smart Warehousing
    ("smart_warehousing", "inventory"),
    ("smart_warehousing", "storage_location"),
    ("smart_warehousing", "warehouse"),
    ("smart_warehousing", "environmental_sensor_logs"),
    ("smart_warehousing", "quarantine_area_logs"),
    # Reverse Logistics
    ("reverse_logistics", "global_recall_ledger"),
    ("reverse_logistics", "return_requests"),
    # Product and Batch
    ("product_and_batch_intelligence", "batch_master"),
    ("product_and_batch_intelligence", "medicines"),
    # Identity
    ("identity_mod", "organisations"),
    ("identity_mod", "users"),
    ("identity_mod", "auth_audit_logs"),
]

for schema, table in schemas_tables:
    print(f"\n--- {schema}.{table} ---")
    try:
        res = client.schema(schema).table(table).select("*").limit(1).execute()
        if res.data:
            cols = list(res.data[0].keys())
            print(f"  Columns: {cols}")
        else:
            # Try to get columns even with no data by selecting with head
            print(f"  (no data, attempting column discovery)")
            # Just list what we got
            print(f"  Empty result")
    except Exception as e:
        print(f"  ERROR: {e}")
