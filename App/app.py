import streamlit as st
from core.db_client import supabase_client
from core.auth import authenticate_user, logout_user

# 1. Page Configuration (Must be the first command)
st.set_page_config(
    page_title="Lethe Logistics Platform",
    page_icon="📦",
    layout="wide",
    initial_sidebar_state="collapsed"
)

# 2. Session State Initialization
if "authenticated" not in st.session_state:
    st.session_state["authenticated"] = False


# 3. Dynamic Page Routing
def main():
    if not st.session_state["authenticated"]:
        # --- CSS INJECTION: HIDE SIDEBAR ON LOGIN ---
        st.markdown(
            """
            <style>
                [data-testid="collapsedControl"] {display: none;}
                [data-testid="stSidebar"] {display: none;}
            </style>
            """,
            unsafe_allow_html=True,
        )

        # --- CLEAN LOGIN INTERFACE ---
        st.markdown("<h1 style='text-align: center;'>Lethe Logistics</h1>", unsafe_allow_html=True)
        st.markdown("<h4 style='text-align: center; color: gray;'>Closed-Loop Pharmaceutical Supply Chain</h4>",
                    unsafe_allow_html=True)
        st.write("")
        st.write("")

        col1, col2, col3 = st.columns([1, 1.5, 1])
        with col2:
            with st.form("login_form"):
                email = st.text_input("Work Email", placeholder="admin@lethe.com")
                password = st.text_input("Password", type="password")
                submit = st.form_submit_button("Authenticate", use_container_width=True)

                if submit:
                    success, msg = authenticate_user(email, password)
                    if success:
                        st.rerun()
                    else:
                        st.error(f"Authentication Failed: {msg}")

    else:
        # --- ROLE-BASED WORKFLOW ROUTING ---
        user_role = st.session_state.get("role_name", "")

        page_master = st.Page("pages/1_Master_Data.py", title="Master Data", icon="🗃️")
        page_prod = st.Page("pages/2_Production.py", title="Production & Batches", icon="🏭")
        page_inv = st.Page("pages/3_Inventory.py", title="Inventory & QC", icon="🏢")
        page_fwd = st.Page("pages/4_Forward_Logistics.py", title="Forward Logistics", icon="🚚")
        page_rev = st.Page("pages/5_Reverse_Logistics.py", title="Reverse Logistics", icon="🚨")

        nav_pages = []
        if user_role == "Admin":
            nav_pages = [page_master, page_prod, page_inv, page_fwd, page_rev]
        elif user_role == "Manufacturer":
            nav_pages = [page_prod, page_inv, page_fwd, page_rev]
        elif user_role == "Retailer":
            nav_pages = [page_fwd, page_rev]
        else:
            st.error("Role not recognized or unassigned.")
            if st.button("Log Out"):
                logout_user()
                st.rerun()
            st.stop()

        pg = st.navigation(nav_pages)

        st.sidebar.title("🔐 Session Profile")
        st.sidebar.write(f"**User:** {st.session_state.get('email', 'Unknown')}")
        st.sidebar.write(f"**Role:** {user_role}")
        st.sidebar.divider()
        if st.sidebar.button("Log Out", use_container_width=True):
            logout_user()
            st.rerun()

        pg.run()


if __name__ == "__main__":
    main()