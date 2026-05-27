<%-- 
    Document   : progauthdelete
    Created on : Sep 18, 2025, 11:22:41 AM
    Author     : JRMartin <JRMartin at your.org>
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="erp.programAuthor.ProgAuthDAO" %> <%-- change package name --%>

<%
    response.setContentType("application/json");
    JSONObject result = new JSONObject();

    String userId = request.getParameter("userid");
    String regy = request.getParameter("regy");
    String courseId = request.getParameter("courseid");
    String section = request.getParameter("section");
    String officeids=request.getParameter("officeid");
    if(userId != null && regy != null && courseId != null && section != null){
        boolean deleted = ProgAuthDAO.deleteProgAuth(userId, regy, courseId, section,Integer.parseInt(officeids));

        if(deleted){
            result.put("status", "success");
            result.put("message", "Deleted successfully");
        } else {
            result.put("status", "error");
            result.put("message", "Record not found or not deleted");
        }
    } else {
        result.put("status", "error");
        result.put("message", "Missing parameters");
    }

    out.print(result.toJSONString());
%>

