<%-- 
    Document   : user_module_permission
    Created on : Jul 4, 2025, 2:25:14 PM
    Author     : rm
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="erp.generalmaster.SinglePermissionLoader" %>
<%@ page import="org.json.simple.JSONObject" %>
<%
    String empid = request.getParameter("empid");
    String moduleid = request.getParameter("moduleid");

    JSONObject result = SinglePermissionLoader.getPermission(empid, moduleid);
    out.print(result.toJSONString());
%>

