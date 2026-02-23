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

# URLs for calling bedget categorylists endpoints 
API_ENDPOINT1 = "http://localhost:52773/csp/rest/csp/budget/categorylist/Income"
API_ENDPOINT2 = "http://localhost:52773/csp/rest/csp/budget/categorylist/Expense"

# Create two columns
colIncome, colExpense = st.columns(2)

# Add content to the first column
with colIncome:
    st.subheader("Income")
    # if st.button("Get Expenses"):
    api_response1 = requests.get(API_ENDPOINT1)
    if api_response1.status_code == 200:
        expenses = api_response1.json()
        st.write(expenses)
    else:
        st.error(f"API call failed: {api_response1.status_code}")
    # Validate that categorylist exists and is a list of strings
    if not isinstance(expenses.get("categorylist"), list) or not all(isinstance(item, str) for item in expenses["categorylist"]):
        st.error("'categorylist' must be an array of strings.")
        st.stop()
    category_list = expenses["categorylist"]
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
