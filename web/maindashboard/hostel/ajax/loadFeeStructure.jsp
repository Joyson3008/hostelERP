<%@page contentType="application/json"
        pageEncoding="UTF-8"%>

<%@page import="Dao.ERPHostel.ERPHostelFeeDAO"%>

<%

    try {

        String academicyearid =
                request.getParameter("academicyearid");

        String blockno =
                request.getParameter("blockno");

        String roomnofrom =
                request.getParameter("roomnofrom");

        String roomnoto =
                request.getParameter("roomnoto");

        String result =
                ERPHostelFeeDAO.loadFeeStructure(
                        academicyearid,
                        blockno,
                        roomnofrom,
                        roomnoto);

        out.print(result);

    } catch (Exception e) {

        System.out.println(
                "\n\nCatch in loadFeeStructure.jsp\n\n");

        e.printStackTrace();

        out.print(
            "{\"success\":false,"
            + "\"message\":\""
            + e.getMessage().replace("\"", "'")
            + "\"}"
        );
    }

%>