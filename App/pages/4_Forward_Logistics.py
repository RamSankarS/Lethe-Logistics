import streamlit as st
import pandas as pd
from core.db_client import supabase_client
from datetime import datetime, date

# 1. Page Config
st.set_page_config(page_title="Forward Logistics & Fulfillment", page_icon="🚚", layout="wide")

# 2. Auth Guard & RBAC Enforcement
if not st.session_state.get("authenticated", False):
    st.error("Access Denied. Please log in from the main portal.")
    st.stop()

user_role = st.session_state.get("role_name", "")
if user_role not in ["Admin", "Manufacturer", "Retailer"]:
    st.error(f"Unauthorized. Your role (`{user_role}`) cannot access Forward Logistics.")
    st.stop()

# 3. Header & Context
st.title("🚚 Forward Logistics & Outbound Fulfillment")
st.caption("Manage sales orders, batch item allocations, vehicle fleet dispatch, and time-series delivery trends.")
st.divider()

# 4. Fetch Supporting Reference Data Independently
try:
    orgs_res = supabase_client.schema('identity_mod').table('organisations').select("*").execute()
    batches_res = supabase_client.schema('product_and_batch_intelligence').table('batch_master').select("*").execute()
    meds_res = supabase_client.schema('product_and_batch_intelligence').table('medicines').select("*").execute()
    vehicles_res = supabase_client.schema('forward_fulfillment').table('vehicle_fleet_registry').select("*").execute()
    users_res = supabase_client.schema('identity_mod').table('users').select("*").execute()

    org_map = {o["org_id"]: o for o in orgs_res.data} if orgs_res.data else {}
    batch_map = {b["batch_id"]: b for b in batches_res.data} if batches_res.data else {}
    med_map = {m["medicine_id"]: m for m in meds_res.data} if meds_res.data else {}
    vehicle_map = {v["vehicle_id"]: v for v in vehicles_res.data} if vehicles_res.data else {}
    user_map = {u["user_id"]: u for u in users_res.data} if users_res.data else {}
except Exception as e:
    st.error(f"Error fetching reference data: {e}")
    org_map, batch_map, med_map, vehicle_map, user_map = {}, {}, {}, {}, {}

# 5. Tabbed Interface
tab_orders, tab_items, tab_dispatch, tab_delivery = st.tabs([
    "🛒 Sales Orders & Analytics",
    "📦 Order Items (Batch Allocation)",
    "🚛 Shipping Manifest & Fleet",
    "✅ Delivery Proof Receipts"
])

