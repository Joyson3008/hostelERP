<%-- 
    Document   : getRegisteredStudents
    Created on : Apr 28, 2026, 10:35:06 AM
    Author     : lccerp26
--%>

<%@ page contentType="application/json" pageEncoding="UTF-8" %>
<%@ page import="Dao.ERPHostel.HostelDashboardDAO" %>
<%@ page import="org.json.simple.JSONArray" %>

<%
    try {

        JSONArray arr = HostelDashboardDAO.getRegisteredStudentsdash();
        
        System.out.println("\n\ngetRegisteredStudents.jsp Success\n\n\n");
        out.print(arr.toJSONString());

    } catch (Exception e) {

        System.out.println("\n\n\ngetRegisteredStudents.jsp\n\n\n" + e);

        out.print("[]");
    }
%>
