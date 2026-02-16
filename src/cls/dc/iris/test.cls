Class dc.iris.test
{

ClassMethod Run(pUnitTestRoot As %String = "/irisdev/app/tests") As %Status
{
    Set tSC = $$$OK
    Set tData = $Get(^UnitTestRoot)
    If ("" = tData) Set ^UnitTestRoot = pUnitTestRoot
    Do ##class(%UnitTest.Manager).RunTest(,"/nodelete")
    Quit tSC
}

}
