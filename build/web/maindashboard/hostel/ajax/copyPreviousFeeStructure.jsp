<%-- 
    Document   : copyPreviousFeeStructure.jsp
    Created on : 27-May-2026, 3:11:15 pm
    Author     : R JOYSON
--%>

<%@page contentType="application/json"
        pageEncoding="UTF-8"%>

<%@page import="Dao.ERPHostel.ERPHostelFeeDAO"%>

<%

    try {

        String academicyearidStr =
        request.getParameter(
                "academicyearid");

String hosteltype =
        request.getParameter(
                "hosteltype");

String blocknoStr =
        request.getParameter(
                "blockno");

if (academicyearidStr == null
        || academicyearidStr.trim().equals("")
        || blocknoStr == null
        || blocknoStr.trim().equals("")) {

    out.print(
        "{\"success\":false,"
        + "\"message\":\"Academic Year or Block Missing\"}");

    return;
}

int academicyearid =
        Integer.parseInt(
                academicyearidStr);

int blockno =
        Integer.parseInt(
                blocknoStr);

        String result =
                ERPHostelFeeDAO
                .copyPreviousFeeStructure(
                        academicyearid,
                        hosteltype,
                        blockno);

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
