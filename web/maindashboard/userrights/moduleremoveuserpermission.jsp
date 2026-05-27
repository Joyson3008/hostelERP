<%-- 
    Document   : moduleremoveuserpermission
    Created on : Jun 25, 2025, 9:25:34 AM
    Author     : rm
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="modu" class="erp.module.ModuleMaster" scope="request"/>
<%
String mcode = request.getParameter("mcode");
String userid = request.getParameter("userid");

String success = modu.deleteRecord(mcode, userid);

out.print(success);
%>
