<%-- 
    Document   : downloadAllocationPdf.jsp
    Created on : 27-May-2026, 11:45:01 pm
    Author     : R JOYSON
--%>

<%@page contentType="application/json"
        pageEncoding="UTF-8"%>

<%@page import="Dao.ERPHostel.ERPHostelRoomDAO"%>

<%

    try {

        String result =
                ERPHostelRoomDAO
                .getAllAllocatedStudentsForPdf();

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
