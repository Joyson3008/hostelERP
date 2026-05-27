<%-- 
    Document   : saveBlock
    Created on : Apr 21, 2026, 3:43:45?PM
    Author     : lccerp26
--%>
<%@page contentType="application/json"%>
<%@page import="Dao.ERPHostel.ERPHostelRoomDAO"%>

<%

    try {

        String blockname = request.getParameter("blockname");
        int floors = Integer.parseInt(request.getParameter("floors"));

        String user = "";
        String ip = request.getRemoteAddr();

        out.print(ERPHostelRoomDAO.insertBlock(blockname, floors, user, ip));

    } catch (Exception e) {

        System.out.println("\n\n\nsaveBlock.jsp\n\n\n" + e);

    }

%>
