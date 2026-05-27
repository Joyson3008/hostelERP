<%@page contentType="application/json"
        pageEncoding="UTF-8"%>

<%@page import="Dao.ERPHostel.ERPHostelFeeDAO"%>

<%

    try {

        int blockno =
                Integer.parseInt(
                        request.getParameter(
                                "blockno"));

        String result =
                ERPHostelFeeDAO
                        .getFeeAssignmentPreview(
                                blockno);

        out.print(result);

    } catch (Exception e) {

        e.printStackTrace();

        out.print("{}");
    }

%>