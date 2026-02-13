# app.py - Main Application Entry Point
"""
IRIS Data Manager - Main Application

MIT License

Copyright (c) 2025 Pietro Di Leo

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

A Streamlit application for managing and analyzing InterSystems IRIS data
"""

import streamlit as st
import logging
from utils.session_state import initialize_session_state
from ui.connection_sidebar import render_connection_sidebar
from ui.upload_tab import render_upload_tab
from ui.explore_tab import render_explore_tab
from config.settings import AppConfig

# Load environment variables from .env file
config = AppConfig()

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# ---------- Page Configuration ----------
st.set_page_config(
    page_title="IRIS Data Manager", 
    layout="wide",
    page_icon="📊",
    initial_sidebar_state="expanded"
)

# ---------- Initialize Session State ----------
initialize_session_state(config)

# ---------- Render Connection Sidebar ----------
render_connection_sidebar(config)

# ---------- Main Content ----------
st.title("📊 IRIS Data Manager")
st.write("Upload files, explore data, or manually define tables to save on InterSystems IRIS.")

# Check connection status
if st.session_state.iris_connection is None:
    st.warning("⚠️ **Not connected to database**. Please configure connection in the sidebar.")
    st.stop()

# ---------- Create Tabs (only if connected) ----------
tab_names = ["📤 Upload Data", "🔍 Explore & Analyze"]
tabs = st.tabs(tab_names)

# ---------- Render Tabs ----------
with tabs[0]:
    render_upload_tab(st.session_state.iris_connection)

with tabs[1]:
    render_explore_tab(st.session_state.iris_connection)
