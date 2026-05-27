<%-- 
    Document   : modulefileaction
    Created on : Jul 4, 2025, 12:09:48 PM
    Author     : rm
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="erp.generalmaster.ModuleFileLink" %>
<%@ page import="java.io.*" %>

<%
    // Get parameters from the request
    String code = request.getParameter("modulelist");
    String source = request.getParameter("filelink");
    String name = request.getParameter("filenamelink");
    String desc = request.getParameter("filenamelinkdesc");
    String filetype = request.getParameter("filetype");

    String result = "Invalid Request!";
    try {
        if (code != null && name != null && source != null && desc != null && filetype != null) {
            ModuleFileLink mfl = new ModuleFileLink();
            result = mfl.saveOrUpdate(code.trim(), name.trim(), source.trim(), desc.trim(), filetype.trim());
        } else {
            result = "Missing parameters!";
        }
    } catch (Exception e) {
        result = "Error: " + e.getMessage();
        e.printStackTrace();
    }

    out.print(result);
%>


