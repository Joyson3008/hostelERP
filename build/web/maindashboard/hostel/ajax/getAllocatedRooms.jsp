<%-- 
    Document   : getAllocatedRooms
    Created on : Apr 27, 2026, 5:38:57 PM
    Author     : lccerp26
--%>

<%@page import="org.json.simple.JSONArray"%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="Dao.ERPHostel.ERPHostelRoomDAO"%>

<%--
<%
    String login = (String) session.getAttribute("login");

    if (login != null) {
%>

--%>
<%
    try {

        String blockid = request.getParameter("blockid");
        String floorid = request.getParameter("floorid");
        String type = request.getParameter("type");

        JSONArray arr = ERPHostelRoomDAO.getAllocatedRooms(blockid, floorid, type);

        out.print(arr.toJSONString());

    } catch (Exception e) {

        System.out.println("\n\n\ngetAllocatedRooms.jsp\n\n\n" + e);
        out.print("[]");

    }
%>

<%--
<% } else {%>

Session Time Out
<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" />

<% }%>
--%>
