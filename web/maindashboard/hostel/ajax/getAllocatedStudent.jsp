<%-- 
    Document   : getAllocatedStudent
    Created on : Apr 28, 2026
    Author     : lccerp26
--%>

<%@page contentType="application/json" pageEncoding="UTF-8"%>

<%@page import="Dao.ERPHostel.ERPHostelDAO"%>
<%@page import="org.json.simple.JSONObject"%>

<%
    try {

        // =====================================
        // GET SEARCH VALUE
        // =====================================

        String searchText =
                request.getParameter("searchText");

        System.out.println(
                "\n=================================");

        System.out.println(
                "getAllocatedStudent.jsp");

        System.out.println(
                "=================================");

        System.out.println(
                "SEARCH : " + searchText);

        // =====================================
        // VALIDATION
        // =====================================

        if (searchText == null
                || searchText.trim().equals("")) {

            JSONObject err =
                    new JSONObject();

            err.put("success", false);

            err.put(
                    "message",
                    "Search value missing");

            out.print(err.toJSONString());

            return;
        }

        // =====================================
        // REMOVE EXTRA SPACES
        // =====================================

        searchText = searchText.trim();

        // =====================================
        // DAO CALL
        // =====================================

        JSONObject obj =
                ERPHostelDAO
                        .getAllocatedStudent(
                                searchText);

        // =====================================
        // DEBUG
        // =====================================

        System.out.println(
                "\nDAO RESPONSE :\n"
                + obj.toJSONString());

        // =====================================
        // RESPONSE
        // =====================================

        out.print(obj.toJSONString());

        out.flush();

        System.out.println(
                "\n=================================");

        System.out.println("END");

        System.out.println(
                "=================================\n");

    } catch (Exception e) {

        System.out.println(
                "\n\nCatch in getAllocatedStudent.jsp\n\n");

        e.printStackTrace();

        JSONObject err =
                new JSONObject();

        err.put("success", false);

        err.put(
                "message",
                e.getMessage() != null
                ? e.getMessage()
                : "Unknown Error");

        out.print(err.toJSONString());
    }
%>