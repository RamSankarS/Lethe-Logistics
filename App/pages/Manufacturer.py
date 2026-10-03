import streamlit as st
import pandas as pd
from core.db_client import supabase_client

# 1. Page Config
st.set_page_config(page_title="Manufacturer Portal", page_icon="🏢", layout="wide")

# 2. Auth Guard & RBAC Enforcement
if not st.session_state.get("authenticated", False):
    st.error("Access Denied. Please log in from the main portal.")
    st.stop()

user_org_type = st.session_state.get("org_type")
if user_org_type not in ["Manufacturer", "Admin"]:
    st.error(f"Unauthorized. Your organization type (`{user_org_type}`) cannot access the Manufacturer portal.")
    st.stop()

# 3. Header & Context
st.title("🏢 Manufacturer Operations Portal")
st.caption(f"Logged in as: **{st.session_state.get('email')}** | Organization: **{st.session_state.get('org_name')}**")
st.divider()

# Tabbed Interface for Modular Workflows
tab_view, tab_create, tab_recall = st.tabs([
    "📋 Registered Batches", 
    "➕ Register New Batch", 
    "🚨 Initiate Global Recall"
])

# --- TAB 1: VIEW BATCHES ---
with tab_view:
    st.subheader("Batch Master Registry")
    
    try:
        # Query batches belonging specifically to this Manufacturer's org_id
        response = supabase_client.schema("product_and_batch_intelligence") \
            .table("batch_master") \
            .select("batch_id, batch_number, quantity_produced, status, mfg_date, expiry_date, medicines(brand_name, generic_name, category)") \
            .eq("manufacturer_id", st.session_state.get("org_id")) \
            .execute()
        
        batches = response.data
        if batches:
            # Flatten joined JSON for display in Streamlit dataframe
            flattened = []
            for b in batches:
                med = b.get("medicines", {}) or {}
                flattened.append({
                    "Batch ID": b.get("batch_id"),
                    "Batch Number": b.get("batch_number"),
                    "Brand Name": med.get("brand_name", "N/A"),
                    "Generic Name": med.get("generic_name", "N/A"),
                    "Category": med.get("category", "N/A"),
                    "Quantity": b.get("quantity_produced"),
                    "Status": b.get("status"),
                    "Mfg Date": b.get("mfg_date"),
                    "Expiry Date": b.get("expiry_date")
                })
            df = pd.DataFrame(flattened)
            st.dataframe(df, use_container_width=True, hide_index=True)
        else:
            st.info("No batches found for your organization.")
            
    except Exception as e:
        st.error(f"Failed to fetch batch records: {str(e)}")

# --- TAB 2: REGISTER NEW BATCH ---
with tab_create:
    st.subheader("Register Production Batch")
    
    # Fetch available medicines to populate drop-down
    med_options = {}
    try:
        med_resp = supabase_client.schema("product_and_batch_intelligence") \
            .table("medicines") \
            .select("medicine_id, brand_name, generic_name") \
            .eq("is_active", True) \
            .execute()
        
        for m in med_resp.data:
            med_options[f"{m['brand_name']} ({m['generic_name']})"] = m["medicine_id"]
    except Exception as e:
        st.error(f"Error loading medicine catalog: {str(e)}")

    if med_options:
        with st.form("create_batch_form"):
            selected_med_label = st.selectbox("Select Medicine", options=list(med_options.keys()))
            batch_num = st.text_input("Batch Number (Unique)", placeholder="e.g., BATCH-2026-X99")
            col1, col2 = st.columns(2)
            with col1:
                mfg_date = st.date_input("Manufacturing Date")
            with col2:
                exp_date = st.date_input("Expiry Date")
            
            quantity = st.number_input("Quantity Produced", min_value=1, step=100, value=1000)
            submit_batch = st.form_submit_button("Register Batch", use_container_width=True)

            if submit_batch:
                if not batch_num:
                    st.error("Please enter a valid batch number.")
                elif exp_date <= mfg_date:
                    st.error("Expiry date must be after manufacturing date.")
                else:
                    try:
                        payload = {
                            "medicine_id": med_options[selected_med_label],
                            "manufacturer_id": st.session_state.get("org_id"),
                            "registered_by_user_id": st.session_state.get("user_id"),
                            "batch_number": batch_num,
                            "mfg_date": str(mfg_date),
                            "expiry_date": str(exp_date),
                            "quantity_produced": quantity,
                            "status": "Pending"
                        }
                        
                        supabase_client.schema("product_and_batch_intelligence") \
                            .table("batch_master") \
                            .insert(payload) \
                            .execute()
                            
                        st.success(f"Batch '{batch_num}' registered successfully!")
                        st.rerun()
                    except Exception as e:
                        st.error(f"Failed to register batch: {str(e)}")

# --- TAB 3: INITIATE GLOBAL RECALL ---
with tab_recall:
    st.subheader("Trigger Emergency Product Recall")
    st.warning("⚠️ Action Warning: Triggering a recall instantly flags the batch across all warehouses, distributors, and retailers.")
    
    with st.form("global_recall_form"):
        target_batch_id = st.number_input("Enter Batch ID to Recall", min_value=1, step=1)
        reason = st.text_area("Official Recall Reason / Contamination Report", placeholder="e.g., Quality check failed: purity threshold breach.")
        submit_recall = st.form_submit_button("🚨 Issue Global Recall Notice", use_container_width=True)

        if submit_recall:
            if not reason:
                st.error("Recall reason is mandatory for CDSCO/FDA compliance logs.")
            else:
                try:
                    # 1. Insert into global_recall_ledger schema
                    recall_payload = {
                        "batch_id": target_batch_id,
                        "initiated_by_org_id": st.session_state.get("org_id"),
                        "recall_reason": reason,
                        "quarantine_status": "Active"
                    }
                    
                    supabase_client.schema("reverse_logistics") \
                        .table("global_recall_ledger") \
                        .insert(recall_payload) \
                        .execute()
                    
                    # 2. Update status in batch_master
                    supabase_client.schema("product_and_batch_intelligence") \
                        .table("batch_master") \
                        .update({"status": "Recalled"}) \
                        .eq("batch_id", target_batch_id) \
                        .execute()

                    st.success(f"Global recall successfully initiated for Batch ID #{target_batch_id}.")
                    st.rerun()
                except Exception as e:
                    st.error(f"Recall failed: {str(e)}")