<%-- 
    Document   : getRentCategories
    Created on : Apr 18, 2026, 5:15:18 PM
    Author     : lccerp26
--%>

<%@page import="org.json.simple.JSONArray"%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="Dao.ERPHostel.ERPHostelRoomDAO"%>

<%
    try {

        JSONArray arr = ERPHostelRoomDAO.getRentCategories();

        out.print(arr.toJSONString());

        System.out.println("DEBUG [getRentCategories.jsp]: " + arr);

    } catch (Exception e) {
        System.out.println("\n\n\ngetRentCategories.jsp\n\n\n" + e);
        out.print("[]");
    }
%>
