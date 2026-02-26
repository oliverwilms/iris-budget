 [![Gitter](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/iris-budget)
 [![Quality Gate Status](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Firis-budget&metric=alert_status)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Firis-budget)
 [![Reliability Rating](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Firis-budget&metric=reliability_rating)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Firis-budget)
# InterSystems IRIS Full Stack Budget App
This app was developed using iris-fullstack-template. It consists of InterSystems IRIS REST API and Frontend Application. 
It has Unit tests which could be run interactively, or using ZPM, or via Github CI.
It demoes the way to develop using Docker containers.
It demoes how to package the application in ZPM module and how to deploy it using ZPM.

I need a table of categories to create a budget for my personal finance.

I chose to use Streamlit for my frontend application to communicate with InterSystes IRIS.
<img width="1411" alt="Screenshot" src="https://github.com/oliverwilms/bilder/blob/main/Screenshot_Budget_AddCategory.png">
<img width="1411" alt="Screenshot" src="https://github.com/oliverwilms/bilder/blob/main/Streamlit_Budget_Form.JPG">

## Installation
### Docker way
Clone the repo, run:
```
docker-compose up -d
```
Run the application with URL: http://localhost:52773/csp/IRISAPP/index.html#/
### ZPM way
Open IRIS terminal and run ZPM:
```
USER>zpm
zpm:USER>install "demo-coffeemaker"
```

## Unit Testing
This repository has [U]nit Tests](https://github.com/intersystems-community/iris-fullstack-template/blob/787acb10efae8847e3084db26c3e4211bd5a753a/tests/UnitTest/Demo/coffeemaker.cls).
THere is a [Github Actions CI workflow](https://github.com/intersystems-community/iris-fullstack-template/blob/787acb10efae8847e3084db26c3e4211bd5a753a/.github/workflows/main.yml) in this repo, which performs unit testing with every push to Github repository and fails if tests fail.

But you also can run the test script locally with:
```
IRISAPP>set ^UnitTestRoot="/irisdev/app/tests"
IRISAPP>do ##class(%UnitTest.Manager).RunTest(,"/nodelete")
```

Or with ZPM:
```
IRISAPP>zpm
zpm:IRISAPP>load /irisdev/app
zpm:IRISAPP>test demo-coffeemaker
```

I created a classMethod to run tests which I can remember:
```
IRISAPP>Do ##class(dc.iris.test).Run()
```

Review UnitTest results in URL: http://yourserver:52773/csp/sys/%25UnitTest.Portal.Indices.cls?$NAMESPACE=IRISAPP

## ZPM Package Manager
This module is zpm-packaged, which means that it is described with [module.xml](https://github.com/oliverwilms/iris-budget/blob/master/module.xml) and available in public repository and installable with:
zpm "install iris-budget"

## View Streamlit app in browser
```
docker compose up -d
docker exec -it iris-budget-iris-1 bash
irisowner@f71c77f15f28:~/irisbuild$ cd /irisdev/app/python/
irisowner@f71c77f15f28:/irisdev/app/python$ pip install streamlit
irisowner@f71c77f15f28:/irisdev/app/python$ streamlit run budget.py
```
View the Streamlit appliction in browser at http://yourserver:8501
