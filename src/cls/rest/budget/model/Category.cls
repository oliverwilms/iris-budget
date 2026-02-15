Class rest.budget.model.Category Extends (%Persistent, %Populate, %pkg.isc.json.adaptor, %pkg.isc.rest.model.adaptor)
{

Parameter RESOURCENAME = "category";

Parameter %JSONINCLUDEID = 1;

Property Name As %String(%JSONFIELDNAME = "name");

Property Type As %String(%JSONFIELDNAME = "type");

/// Checks the user's permission for a particular operation on a particular record.
/// <var>pOperation</var> may be one of:
/// CREATE
/// READ
/// UPDATE
/// DELETE
/// QUERY
/// ACTION:<action name>
/// <var>pUserContext</var> is supplied by <method>GetUserContext</method>
ClassMethod CheckPermission(pID As %String, pOperation As %String, pUserContext As %pkg.isc.rest.authentication.platformUser) As %Boolean
{
	Quit (pOperation = "QUERY") || (pOperation = "READ") || (pOperation = "CREATE") || (pOperation = "UPDATE")
}

XData ActionMap [ XMLNamespace = "http://www.intersystems.com/_pkg/isc/rest/action" ]
{
}

}
