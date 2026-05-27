<%-- 
    Document   : changePasswordAction
    Created on : Oct 14, 2025, 4:10:24 PM
    Author     : JR Martin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>


<%
    String login = (String) session.getAttribute("login");

    if (login != null) {
        //out.println(uid);
%>
<%@ page import="erp.auth.ChangePasswordDAO" %>
<%@ page session="true" %>
<%
    response.setContentType("text/plain");

    String authUserId = (String) session.getAttribute("username");
    if (authUserId == null) {
        out.print("USER_NOT_FOUND");
        return;
    }

    String oldPwd = request.getParameter("oldPassword");
    String newPwd = request.getParameter("newPassword");

    ChangePasswordDAO dao = new ChangePasswordDAO();
    String result = dao.changePassword(authUserId, oldPwd, newPwd);

    out.print(result);  // SUCCESS, INCORRECT_OLD_PASSWORD, etc.
%>

<% } else {
// out.println(uid);
    out.println("session Time out");
%>
<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" />
<%
    }
%>
