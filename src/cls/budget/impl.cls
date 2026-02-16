/// This API lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.<br/>
/// Business logic class defined by OpenAPI in budget.spec<br/>
/// Created Feb 16, 2026 14:20:10
Class budget.impl Extends %REST.Impl [ ProcedureBlock ]
{

/// If ExposeServerExceptions is true, then details of internal errors will be exposed.
Parameter ExposeServerExceptions = 1;

/// Get category details by category ID<br/>
/// The method arguments hold values for:<br/>
///     categoryId<br/>
ClassMethod categoryGetById(categoryId As %Integer) As %Stream.Object
{
    //(Place business logic here)
    //Do ..%SetStatusCode(<HTTP_status_code>)
    //Do ..%SetHeader(<name>,<value>)
    //Quit (Place response here) ; response may be a string, stream or dynamic object
}

/// Get category list by type (income or expense)<br/>
/// The method arguments hold values for:<br/>
///     categoryType<br/>
ClassMethod categoryListByType(categoryType As %String) As %Stream.Object
{
    Try {
        Set dao = ##class(dc.iris.category).ListByType(categoryType)
        Set tHttpStatusCode = 200
        Do ..%SetStatusCode(tHttpStatusCode)
    } Catch ex {
        Set debug = $INCREMENT(^TESTunit)
        Set ^TESTunit(0-debug,"ex") = $ZERROR
    }
    //Do ..%SetHeader(<name>,<value>)
    //Quit (Place response here) ; response may be a string, stream or dynamic object
    Quit $Get(dao)
}

/// Create a new category with the given information.<br/>
/// The method arguments hold values for:<br/>
///     categoryInfo<br/>
ClassMethod categoryCreate(categoryInfo As %Stream.Object) As %Stream.Object
{
    Set debug = $Increment(^TESTunit)
	Set ^TESTunit(0-debug) = $Get(categoryInfo)
    Try {
        Set dao = ##class(%DynamicAbstractObject).%FromJSON(categoryInfo)
        Set ^TESTunit(0-debug,"dao") = dao.%ToJSON()
        Set pType = dao."IncomeOrExpense"
        Set pName = dao."Name"
        Set tSC = ##class(dc.iris.category).CreateOrUpdate(pType,pName)
        Set tHttpStatusCode = 200
        Set ^TESTunit(0-debug,"tSC") = "OK"
        If $$$ISERR(tSC) {
            Set ^TESTunit(0-debug,"tSC") = $System.Status.GetErrorText(tSC)
        }
        Do ..%SetStatusCode(tHttpStatusCode)
    } Catch ex {
        Set ^TESTunit(0-debug,"ex") = $ZERROR
    }
    //Do ..%SetHeader(<name>,<value>)
    //Quit (Place response here) ; response may be a string, stream or dynamic object
    Quit {}
}

}
