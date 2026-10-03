import streamlit as st
from supabase import create_client, Client

@st.cache_resource(show_spinner=False)
def init_connection() -> Client:
    """
    Initializes and returns a cached Supabase client.
    """
    try:
        url: str = st.secrets["supabase"]["url"]
        key: str = st.secrets["supabase"]["key"]
        return create_client(supabase_url=url, supabase_key=key)
    except KeyError:
        st.error("Database credentials not found. Please check .streamlit/secrets.toml")
        st.stop()
    except Exception as e:
        st.error(f"Failed to connect to the database: {str(e)}")
        st.stop()

# Initialize the client so it can be easily imported into other files
supabase_client = init_connection()