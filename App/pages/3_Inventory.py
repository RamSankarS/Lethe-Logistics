import streamlit as st
import pandas as pd
from core.db_client import supabase_client
from datetime import datetime, date

# 1. Page Config
st.set_page_config(page_title="Inventory & Quality Control", page_icon="🏢", layout="wide")

# 2. Auth Guard & RBAC Enforcement
if not st.session_state.get("authenticated", False):
    st.error("Access Denied. Please log in from the main portal.")
    st.stop()

user_role = st.session_state.get("role_name", "")
if user_role not in ["Admin", "Manufacturer"]:
    st.error(f"Unauthorized. Your role (`{user_role}`) cannot access the Inventory & QC module.")
    st.stop()

# 3. Header & Context
st.title("🏢 Inventory & Quality Control Command Center")
st.caption("Monitor batch lifecycle inventory, track expiration timelines, and enforce compliance states.")
st.divider()

# 4. Fetch Data Independently (Prevents PGRST200 cross-schema join errors)
try:
    batches_res = supabase_client.schema('product_and_batch_intelligence').table('batch_master').select("*").execute()
    meds_res = supabase_client.schema('product_and_batch_intelligence').table('medicines').select("*").execute()
    orgs_res = supabase_client.schema('identity_mod').table('organisations').select("*").execute()

    batches = batches_res.data if batches_res.data else []
    med_map = {m["medicine_id"]: m for m in meds_res.data} if meds_res.data else {}
    org_map = {o["org_id"]: o for o in orgs_res.data} if orgs_res.data else {}
except Exception as e:
    st.error(f"Database connection error: {e}")
    batches, med_map, org_map = [], {}, {}

# Process and Flatten Data for UI
flat_batches = []
today = date.today()

for b in batches:
    mid = b.get("medicine_id")
    mfg_id = b.get("manufacturer_id")
    med = med_map.get(mid, {})
    org = org_map.get(mfg_id, {})

    exp_date_str = b.get("expiry_date")
    is_expired = False
    if exp_date_str:
        try:
            exp_date = datetime.strptime(exp_date_str, "%Y-%m-%d").date()
            if exp_date < today:
                is_expired = True
        except ValueError:
            pass

    flat_batches.append({
        "Batch ID": b.get("batch_id"),
        "Batch Number": b.get("batch_number"),
        "Brand Name": med.get("brand_name", "N/A"),
        "Generic Name": med.get("generic_name", "N/A"),
        "Manufacturer": org.get("org_name", "N/A"),
        "Quantity": b.get("quantity_produced", 0),
        "Mfg Date": b.get("mfg_date", "N/A"),
        "Expiry Date": exp_date_str,
        "Expired": "Yes" if is_expired else "No",
        "Status": b.get("status", "Pending")
    })

df_batches = pd.DataFrame(flat_batches)

# High-Level Metrics Bar
if not df_batches.empty:
    m1, m2, m3, m4 = st.columns(4)
    m1.metric("Total Batches Tracked", len(df_batches))
    m2.metric("Passed / Active", len(df_batches[df_batches["Status"] == "Passed"]))
    m3.metric("Under Quarantine", len(df_batches[df_batches["Status"] == "Quarantine"]))
    m4.metric("Flagged Recalls", len(df_batches[df_batches["Status"] == "Recall"]), delta_color="inverse")
    st.divider()

# 5. Tabbed Interface
tab_stock, tab_qc, tab_specs = st.tabs([
    "📦 Inventory & Analytics",
    "🔎 Quality Control Management",
    "🧪 Technical Standards"
])

