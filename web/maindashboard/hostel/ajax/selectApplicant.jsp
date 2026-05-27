<%-- 
    Document   : selectApplicant
    Created on : Apr 14, 2026, 11:07:27 AM
    Author     : lccerp26
--%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>

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
    // Get Client IP (BEST METHOD)
    String ip = request.getRemoteAddr();

    try {

        String appnos = request.getParameter("applicationno");

        System.out.println("\n\nselectApplicant.jsp");
        System.out.println("Applications: " + appnos);
        System.out.println("User: " + userId);
        System.out.println("IP: " + ip);

        String result = ERPHostelDAO.SelectApplicant(appnos, userId, ip);

        out.print(result);

    } catch (Exception e) {

        System.out.println("\n\n\nCatch in selectApplicant.jsp\n\n\n");
        e.printStackTrace();

        out.print("{\"success\":false,\"error\":\"" + e.getMessage() + "\"}");
    }
%>

<% } else {%>

session Time out

<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" />

<% }%>

