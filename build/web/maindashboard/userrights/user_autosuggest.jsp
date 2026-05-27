<%-- 
    Document   : user_autosuggest
    Created on : Jul 4, 2025, 1:55:36 PM
    Author     : rm
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="erp.generalmaster.UserAutoSuggest" %>
<%@ page import="org.json.simple.JSONArray" %>
<%
    String q = request.getParameter("query");
    if (q == null) q = "";

    UserAutoSuggest suggest = new UserAutoSuggest();
    JSONArray suggestions = suggest.getUserSuggestions(q);

    out.print(suggestions.toJSONString());
%>

