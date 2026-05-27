<%-- 
    Document   : getNonVegStudents
    Created on : Apr 28, 2026, 11:08:58 AM
    Author     : lccerp26
--%>

<%@ page contentType="application/json" pageEncoding="UTF-8" %>
<%@ page import="Dao.ERPHostel.HostelDashboardDAO" %>
<%@ page import="org.json.simple.JSONArray" %>

<%
    try {

        JSONArray arr = HostelDashboardDAO.getNonVegStudents();
        System.out.println("\n\ngetNonVegStudents.jsp Success\n\n\n");

        out.print(arr.toJSONString());

    } catch (Exception e) {

        System.out.println("\n\n\ngetNonVegStudents.jsp\n\n\n" + e);

        out.print("[]");
    }
%>
