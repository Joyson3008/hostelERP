<%-- 
    Document   : modulefilelist
    Created on : Jul 4, 2025, 12:10:03 PM
    Author     : rm
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONArray, org.json.simple.JSONObject" %>
<%@ page import="erp.generalmaster.ModuleFileLink" %>
<%
    String moduleCode = request.getParameter("modulecode");
    JSONArray arr = new JSONArray();
    ModuleFileLink mfl = new ModuleFileLink();

    for (ModuleFileLink.Row row : mfl.getFileLinks(moduleCode)) {
        JSONObject obj = new JSONObject();
        obj.put("code", row.code);
        obj.put("name", row.name);
        obj.put("source", row.source);
        obj.put("desc", row.desc);
        obj.put("filetype", row.filetype);
        arr.add(obj);
    }
    out.print(arr.toJSONString());
    System.out.println("---------ddd \n"+arr.toJSONString());
%>
