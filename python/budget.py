# Python
import streamlit as st
import requests
import json

# Base URL of the API
BASE_URL = "https://raw.githubusercontent.com/oliverwilms/iris-budget/master/swagger/budget.json"

st.title("Budget API Explorer")

# Example: Fetching Swagger JSON
# st.subheader("Swagger JSON")
response = requests.get(BASE_URL)
if response.status_code == 200:
    swagger_data = response.json()
    #st.json(swagger_data)
else:
    st.error("Failed to fetch Swagger JSON")

# URLs for calling bedget categorylists endpoints 
API_ENDPOINT1 = "http://localhost:52773/csp/rest/csp/budget/categorylist/Income"
API_ENDPOINT2 = "http://localhost:52773/csp/rest/csp/budget/categorylist/Expense"
SUBMIT_API = "https://example.com/api/finance/submit"  # POST endpoint

# Fetch categories from APIs
def get_categories(url):
    try:
        response = requests.get(url)
        response.raise_for_status()
        return response.json()  # Expecting a list of category names
    except Exception as e:
        st.error(f"Error fetching categories: {e}")
        return []

expense_categories = get_categories(API_ENDPOINT2)
income_categories = get_categories(API_ENDPOINT1)
expense_list = expense_categories["categorylist"]
income_list = income_categories["categorylist"]

st.subheader("💰 Expense & Income Entry Form")

with st.form("budget_form"):
    col1, col2 = st.columns(2)

    expense_data = {}
    income_data = {}

    with col1:
        st.subheader("Income")
        for cat in income_list:
            income_data[cat] = st.number_input(
                f"{cat} (Income)", min_value=0.0, step=0.01, format="%.2f"
            )

    with col2:
        st.subheader("Expenses")
        for cat in expense_list:
            expense_data[cat] = st.number_input(
                f"{cat} (Expense)", min_value=0.0, step=0.01, format="%.2f"
            )

    submitted = st.form_submit_button("Submit")

if submitted:
    payload = {
        "expenses": expense_data,
        "income": income_data
    }

    try:
        res = requests.post(SUBMIT_API, json=payload)
        res.raise_for_status()
        st.success("✅ Data submitted successfully!")
        st.json(res.json())  # Show API response
    except requests.exceptions.RequestException as e:
        st.error(f"❌ Failed to submit data: {e}")


# Create two columns
colIncome, colExpense = st.columns(2)

# Add content to the first column
with colIncome:
    st.subheader("Income")
    # if st.button("Get Incomes"):
    api_response1 = requests.get(API_ENDPOINT1)
    if api_response1.status_code == 200:
        expenses = api_response1.json()
        #st.write(expenses)
    else:
        st.error(f"API call failed: {api_response1.status_code}")
    # Validate that categorylist exists and is a list of strings
    if not isinstance(expenses.get("categorylist"), list) or not all(isinstance(item, str) for item in expenses["categorylist"]):
        st.error("'categorylist' must be an array of strings.")
        st.stop()
    category_list = expenses["categorylist"]
    # Create a form
    with st.form("income_form"):
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

# Add content to the second column
with colExpense:
    st.subheader("Expense")
    # if st.button("Get Expenses"):
    api_response1 = requests.get(API_ENDPOINT2)
    if api_response1.status_code == 200:
        expenses = api_response1.json()
        #st.write(expenses)
    else:
        st.error(f"API call failed: {api_response1.status_code}")
    # Validate that categorylist exists and is a list of strings
    if not isinstance(expenses.get("categorylist"), list) or not all(isinstance(item, str) for item in expenses["categorylist"]):
        st.error("'categorylist' must be an array of strings.")
        st.stop()
    category_list = expenses["categorylist"]
    # Create a form
    with st.form("expense_form"):
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
