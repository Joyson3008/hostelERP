<%-- 
    Document   : modulelist
    Created on : Jul 4, 2025, 11:42:55 AM
    Author     : rm
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="erp.generalmaster.Module" %>
<%@ page import="java.util.List" %>

<%
    JSONArray jsonArray = new JSONArray();
    try {
        Module m = new Module();
        List<Module.Row> list = m.getModules();

        for (Module.Row mod : list) {
            JSONObject obj = new JSONObject();
            obj.put("id", mod.id);
            obj.put("modulename", mod.modulename);
            obj.put("modulecode", mod.modulecode);
            obj.put("modulefolder", mod.modulefolder);
            jsonArray.add(obj);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    out.print(jsonArray.toJSONString());
%>


