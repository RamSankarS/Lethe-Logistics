import streamlit as st
import pandas as pd
from core.db_client import supabase_client

# 1. Page Config
st.set_page_config(page_title="Production & Batches", page_icon="🏭", layout="wide")

# 2. Auth Guard & RBAC Enforcement
if not st.session_state.get("authenticated", False):
    st.error("Access Denied. Please log in from the main portal.")
    st.stop()

user_role = st.session_state.get("role_name", "")
if user_role not in ["Admin", "Manufacturer"]:
    st.error(f"Unauthorized. Your role (`{user_role}`) cannot access the Production module.")
    st.stop()

# 3. Header & Context
st.title("🏭 Production & Batch Management")
st.caption("Define drug catalogs and register manufactured batches.")
st.divider()

# 4. Tabbed Interface
tab_catalog, tab_batches = st.tabs([
    "💊 Drug Catalog (Medicines)",
    "📦 Batch Master Registry"
])

# --- TAB 1: MEDICINES ---
with tab_catalog:
    col_med_form, col_med_data = st.columns([1, 2])

    with col_med_form:
        st.subheader("Register Medicine")
        with st.form("new_medicine_form"):
            brand_name = st.text_input("Brand Name")
            generic_name = st.text_input("Generic Name")
            category = st.selectbox("Category", ["Analgesic", "Antibiotic", "Antipyretic", "Vaccine", "Cardiovascular"])

            if st.form_submit_button("Save Medicine", use_container_width=True):
                if not brand_name or not generic_name:
                    st.error("Brand and Generic names are required.")
                else:
                    try:
                        supabase_client.schema('product_and_batch_intelligence').table('medicines').insert({
                            "brand_name": brand_name,
                            "generic_name": generic_name,
                            "category": category,
                            "is_active": True
                        }).execute()
                        st.success("Medicine registered successfully!")
                        st.rerun()
                    except Exception as e:
                        st.error(f"Database error: {e}")

    with col_med_data:
        st.subheader("Approved Medicines")
        try:
            res_med = supabase_client.schema('product_and_batch_intelligence').table('medicines').select("*").execute()
            if res_med.data:
                df_med = pd.DataFrame(res_med.data).rename(columns={
                    "medicine_id": "ID", "brand_name": "Brand Name", "generic_name": "Generic Name",
                    "category": "Category", "is_active": "Active"
                })
                st.dataframe(df_med, use_container_width=True, hide_index=True)
            else:
                st.info("No medicines found in product_and_batch_intelligence.medicines.")
        except Exception as e:
            st.error(f"Failed to load medicines: {e}")

# --- TAB 2: BATCH MASTER ---
with tab_batches:
    st.subheader("Batch Master Registry")
    col_b_form, col_b_data = st.columns([1, 2.5])

    with col_b_form:
        try:
            res_meds = supabase_client.schema('product_and_batch_intelligence').table('medicines').select(
                "medicine_id, brand_name").execute()
            med_map = {m["brand_name"]: m["medicine_id"] for m in res_meds.data} if res_meds.data else {}

            res_mfg = supabase_client.schema('identity_mod').table('organisations').select("org_id, org_name").eq(
                "org_type", "Manufacturer").execute()
            mfg_map = {o["org_name"]: o["org_id"] for o in res_mfg.data} if res_mfg.data else {}
        except Exception:
            med_map, mfg_map = {}, {}

        with st.form("batch_master_form"):
            b_num = st.text_input("Batch Number", placeholder="BATCH-2026-001")
            sel_med = st.selectbox("Medicine", options=list(med_map.keys()) if med_map else ["No Medicines Found"])
            sel_mfg = st.selectbox("Manufacturer Organisation",
                                   options=list(mfg_map.keys()) if mfg_map else ["No Manufacturers Found"])
            qty = st.number_input("Quantity Produced", min_value=100, step=100, value=1000)
            mfg_date = st.date_input("Manufacturing Date")
            expiry_date = st.date_input("Expiry Date")

            if st.form_submit_button("Register Batch", use_container_width=True):
                if not med_map or not mfg_map:
                    st.error("Missing Medicine or Manufacturer dependencies.")
                elif expiry_date <= mfg_date:
                    st.error("Expiry date must be after manufacturing date.")
                else:
                    try:
                        supabase_client.schema('product_and_batch_intelligence').table('batch_master').insert({
                            "batch_number": b_num,
                            "medicine_id": med_map[sel_med],
                            "manufacturer_id": mfg_map[sel_mfg],
                            "registered_by_user_id": st.session_state["user_id"],
                            "quantity_produced": qty,
                            "mfg_date": str(mfg_date),
                            "expiry_date": str(expiry_date),
                            "status": "Pending"
                        }).execute()
                        st.success(f"Batch {b_num} registered successfully!")
                        st.rerun()
                    except Exception as e:
                        st.error(f"Database error: {e}")

    with col_b_data:
        try:
            res_batches = supabase_client.schema('product_and_batch_intelligence').table('batch_master').select(
                "batch_id, batch_number, quantity_produced, mfg_date, expiry_date, status, medicines(brand_name)"
            ).execute()

            if res_batches.data:
                flat_b = [{
                    "Batch ID": b["batch_id"],
                    "Batch No.": b["batch_number"],
                    "Medicine": (b.get("medicines") or {}).get("brand_name", "N/A"),
                    "Quantity": b["quantity_produced"],
                    "Mfg Date": b["mfg_date"],
                    "Expiry Date": b["expiry_date"],
                    "Status": b["status"]
                } for b in res_batches.data]

                df_b = pd.DataFrame(flat_b)
                st.dataframe(
                    df_b.style.map(
                        lambda s: "background-color: #ff4b4b; color: white" if s == "Recall"
                        else "background-color: #faca2b; color: black" if s == "Quarantine"
                        else "", subset=["Status"]
                    ),
                    use_container_width=True, hide_index=True
                )
            else:
                st.info("No batches found in product_and_batch_intelligence.batch_master.")
        except Exception as e:
            st.error(f"Failed to fetch batches: {e}")