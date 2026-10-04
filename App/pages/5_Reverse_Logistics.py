import streamlit as st
import pandas as pd
from core.db_client import supabase_client
from datetime import datetime, date

# 1. Page Config
st.set_page_config(page_title="Reverse Logistics & Compliance", page_icon="🚨", layout="wide")

# 2. Auth Guard & RBAC Enforcement
if not st.session_state.get("authenticated", False):
    st.error("Access Denied. Please log in from the main portal.")
    st.stop()

user_role = st.session_state.get("role_name", "")
if user_role not in ["Admin", "Manufacturer", "Retailer"]:
    st.error(f"Unauthorized. Your role (`{user_role}`) cannot access Reverse Logistics.")
    st.stop()

# 3. Header & Context
st.title("🚨 Reverse Logistics, Recalls & Disposal Ledger")
st.caption("Manage global drug recalls, return requests, quality assessments, and certified immutable disposals.")
st.divider()

# 4. Fetch Reference Data Independently
try:
    orgs_res = supabase_client.schema('identity_mod').table('organisations').select("*").execute()
    batches_res = supabase_client.schema('product_and_batch_intelligence').table('batch_master').select("*").execute()
    meds_res = supabase_client.schema('product_and_batch_intelligence').table('medicines').select("*").execute()
    users_res = supabase_client.schema('identity_mod').table('users').select("*").execute()

    org_map = {o["org_id"]: o for o in orgs_res.data} if orgs_res.data else {}
    batch_map = {b["batch_id"]: b for b in batches_res.data} if batches_res.data else {}
    med_map = {m["medicine_id"]: m for m in meds_res.data} if meds_res.data else {}
    user_map = {u["user_id"]: u for u in users_res.data} if users_res.data else {}
except Exception as e:
    st.error(f"Error fetching reference data: {e}")
    org_map, batch_map, med_map, user_map = {}, {}, {}, {}

# 5. Tabbed Interface
tab_recalls, tab_returns, tab_assessments, tab_disposals = st.tabs([
    "📢 Global Recalls",
    "↩️ Return Requests & Analytics",
    "🔬 Stock Assessments",
    "☢️ Disposal Certificates"
])

# --- TAB 1: GLOBAL RECALLS ---
with tab_recalls:
    st.subheader("Global Recall Ledger")
    col_rc_form, col_rc_data = st.columns([1, 2])

    with col_rc_form:
        with st.form("global_recall_form"):
            st.markdown("##### Initiate Batch Recall")
            active_batches = {
                f"{b['batch_number']} ({med_map.get(b['medicine_id'], {}).get('brand_name', 'N/A')})": b["batch_id"] for
                b in batch_map.values() if b.get("status") != "Disposed"}
            org_options = {o["org_name"]: o["org_id"] for o in org_map.values()}

            sel_batch = st.selectbox("Target Batch",
                                     options=list(active_batches.keys()) if active_batches else ["No Active Batches"])
            initiating_org = st.selectbox("Initiating Organisation",
                                          options=list(org_options.keys()) if org_options else ["No Organisations"])
            quarantine_status = st.selectbox("Quarantine Status",
                                             ["Strict Hold", "Warehouse Quarantine", "In-Transit Lock"])
            recall_reason = st.text_area("Recall Reason / Regulatory Cause",
                                         placeholder="e.g., Contamination detected in active pharmaceutical ingredient.")

            if st.form_submit_button("Broadcast Recall Notice", use_container_width=True):
                if not active_batches or not org_options:
                    st.error("Missing batch or organisation dependencies.")
                else:
                    try:
                        target_batch_id = active_batches[sel_batch]

                        # 1. Insert into reverse_logistics.global_recall_ledger
                        supabase_client.schema('reverse_logistics').table('global_recall_ledger').insert({
                            "batch_id": target_batch_id,
                            "initiated_by_org_id": org_options[initiating_org],
                            "recall_reason": recall_reason,
                            "quarantine_status": quarantine_status,
                            "created_at_utc": datetime.utcnow().isoformat()
                        }).execute()

                        # 2. Globally update batch status to Recall
                        supabase_client.schema('product_and_batch_intelligence').table('batch_master').update({
                            "status": "Recall"
                        }).eq("batch_id", target_batch_id).execute()

                        st.success("Global recall notice broadcasted and batch status locked to 'Recall'!")
                        st.rerun()
                    except Exception as e:
                        st.error(f"Database error: {e}")

    with col_rc_data:
        try:
            recalls_res = supabase_client.schema('reverse_logistics').table('global_recall_ledger').select(
                "*").execute()
            recalls = recalls_res.data if recalls_res.data else []

            if recalls:
                flat_recalls = []
                for r in recalls:
                    b = batch_map.get(r.get("batch_id"), {})
                    org = org_map.get(r.get("initiated_by_org_id"), {})
                    flat_recalls.append({
                        "Recall ID": r.get("recall_id"),
                        "Batch Number": b.get("batch_number", "N/A"),
                        "Initiated By": org.get("org_name", "N/A"),
                        "Quarantine Status": r.get("quarantine_status"),
                        "Reason": r.get("recall_reason"),
                        "Date (UTC)": r.get("created_at_utc", "")[:16].replace("T", " ")
                    })
                st.dataframe(pd.DataFrame(flat_recalls), use_container_width=True, hide_index=True)
            else:
                st.info("No active global recalls logged.")
        except Exception as e:
            st.error(f"Failed to fetch global recalls: {e}")

