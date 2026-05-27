<%-- 
    Document   : moduleaction
    Created on : Jul 4, 2025, 11:37:17 AM
    Author     : rm
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="erp.generalmaster.Module" %>
<%
    String idStr = request.getParameter("id");
    String modulecode = request.getParameter("modulecode");
    String modulename = request.getParameter("modulename");
    String modulefolder = request.getParameter("modulefolder");

    int id = 0;
    try {
        if (idStr != null && !idStr.trim().equals("")) {
            id = Integer.parseInt(idStr.trim());
        }
    } catch (Exception e) {
        id = 0;
    }

    Module mod = new Module();
    String result = mod.saveModule(id, modulecode, modulename, modulefolder);
    out.print(result);
%>



