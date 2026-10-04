import streamlit as st
from core.db_client import supabase_client


def authenticate_user(email: str, password: str) -> tuple[bool, str]:
    """
    Authenticates the user via Supabase Auth and fetches their RBAC details
    from the identity_mod schema (users, roles, organisations).
    Returns a tuple: (success_boolean, message)
    """
    try:
        # 1. Authenticate against Supabase Auth (GoTrue)
        auth_response = supabase_client.auth.sign_in_with_password({
            "email": email,
            "password": password
        })

        # The Supabase Auth UID matches user_id in identity_mod.users
        user_auth_id = auth_response.user.id

        # 2. Query the identity_mod schema with foreign-key joins
        user_response = supabase_client.schema('identity_mod').table('users') \
            .select(
            'user_id, org_id, role_id, first_name, last_name, roles(role_name), organisations(org_name, org_type)') \
            .eq('user_id', user_auth_id) \
            .single() \
            .execute()

        data = user_response.data

        # 3. Populate Streamlit Session State
        st.session_state["authenticated"] = True
        st.session_state["user_id"] = user_auth_id
        st.session_state["email"] = email
        st.session_state["first_name"] = data.get("first_name", "")
        st.session_state["last_name"] = data.get("last_name", "")
        st.session_state["org_id"] = data.get("org_id")

        # Safely extract joined role name
        role_info = data.get("roles") or {}
        st.session_state["role_name"] = role_info.get("role_name", "Unassigned")

        # Safely extract joined organization info
        org_info = data.get("organisations") or {}
        st.session_state["org_name"] = org_info.get("org_name", "")
        st.session_state["org_type"] = org_info.get("org_type", "")

        return True, "Login successful"

    except Exception as e:
        st.session_state["authenticated"] = False

        error_msg = str(e)
        if "message=" in error_msg:
            try:
                error_msg = error_msg.split("message='")[1].split("'")[0]
            except IndexError:
                pass

        return False, error_msg


def logout_user():
    """
    Terminates the Supabase session and clears the Streamlit session state.
    """
    try:
        supabase_client.auth.sign_out()
    except Exception:
        pass

    st.session_state.clear()
    st.session_state["authenticated"] = False