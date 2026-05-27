<%-- 
    Document   : saveRooms
    Created on : Apr 18, 2026, 5:16:31 PM
    Author     : lccerp26
--%>

<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="Dao.ERPHostel.ERPHostelRoomDAO"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.parser.JSONParser"%>

<%--<%
    String login = (String) session.getAttribute("login");

    if (login != null) {
%> --%>

<%
    try {

        int blockid = Integer.parseInt(request.getParameter("blockid"));
        int floorid = Integer.parseInt(request.getParameter("floorid"));
        int roomCount = Integer.parseInt(request.getParameter("roomCount"));
        int maxOccupants = Integer.parseInt(request.getParameter("maxOccupants"));
        
        String roomsStr = request.getParameter("rooms");

        JSONParser parser = new JSONParser();

        String user = (String) session.getAttribute("username");
        String ip = request.getRemoteAddr();

        String result = ERPHostelRoomDAO.insertRooms(blockid, floorid, roomCount, maxOccupants, user, ip);

        System.out.println("\n\nsaveRooms.jsp Response:\n" + result + "\n\n");

        out.print(result);

    } catch (Exception e) {

        System.out.println("\n\n\nsaveRooms.jsp ERROR\n\n\n" + e);

        out.print("{\"success\": false, \"error\": \"Invalid Data\"}");

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
