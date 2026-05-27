<%-- 
    Document   : permissionlist
    Created on : Jul 4, 2025, 1:46:05 PM
    Author     : rm
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="erp.generalmaster.UserPermissionLoader" %>
<%@ page import="org.json.simple.JSONArray" %>
<%
    try{
    String empid = request.getParameter("empid");
    String mid = request.getParameter("mid");
    if (empid == null) empid = "";
    JSONArray result = UserPermissionLoader.getPermissions(empid,mid);
    out.print(result.toJSONString());
    }catch(Exception e){
        out.println(e);
    }
%>



