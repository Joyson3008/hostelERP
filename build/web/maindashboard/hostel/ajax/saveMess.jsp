<%-- 
    Document   : saveMess
    Created on : Apr 27, 2026, 2:00:47 PM
    Author     : lccerp26
--%>

<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="Dao.ERPHostel.ERPHostelRoomDAO"%>
<%@page import="java.net.InetAddress"%>

<%--
<%
    String login = (String) session.getAttribute("login");

    if (login != null) {
%>
--%>

<%
    try {

        String name = request.getParameter("mess_name");
        String shortName = request.getParameter("mess_short_name");

        String ip = InetAddress.getLocalHost().getHostAddress();
        String user = ""; // or pass from session if needed

        String result = ERPHostelRoomDAO.insertMess(name, shortName, user, ip);

        out.print(result);

        System.out.println("\n\nsaveMess.jsp INPUT: " + name + " | " + shortName);

    } catch (Exception e) {

        System.out.println("\n\nCatch in saveMess.jsp\n");
        e.printStackTrace();

        out.print("{\"success\":false}");

    }
%>

<%--<%
} else {
%>

Session Time Out

<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" />

<%
    }
%> --%>
