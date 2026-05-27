<%-- 
    Document   : reset_user_password
    Created on : Jul 7, 2025, 4:17:57 PM
    Author     : rm
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="erp.auth.UserModule" %>
<%
    String userId = request.getParameter("userid");
    String password = request.getParameter("password");

    if (userId != null && password != null && !password.trim().isEmpty()) {
        boolean updated = UserModule.updatePassword(userId, password);
        out.print(updated ? "Password updated successfully." : "Failed to update password.");
    } else {
        out.print("Missing user ID or password.");
    }
%>

