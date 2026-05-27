<%@page contentType="application/json"
        pageEncoding="UTF-8"%>

<%@page import="Dao.ERPHostel.ERPHostelFeeDAO"%>

<%

    try {

        long feestructureid =
                Long.parseLong(
                        request.getParameter(
                                "feestructureid"));

        String result =
                ERPHostelFeeDAO
                        .deleteFeeStructure(
                                feestructureid);

        out.print(result);

    } catch (Exception e) {

        e.printStackTrace();

        out.print(
            "{\"success\":false}"
        );
    }

%>