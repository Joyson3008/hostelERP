<%-- 
    Document   : update_user_modules
    Created on : Jul 7, 2025, 2:05:40 PM
    Author     : rm
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="erp.auth.UserModule" %>
<%
    String userId = request.getParameter("userid");
    String userIdname = request.getParameter("useridname");
    String mods = request.getParameter("modname");  // comma-separated string
    String roles = request.getParameter("roles"); // comma-separated roles



    //out.println("USER ID: " + userId + "<br>");
   // out.println("MODS: " + mods + "<br>");

    if (userId == null || mods == null || mods.trim().isEmpty()) {
        out.print("❌ userId or mods is null/empty");
        return;
    }

    boolean ok = UserModule.updateOrInsertPassword(userId, userId, mods, userIdname, roles);
out.print(ok ? "success" : "fail");
%>