# --- TAB 1: SALES ORDERS & TIME-SERIES ANALYTICS ---
with tab_orders:
    st.subheader("Sales Order Volume & Timeline Analytics")

    # Fetch orders for metrics & time-series
    try:
        orders_res = supabase_client.schema('forward_fulfillment').table('sales_orders').select("*").execute()
        orders = orders_res.data if orders_res.data else []
    except Exception as e:
        orders = []
        st.error(f"Failed to fetch sales orders: {e}")

    if orders:
        df_orders = pd.DataFrame(orders)

        # --- TIME-SERIES METRICS & CHART ---
        df_orders["order_date"] = pd.to_datetime(df_orders["order_date"])
        timeline_df = df_orders.groupby("order_date").size().reset_index(name="Orders Count")
        timeline_df = timeline_df.sort_values("order_date")

        col_m1, col_m2, col_m3 = st.columns(3)
        col_m1.metric("Total Orders Placed", len(df_orders))
        col_m2.metric("Pending Fulfillment", len(df_orders[df_orders["order_status"] == "Pending"]))
        col_m3.metric("Successfully Delivered", len(df_orders[df_orders["order_status"] == "Delivered"]))

        st.write("")
        st.markdown("##### 📈 Order Placement Velocity Over Time")
        st.line_chart(timeline_df.set_index("order_date"), color="#17a2b8")
        st.divider()

    col_o_form, col_o_data = st.columns([1, 1.5])

    with col_o_form:
        st.markdown("##### Create New Sales Order")
        retailer_options = {o["org_name"]: o["org_id"] for o in org_map.values() if o.get("org_type") == "Retailer"}

        with st.form("new_sales_order_form"):
            buyer_org = st.selectbox("Buyer Organisation (Retailer)",
                                     options=list(retailer_options.keys()) if retailer_options else [
                                         "No Retailers Registered"])
            order_status = st.selectbox("Order Status", ["Pending", "Approved", "Processing", "Shipped", "Delivered"])
            expected_date = st.date_input("Expected Delivery Date", value=date.today())

            if st.form_submit_button("Create Sales Order", use_container_width=True):
                if not retailer_options:
                    st.error("Please register a Retailer organisation in Master Data first.")
                else:
                    try:
                        supabase_client.schema('forward_fulfillment').table('sales_orders').insert({
                            "buyer_org_id": retailer_options[buyer_org],
                            "order_date": str(date.today()),
                            "order_status": order_status,
                            "expected_del_date": str(expected_date)
                        }).execute()
                        st.success("Sales order successfully created!")
                        st.rerun()
                    except Exception as e:
                        st.error(f"Database error: {e}")

    with col_o_data:
        st.markdown("##### Active Orders Registry")
        if orders:
            flat_orders = []
            for o in orders:
                org = org_map.get(o.get("buyer_org_id"), {})
                flat_orders.append({
                    "Order ID": o.get("order_id"),
                    "Retailer": org.get("org_name", "N/A"),
                    "Order Date": str(o.get("order_date"))[:10],
                    "Expected Delivery": o.get("expected_del_date"),
                    "Status": o.get("order_status")
                })

            df_table = pd.DataFrame(flat_orders)
            st.dataframe(
                df_table.style.map(
                    lambda s: "color: #28a745; font-weight:bold;" if s == "Delivered"
                    else "color: #17a2b8;" if s == "Shipped"
                    else "color: #faca2b;" if s == "Pending"
                    else "", subset=["Status"]
                ),
                use_container_width=True, hide_index=True
            )
        else:
            st.info("No sales orders logged.")

# --- TAB 2: ORDER ITEMS ---
with tab_items:
    st.subheader("Allocate Batches to Sales Orders")
    col_i_form, col_i_data = st.columns([1, 2])

    with col_i_form:
        try:
            orders_res = supabase_client.schema('forward_fulfillment').table('sales_orders').select(
                "order_id, buyer_org_id").execute()
            open_orders = {
                f"Order #{o['order_id']} ({org_map.get(o['buyer_org_id'], {}).get('org_name', 'N/A')})": o["order_id"]
                for o in (orders_res.data or [])}

            passed_batches = {
                f"{b['batch_number']} ({med_map.get(b['medicine_id'], {}).get('brand_name', 'N/A')})": b["batch_id"] for
                b in batch_map.values() if b.get("status") in ["Passed", "Pending"]}
        except Exception:
            open_orders, passed_batches = {}, {}

        with st.form("order_item_allocation_form"):
            sel_order = st.selectbox("Select Order",
                                     options=list(open_orders.keys()) if open_orders else ["No Orders Available"])
            sel_batch = st.selectbox("Select Batch", options=list(passed_batches.keys()) if passed_batches else [
                "No Active Batches Available"])
            quantity = st.number_input("Quantity Allocated", min_value=1, step=10, value=100)
            unit_price = st.number_input("Unit Price ($)", min_value=0.01, step=1.0, value=25.00)

            if st.form_submit_button("Allocate Item", use_container_width=True):
                if not open_orders or not passed_batches:
                    st.error("Missing valid orders or batches.")
                else:
                    try:
                        supabase_client.schema('forward_fulfillment').table('order_items').insert({
                            "order_id": open_orders[sel_order],
                            "batch_id": passed_batches[sel_batch],
                            "quantity": quantity,
                            "unit_price": unit_price
                        }).execute()
                        st.success("Batch successfully allocated to order!")
                        st.rerun()
                    except Exception as e:
                        st.error(f"Database error: {e}")

    with col_i_data:
        try:
            items_res = supabase_client.schema('forward_fulfillment').table('order_items').select("*").execute()
            items = items_res.data if items_res.data else []

            if items:
                flat_items = []
                for item in items:
                    b = batch_map.get(item.get("batch_id"), {})
                    m = med_map.get(b.get("medicine_id"), {})
                    flat_items.append({
                        "Item ID": item.get("order_item_id"),
                        "Order ID": item.get("order_id"),
                        "Batch": b.get("batch_number", "N/A"),
                        "Medicine": m.get("brand_name", "N/A"),
                        "Qty": item.get("quantity"),
                        "Unit Price": f"${item.get('unit_price', 0):.2f}",
                        "Line Total": f"${(item.get('quantity', 0) * item.get('unit_price', 0)):.2f}"
                    })
                st.dataframe(pd.DataFrame(flat_items), use_container_width=True, hide_index=True)
            else:
                st.info("No order items allocated.")
        except Exception as e:
            st.error(f"Failed to fetch order items: {e}")

