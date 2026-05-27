<%-- 
    Document   : permissiondelete
    Created on : Jul 4, 2025, 1:46:21 PM
    Author     : rm
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="erp.generalmaster.ModuleUserPermission" %>
<%
    String userid = request.getParameter("empid");
    String modulecode = request.getParameter("modulecode");

    ModuleUserPermission mp = new ModuleUserPermission();
    boolean success = mp.deletePermission(userid, modulecode);

    out.print(success ? "Deleted successfully." : "Delete failed.");
%>

