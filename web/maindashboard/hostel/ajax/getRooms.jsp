<%-- 
    Document   : getRooms
    Created on : Apr 18, 2026, 5:46:06 PM
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

        int blockid = Integer.parseInt(request.getParameter("blockid"));
        String floorParam = request.getParameter("floorid");

        int floorid = 0;

        try {
            floorid = Integer.parseInt(floorParam);
        } catch (Exception e) {
            floorid = 0; // default ALL
        }

        String result = ERPHostelRoomDAO.getRooms(blockid, floorid);

        System.out.println("\n\ngetRooms.jsp Response:\n" + result + "\n\n");

        out.print(result);

    } catch (Exception e) {

        System.out.println("\n\n\ngetRooms.jsp ERROR\n\n\n" + e);

        out.print("[]"); // always valid JSON
    }
%>

<%--
<%
} else {
%>

Session Time out

<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" />

<%
    }
%>
--%>