 [![Gitter](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/iris-fullstack-template)
 [![Quality Gate Status](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Firis-fullstack-template&metric=alert_status)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Firis-fullstack-template)
 [![Reliability Rating](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Firis-fullstack-template&metric=reliability_rating)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Firis-fullstack-template)
# InterSystems IRIS Full Stack demo and template
This repository contains a sample application which consists of InterSystems IRIS REST API and Frontend Application which demoes a coffee-maker shop.

It demonstrates the way to communicate with InterSystes IRIS from any frontend application.
It has Unit tests which could be run interactively, or using ZPM, or via Github CI.
It demoes the way to develop using Docker containers.
It demoes how to package the application in ZPM module and how to deploy it using ZPM.

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
Run the appliction in URL: http://yourserver:52773/csp/coffee/index.html#/

## Development
### Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.
This repository is ready to code in VSCode with ObjectScript plugin.
Install [VSCode](https://code.visualstudio.com/), [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker) and [ObjectScript](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript) plugin and open the folder in VSCode.


This is a template. So use template button in Github and create a new repository with copy of iris-fullstack-template.
![template](https://user-images.githubusercontent.com/2781759/93434019-4142bc00-f8d0-11ea-9b09-0e64501dde53.gif)
Clone your repository.
Open the folder with VSCode.
Build container as it is shown in the gif:
![template-build](https://user-images.githubusercontent.com/2781759/93434498-ebbadf00-f8d0-11ea-992e-3197f007d3bf.gif)
or open the terminal and run:
```
docker-compose up -d
```
Check if the app is running from the VSCode ObjectScript menu:
![template-app1](https://user-images.githubusercontent.com/2781759/93438148-946b3d80-f8d5-11ea-8373-71383bf6395b.gif)

All set. You good to start the development.

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

## ZPM Package Manager
This module is zpm-packaged, which means that it is described with [module.xml](https://github.com/oliverwilms/iris-budget/blob/master/module.xml) and available in public repository and installable with:
zpm "install iris-budget"

## Credits
Demo is built using original [Coffee Maker application](https://github.com/intersystems/FirstLook-REST) by Michael Smart a and it's enhanced version by [Caret Dev](https://github.com/caretdev/CoffeeMaker).