# --- TAB 3: SHIPPING MANIFEST & FLEET ---
with tab_dispatch:
    st.subheader("Vehicle Fleet & Shipping Manifests")

    col_v_form, col_v_data = st.columns(2)
    with col_v_form:
        st.markdown("##### Register Fleet Vehicle")
        with st.form("vehicle_form"):
            v_num = st.text_input("Vehicle Registration No.", placeholder="MP-04-AB-1234")
            v_type = st.selectbox("Vehicle Type", ["Refrigerated Truck", "Standard Cargo Van", "Cold Chain Container"])
            trans_org = st.selectbox("Transporter Org",
                                     options=list({o["org_name"]: o["org_id"] for o in org_map.values()}.keys()) or [
                                         "None"])

            if st.form_submit_button("Add Vehicle", use_container_width=True):
                try:
                    org_id_val = {o["org_name"]: o["org_id"] for o in org_map.values()}.get(trans_org)
                    supabase_client.schema('forward_fulfillment').table('vehicle_fleet_registry').insert({
                        "vehicle_no": v_num,
                        "vehicle_type": v_type,
                        "transporter_org_id": org_id_val
                    }).execute()
                    st.success("Vehicle registered!")
                    st.rerun()
                except Exception as e:
                    st.error(f"Error: {e}")

    with col_v_data:
        st.markdown("##### Registered Vehicles")
        if vehicle_map:
            df_v = pd.DataFrame(list(vehicle_map.values())).rename(
                columns={"vehicle_id": "ID", "vehicle_no": "Vehicle No", "vehicle_type": "Type"})
            st.dataframe(df_v[["ID", "Vehicle No", "Type"]], use_container_width=True, hide_index=True)
        else:
            st.info("No vehicles registered in fleet.")

    st.divider()
    st.subheader("Create Shipping Manifest")

    with st.form("manifest_form"):
        m_col1, m_col2 = st.columns(2)
        with m_col1:
            try:
                orders_res = supabase_client.schema('forward_fulfillment').table('sales_orders').select(
                    "order_id").execute()
                ord_options = {o["order_id"]: o["order_id"] for o in (orders_res.data or [])}
            except Exception:
                ord_options = {}

            sel_ord_id = st.selectbox("Sales Order ID",
                                      options=list(ord_options.keys()) if ord_options else ["No Orders"])
            veh_options = {v["vehicle_no"]: v["vehicle_id"] for v in vehicle_map.values()}
            sel_veh = st.selectbox("Fleet Vehicle",
                                   options=list(veh_options.keys()) if veh_options else ["No Vehicles"])

        with m_col2:
            driver_options = {f"{u['first_name']} {u['last_name']}": u['user_id'] for u in user_map.values()}
            sel_driver = st.selectbox("Assigned Driver",
                                      options=list(driver_options.keys()) if driver_options else ["No Users"])
            est_arrival = st.date_input("Estimated Arrival Date")
            manifest_status = st.selectbox("Manifest Status", ["Dispatched", "In-Transit", "Delayed"])

        if st.form_submit_button("Dispatch Shipment Manifest", use_container_width=True):
            if not ord_options or not veh_options:
                st.error("Missing order or vehicle dependencies.")
            else:
                try:
                    supabase_client.schema('forward_fulfillment').table('shipping_manifest').insert({
                        "order_id": sel_ord_id,
                        "vehicle_id": veh_options[sel_veh],
                        "driver_user_id": driver_options[sel_driver],
                        "dispatch_time_utc": datetime.utcnow().isoformat(),
                        "estimated_arrival_utc": str(est_arrival),
                        "manifest_status": manifest_status
                    }).execute()

                    supabase_client.schema('forward_fulfillment').table('sales_orders').update(
                        {"order_status": "Shipped"}).eq("order_id", sel_ord_id).execute()

                    st.success("Manifest dispatched successfully!")
                    st.rerun()
                except Exception as e:
                    st.error(f"Database error: {e}")

