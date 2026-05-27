<%-- 
    Document   : updateRoom
    Created on : Apr 27, 2026, 9:56:19 AM
    Author     : lccerp26
--%>

<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="Dao.ERPHostel.ERPHostelRoomDAO"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.parser.JSONParser"%>

<%
    try {

        int roomid = Integer.parseInt(request.getParameter("roomid"));
        int capacity = Integer.parseInt(request.getParameter("capacity"));
        //int occupants = Integer.parseInt(request.getParameter("occupants"));
        String assets = request.getParameter("assets");

        String user = (String) session.getAttribute("username");
        String ip = request.getRemoteAddr();

        out.print(ERPHostelRoomDAO.updateRoom(roomid, capacity, assets, user, ip));

    } catch (Exception e) {

        System.out.println("\n\nupdateRoom.jsp ERROR\n\n" + e);

        out.print("{\"success\":false}");
    }
%>
