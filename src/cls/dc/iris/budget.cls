Class dc.iris.budget Extends %RegisteredObject
{

ClassMethod setupCategories() As %Status
{
    Set tSC = ##class(dc.iris.category).CreateOrUpdate("Income","Paycheck")
    If $$$ISOK(tSC) Set tSC = ##class(dc.iris.category).CreateOrUpdate("Income","Freelance")
    If $$$ISOK(tSC) Set tSC = ##class(dc.iris.category).CreateOrUpdate("Income","Contests")
    If $$$ISOK(tSC) Set tSC = ##class(dc.iris.category).CreateOrUpdate("Income","Interest")
    If $$$ISOK(tSC) Set tSC = ##class(dc.iris.category).CreateOrUpdate("Income","Investments")
    If $$$ISOK(tSC) Set tSC = ##class(dc.iris.category).CreateOrUpdate("Income","Other Income")
    ;
    If $$$ISOK(tSC) Set tSC = ##class(dc.iris.category).CreateOrUpdate("Expense","Giving")
    If $$$ISOK(tSC) Set tSC = ##class(dc.iris.category).CreateOrUpdate("Expense","Housing")
    If $$$ISOK(tSC) Set tSC = ##class(dc.iris.category).CreateOrUpdate("Expense","Food")
    If $$$ISOK(tSC) Set tSC = ##class(dc.iris.category).CreateOrUpdate("Expense","Clothing")
    If $$$ISOK(tSC) Set tSC = ##class(dc.iris.category).CreateOrUpdate("Expense","Automobile")
    If $$$ISOK(tSC) Set tSC = ##class(dc.iris.category).CreateOrUpdate("Expense","Digital Services")
    If $$$ISOK(tSC) Set tSC = ##class(dc.iris.category).CreateOrUpdate("Expense","Vacation")
    If $$$ISOK(tSC) Set tSC = ##class(dc.iris.category).CreateOrUpdate("Expense","Leisure")
    If $$$ISOK(tSC) Set tSC = ##class(dc.iris.category).CreateOrUpdate("Expense","Other Expense")
}

}
