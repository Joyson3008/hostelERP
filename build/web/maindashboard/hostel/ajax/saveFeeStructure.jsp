<%@page contentType="application/json"
        pageEncoding="UTF-8"%>

<%@page import="Dao.ERPHostel.ERPHostelFeeDAO"%>

<%

    try {

        String jsonData =
                request.getParameter("jsonData");

        // =========================================
        // VALIDATION
        // =========================================

        if (jsonData == null
                || jsonData.trim().isEmpty()) {

            out.print(
                "{\"success\":false,"
                + "\"message\":\"No Data Received\"}"
            );

            return;
        }

        String createdBy =
                (String) session.getAttribute("username");

        String createdIp =
                request.getRemoteAddr();

        if (createdBy == null
                || createdBy.trim().isEmpty()) {

            createdBy = "admin";
        }

        // =========================================
        // SAVE
        // =========================================

        String result =
                ERPHostelFeeDAO.saveFeeStructure(
                        jsonData,
                        createdBy,
                        createdIp);

        out.print(result);

    } catch (Exception e) {

        System.out.println(
                "\n\nCatch in saveFeeStructure.jsp\n\n");

        e.printStackTrace();

        out.print(
            "{\"success\":false,"
            + "\"message\":\""
            + e.getMessage().replace("\"", "'")
            + "\"}"
        );
    }

%>