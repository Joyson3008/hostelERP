<%@page contentType="application/json"
        pageEncoding="UTF-8"%>

<%@page import="Dao.ERPHostel.ERPHostelFeeDAO"%>

<%

    try {

        int blockno =
                Integer.parseInt(
                        request.getParameter("blockno"));

        String roomtype =
                request.getParameter("roomtype");

        String academicyear =
                request.getParameter("academicyear");

        String result =
                ERPHostelFeeDAO.getFeeStructure(
                        blockno,
                        roomtype,
                        academicyear);

        out.print(result);

    } catch (Exception e) {

        e.printStackTrace();

        out.print("{}");
    }

%>