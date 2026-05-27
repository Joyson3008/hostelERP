<%-- 
    Document   : insert_permission
    Created on : Jul 4, 2025, 2:39:48 PM
    Author     : rm
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="erp.generalmaster.UserPermission" %>
<%
    String permissionData = request.getParameter("permissionData");
    System.err.println("eeee \n"+permissionData);

    UserPermission up = new UserPermission();
    String status = up.insertPermissions(permissionData);
    out.print(status);
%>


