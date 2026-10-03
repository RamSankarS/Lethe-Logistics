import streamlit as st
import pandas as pd
from core.db_client import supabase_client

# 1. Page Config
st.set_page_config(page_title="Distributor Portal", page_icon="📦", layout="wide")

# 2. Auth Guard & RBAC Enforcement
if not st.session_state.get("authenticated", False):
    st.error("Access Denied. Please log in from the main portal.")
    st.stop()

user_org_type = st.session_state.get("org_type")
if user_org_type not in ["Distributor", "Admin"]:
    st.error(f"Unauthorized. Your organization type (`{user_org_type}`) cannot access the Distributor portal.")
    st.stop()

# 3. Header & Context
st.title("📦 Distributor Operations Portal")
st.caption(f"Logged in as: **{st.session_state.get('email')}** | Organization: **{st.session_state.get('org_name')}**")
st.divider()

# Tabbed Interface for Modular Workflows
tab_inventory, tab_sensors = st.tabs([
    "📊 Live Inventory", 
    "❄️ Cold-Chain Monitors"
])

# --- TAB 1: LIVE INVENTORY ---
with tab_inventory:
    st.subheader("Current Warehouse Inventory")
    
    try:
        # Perform deep relational joins across schemas to get readable inventory data
        inv_resp = supabase_client.schema("smart_warehousing") \
            .table("inventory") \
            .select("available_quantity, last_update, storage_location(zone_type, warehouse(warehouse_name, city)), batch_master(batch_number, status)") \
            .execute()
        
        if inv_resp.data:
            flattened = []
            for item in inv_resp.data:
                # Safely extract nested JSON objects returned by Supabase
                loc = item.get("storage_location") or {}
                wh = loc.get("warehouse") or {}
                batch = item.get("batch_master") or {}
                
                flattened.append({
                    "Warehouse": wh.get("warehouse_name", "N/A"),
                    "City": wh.get("city", "N/A"),
                    "Zone": loc.get("zone_type", "N/A"),
                    "Batch Number": batch.get("batch_number", "N/A"),
                    "Qty Available": item.get("available_quantity", 0),
                    "Status": batch.get("status", "N/A"),
                    "Last Verified": item.get("last_update")[:16] if item.get("last_update") else "N/A"
                })
            df = pd.DataFrame(flattened)
            st.dataframe(df, use_container_width=True, hide_index=True)
        else:
            st.info("No active inventory found.")
            
    except Exception as e:
        st.error(f"Failed to fetch inventory records: {str(e)}")

# --- TAB 2: COLD-CHAIN SENSORS ---
with tab_sensors:
    st.subheader("Environmental Sensor Logs")
    st.write("Real-time telemetry from storage locations to ensure CDSCO/FDA temperature compliance.")
    
    try:
        # Fetch the latest 50 sensor logs, joining target thresholds from the location table
        sensor_resp = supabase_client.schema("smart_warehousing") \
            .table("environmental_sensor_logs") \
            .select("temperature_celsius, humidity_percentage, recorded_at, storage_location(zone_type, target_max_temp, warehouse(warehouse_name))") \
            .order("recorded_at", desc=True) \
            .limit(50) \
            .execute()
            
        if sensor_resp.data:
            sensor_data = []
            for log in sensor_resp.data:
                loc = log.get("storage_location") or {}
                wh = loc.get("warehouse") or {}
                
                temp = log.get("temperature_celsius")
                max_temp = loc.get("target_max_temp")
                
                # Dynamic Python-side compliance checking
                status = "✅ Stable"
                if temp and max_temp and temp > max_temp:
                    status = "🚨 BREACH"
                    
                sensor_data.append({
                    "Timestamp": log.get("recorded_at")[:16] if log.get("recorded_at") else "N/A",
                    "Warehouse": wh.get("warehouse_name", "N/A"),
                    "Zone": loc.get("zone_type", "N/A"),
                    "Temp (°C)": temp,
                    "Humidity (%)": log.get("humidity_percentage"),
                    "Max Temp Limit": max_temp,
                    "Compliance": status
                })
            
            # Applying styling to highlight breaches instantly
            df_sensors = pd.DataFrame(sensor_data)
            st.dataframe(
                df_sensors.style.map(lambda x: "background-color: #ff4b4b; color: white;" if x == "🚨 BREACH" else "", subset=["Compliance"]),
                use_container_width=True, 
                hide_index=True
            )
        else:
            st.info("No sensor logs available.")
            
    except Exception as e:
        st.error(f"Failed to fetch sensor logs: {str(e)}")