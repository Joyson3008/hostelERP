<%-- 
    Document   : getMess
    Created on : Apr 27, 2026, 1:55:58 PM
    Author     : lccerp26
--%>

<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="Dao.ERPHostel.ERPHostelRoomDAO"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%--
<%
    String login = (String) session.getAttribute("login");

    if (login != null) {
%>
--%>
<%
    try {

        JSONArray arr = ERPHostelRoomDAO.getMessList(); // DAO method

        out.print(arr.toJSONString());

        System.out.println("\n\ngetMess.jsp RESPONSE:\n" + arr.toJSONString());

    } catch (Exception e) {

        System.out.println("\n\nERROR in getMess.jsp\n");
        e.printStackTrace();

        out.print("[]"); // return empty array

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
