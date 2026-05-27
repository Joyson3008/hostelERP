<%-- 
    Document   : getBlocks
    Created on : Apr 18, 2026, 5:07:45 PM
    Author     : lccerp26
--%>

<%@page import="org.json.simple.JSONArray"%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="Dao.ERPHostel.ERPHostelRoomDAO"%>

<%
    try {

        String result = ERPHostelRoomDAO.getBlocks();

        System.out.println("\n\nTEST OUTPUT:\n" + result + "\n\n");

        out.print(result);

    } catch (Exception e) {
        System.out.println("\n\n\ngetBlocks.jsp\n\n\n" + e);
        out.print("[]");
    }
%>