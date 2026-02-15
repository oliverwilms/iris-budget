Class rest.client  
{

ClassMethod CallRESTapi(pIris As %String, pUrl As %String, ByRef pResponseData As %DynamicObject, pType As %String = "GET", pBody = "") As %Status
{
	#define maxRESTapiErr 3
	#define maxRetries 2
	//#define timeout 12
	Do ..DebugTEST("rest.client - CallRESTapi")
	Do ..DebugTEST("pIris = "_$Get(pIris))
	Do ..DebugTEST("pUrl = "_$Get(pUrl))
	Do ..DebugTEST("pType = "_$Get(pType))
	Do ..DebugTEST("pBody = "_$Get(pBody))
	Set myUnitTest = $Get(^myUnitTests)
	Set tErrorCount = 0
	Set tParamIRIS = pIris
	If (pIris = 0) Set pIris = "127.0.0.1:52773"
	Set tServer = $Piece(pIris,":",1)
	Set tPort = $Piece(pIris,":",2)
	Do {
		Set tRetryFlag = 0
		Set pResponse = $$$NULLOREF
		Set tRequest = ##class(%Net.HttpRequest).%New()
		Try {
			If (pBody.%IsA("%DynamicAbstractObject")) {
				Set tJSONMessage = pBody.%ToJSON()
				Do ..DebugTEST("tJSONMessage = "_$Get(tJSONMessage))
				Set pBody = tJSONMessage
				Set tSC = tRequest.SetHeader("content-type","application/json")
				Do ..DebugStatus(tSC)
			}
		} Catch exp {
			Do ..DebugTEST("Catch= "_$ZERROR)
		}
		If ($Get(tJSONMessage) '= "") {
			Do tRequest.EntityBody.Write(tJSONMessage)
			Do ..DebugTEST("pBody2 = "_$Get(tJSONMessage))
		}
		If (tPort = 443) {
			Set tRequest.Https = 1
			Set tRequest.SSLCheckServerIdentity = 0
			Set tRequest.SSLConfiguration = "ISC.FeatureTracker.SSL.Config"
			Do ..DebugTEST("SSLConfiguration = "_tRequest.SSLConfiguration)
		}
		// InitiateAuthentication does not exist in HealthShare versions
		Try {
			//Supported schemes are Negotiate, NTLM and Basic.
			Set tRequest.InitiateAuthentication = "Basic"
			Set tRequest.Username = "_SYSTEM"
			Set tRequest.Password = ##class(Oliver.JWT).getPass()  // ..GetPass(pIris)
		} Catch {
		}
		Set tRequest.Port = tPort
		If (tServer '= "") Set tRequest.Server = tServer
		Set tTimeout = ..GetTimeoutREST()
		Do ..DebugTEST("tTimeout = "_$Get(tTimeout))
		Set tRequest.Timeout = tTimeout
		//Set type = "GET"
		Set location = $Get(pUrl)
		//Set location = ##class(%CSP.Page).EscapeURL(location)
		Set test = 0
		Set reset = 1
		Do ..DebugTEST("location = "_$Get(location))
		Set tSC = tRequest.Send(pType,location,test,reset)
		If $$$ISERR(tSC) Do ..DebugStatus(tSC)
		If (tPort = 443) {
			Do ..DebugTEST("SSLError = "_tRequest.SSLError)
		}
		Set pResponse = tRequest.HttpResponse
		Do ..DebugTEST("HttpResponse = "_pResponse)
		If $IsObject(pResponse) {
			Do ..DebugTEST("pResponse.StatusCode = "_pResponse.StatusCode)
			If (pResponse.StatusCode '= 200) {
				Do ..DebugTEST("StatusCode = "_pResponse.StatusCode)
				Do ..DebugTEST("ReasonPhrase = "_pResponse.ReasonPhrase)
			}
			If (pResponse.StatusCode = 500) {  // Internal Server Error
				If $Increment(tErrorCount) <= $$$maxRetries Set tRetryFlag = 1
			}
		} Else {
			//Do ..DebugTEST("HttpResponse = "_pResponse)
		}
	} While tRetryFlag

	If $IsObject(pResponse) {
		#dim tDataStream As %Stream.GlobalBinary
		Set tDataStream = pResponse.Data
		Do ..DebugTEST("tDataStream = "_pResponse.Data)
		Set tSize = tDataStream.Size
		Do ..DebugTEST("tDataStream.Size = "_tSize)
		Set tDataString = tDataStream.Read(.len,.sc)
		If $$$ISOK(sc) {
			Do ..DebugTEST("tDataString = "_tDataString)
		} Else {
			Do ..DebugTEST("Data = "_pResponse.Data)
			Do ..DebugTEST("len = "_$Get(len))
			Do ..DebugStatus(sc)
		}
		Try {
			//Set pResponseData = ##class(%DynamicObject).%FromJSON(tDataString)
		}
		Catch {
			//Set tSC = $$$ERROR($$$GeneralError,"JSON error")
			If (pResponse.StatusCode '= 200) {
				Set tSC = $$$ERROR($$$GeneralError,"Response was "_pResponse.StatusCode_" / "_pResponse.ReasonPhrase)
				Do ..DebugStatus(tSC)
			}
			//Do ..DebugStatus(tSC)
		}
		Set pResponseData = pResponse.Data
	}
	Quit tSC
}

ClassMethod DebugMerge(strMessage As %String = "", ByRef pArray) As %Status
{
	Merge ^TESTunit($I(^TESTunit)) = pArray
	Set tValue = ""
	If $Get(pArray) '= "" Set tValue = " = "_pArray
	Set ^TESTunit(^TESTunit) = $ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : "_strMessage_tValue
	Quit $$$OK
}

ClassMethod DebugTEST(strMessage As %String = "") As %Status
{
	Set ^TESTunit($I(^TESTunit)) = $ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : "_strMessage
	Quit $$$OK
}

ClassMethod StatusToText(pStatus As %Status) As %String
{
	Set tReturn = $System.Status.GetOneErrorText(pStatus)
	Quit tReturn
}

ClassMethod DebugStatus(pStatus As %Status) As %Status
{
	Set tStatus = ..StatusToText(pStatus)
	Quit ..DebugTEST(tStatus)
}

ClassMethod GetTimeoutREST() As %String
{
	#define timeout 30
	Set tDefaultTimeout = $$$timeout
	Set tTimeoutREST = $Get(^myFeeder("Config","Util","Timeout","REST"),tDefaultTimeout)
	Set tReturn = tTimeoutREST
	Quit tReturn
}

}
