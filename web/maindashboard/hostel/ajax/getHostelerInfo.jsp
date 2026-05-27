<%-- 
    Document   : getHostelerInfo.jsp
    Created on : 25-May-2026, 4:07:22 pm
    Author     : R JOYSON
--%>

<%@page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="Dao.ERPHostel.ERPHostelDAO"%>
<%@page import="org.json.simple.JSONObject"%>
<%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Access-Control-Allow-Origin", "*");

    String searchText = request.getParameter("searchText");

    JSONObject result = new JSONObject();

    if (searchText == null || searchText.trim().isEmpty()) {
        result.put("success", false);
        result.put("message", "Please enter a search value.");
        out.print(result.toJSONString());
        return;
    }

    try {
        result = ERPHostelDAO.getHostelerInfo(searchText.trim());
    } catch (Exception e) {
        result.put("success", false);
        result.put("message", "Server error: " + e.getMessage());
        e.printStackTrace();
    }

    out.print(result.toJSONString());
%>
