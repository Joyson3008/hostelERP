<%-- 
    Document   : getAcademicYears
    Created on : Apr 13, 2026, 2:12:16 PM
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

        JSONArray arr = ERPHostelDAO.getAcademicYears();

        out.print(arr.toJSONString());

        System.out.println("\n\ngetAcademicYears.jsp");
        System.out.println("LOGIN USER: " + userId);
        System.out.println("IP: " + serverIp);
        System.out.println("RESPONSE: " + arr.toJSONString());

    } catch (Exception e) {

        System.out.println("\n\n\ngetAcademicYears.jsp ERROR\n\n\n");
        e.printStackTrace();

        out.print("[]");
    }
%>

<% } else {%>

session Time out

<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" />

<% }%>

