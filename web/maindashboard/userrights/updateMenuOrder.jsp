<%-- 
    Document   : updateMenuOrder
    Created on : Jan 5, 2026, 4:02:48 PM
    Author     : martin
--%>


<%
       String login = (String)session.getAttribute("login");

if(login!=null){
        //out.println(uid);
%>

<%@ page import="java.io.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page import="erp.generalmaster.UserPermissionLoader" %>

<%
BufferedReader reader = request.getReader();
StringBuilder sb = new StringBuilder();
String line;
while ((line = reader.readLine()) != null) {
    sb.append(line);
}

JSONParser parser = new JSONParser();
JSONArray arr = (JSONArray) parser.parse(sb.toString());

UserPermissionLoader dao = new UserPermissionLoader();
dao.updateUserMenuOrder(arr);
%>


<% }
else{
// out.println(uid);
out.println("session Time out");
%>
<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" /> 
<%
}
%>
