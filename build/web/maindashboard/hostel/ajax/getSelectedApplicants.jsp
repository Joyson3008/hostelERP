<%-- 
    Document   : getSelectedApplicants
    Created on : Apr 14, 2026, 11:23:24 AM
    Author     : lccerp26
--%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>

<%@page import="Dao.ERPHostel.ERPHostelDAO"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.net.InetAddress"%>
<%@page import="java.net.UnknownHostException"%>

<%
    String login = (String) session.getAttribute("login");
    String userId = (String) session.getAttribute("username");
    String currofficeid = (String) session.getAttribute("currentOfficeUid");

    if (login != null) {
%>

<%
    String serverIp = "Unknown";

    try {
        InetAddress localHost = InetAddress.getLocalHost();
        serverIp = localHost.getHostAddress();
    } catch (UnknownHostException e) {
        serverIp = "Error resolving IP: " + e.getMessage();
    }
%>

<%
    try {

        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        String institution = request.getParameter("institution");
        String academicyear = request.getParameter("academicyear");
        String office = request.getParameter("office");

        System.out.println("\n\ngetSelectedApplicants.jsp");
        System.out.println("FROM DATE: " + fromDate);
        System.out.println("TO DATE: " + toDate);
        System.out.println("INSTITUTION: " + institution);
        System.out.println("ACADEMIC YEAR: " + academicyear);
        System.out.println("OFFICE: " + office);
        System.out.println("LOGIN USER: " + userId);
        System.out.println("IP: " + serverIp);

        JSONArray arr = ERPHostelDAO.getSelectedApplicants(fromDate, toDate, institution, academicyear, office);

        out.print(arr.toJSONString());

        System.out.println("RESPONSE: " + arr.toJSONString());

    } catch (Exception e) {

        System.out.println("\n\n\nCatch in getSelectedApplicants.jsp\n\n\n");
        e.printStackTrace();

        out.print("[]");
    }
%>

<% } else {%>

session Time out

<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" />

<% }%>
