Class dc.iris.category Extends %Persistent
{

Property Name As %String;

Property Type As %String(VALUELIST = ",Income,Expense");

ClassMethod CheckExists(pType As %String = "", pName As %String = "") As %Status
{
	Set query = "SELECT ID FROM dc_iris.category WHERE Type = '%1' AND Name = '%2'"
	Set query = $Replace(query,"%1",$Get(pType))
	Set query = $Replace(query,"%2",$Get(pName))
	Set tSC = ##class(dc.iris.sql).ExecuteQueryOneValue(query,.tID)
	Quit tID
}

ClassMethod CreateOrUpdate(pType As %String = "", pName As %String = "") As %Status
{
	Set debug = $Increment(^TESTunit)
	Set ^TESTunit(0-debug) = $Get(pType)_"^"_$Get(pName)
	Set tExists = ##class(dc.iris.category).CheckExists(pType,pName)
	If (0 < tExists) { Quit $$$OK }
	;
	Set oCategory = ##class(dc.iris.category).%New()
	Set oCategory.Type = $Get(pType)
	Set oCategory.Name = $Get(pName)
	Set tSC = oCategory.%Save()
	Set ^TESTunit(0-debug,"tSC") = "OK"
	If $$$ISERR(tSC) Set ^TESTunit(0-debug,"tSC") = $System.Status.GetErrorText(tSC)
	Quit tSC
}

Storage Default
{
<Data name="categoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>^dc.iris.categoryD</DataLocation>
<DefaultData>categoryDefaultData</DefaultData>
<IdLocation>^dc.iris.categoryD</IdLocation>
<IndexLocation>^dc.iris.categoryI</IndexLocation>
<StreamLocation>^dc.iris.categoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
