<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="Dao.ERPHostel.ERPHostelFeeDAO"%>
<%
    try {

        String jsonData = request.getParameter("jsonData");

        // ✅ Debug: confirm JSP receives the payload
        System.out.println("\n\n=== updateFeeStructure.jsp ===");
        System.out.println("jsonData received: " + jsonData);

        if (jsonData == null || jsonData.trim().isEmpty()) {
            out.print("{\"success\":false,\"message\":\"jsonData is null or empty\"}");
            return;
        }

        String updatedBy = (String) session.getAttribute("username");
        String updatedIp = request.getRemoteAddr();

        if (updatedBy == null) updatedBy = "admin";

        String result = ERPHostelFeeDAO.updateFeeStructure(jsonData, updatedBy, updatedIp);

        System.out.println("updateFeeStructure result: " + result);

        out.print(result);

    } catch (Exception e) {
        e.printStackTrace();
        out.print(
            "{\"success\":false,\"message\":\"" + e.getMessage().replace("\"","'") + "\"}"
        );
    }
%>