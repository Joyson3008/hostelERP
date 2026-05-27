<%-- 
    Document   : progauthview
    Created on : Sep 18, 2025, 10:44:36?AM
    Author     : JRMartin <JRMartin at your.org>
--%>

<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="erp.programAuthor.ProgAuthDAO" %>
<%
response.setContentType("application/json");
String userId = request.getParameter("userid");
String regy   = request.getParameter("regy");

JSONArray data = ProgAuthDAO.getProgAuth(userId, regy);
out.print(data.toJSONString());
%>
