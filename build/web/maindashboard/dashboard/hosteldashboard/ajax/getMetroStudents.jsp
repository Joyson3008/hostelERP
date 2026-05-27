<%-- 
    Document   : getMetroStudents
    Created on : Apr 28, 2026, 11:13:15 AM
    Author     : lccerp26
--%>

<%@ page contentType="application/json" pageEncoding="UTF-8" %>
<%@ page import="Dao.ERPHostel.HostelDashboardDAO" %>
<%@ page import="org.json.simple.JSONArray" %>

<%
    try {

        JSONArray arr = HostelDashboardDAO.getMetroStudents();
        System.out.println("\n\ngetMetroStudents.jsp Success\n\n\n");

        out.print(arr.toJSONString());

    } catch (Exception e) {

        System.out.println("\n\n\ngetMetroStudents.jsp\n\n\n" + e);

        out.print("[]");
    }
%>