# --- TAB 4: DELIVERY PROOF RECEIPTS ---
with tab_delivery:
    st.subheader("Delivery Proof & Receipt Confirmation")
    col_d_form, col_d_data = st.columns([1, 2])

    with col_d_form:
        try:
            shipped_res = supabase_client.schema('forward_fulfillment').table('sales_orders').select("order_id").eq(
                "order_status", "Shipped").execute()
            shipped_orders = {o["order_id"]: o["order_id"] for o in (shipped_res.data or [])}
        except Exception:
            shipped_orders = {}

        with st.form("delivery_proof_form"):
            d_order_id = st.selectbox("Shipped Order ID",
                                      options=list(shipped_orders.keys()) if shipped_orders else ["No Shipped Orders"])
            condition = st.selectbox("Received Condition",
                                     ["Intact / Perfect", "Minor Outer Damage", "Temperature Compromised", "Rejected"])
            digital_sig = st.text_input("Digital Signature / Receiver Name", placeholder="e.g., Dr. John Doe")
            remarks = st.text_area("Delivery Remarks")

            if st.form_submit_button("Confirm Delivery & Close Order", use_container_width=True):
                if not shipped_orders:
                    st.error("No orders currently in 'Shipped' status awaiting delivery.")
                else:
                    try:
                        supabase_client.schema('forward_fulfillment').table('delivery_proof_receipt').insert({
                            "order_id": d_order_id,
                            "received_by_user_id": st.session_state["user_id"],
                            "delivery_time": datetime.utcnow().isoformat(),
                            "received_condition": condition,
                            "digital_signature": digital_sig,
                            "remarks": remarks
                        }).execute()

                        supabase_client.schema('forward_fulfillment').table('sales_orders').update(
                            {"order_status": "Delivered"}).eq("order_id", d_order_id).execute()

                        st.success("Delivery confirmed and order marked as Delivered!")
                        st.rerun()
                    except Exception as e:
                        st.error(f"Database error: {e}")

    with col_d_data:
        try:
            receipts_res = supabase_client.schema('forward_fulfillment').table('delivery_proof_receipt').select(
                "*").execute()
            receipts = receipts_res.data if receipts_res.data else []

            if receipts:
                flat_rec = []
                for r in receipts:
                    u = user_map.get(r.get("received_by_user_id"), {})
                    flat_rec.append({
                        "Receipt ID": r.get("receipt_id"),
                        "Order ID": r.get("order_id"),
                        "Receiver": f"{u.get('first_name', '')} {u.get('last_name', '')}".strip(),
                        "Condition": r.get("received_condition"),
                        "Signature": r.get("digital_signature"),
                        "Time (UTC)": r.get("delivery_time", "")[:16].replace("T", " ")
                    })
                st.dataframe(pd.DataFrame(flat_rec), use_container_width=True, hide_index=True)
            else:
                st.info("No delivery receipts recorded yet.")
        except Exception as e:
            st.error(f"Failed to load receipts: {e}")