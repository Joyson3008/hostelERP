<%-- 
    Document   : getRCStudents
    Created on : Apr 28, 2026, 11:18:42 AM
    Author     : lccerp26
--%>

<%@ page contentType="application/json" pageEncoding="UTF-8" %>
<%@ page import="Dao.ERPHostel.HostelDashboardDAO" %>
<%@ page import="org.json.simple.JSONArray" %>

<%
    try {

        JSONArray arr = HostelDashboardDAO.getRCStudents();
        System.out.println("\n\ngetRCStudents.jsp Success\n\n\n");
        out.print(arr.toJSONString());

    } catch (Exception e) {

        System.out.println("\n\n\ngetRCStudents.jsp\n\n\n" + e);

        out.print("[]");
    }
%>
