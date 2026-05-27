<%-- 
    Document   : getDistricts
    Created on : Apr 7, 2026, 10:46:05 AM
    Author     : lccerp26
--%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>

<%@page import="org.json.simple.JSONArray"%>
<%@page import="Dao.ERPHostel.ERPHostelDAO"%>
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

        String stateid = request.getParameter("stateid");

        System.out.println("\n\ngetDistricts.jsp");
        System.out.println("STATE ID: " + stateid);
        System.out.println("LOGIN USER: " + userId);
        System.out.println("IP: " + serverIp);

        JSONArray arr = ERPHostelDAO.getDistricts();

        out.print(arr.toJSONString());

        System.out.println("RESPONSE: " + arr.toJSONString());

    } catch (Exception e) {

        System.out.println("\n\n\nCatch in getDistricts.jsp\n\n\n");
        e.printStackTrace();

        out.print("[]");
    }
%>

<% } else {%>

session Time out

<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" />

<% }%>

