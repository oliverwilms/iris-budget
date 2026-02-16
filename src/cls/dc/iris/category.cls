Class dc.iris.category Extends %Persistent
{

Parameter DEBUG = 0;

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
	If ..#DEBUG Set debug = $Increment(^TESTunit)
	If ..#DEBUG Set ^TESTunit(0-debug) = $Get(pType)_"^"_$Get(pName)
	Set tExists = ##class(dc.iris.category).CheckExists(pType,pName)
	If (0 < tExists) { Quit $$$OK }
	;
	Set oCategory = ##class(dc.iris.category).%New()
	Set oCategory.Type = $Get(pType)
	Set oCategory.Name = $Get(pName)
	Set tSC = oCategory.%Save()
	If ..#DEBUG Set ^TESTunit(0-debug,"tSC") = "OK"
	If $$$ISERR(tSC) If ..#DEBUG Set ^TESTunit(0-debug,"tSC") = $System.Status.GetErrorText(tSC)
	Quit tSC
}

ClassMethod ListByType(pType As %String = "Income") As %DynamicAbstractObject
{
	If ..#DEBUG Set debug = $Increment(^TESTunit)
	If ..#DEBUG Set ^TESTunit(0-debug) = $Get(pType)
	Set query = "SELECT ID, Name FROM dc_iris.category WHERE TYPE = '%1'"
	Set query = $Replace(query,"%1",$Get(pType))
	Set tReturn = ##class(dc.iris.sql).ExecuteQuerySelect(query,.pResultArray)
	Set dao = {}
	Set dao."categorylist" = []
	Set tRowIndex = ""
	For {
		Set tRowIndex = $Order(pResultArray(tRowIndex))
		If ("" = tRowIndex) { Quit }
		Set tName = $Get(pResultArray(tRowIndex))
		Do dao."categorylist".%Push(tName)
	}
	Quit dao
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
<ExtentSize>1</ExtentSize>
<IdLocation>^dc.iris.categoryD</IdLocation>
<IndexLocation>^dc.iris.categoryI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>2</AverageFieldSize>
<OutlierSelectivity>.999999:</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>3</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Name">
<AverageFieldSize>10</AverageFieldSize>
<OutlierSelectivity>.999999:"Paycheck"</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<Property name="Type">
<AverageFieldSize>8</AverageFieldSize>
<OutlierSelectivity>.999999:"Income"</OutlierSelectivity>
<Selectivity>0.0001%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^dc.iris.categoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
