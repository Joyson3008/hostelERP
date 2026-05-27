<%-- 
    Document   : load_module_options
    Created on : Jul 4, 2025, 12:12:26 PM
    Author     : rm
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="erp.generalmaster.ModuleListLoader" %>
<%
    ModuleListLoader loader = new ModuleListLoader();
    List<ModuleListLoader.Module> list = loader.getModules();

    for (ModuleListLoader.Module m : list) {
%>
<option value="<%= m.key %>"><%= m.desc %></option>
<%
    }
%>

