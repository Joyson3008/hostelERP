<%-- 
    Document   : suggest_user
    Created on : Jul 7, 2025, 1:57:21 PM
    Author     : rm
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="erp.auth.UserSuggester, java.util.*" %>
<%
    String keyword = request.getParameter("q");
    List<Map<String, String>> suggestions = UserSuggester.getSuggestions(keyword);
%>
<%
    for (Map<String, String> user : suggestions) {
        String uid = user.get("id");
        String uname = user.get("name");
%>
<div onclick="selectUser('<%= uid %>', '<%= uname.replace("'", "\\'") %>')" style="padding: 8px; cursor: pointer;">
    <%= uname %>
</div>
<%
    }
%>

