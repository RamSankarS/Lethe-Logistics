import streamlit as st
import pandas as pd
from core.db_client import supabase_client

# 1. Page Config
st.set_page_config(page_title="Compliance & Audit Portal", page_icon="⚖️", layout="wide")

# 2. Auth Guard & RBAC Enforcement
if not st.session_state.get("authenticated", False):
    st.error("Access Denied. Please log in from the main portal.")
    st.stop()

user_org_type = st.session_state.get("org_type")
if user_org_type not in ["Regulatory_Body", "Admin"]:
    st.error(f"Unauthorized. Your organization type (`{user_org_type}`) cannot access the Compliance portal.")
    st.stop()

# 3. Header & Context
st.title("⚖️ Regulatory Compliance & Audit Portal")
st.caption(f"Logged in as: **{st.session_state.get('email')}** | Authority Scope: **{st.session_state.get('org_name')}**")
st.divider()

# Tabbed Interface for Regulatory Inspection
tab_audit, tab_quarantine, tab_recalls = st.tabs([
    "📜 System Audit Ledger", 
    "🚨 Environmental Breaches & Quarantine", 
    "📢 Global Recall Oversight"
])

# --- TAB 1: SYSTEM AUDIT LEDGER ---
with tab_audit:
    st.subheader("WORM Audit Trail (`identity_mod.auth_audit_logs`)")
    st.info("Read-Only View: Displays all critical administrative, login, and batch modification events across the supply chain.")
    
    try:
        response = supabase_client.schema("identity_mod") \
            .table("auth_audit_logs") \
            .select("log_id, action_type, source_module, ip_address, log_time_stamp_utc, event_payload, users(first_name, last_name, organisations(org_name))") \
            .order("log_time_stamp_utc", desc=True) \
            .limit(100) \
            .execute()
        
        logs = response.data
        if logs:
            flattened = []
            for log in logs:
                usr = log.get("users") or {}
                org = usr.get("organisations") or {}
                user_name = f"{usr.get('first_name', '')} {usr.get('last_name', '')}".strip() or "System/Unassigned"
                
                flattened.append({
                    "Timestamp (UTC)": log.get("log_time_stamp_utc")[:19] if log.get("log_time_stamp_utc") else "N/A",
                    "Action Type": log.get("action_type"),
                    "Source Module": log.get("source_module"),
                    "User": user_name,
                    "Organization": org.get("org_name", "N/A"),
                    "IP Address": log.get("ip_address"),
                    "Payload Detail": str(log.get("event_payload") or {})
                })
            
            df_audit = pd.DataFrame(flattened)
            st.dataframe(df_audit, use_container_width=True, hide_index=True)
        else:
            st.info("No audit log records found.")
            
    except Exception as e:
        st.error(f"Failed to fetch audit records: {str(e)}")

# --- TAB 2: QUARANTINE & BREACHES ---
with tab_quarantine:
    st.subheader("Active Quarantine & Cold-Chain Failure Logs")
    
    try:
        quarantine_resp = supabase_client.schema("smart_warehousing") \
            .table("quarantine_area_logs") \
            .select("quarantine_id, quarantine_reason, status, batch_master(batch_number), storage_location(zone_type, warehouse(warehouse_name)), environmental_sensor_logs(temperature_celsius, humidity_percentage)") \
            .execute()
        
        q_logs = quarantine_resp.data
        if q_logs:
            flattened_q = []
            for q in q_logs:
                batch = q.get("batch_master") or {}
                loc = q.get("storage_location") or {}
                wh = loc.get("warehouse") or {}
                sensor = q.get("environmental_sensor_logs") or {}
                
                flattened_q.append({
                    "Quarantine ID": q.get("quarantine_id"),
                    "Batch Number": batch.get("batch_number", "N/A"),
                    "Warehouse": wh.get("warehouse_name", "N/A"),
                    "Zone": loc.get("zone_type", "N/A"),
                    "Quarantine Reason": q.get("quarantine_reason"),
                    "Breach Temp (°C)": sensor.get("temperature_celsius", "N/A"),
                    "Status": q.get("status")
                })
            
            df_q = pd.DataFrame(flattened_q)
            st.dataframe(df_q, use_container_width=True, hide_index=True)
        else:
            st.info("No quarantine events currently logged.")
            
    except Exception as e:
        st.error(f"Failed to fetch quarantine logs: {str(e)}")

# --- TAB 3: GLOBAL RECALL OVERSIGHT ---
with tab_recalls:
    st.subheader("Global Recall Ledger (`reverse_logistics.global_recall_ledger`)")
    
    try:
        recalls_resp = supabase_client.schema("reverse_logistics") \
            .table("global_recall_ledger") \
            .select("recall_id, recall_reason, quarantine_status, created_at_utc, batch_master(batch_number, quantity_produced, medicines(brand_name)), organisations(org_name)") \
            .order("created_at_utc", desc=True) \
            .execute()
        
        recalls = recalls_resp.data
        if recalls:
            flattened_r = []
            for r in recalls:
                batch = r.get("batch_master") or {}
                med = batch.get("medicines") or {}
                org = r.get("organisations") or {}
                
                flattened_r.append({
                    "Recall ID": r.get("recall_id"),
                    "Initiated By": org.get("org_name", "N/A"),
                    "Batch Number": batch.get("batch_number", "N/A"),
                    "Medicine": med.get("brand_name", "N/A"),
                    "Units Produced": batch.get("quantity_produced", 0),
                    "Reason": r.get("recall_reason"),
                    "Quarantine Status": r.get("quarantine_status"),
                    "Issued At (UTC)": r.get("created_at_utc")[:16] if r.get("created_at_utc") else "N/A"
                })
            
            df_recalls = pd.DataFrame(flattened_r)
            st.dataframe(df_recalls, use_container_width=True, hide_index=True)
        else:
            st.info("No active global recalls logged.")
            
    except Exception as e:
        st.error(f"Failed to fetch recall records: {str(e)}")