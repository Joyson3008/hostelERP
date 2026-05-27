<%-- 
    Document   : getStudentByRegNo
    Created on : Apr 14, 2026, 2:38:11?PM
    Author     : lccerp26
--%>

<%@page contentType="application/json" pageEncoding="UTF-8"%>

<%@page import="org.json.simple.JSONObject"%>
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

        String regno = request.getParameter("regno");

        System.out.println("\n\nfetchStudentByRegNo.jsp");
        System.out.println("REGNO: " + regno);
        System.out.println("LOGIN USER: " + userId);
        System.out.println("IP: " + serverIp);

        JSONObject obj = ERPHostelDAO.getStudentByRegNo(regno);

        out.print(obj.toJSONString());

        System.out.println("RESPONSE: " + obj.toJSONString());

    } catch (Exception e) {

        System.out.println("\n\n\nfetchStudentByRegNo.jsp from Catch\n\n\n");
        e.printStackTrace();

        out.print("{}");
    }
%>

<% } else {%>

session Time out

<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" />

<% }%>