# --- TAB 2: RETURN REQUESTS & ANALYTICS ---
with tab_returns:
    st.subheader("Retailer Return Requests & Volume Analytics")

    # Fetch returns data for interactive charts
    try:
        returns_res = supabase_client.schema('reverse_logistics').table('return_requests').select("*").execute()
        returns_data = returns_res.data if returns_res.data else []
    except Exception:
        returns_data = []

    if returns_data:
        df_ret = pd.DataFrame(returns_data)
        col_ch1, col_ch2 = st.columns(2)
        with col_ch1:
            st.markdown("##### Return Requests by Status")
            status_counts = df_ret["status"].value_counts().reset_index()
            status_counts.columns = ["Status", "Count"]
            st.bar_chart(status_counts.set_index("Status"), color="#ff4b4b")
        with col_ch2:
            st.markdown("##### Return Volume by Reason")
            reason_counts = df_ret.groupby("return_reason")["quantity_returned"].sum().reset_index()
            reason_counts.columns = ["Reason", "Total Quantity"]
            st.bar_chart(reason_counts.set_index("Reason"), color="#faca2b")
        st.divider()

    col_ret_form, col_ret_data = st.columns([1, 1.5])

    with col_ret_form:
        st.markdown("##### File Master Return")
        retailers = {o["org_name"]: o["org_id"] for o in org_map.values() if o.get("org_type") == "Retailer"}
        all_batches = {f"{b['batch_number']}": b["batch_id"] for b in batch_map.values()}

        with st.form("return_request_form"):
            buyer_org = st.selectbox("Returner Organisation (Retailer)",
                                     options=list(retailers.keys()) if retailers else ["No Retailers"])
            sel_batch_ret = st.selectbox("Batch to Return",
                                         options=list(all_batches.keys()) if all_batches else ["No Batches"])
            qty_returned = st.number_input("Quantity Returned", min_value=1, step=10, value=50)
            return_reason = st.text_area("Return Reason",
                                         placeholder="e.g., Expired shelf-life / Packaging compromise.")
            status = st.selectbox("Status", ["Pending", "Approved", "Rejected"])

            if st.form_submit_button("Submit Return Request", use_container_width=True):
                if not retailers or not all_batches:
                    st.error("Missing retailer or batch records.")
                else:
                    try:
                        supabase_client.schema('reverse_logistics').table('return_requests').insert({
                            "returner_org_id": retailers[buyer_org],
                            "batch_id": all_batches[sel_batch_ret],
                            "quantity_returned": qty_returned,
                            "return_reason": return_reason,
                            "status": status,
                            "created_at_utc": datetime.utcnow().isoformat()
                        }).execute()
                        st.success("Return request successfully filed!")
                        st.rerun()
                    except Exception as e:
                        st.error(f"Database error: {e}")

    with col_ret_data:
        st.markdown("##### Active Return Requests Registry")
        if returns_data:
            flat_returns = []
            for rr in returns_data:
                org = org_map.get(rr.get("returner_org_id"), {})
                b = batch_map.get(rr.get("batch_id"), {})
                flat_returns.append({
                    "Return ID": rr.get("return_id"),
                    "Retailer": org.get("org_name", "N/A"),
                    "Batch": b.get("batch_number", "N/A"),
                    "Qty": rr.get("quantity_returned"),
                    "Reason": rr.get("return_reason"),
                    "Status": rr.get("status")
                })
            st.dataframe(pd.DataFrame(flat_returns), use_container_width=True, hide_index=True)
        else:
            st.info("No return requests recorded.")

