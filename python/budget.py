# Python
import streamlit as st
import requests
import json

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

# if st.button("Get Expenses"):
api_response = requests.get(API_ENDPOINT)
if api_response.status_code == 200:
    expenses = api_response.json()
    st.write(expenses)
else:
    st.error(f"API call failed: {api_response.status_code}")

# Parse JSON safely
try:
    data = json.loads(expenses)
    category_list = data.get("categorylist", [])
    if not isinstance(category_list, list) or not all(isinstance(item, str) for item in category_list):
        st.error("Invalid categorylist format. Must be an array of strings.")
        st.stop()
except json.JSONDecodeError:
    st.error("Invalid JSON format.")
    st.stop()

st.subheader("Dynamic Streamlit Form Example")

# Create a form
with st.form("dynamic_form"):
    form_data = {}
    # Loop through category list and create inputs dynamically
    for category in category_list:
        # Create a number input for each category
        form_data[category] = st.number_input(category, min_value=0, step=1)

    # Submit button
    submitted = st.form_submit_button("Submit")

# Handle form submission
if submitted:
    st.success("Form submitted successfully!")
    st.json(form_data)


# Example of calling an endpoint (replace with real API base URL)
POST_ENDPOINT = "http://localhost:52773/csp/rest/csp/budget/category"  # Replace with actual API URL

# You can create input forms to call POST endpoints
st.subheader("Add Category")
with st.form("add_budget_form"):
    options = ["Income", "Expense"]
    type = st.radio("Category Type:", options, index=0)
    name = st.text_input("Category Name")
    amount = st.number_input("Amount", min_value=0.0)
    submitted = st.form_submit_button("Add Category")
    if submitted:
        payload = {"type": type, "name": name, "amount": amount}
        post_response = requests.post(POST_ENDPOINT, json=payload)
        if post_response.status_code == 200:
            st.success("Category added successfully!")
        else:
            st.error(f"POST call failed: {post_response.status_code}")
