import streamlit as st
import pandas as pd
from core.db_client import supabase_client
from datetime import datetime, date

# 1. Page Config
st.set_page_config(page_title="Retailer Portal", page_icon="🛒", layout="wide")

# 2. Auth Guard & RBAC Enforcement (Supports all Admin name variants & Retailer)
if not st.session_state.get("authenticated", False):
    st.error("Access Denied. Please log in from the main portal.")
    st.stop()

user_role = st.session_state.get("role_name", "")
ADMIN_ROLES = ["Admin", "SysAdmin", "System Admin", "Administrator"]

if user_role not in ADMIN_ROLES and user_role != "Retailer":
    st.error(f"Unauthorized. Your role (`{user_role}`) cannot access the Retailer Portal.")
    st.stop()

# 3. Header & Context
st.title("🛒 Retailer Operations Portal")
st.caption("Manage pharmacy purchase orders, track live shipment analytics, and file stock return claims.")
st.divider()

org_id = st.session_state.get("org_id")

# 4. Fetch Reference Data Independently
try:
    batches_res = supabase_client.schema('product_and_batch_intelligence').table('batch_master').select("*").execute()
    meds_res = supabase_client.schema('product_and_batch_intelligence').table('medicines').select("*").execute()

    batch_map = {b["batch_id"]: b for b in batches_res.data} if batches_res.data else {}
    med_map = {m["medicine_id"]: m for m in meds_res.data} if meds_res.data else {}

    # Fetch orders specific to this retailer organization (or all if Admin/SysAdmin)
    orders_query = supabase_client.schema('forward_fulfillment').table('sales_orders').select("*")
    if user_role == "Retailer" and org_id:
        orders_query = orders_query.eq("buyer_org_id", org_id)
    orders_res = orders_query.execute()
    orders = orders_res.data if orders_res.data else []
except Exception as e:
    st.error(f"Database error fetching retailer data: {e}")
    orders, batch_map, med_map = [], {}, {}

# 5. Tabbed Interface
tab_overview, tab_orders, tab_returns = st.tabs([
    "📊 Retail Analytics & Overview",
    "📦 My Purchase Orders",
    "↩️ File Return or Recall Claim"
])

# --- TAB 1: RETAIL ANALYTICS & OVERVIEW ---
with tab_overview:
    st.subheader("Pharmacy Order Analytics & Delivery Velocity")

    if orders:
        df_orders = pd.DataFrame(orders)

        col_m1, col_m2, col_m3 = st.columns(3)
        col_m1.metric("Total Orders Placed", len(df_orders))
        col_m2.metric("Delivered Orders", len(df_orders[df_orders["order_status"] == "Delivered"]))
        col_m3.metric("In-Transit / Pending",
                      len(df_orders[df_orders["order_status"].isin(["Pending", "Shipped", "Processing"])]))
        st.divider()

        col_g1, col_g2 = st.columns(2)

        with col_g1:
            st.markdown("##### Order Status Breakdown")
            status_counts = df_orders["order_status"].value_counts().reset_index()
            status_counts.columns = ["Status", "Count"]
            st.bar_chart(status_counts.set_index("Status"), color="#28a745")

        with col_g2:
            st.markdown("##### Order Placement Timeline")
            if "order_date" in df_orders.columns:
                df_orders["order_date"] = pd.to_datetime(df_orders["order_date"])
                timeline = df_orders.groupby("order_date").size().reset_index(name="Order Volume")
                st.line_chart(timeline.set_index("order_date"), color="#17a2b8")
    else:
        st.info("No purchase orders found for analytics.")

# --- TAB 2: MY PURCHASE ORDERS ---
with tab_orders:
    st.subheader("Purchase Order Management")
    col_f, col_d = st.columns([1, 1.5])

    with col_f:
        st.markdown("##### Place New Purchase Order")
        with st.form("retailer_order_form"):
            expected_date = st.date_input("Expected Delivery Date", value=date.today())

            if st.form_submit_button("Submit Purchase Order", use_container_width=True):
                if not org_id and user_role == "Retailer":
                    st.error("Retailer Organization ID not found in session state.")
                else:
                    try:
                        # Fallback to first available retailer org if org_id is not bound to session for admin testing
                        target_org = org_id
                        if not target_org:
                            orgs_res = supabase_client.schema('identity_mod').table('organisations').select(
                                "org_id").eq("org_type", "Retailer").limit(1).execute()
                            if orgs_res.data:
                                target_org = orgs_res.data[0]["org_id"]

                        supabase_client.schema('forward_fulfillment').table('sales_orders').insert({
                            "buyer_org_id": target_org,
                            "order_date": str(date.today()),
                            "order_status": "Pending",
                            "expected_del_date": str(expected_date)
                        }).execute()
                        st.success("Purchase order successfully submitted!")
                        st.rerun()
                    except Exception as e:
                        st.error(f"Database error: {e}")

    with col_d:
        st.markdown("##### Active Order History")
        if orders:
            flat_orders = []
            for o in orders:
                flat_orders.append({
                    "Order ID": o.get("order_id"),
                    "Order Date": str(o.get("order_date"))[:10],
                    "Expected Delivery": o.get("expected_del_date"),
                    "Status": o.get("order_status")
                })
            df_tab = pd.DataFrame(flat_orders)
            st.dataframe(
                df_tab.style.map(
                    lambda s: "color: #28a745; font-weight:bold;" if s == "Delivered"
                    else "color: #17a2b8;" if s == "Shipped"
                    else "color: #faca2b;" if s == "Pending"
                    else "", subset=["Status"]
                ),
                use_container_width=True, hide_index=True
            )
        else:
            st.info("No orders recorded.")

# --- TAB 3: FILE RETURN OR RECALL CLAIM ---
with tab_returns:
    st.subheader("File Return Request (Reverse Logistics)")
    st.write("Submit claims for expired shelf-life, damaged packaging, or regulatory batch recalls.")

    with st.form("retailer_return_form"):
        all_batches = {
            f"{b['batch_number']} ({med_map.get(b['medicine_id'], {}).get('brand_name', 'N/A')})": b["batch_id"] for b
            in batch_map.values()}

        sel_batch = st.selectbox("Select Batch to Return",
                                 options=list(all_batches.keys()) if all_batches else ["No Batches Available"])
        qty = st.number_input("Quantity to Return", min_value=1, step=5, value=10)
        reason = st.text_area("Reason for Return",
                              placeholder="e.g., Temperature excursion during transit / Damaged blister packs")

        if st.form_submit_button("Submit Return Claim", use_container_width=True):
            target_org = org_id
            if not target_org:
                orgs_res = supabase_client.schema('identity_mod').table('organisations').select("org_id").eq("org_type",
                                                                                                             "Retailer").limit(
                    1).execute()
                if orgs_res.data:
                    target_org = orgs_res.data[0]["org_id"]

            if not target_org or not all_batches:
                st.error("Missing organization ID or active batch records.")
            else:
                try:
                    supabase_client.schema('reverse_logistics').table('return_requests').insert({
                        "returner_org_id": target_org,
                        "batch_id": all_batches[sel_batch],
                        "quantity_returned": qty,
                        "return_reason": reason,
                        "status": "Pending",
                        "created_at_utc": datetime.utcnow().isoformat()
                    }).execute()
                    st.success("Return claim successfully transmitted to Reverse Logistics!")
                    st.rerun()
                except Exception as e:
                    st.error(f"Database error: {e}")