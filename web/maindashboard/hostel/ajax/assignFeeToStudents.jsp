<%@page contentType="application/json"
        pageEncoding="UTF-8"%>

<%@page import="Dao.ERPHostel.ERPHostelFeeDAO"%>

<%

    try {

        String jsonData =
                request.getParameter("jsonData");

        String allocatedBy =
                (String) session.getAttribute("username");

        String allocatedIp =
                request.getRemoteAddr();

        if (allocatedBy == null) {

            allocatedBy = "admin";
        }

        String result =
                ERPHostelFeeDAO.assignFeeToStudents(
                        jsonData,
                        allocatedBy,
                        allocatedIp);

        out.print(result);

    } catch (Exception e) {

        e.printStackTrace();

        out.print(
            "{\"success\":false,"
            + "\"message\":\""
            + e.getMessage()
            + "\"}"
        );
    }

%>