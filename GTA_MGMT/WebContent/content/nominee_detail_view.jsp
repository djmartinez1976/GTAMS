<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Nominee details</title>
</head>
<body>
	<%
		Connection connection = DriverManager.getConnection( "jdbc:mysql://localhost:3306/GTAMS", "root", "root");
        Statement stmtNominee = connection.createStatement() ;
        ResultSet rsNominee = stmtNominee.executeQuery("select * from nominee where name='" + request.getParameter("nomineeName")+"'") ;
        

        if (rsNominee.next())
        {
		%>
	      <TABLE BORDER="1">
		<%
        ResultSetMetaData rsmd = rsNominee.getMetaData();
        int columnCount = rsmd.getColumnCount();
        // The column count starts from 1
        for (int i = 1; i <= columnCount; i++ ) {
          String colName = rsmd.getColumnName(i);
          String dataValue = rsNominee.getString(i);
    %>
      <TR>
          <TD><%=colName %></TD>
          <Td><%=dataValue %></TD>
        </TR>
       
       <%}%>
       </TABLE>
       <%} %>
</body>
</html>
