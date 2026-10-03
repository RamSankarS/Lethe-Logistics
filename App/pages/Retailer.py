import streamlit as st
import pandas as pd
from datetime import datetime
from core.db_client import supabase_client

# 1. Page Config
st.set_page_config(page_title="Retailer Portal", page_icon="🏬", layout="wide")

# 2. Auth Guard & RBAC Enforcement
if not st.session_state.get("authenticated", False):
    st.error("Access Denied. Please log in from the main portal.")
    st.stop()

user_org_type = st.session_state.get("org_type")
if user_org_type not in ["Retailer", "Admin"]:
    st.error(f"Unauthorized. Your organization type (`{user_org_type}`) cannot access the Retailer portal.")
    st.stop()

# 3. Header & Context
st.title("🏬 Retailer Operations Portal")
st.caption(f"Logged in as: **{st.session_state.get('email')}** | Organization: **{st.session_state.get('org_name')}**")
st.divider()

# Tabbed Interface for Modular Workflows
tab_orders, tab_receipt, tab_return = st.tabs([
    "📦 Purchase Orders & Status", 
    "📝 Confirm Delivery Receipt", 
    "↩️ Request Return / Damage Claim"
])

# --- TAB 1: PURCHASE ORDERS ---
with tab_orders:
    st.subheader("Your Purchase Orders")
    
    try:
        response = supabase_client.schema("forward_fulfillment") \
            .table("sales_orders") \
            .select("order_id, order_date, order_status, expected_del_date, order_items(quantity, unit_price, batch_master(batch_number, medicines(brand_name)))") \
            .eq("buyer_org_id", st.session_state.get("org_id")) \
            .execute()
        
        orders = response.data
        if orders:
            flattened = []
            for o in orders:
                items = o.get("order_items", [])
                item_summary = []
                total_val = 0
                
                for item in items:
                    qty = item.get("quantity", 0)
                    price = item.get("unit_price", 0)
                    total_val += qty * price
                    
                    batch = item.get("batch_master") or {}
                    med = batch.get("medicines") or {}
                    brand = med.get("brand_name", "Unknown")
                    item_summary.append(f"{brand} (Qty: {qty})")
                
                flattened.append({
                    "Order ID": o.get("order_id"),
                    "Order Date": o.get("order_date"),
                    "Status": o.get("order_status"),
                    "Expected Delivery": o.get("expected_del_date") or "N/A",
                    "Items": ", ".join(item_summary) if item_summary else "N/A",
                    "Total Value ($)": round(total_val, 2)
                })
            
            df_orders = pd.DataFrame(flattened)
            st.dataframe(df_orders, use_container_width=True, hide_index=True)
        else:
            st.info("No purchase orders registered for your organization.")
            
    except Exception as e:
        st.error(f"Failed to fetch purchase orders: {str(e)}")

# --- TAB 2: CONFIRM DELIVERY RECEIPT ---
with tab_receipt:
    st.subheader("Submit Delivery Proof & Condition Report")
    st.write("Record receipt of goods into the immutable chain of custody.")
    
    with st.form("delivery_proof_form"):
        order_id = st.number_input("Target Order ID", min_value=1, step=1)
        condition = st.selectbox("Received Condition", options=["Good", "Damaged", "Partial"])
        sig = st.text_input("Digital Signature / Inspector Initials", placeholder="e.g., SIG-RET-884")
        remarks = st.text_area("Remarks / Damage Inspection Notes", placeholder="e.g., Outer seals intact, temperature log verified.")
        
        submit_proof = st.form_submit_button("Record Delivery Receipt", use_container_width=True)
        
        if submit_proof:
            if not sig:
                st.error("Digital signature is required to confirm proof of receipt.")
            else:
                try:
                    proof_payload = {
                        "order_id": order_id,
                        "received_by_user_id": st.session_state.get("user_id"),
                        "delivery_time": datetime.utcnow().isoformat(),
                        "received_condition": condition,
                        "digital_signature": sig,
                        "remarks": remarks
                    }
                    
                    # 1. Record the receipt
                    supabase_client.schema("forward_fulfillment") \
                        .table("delivery_proof_receipt") \
                        .insert(proof_payload) \
                        .execute()
                    
                    # 2. Update order status to Delivered
                    supabase_client.schema("forward_fulfillment") \
                        .table("sales_orders") \
                        .update({"order_status": "Delivered"}) \
                        .eq("order_id", order_id) \
                        .execute()
                    
                    st.success(f"Delivery receipt logged for Order #{order_id}. Chain of custody updated.")
                    st.rerun()
                except Exception as e:
                    st.error(f"Failed to log delivery proof: {str(e)}")

# --- TAB 3: REQUEST RETURN ---
with tab_return:
    st.subheader("Initiate Reverse Logistics Return Request")
    
    with st.form("return_request_form"):
        batch_id = st.number_input("Batch ID to Return", min_value=1, step=1)
        recall_id_input = st.number_input("Associated Recall ID (Optional)", min_value=0, step=1, value=0)
        qty_returned = st.number_input("Quantity to Return", min_value=1, step=1, value=10)
        return_reason = st.text_area("Reason for Return", placeholder="e.g., Packaging compromise during transit / Batch recall compliance.")
        
        submit_return = st.form_submit_button("Submit Return Request", use_container_width=True)
        
        if submit_return:
            if not return_reason:
                st.error("Return reason must be provided.")
            else:
                try:
                    return_payload = {
                        "returner_org_id": st.session_state.get("org_id"),
                        "batch_id": batch_id,
                        "recall_id": recall_id_input if recall_id_input > 0 else None,
                        "quantity_returned": qty_returned,
                        "return_reason": return_reason,
                        "status": "Initiated"
                    }
                    
                    supabase_client.schema("reverse_logistics") \
                        .table("return_requests") \
                        .insert(return_payload) \
                        .execute()
                    
                    st.success(f"Return request initiated for Batch #{batch_id}. Pending assessment.")
                    st.rerun()
                except Exception as e:
                    st.error(f"Failed to create return request: {str(e)}")