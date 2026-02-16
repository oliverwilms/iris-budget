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

/// "SELECT ID, Name FROM dc_iris.category WHERE ...
ClassMethod ExecuteQuerySelect(pQuery As %String, ByRef pResultArray) As %Status
{
    Try {
        Set statement = ##class(%SQL.Statement).%New(1)  ; 1 - ODBC mode
        Set status = statement.%Prepare(pQuery)
        If $$$ISERR(status) {write "%Prepare failed:" do $SYSTEM.Status.DisplayError(status) quit}
        Set rset = statement.%Execute()
        If (rset.%SQLCODE '= 0) {write "%Execute failed:", !, "SQLCODE ", rset.%SQLCODE, ": ", rset.%Message quit}
        ;
        Set x = $Piece(pQuery,"SELECT ",2)
        Set columns = $Piece(x," FROM",1)
        For index = 1:1:$Length(columns,", ") {
            Set col(index) = $Piece(columns,", ",index)
        }
        ;
        While rset.%Next() {
            Set tRowCount = rset.%ROWCOUNT
            Set tID = rset.ID
            Set index = 2
            Set tData = rset.%GetData(index)
            Set pResultArray(tRowCount) = tData
        }
        If (rset.%SQLCODE < 0) {write "%Next failed:", !, "SQLCODE ", rset.%SQLCODE, ": ", rset.%Message quit}
    } Catch ex {}
    Quit $$$OK
}

}
