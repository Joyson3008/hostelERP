<%@page contentType="application/json"
        pageEncoding="UTF-8"%>

<%@page import="Dao.ERPHostel.ERPHostelFeeDAO"%>

<%

    try {

        int blockno =
                Integer.parseInt(
                        request.getParameter(
                                "blockno"));

        int roomnofrom =
                Integer.parseInt(
                        request.getParameter(
                                "roomnofrom"));

        int roomnoto =
                Integer.parseInt(
                        request.getParameter(
                                "roomnoto"));

        String result =
                ERPHostelFeeDAO
                .getFeeAssignmentPreview(
                        blockno,
                        roomnofrom,
                        roomnoto);

        out.print(result);

    } catch (Exception e) {

        e.printStackTrace();

        out.print(
            "{\"success\":false,"
            + "\"message\":\""
            + e.getMessage()
            + "\"}");
    }

%>