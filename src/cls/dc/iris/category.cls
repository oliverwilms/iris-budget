Class dc.iris.category Extends %Persistent
{

Property Name As %String;

Property Type As %String(VALUELIST = ",Income,Expense");

ClassMethod CreateOrUpdate(pType As %String, pName As %String) As %Status
{
	Set oCategory = ##class(dc.iris.category).%New()
	Set oCategory.Type = $Get(pType)
	Set oCategory.Name = $Get(pName)
	Set tSC = oCategory.%Save()
	Quit tSC
}

}
