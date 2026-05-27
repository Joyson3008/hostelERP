<%-- 
    Document   : getVegStudents
    Created on : Apr 28, 2026, 10:56:44 AM
    Author     : lccerp26
--%>

<%@ page contentType="application/json" pageEncoding="UTF-8" %>
<%@ page import="Dao.ERPHostel.HostelDashboardDAO" %>
<%@ page import="org.json.simple.JSONArray" %>

<%
    try {

        JSONArray arr = HostelDashboardDAO.getVegStudentsdash();

        System.out.println("\n\ngetVegStudents.jsp Success\n\n\n");
        out.print(arr.toJSONString());

    } catch (Exception e) {

        System.out.println("\n\n\ngetVegStudents.jsp\n\n\n" + e);

        out.print("[]");
    }
%>
