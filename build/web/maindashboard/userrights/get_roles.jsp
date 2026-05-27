<%-- 
    Document   : get_roles
    Created on : Nov 6, 2025, 11:17:51 AM
    Author     : martin
--%>

<jsp:useBean id="modu" class="erp.module.ModuleMaster" scope="request"/>

<%@ page import="org.json.simple.*" %>
<%
       String login = (String)session.getAttribute("login");

if(login!=null){
        //out.println(uid);
%>
<%@ page import="erp.auth.RoleMasterDao" %>
<%@ page import="org.json.simple.JSONArray" %>
<%
    response.setContentType("application/json");
    RoleMasterDao dao = new RoleMasterDao();
    JSONArray roles = dao.getAllRoles();
    System.out.println("\n \n \n"+roles);
    out.print(roles.toJSONString());
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
