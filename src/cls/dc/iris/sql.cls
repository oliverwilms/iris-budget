Class dc.iris.sql
{

ClassMethod ExecuteQueryOneValue(pQuery As %String, ByRef pResult As %String) As %Status
{
	Set pResult = ""
	Set rs = ##class(%ResultSet).%New()
	Set tSC = rs.Prepare(pQuery)
	If $$$ISOK(tSC) {
		Set tSC = rs.Execute()
		If $$$ISOK(tSC), rs.Next() Set pResult = rs.GetData(1)
	}
	Do rs.Close()
	Set rs = ""
	Quit tSC
}

ClassMethod ExecuteQuerySelect(pQuery As %String, ByRef pResultArray) As %Status
{
    Try {
        Set statement = ##class(%SQL.Statement).%New(1)  ; 1 - ODBC mode
        Set status = statement.%Prepare(pQuery)
        If $$$ISERR(status) {write "%Prepare failed:" do $SYSTEM.Status.DisplayError(status) quit}
        Set rset = statement.%Execute()
        If (rset.%SQLCODE '= 0) {write "%Execute failed:", !, "SQLCODE ", rset.%SQLCODE, ": ", rset.%Message quit}
        While rset.%Next() {
            Write "Row count ",rset.%ROWCOUNT,!
            Write rset.ID
            Write ", Href ",rset.Href,!!
        }
        If (rset.%SQLCODE < 0) {write "%Next failed:", !, "SQLCODE ", rset.%SQLCODE, ": ", rset.%Message quit}
        Write !,"End of data"
        Write !,"Total row count=",rset.%ROWCOUNT
    } Catch ex {}
    Quit 1
}

}
