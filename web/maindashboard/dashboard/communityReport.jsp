<%-- 
    Document   : communityReport.jsp
    Created on : Sep 3, 2025, 2:29:51 PM
    Author     : rm
--%>

<%@page import="org.json.simple.JSONArray"%>
<%@page import="erp.dashboard.StudentCountDAO"%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%
    String regulation = request.getParameter("regulationid");
    String section = (String) session.getAttribute("currentOfficeUid");
    System.out.println(" \n \n +++ section"+section);

    if (section == null || section.trim().equals("")) {
        section = "I"; // default
    }

    StudentCountDAO dao = new StudentCountDAO();
    JSONArray jsonData = dao.getCommunityGenderReportBySection(regulation,section);
    System.out.println(jsonData.toString());
    out.print(jsonData.toString());
%>

