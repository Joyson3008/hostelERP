<%-- 
    Document   : load_user_roles
    Created on : Nov 6, 2025, 11:45:53â¯AM
    Author     : martin
--%>

<%@ page import="org.json.simple.*,erp.auth.UserModule" %>
<%
       String login = (String)session.getAttribute("login");

if(login!=null){
        //out.println(uid);
%>

<%@ page import="erp.auth.UserModule" %>
<%@ page contentType="application/json;charset=UTF-8" %>

<%@page contentType="application/json;charset=UTF-8"%>
<%@page import="erp.auth.UserModule"%>
<%
    String userId = request.getParameter("userid");
    if (userId == null || userId.trim().isEmpty()) {
        out.print("[]");
        return;
    }

    out.print(UserModule.getUserRoles(userId));
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
