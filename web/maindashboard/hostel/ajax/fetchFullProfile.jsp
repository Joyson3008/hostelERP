<%--
    Document : fetchFullProfile
    Created on : Nov 18, 2025, 11:04:59 AM
    Author : dinesh
--%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>

<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="Dao.ERPHostel.ERPHostelDAO"%>
<%@page import="java.net.InetAddress"%>
<%@page import="java.net.UnknownHostException"%>
<%@page import="org.json.simple.*"%>
<%@page import="java.sql.*"%>
<%@page import="Dbs.Connect.CyberCon"%>

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

        // GET REGISTER NUMBER FROM REQUEST
        String regno = request.getParameter("registerno");

        System.out.println("\n\nfetchFullProfile.jsp");
        System.out.println("REGNO: " + regno);
        System.out.println("LOGIN USER: " + userId);
        System.out.println("IP: " + serverIp);

        // CALL DAO
        String json = ERPHostelDAO.getFullHostelStudentProfile(regno);

        out.print(json);

    } catch (Exception e) {

        System.out.println("\n\nCATCH in fetchFullProfile.jsp\n\n");
        e.printStackTrace();

        out.print("{\"error\":\"Server Conncection Not Established\"}");
    }
%>

<% } else {%>

session Time out

<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" />

<% }%>