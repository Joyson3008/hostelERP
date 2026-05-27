<%-- 
    Document   : modulefiledelete
    Created on : Jul 4, 2025, 1:36:34 PM
    Author     : rm
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="erp.generalmaster.ModuleFileLink" %>
<%
    String modulecode = request.getParameter("modulelist");
    String filename = request.getParameter("filenamelink");

    ModuleFileLink mfl = new ModuleFileLink();
    boolean success = mfl.deleteFile(modulecode, filename);

    if (success) {
        out.print("Deleted successfully.");
    } else {
        out.print("Delete failed.");
    }
%>

