import streamlit as st
from core.auth import authenticate_user, logout_user

# 1. Page Configuration
st.set_page_config(
    page_title="Lethe Logistics Platform",
    page_icon="📦",
    layout="wide",
    initial_sidebar_state="expanded"
)

# 2. Session State Initialization
if "authenticated" not in st.session_state:
    st.session_state["authenticated"] = False

# 3. Main Application Entrypoint
def main():
    if not st.session_state["authenticated"]:
        # --- LOGIN SCREEN ---
        st.title("📦 Lethe Logistics")
        st.subheader("Closed-Loop Pharmaceutical Supply Chain Platform")
        st.write("Please log in with your organization credentials to access your portal.")

        col1, col2, col3 = st.columns([1, 2, 1])
        with col2:
            with st.form("login_form", clear_on_submit=False):
                email = st.text_input("Work Email", placeholder="user@organization.com")
                password = st.text_input("Password", type="password")
                submit = st.form_submit_button("Sign In", use_container_width=True)

                if submit:
                    if not email or not password:
                        st.error("Please enter both email and password.")
                    else:
                        with st.spinner("Authenticating and fetching RBAC permissions..."):
                            success, message = authenticate_user(email, password)
                            if success:
                                st.success("Login successful!")
                                st.rerun()
                            else:
                                st.error(f"Authentication failed: {message}")

    else:
        # --- AUTHENTICATED LANDING HUB ---
        st.sidebar.title("🔐 User Profile")
        st.sidebar.write(f"**User:** {st.session_state.get('email')}")
        st.sidebar.write(f"**Organization:** {st.session_state.get('org_name')}")
        st.sidebar.write(f"**Org Type:** `{st.session_state.get('org_type')}`")
        st.sidebar.write(f"**Role:** `{st.session_state.get('system_role')}`")
        
        st.sidebar.divider()
        if st.sidebar.button("Log Out", use_container_width=True):
            logout_user()
            st.rerun()

        # Main Hub Welcome View
        st.title(f"Welcome, {st.session_state.get('org_name')}")
        st.info("👈 Use the navigation sidebar to select your operational dashboard.")

        st.markdown("""
        ### Active Session Overview
        Your identity and organization domain have been verified:
        """)
        
        m_col1, m_col2, m_col3 = st.columns(3)
        m_col1.metric("Organization Type", st.session_state.get("org_type"))
        m_col2.metric("Assigned System Role", st.session_state.get("system_role"))
        m_col3.metric("Security Status", "Authenticated (Active)")

if __name__ == "__main__":
    main()