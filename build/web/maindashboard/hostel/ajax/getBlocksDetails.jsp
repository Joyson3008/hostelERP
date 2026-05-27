<%--
    Document   : getBlocksDetails.jsp
    Purpose    : Load Hostel Blocks
--%>

<%@page contentType="application/json"
        pageEncoding="UTF-8"%>

<%@page import="Dao.ERPHostel.ERPHostelFeeDAO"%>
<%@page import="org.json.simple.JSONArray"%>

<%

    try {

        JSONArray result =
                ERPHostelFeeDAO.getBlocksDetails();

        out.print(
                result.toJSONString());

    } catch (Exception e) {

        e.printStackTrace();

        out.print("[]");
    }

%>