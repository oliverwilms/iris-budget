# Python
import streamlit as st
import requests

# Base URL of the API
BASE_URL = "https://raw.githubusercontent.com/oliverwilms/iris-budget/master/swagger/budget.json"

st.title("Budget API Explorer")

# Example: Fetching Swagger JSON
st.subheader("Swagger JSON")
response = requests.get(BASE_URL)
if response.status_code == 200:
    swagger_data = response.json()
    st.json(swagger_data)
else:
    st.error("Failed to fetch Swagger JSON")

# Example of calling an endpoint (replace with real API base URL)
API_ENDPOINT = "http://localhost:52773/csp/rest/csp/budget/categorylist/Expense"  # Replace with actual API URL

st.subheader("Fetch Expenses")

if st.button("Get Expenses"):
    api_response = requests.get(API_ENDPOINT)
    if api_response.status_code == 200:
        expenses = api_response.json()
        st.write(expenses)
    else:
        st.error(f"API call failed: {api_response.status_code}")

# Example of calling an endpoint (replace with real API base URL)
POST_ENDPOINT = "http://localhost:52773/csp/rest/csp/budget/category"  # Replace with actual API URL

# You can create input forms to call POST endpoints
st.subheader("Add Category")
with st.form("add_budget_form"):
    name = st.text_input("Category Name")
    amount = st.number_input("Amount", min_value=0.0)
    submitted = st.form_submit_button("Add Category")
    if submitted:
        payload = {"name": name, "amount": amount}
        post_response = requests.post(POST_ENDPOINT, json=payload)
        if post_response.status_code == 201:
            st.success("Budget added successfully!")
        else:
            st.error(f"POST call failed: {post_response.status_code}")
