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
    Set pContinue = 1
    Quit $$$OK
}

XData UrlMap
{
<Routes>
    <Map Prefix="/csp/budget" Forward="budget.disp"/>
  </Routes>
}

}
