Class rest.dispatch Extends %CSP.REST
{

Parameter DEBUG = 1;

ClassMethod OnPreDispatch(pUrl As %String, pMethod As %String, ByRef pContinue As %Boolean) As %Status
{
    /*
This method gets called prior to dispatch of the request. Put any common code here that you want to be executed for EVERY request. 
If pContinue is set to 0, the request will NOT be dispatched according to the UrlMap. 
In this case it's the responsibility of the user to return a response.
    */
    If ..#DEBUG {
        Set debug = $Increment(^TESTunit)
        Set ^TESTunit(0-debug) = $ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : rest.dispatch - OnPreDispatch"
        Set ^TESTunit(0-debug,"pUrl") = $Get(pUrl)
        Set ^TESTunit(0-debug,"pMethod") = $Get(pMethod)
    }
    Set tSC = $$$OK
    // Example to retrieve API key from headers
    Set apiKey = $Get(%request.CgiEnvs("HTTP_API_KEY"))
    If ..#DEBUG {
        Set ^TESTunit(0-debug,"apiKey") = $Get(apiKey)
    }
    Set token = $Get(%request.Data("token",1))
    If ..#DEBUG {
        Set ^TESTunit(0-debug,"token") = $Get(token)
    }
    Set tValid = 0
    // Implement your custom authentication logic here
    If $Data(token) {
        Set tValid = ..AuthenticateUser(token)
    }
    If ..#DEBUG {
        Set ^TESTunit(0-debug,"tValid") = $Get(tValid)
    }
    If tValid {
        Set pContinue = 1
    } Else {
       Set %response.Status = "401 Unauthorized"
       Set pContinue = $$$NO
    }
    Quit tSC
}

ClassMethod AuthenticateUser(pToken As %String) As %Integer
{
    If ..#DEBUG {
        Set debug = $Increment(^TESTunit)
        Set ^TESTunit(0-debug) = $ZDateTime($NOW(),8,1,3)_" : "_$JOB_" : rest.dispatch - AuthenticateUser"
        Set ^TESTunit(0-debug,"pToken") = $Get(pToken)
    }
    ;
    // Line below requires Role with %Service_Login:Use
    //Set success = $SYSTEM.Security.Login("_SYSTEM", "SYS")
    ;
    // Line below caused <PROTECT>AuthenticateUser+10^rest.dispatch.1
    //If '($e($roles,1,$l("%All"))="%All") { n $ET,$roles s $ET="",$roles=$roles_","_"%All" }
    If ..#DEBUG {
        Set ^TESTunit(0-debug,"success") = $Get(success)
    }
    Quit $$$OK
}

XData UrlMap
{
<Routes>
    <Map Prefix="/csp/budget" Forward="budget.disp"/>
  </Routes>
}

}
