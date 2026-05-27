<%-- 
    Document   : updateMenuPermission
    Created on : Oct 14, 2025, 4:40:47 PM
    Author     : JR Martin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String login = (String) session.getAttribute("login");
    String modu = (String) session.getAttribute("username");

    if (login != null) {
        //out.println(uid);
%>
<%@ page import="erp.auth.MenuPermissionDAO" %>
<%
    String mcode = request.getParameter("mcode");
    String status = request.getParameter("status");

    if (mcode != null && status != null) {
        MenuPermissionDAO dao = new MenuPermissionDAO();
        String result = dao.updateMenuPermission(mcode, status,modu);
        out.print(result);
    } else {
        out.print("INVALID_INPUT");
    }
%>

<% } else {
// out.println(uid);
    out.println("session Time out");
%>
<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" />
<%
    }
%>
