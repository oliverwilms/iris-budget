Class dc.iris.category Extends %Persistent
{

Property Name As %String;

Property Type As %String(VALUELIST = ",Income,Expense");

ClassMethod CreateOrUpdate(pType As %String, pName As %String) As %Status
{
	Set debug = $Increment(^TESTunit)
	Set ^TESTunit(0-debug) = $Get(pType)_"^"_$Get(pName)
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