# --- TAB 3: STOCK ASSESSMENTS ---
with tab_assessments:
    st.subheader("Returned Stock Quality Assessments")
    col_a_form, col_a_data = st.columns([1, 2])

    with col_a_form:
        try:
            ret_res = supabase_client.schema('reverse_logistics').table('return_requests').select("return_id").execute()
            return_options = {r["return_id"]: r["return_id"] for r in (ret_res.data or [])}
        except Exception:
            return_options = {}

        with st.form("stock_assessment_form"):
            sel_return_id = st.selectbox("Return Request ID",
                                         options=list(return_options.keys()) if return_options else ["No Requests"])
            inspection_result = st.text_area("Inspection Findings",
                                             placeholder="e.g., Seal broken, moisture ingress confirmed.")
            disposition_action = st.selectbox("Recommended Disposition Action",
                                              ["Destroy / Incinerate", "Return to Manufacturer", "Quarantine Hold"])

            if st.form_submit_button("Record Assessment", use_container_width=True):
                if not return_options:
                    st.error("No return requests available for assessment.")
                else:
                    try:
                        supabase_client.schema('reverse_logistics').table('return_stock_assessment').insert({
                            "return_id": sel_return_id,
                            "inspector_user_id": st.session_state["user_id"],
                            "inspection_result": inspection_result,
                            "disposition_action": disposition_action,
                            "assessed_at_utc": datetime.utcnow().isoformat()
                        }).execute()
                        st.success("Stock assessment recorded successfully!")
                        st.rerun()
                    except Exception as e:
                        st.error(f"Database error: {e}")

    with col_a_data:
        try:
            assess_res = supabase_client.schema('reverse_logistics').table('return_stock_assessment').select(
                "*").execute()
            assessments = assess_res.data if assess_res.data else []

            if assessments:
                flat_ass = []
                for a in assessments:
                    u = user_map.get(a.get("inspector_user_id"), {})
                    flat_ass.append({
                        "Assessment ID": a.get("assessment_id"),
                        "Return ID": a.get("return_id"),
                        "Inspector": f"{u.get('first_name', '')} {u.get('last_name', '')}".strip(),
                        "Result": a.get("inspection_result"),
                        "Disposition": a.get("disposition_action")
                    })
                st.dataframe(pd.DataFrame(flat_ass), use_container_width=True, hide_index=True)
            else:
                st.info("No stock assessments recorded.")
        except Exception as e:
            st.error(f"Failed to fetch assessments: {e}")

# --- TAB 4: DISPOSAL CERTIFICATES & ANALYTICS ---
with tab_disposals:
    st.subheader("☢️️ Certified Disposal Certificates & Ledger")

    # Fetch disposal certs for analytics chart
    try:
        certs_res = supabase_client.schema('reverse_logistics').table('disposal_certificates').select("*").execute()
        certs = certs_res.data if certs_res.data else []
    except Exception:
        certs = []

    if certs:
        df_certs = pd.DataFrame(certs)
        st.markdown("##### Disposal Methods Distribution")
        method_counts = df_certs["disposal_method"].value_counts().reset_index()
        method_counts.columns = ["Disposal Method", "Count"]
        st.bar_chart(method_counts.set_index("Disposal Method"), color="#dc3545")
        st.divider()

    if user_role == "Retailer":
        st.warning("Retailer clearance restricts execution of disposal certificates. Read-only view.")
        show_disposal_form = False
    else:
        show_disposal_form = True

    col_d_form, col_d_data = st.columns([1, 1.5])

    if show_disposal_form:
        with col_d_form:
            try:
                assess_res = supabase_client.schema('reverse_logistics').table('return_stock_assessment').select(
                    "assessment_id").execute()
                assessment_options = {a["assessment_id"]: a["assessment_id"] for a in (assess_res.data or [])}
            except Exception:
                assessment_options = {}

            with st.form("disposal_certificate_form"):
                sel_assessment = st.selectbox("Assessment ID",
                                              options=list(assessment_options.keys()) if assessment_options else [
                                                  "No Assessments"])
                disposal_method = st.selectbox("Disposal Method", ["High-Temp Incineration", "Chemical Neutralization",
                                                                   "Controlled Landfill"])
                evidence_hash = st.text_input("Evidence Hash / Certificate Ref",
                                              placeholder="SHA-256 Hash of destruction certificate")

                if st.form_submit_button("Issue Disposal Certificate", use_container_width=True):
                    if not assessment_options:
                        st.error("No valid assessments available.")
                    else:
                        try:
                            supabase_client.schema('reverse_logistics').table('disposal_certificates').insert({
                                "assessment_id": sel_assessment,
                                "witness_user_id": st.session_state["user_id"],
                                "disposal_method": disposal_method,
                                "evidence_hash": evidence_hash,
                                "disposed_at_utc": datetime.utcnow().isoformat()
                            }).execute()
                            st.success("Disposal certificate issued and logged immutably!")
                            st.rerun()
                        except Exception as e:
                            st.error(f"Database error: {e}")

    with col_d_data:
        st.markdown("##### Disposal Certificates Registry")
        if certs:
            flat_certs = []
            for c in certs:
                u = user_map.get(c.get("witness_user_id"), {})
                flat_certs.append({
                    "Certificate ID": c.get("certificate_id"),
                    "Assessment ID": c.get("assessment_id"),
                    "Witness": f"{u.get('first_name', '')} {u.get('last_name', '')}".strip(),
                    "Method": c.get("disposal_method"),
                    "Evidence Hash": c.get("evidence_hash"),
                    "Disposed At (UTC)": c.get("disposed_at_utc", "")[:16].replace("T", " ")
                })
            st.dataframe(pd.DataFrame(flat_certs), use_container_width=True, hide_index=True)
        else:
            st.info("No disposal certificates issued.")