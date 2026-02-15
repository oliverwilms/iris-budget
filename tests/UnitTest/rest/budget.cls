Class UnitTest.rest.budget Extends (%UnitTest.TestCase, rest.client)
{

Parameter TRANSACTION = 0;

ClassMethod GetIris() As %String
{
	Set tIris = "127.0.0.1:52773"
	Quit tIris
}

ClassMethod GetPayload(pUseCase = 0) As %DynamicAbstractObject
{
  Set dao = {}  // Use Datamaker here
  Set dao."IncomeOrExpense" = "Income"
  Set dao."Name" = "Paycheck"
  Quit dao
}

ClassMethod GetUrl(pUseCase, ByRef pType As %String, ByRef pUrl As %String) As %Status
{
  Set pType = "POST"
  Set pUrl = "/csp/budget/category"
  Quit $$$OK
}

ClassMethod Run()
{
  do ##class(%UnitTest.Manager).DebugRunTestCase(..%ClassName(1))
}

Method OnBeforeOneTest(testname As %String) As %Status
{
	If (0 = ..#TRANSACTION) { Quit $$$OK }
  TStart 
  Quit $$$OK
}

Method OnAfterOneTest(testname As %String) As %Status
{
	If (0 = ..#TRANSACTION) { Quit $$$OK }
  TROllback 
  Quit $$$OK
}

Method SendRequest(pUseCase As %String = "", pIris As %String = "", pKill = 0, pStatusCode = "", pErrorCode = "", pExpect = "") As %Status
{
	If $Get(pKill) Kill ^TESTunit
	Do ..DebugTEST("UnitTest.rest.budget - SendRequest")
	Set tSC = $$$OK
	Set tSC = ..GetUrl(pUseCase,.pType,.pUrl)
	Set x = pType_" "_$Replace(pIris,":443","")_pUrl
	Do ..LogMessage(x)
	Set dynObj = ..GetPayload(pUseCase)
	Do ..LogMessage("Payload: "_dynObj.%ToJSON())
	Set tSC = ..CallRESTapi(pIris,pUrl,.pResponseData,pType,dynObj)
	zw pResponseData
	;
	Set tSC = pResponseData.Rewind()
	Set tStringResponse = pResponseData.Read()
	Do ..LogMessage("Actual response: "_tStringResponse)
	;
	Set dynObj = ##class(%DynamicAbstractObject).%FromJSON(tStringResponse)
	Set tStatusCode = ""
	Set x = "Test Use Case "_pUseCase_" overall response status code "_tStatusCode_" matches expected value "_pStatusCode
	Do $$$AssertEquals(tStatusCode, pStatusCode, x)
	Set tErrorsCount = 0
	Set tMatchError = 0
  Set tResult = ""
	If ("" = pErrorCode) {
		Set tMatch = (0 = tErrorsCount)
		Set tResult = "No errors"
	}
	If pErrorCode {
		Set tMatch = (tMatchError > 0)
		Set tResult = ""
	}
	Do $$$AssertEquals(tMatch, 1, "Expected Results: "_tResult)
	Quit $$$OK
}

Method Test0PostCategory() As %Status
{
	Set pExpect = "{"
	Do ..LogMessage("Expected response: "_pExpect)
	Set pError = 0
	Set pIris = ..GetIris()
	Set p1 = ""
	Set pKill = 1
	Set pStatusCode = ""
	Set pErrorCode = ""
	Do ..SendRequest(p1, pIris, pKill, pStatusCode, pErrorCode, pExpect)
	Quit $$$OK
}

}
