<%@page contentType="application/json" pageEncoding="UTF-8"%>

<%@page import="Dao.ERPHostel.ERPHostelDAO"%>
<%@page import="org.json.simple.JSONArray"%>

<%
    response.setContentType("application/json");

    try {

        JSONArray arr = ERPHostelDAO.getInstitutions();

        System.out.println("\n\ngetInstitutions.jsp");
        System.out.println("Response : " + arr.toJSONString());

        out.print(arr.toJSONString());

        out.flush();

    } catch (Exception e) {

        System.out.println("\n\nCatch in getInstitutions.jsp\n\n");

        e.printStackTrace();

        out.print("[]");
    }
%>