# --- TAB 1: INVENTORY & EXPIRY MONITOR ---
with tab_stock:
    st.subheader("Batch Stock Analytics & Expiry Tracking")

    if not df_batches.empty:
        # --- INTERACTIVE VISUALIZATION SECTION ---
        col_chart1, col_chart2 = st.columns(2)

        with col_chart1:
            st.markdown("##### Batches by Compliance Status")
            status_counts = df_batches["Status"].value_counts().reset_index()
            status_counts.columns = ["Status", "Count"]
            st.bar_chart(status_counts.set_index("Status"), color="#28a745")

        with col_chart2:
            st.markdown("##### Stock Volume by Medicine Brand")
            brand_qty = df_batches.groupby("Brand Name")["Quantity"].sum().reset_index()
            st.bar_chart(brand_qty.set_index("Brand Name"), color="#17a2b8")

        st.divider()

        col_f1, col_f2 = st.columns(2)
        with col_f1:
            status_filter = st.multiselect(
                "Filter by Status",
                options=df_batches["Status"].unique().tolist(),
                default=df_batches["Status"].unique().tolist()
            )
        with col_f2:
            expired_filter = st.selectbox("Expiry Filter", ["All Batches", "Non-Expired Only", "Expired Stock Only"])

        filtered_df = df_batches[df_batches["Status"].isin(status_filter)]
        if expired_filter == "Non-Expired Only":
            filtered_df = filtered_df[filtered_df["Expired"] == "No"]
        elif expired_filter == "Expired Stock Only":
            filtered_df = filtered_df[filtered_df["Expired"] == "Yes"]

        st.dataframe(
            filtered_df.style.map(
                lambda s: "background-color: #ff4b4b; color: white" if s in ["Recall", "Failed", "Yes"]
                else "background-color: #faca2b; color: black" if s == "Quarantine"
                else "background-color: #28a745; color: white" if s == "Passed"
                else "", subset=["Status", "Expired"]
            ),
            use_container_width=True, hide_index=True
        )
    else:
        st.info("No batches found in batch_master.")

# --- TAB 2: QUALITY CONTROL MANAGEMENT ---
with tab_qc:
    st.subheader("Batch Inspection & Compliance State Enforcement")
    st.write("Updating a batch status here alters its operational state globally across forward and reverse logistics.")

    col_qc_form, col_qc_data = st.columns([1, 2])

    with col_qc_form:
        qc_map = {f"{b['Batch Number']} (Current: {b['Status']})": b["Batch ID"] for b in
                  flat_batches} if flat_batches else {}

        with st.form("qc_inspection_form"):
            target_batch = st.selectbox("Select Batch",
                                        options=list(qc_map.keys()) if qc_map else ["No Batches Available"])
            inspection_status = st.selectbox("Inspection Status", ["Passed", "Quarantine", "Recall"])
            remarks = st.text_area("Compliance Remarks",
                                   placeholder="e.g., Purity threshold verified; temperature logs clear.")

            if st.form_submit_button("Update Batch Status", use_container_width=True):
                if not qc_map:
                    st.error("No batches available for inspection.")
                else:
                    try:
                        batch_id = qc_map[target_batch]

                        supabase_client.schema('product_and_batch_intelligence').table('batch_master').update({
                            "status": inspection_status
                        }).eq("batch_id", batch_id).execute()

                        st.success(f"Batch status successfully updated to '{inspection_status}'!")
                        st.rerun()
                    except Exception as e:
                        st.error(f"Database error during QC update: {e}")

    with col_qc_data:
        st.subheader("Compliance Guidelines")
        st.info("💡 **Passed**: Cleared for forward fulfillment and order allocation.")
        st.warning("⚠️ **Quarantine**: Held for further biological or chemical assaying.")
        st.error("🚨 **Recall**: Flagged and channeled into the Reverse Logistics disposal ledger.")

# --- TAB 3: TECHNICAL STANDARDS ---
with tab_specs:
    st.subheader("Chemical Compositions & Packaging Standards")
    try:
        chem_res = supabase_client.schema('product_and_batch_intelligence').table('chemical_compositions').select(
            "*").execute()
        pkg_res = supabase_client.schema('product_and_batch_intelligence').table('packaging_standards').select(
            "*").execute()

        chem_map = {c["medicine_id"]: c for c in chem_res.data} if chem_res.data else {}
        pkg_map = {p["medicine_id"]: p for p in pkg_res.data} if pkg_res.data else {}

        if med_map:
            specs_list = []
            for mid, m in med_map.items():
                chem = chem_map.get(mid, {})
                pkg = pkg_map.get(mid, {})
                specs_list.append({
                    "Medicine": m.get("brand_name"),
                    "Generic Name": m.get("generic_name"),
                    "Active Ingredient": chem.get("active_ingredient", "N/A"),
                    "Strength": chem.get("strength", "N/A"),
                    "Dosage Form": chem.get("dosage_form", "N/A"),
                    "Min Temp (°C)": pkg.get("min_temp_celsius", "N/A"),
                    "Max Temp (°C)": pkg.get("max_temp_celsius", "N/A"),
                    "Humidity Limit (%)": pkg.get("humidity_limit", "N/A")
                })
            st.dataframe(pd.DataFrame(specs_list), use_container_width=True, hide_index=True)
        else:
            st.info("No technical specifications found.")
    except Exception as e:
        st.error(f"Failed to load technical standards: {e}")