Class UnitTest.iris.category Extends %UnitTest.TestCase
{

ClassMethod Run()
{
  do ##class(%UnitTest.Manager).DebugRunTestCase(..%ClassName(1))
}

Method OnBeforeOneTest(testname As %String) As %Status
{
  TStart 
  Quit $$$OK
}

Method OnAfterOneTest(testname As %String) As %Status
{
  TROllback 
  Quit $$$OK
}

Method "Test Required fields"()
{
  Set category = ##class(dc.iris.category).%New()
  Do $$$AssertStatusNotOK(category.%Save(), "Shouldn't save, due to empty required fields")

  #; Fill Required fields
  Set category.Type = ##class(%PopulateUtils).String()
  Set category.Name = ##class(%PopulateUtils).String()
  Do $$$AssertStatusOK(category.%Save(), "Should save correctly, due to filled required fields")
}

}
