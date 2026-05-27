<%-- 
    Document   : studentCountGenderDash
    Created on : Sep 9, 2025, 11:12:11?AM
    Author     : rm
--%>

<%@ page import="erp.dashboard.StudentCountDAO" %>

<head>

    <META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">
    <META HTTP-EQUIV="PRAGMA" CONTENT="NO-CACHE">
    <META HTTP-EQUIV="EXPIRES" CONTENT="0">
</head>
<%
    response.setDateHeader("Expires", 0);
    response.addHeader("Cache-Control", "no-cache, no-store, must-revlidate");
    response.addHeader("Cache-Control", "post-check=0, pre-check=0");
    response.setHeader("Pragma", "no-cache");
%>

<jsp:useBean id="modu" class="erp.module.ModuleMaster" scope="request"/>

<%@ page import="org.json.simple.*" %>
<%@ page import="java.util.*" %> 
<%     String login = (String) session.getAttribute("login");

    if (login != null) {
        //out.println(uid);
        String officeid = (String) session.getAttribute("currentOfficeUid");
%>

<div class="col-4">
    <h4 class="text-c-red"><%= StudentCountDAO.getcountgenderwise("ug_2025_student",officeid,"M") %></h4>
    <h6 class="text-muted m-b-0">2025</h6>
</div>
    
    <div class="col-4">
    <h4 class="text-c-red"><%= StudentCountDAO.getcountgenderwise("ug_2024_student",officeid,"M") %></h4>
    <h6 class="text-muted m-b-0">2024</h6>
</div>
    
    <div class="col-4">
    <h4 class="text-c-red"><%= StudentCountDAO.getcountgenderwise("ug_2023_student",officeid,"M") %></h4>
    <h6 class="text-muted m-b-0">2023</h6>
</div>




<% } else {
    // out.println(uid);
    out.println("session Time out");
%>
<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" /> 
<%
    }
%>
