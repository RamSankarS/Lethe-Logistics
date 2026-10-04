import streamlit as st
import pandas as pd
from core.db_client import supabase_client

# 1. Page Config
st.set_page_config(page_title="Master Data Management", page_icon="🗃️", layout="wide")

# 2. Auth Guard & RBAC Enforcement
if not st.session_state.get("authenticated", False):
    st.error("Access Denied. Please log in from the main portal.")
    st.stop()

user_role = st.session_state.get("role_name", "")
if user_role != "Admin":
    st.error(f"Unauthorized. Your role (`{user_role}`) cannot access the Master Data module.")
    st.stop()

# 3. Header & Context
st.title("🗃️ Master Data Hub")
st.caption("Manage system roles, user access, and supply chain organizational endpoints.")
st.divider()

# 4. Tabbed Interface
tab_users, tab_orgs = st.tabs([
    "👤 Users & Roles",
    "🏢 Supply Chain Organisations"
])

# --- TAB 1: USERS & ROLES ---
with tab_users:
    col1, col2 = st.columns([2, 1])

    with col1:
        st.subheader("Active System Users")
        try:
            # Query identity_mod schema with foreign-key joins to roles and organisations
            res_users = supabase_client.schema('identity_mod').table('users') \
                .select('user_id, first_name, last_name, roles(role_name), organisations(org_name)') \
                .execute()

            if res_users.data:
                flattened = []
                for u in res_users.data:
                    role_dict = u.get("roles") or {}
                    org_dict = u.get("organisations") or {}
                    flattened.append({
                        "User ID": u.get("user_id"),
                        "Name": f"{u.get('first_name', '')} {u.get('last_name', '')}".strip(),
                        "Organization": org_dict.get("org_name", "N/A"),
                        "Role": role_dict.get("role_name", "Unassigned")
                    })
                df_users = pd.DataFrame(flattened)
                st.dataframe(df_users, use_container_width=True, hide_index=True)
            else:
                st.info("No users found in identity_mod.users.")
        except Exception as e:
            st.error(f"Failed to fetch users: {e}")

    with col2:
        st.subheader("Provision New User")
        try:
            res_roles = supabase_client.schema('identity_mod').table('roles').select('role_id, role_name').execute()
            roles_map = {r["role_name"]: r["role_id"] for r in res_roles.data} if res_roles.data else {}

            res_orgs = supabase_client.schema('identity_mod').table('organisations').select(
                'org_id, org_name').execute()
            orgs_map = {o["org_name"]: o["org_id"] for o in res_orgs.data} if res_orgs.data else {}
        except Exception:
            roles_map, orgs_map = {}, {}

        with st.form("new_user_form"):
            first_name = st.text_input("First Name")
            last_name = st.text_input("Last Name")
            email = st.text_input("Work Email")
            temp_password = st.text_input("Temporary Password", type="password")

            org_choice = st.selectbox("Organization",
                                      options=list(orgs_map.keys()) if orgs_map else ["No Organisations Found"])
            role_choice = st.selectbox("Assign Role",
                                       options=list(roles_map.keys()) if roles_map else ["No Roles Found"])

            if st.form_submit_button("Register User", use_container_width=True):
                if not first_name or not email or not temp_password or not roles_map or not orgs_map:
                    st.error("All fields, roles, and organisations are required.")
                else:
                    try:
                        # 1. Create in Supabase Auth
                        auth_res = supabase_client.auth.admin.create_user({
                            "email": email,
                            "password": temp_password,
                            "email_confirm": True
                        })

                        # 2. Insert into identity_mod.users using auth user id as primary key
                        supabase_client.schema('identity_mod').table('users').insert({
                            "user_id": auth_res.user.id,
                            "first_name": first_name,
                            "last_name": last_name,
                            "org_id": orgs_map[org_choice],
                            "role_id": roles_map[role_choice],
                            "is_active": True
                        }).execute()

                        st.success("User provisioned successfully!")
                        st.rerun()
                    except Exception as e:
                        st.error(f"Error provisioning user: {e}")

# --- TAB 2: ORGANISATIONS ---
with tab_orgs:
    st.subheader("Registered Supply Chain Entities (Manufacturers, Suppliers, Retailers)")

    col_org_form, col_org_data = st.columns([1, 2])

    with col_org_form:
        st.markdown("##### Register Organisation")
        with st.form("new_org_form"):
            org_name = st.text_input("Organisation Name")
            org_type = st.selectbox("Organisation Type", ["Manufacturer", "Supplier", "Retailer", "Logistics Provider"])
            reg_no = st.text_input("Registration / License No.")
            contact_email = st.text_input("Contact Email")

            if st.form_submit_button("Register Organisation", use_container_width=True):
                if not org_name or not reg_no:
                    st.error("Name and Registration number are required.")
                else:
                    try:
                        supabase_client.schema('identity_mod').table('organisations').insert({
                            "org_name": org_name,
                            "org_type": org_type,
                            "reg_no": reg_no,
                            "contact_email": contact_email,
                            "is_active": True
                        }).execute()
                        st.success(f"Organisation '{org_name}' registered successfully!")
                        st.rerun()
                    except Exception as e:
                        st.error(f"Database error: {e}")

    with col_org_data:
        try:
            res_orgs_list = supabase_client.schema('identity_mod').table('organisations').select("*").execute()
            if res_orgs_list.data:
                df_orgs = pd.DataFrame(res_orgs_list.data).rename(columns={
                    "org_id": "Org ID",
                    "org_name": "Name",
                    "org_type": "Type",
                    "reg_no": "Reg No.",
                    "contact_email": "Email",
                    "is_active": "Active"
                })
                st.dataframe(df_orgs, use_container_width=True, hide_index=True)
            else:
                st.info("No organisations registered in identity_mod.organisations.")
        except Exception as e:
            st.error(f"Failed to load organisations: {e}")