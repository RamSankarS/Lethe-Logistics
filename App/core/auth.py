import streamlit as st
from core.db_client import supabase_client

def authenticate_user(email: str, password: str) -> tuple[bool, str]:
    """
    Authenticates the user via Supabase and fetches their RBAC and Organization data.
    Returns a tuple: (success_boolean, message)
    """
    try:
        # 1. Authenticate against Supabase Auth (JWT generation)
        auth_response = supabase_client.auth.sign_in_with_password({
            "email": email,
            "password": password
        })
        
        user_id = auth_response.user.id
        
        # 2. Fetch RBAC and Organization details from the identity_mod schema
        # FIX: We now perform a double-join to get both the org_type and the role_name.
        user_response = supabase_client.schema('identity_mod').table('users') \
            .select('org_id, organisations(org_type, org_name), roles(role_name)') \
            .eq('user_id', user_id) \
            .single() \
            .execute()

        data = user_response.data
        
        # 3. Inject critical data into Streamlit's Session State
        st.session_state["authenticated"] = True
        st.session_state["user_id"] = user_id
        st.session_state["email"] = email
        st.session_state["org_id"] = data.get("org_id")
        
        # Safely extract the joined organization data
        org_info = data.get("organisations") or {}
        st.session_state["org_type"] = org_info.get("org_type")
        st.session_state["org_name"] = org_info.get("org_name")
        
        # FIX: Safely extract the joined role data
        role_info = data.get("roles") or {}
        st.session_state["system_role"] = role_info.get("role_name")

        return True, "Login successful"

    except Exception as e:
        # Force authentication to false if any step fails
        st.session_state["authenticated"] = False
        
        # FIX: Cleanly parse the Supabase API exception to show readable errors to the user.
        error_msg = str(e)
        if "message=" in error_msg:
            try:
                error_msg = error_msg.split("message='")[1].split("'")[0]
            except IndexError:
                pass
                
        return False, error_msg

def logout_user():
    """
    Terminates the Supabase session and completely wipes the Streamlit session state.
    """
    try:
        supabase_client.auth.sign_out()
    except Exception:
        pass # If session is already expired on server, just proceed to wipe local state
    
    st.session_state.clear()
    st.session_state["authenticated"] = False