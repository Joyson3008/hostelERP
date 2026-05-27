<%-- 
    Document   : userofficeaction
    Created on : Jul 8, 2025, 12:26:16 PM
    Author     : rm
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="erp.auth.UserModule"%>
<%
    String action = request.getParameter("action");
    String result = "invalid";
    UserModule user = new UserModule();

    if ("update".equals(action)) {
        String userid = request.getParameter("userid");
        String officeids = request.getParameter("officeids"); // e.g., "1,2"
        System.out.println("------------- \n \n"+userid+"----------------"+officeids);
        result = user.updateUserOfficeIds(userid, officeids);
    }
    out.print(result);
%>

