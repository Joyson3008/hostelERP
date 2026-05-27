<%-- 
    Document   : deleteMess
    Created on : Apr 27, 2026, 2:03:29 PM
    Author     : lccerp26
--%>

<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="Dao.ERPHostel.ERPHostelRoomDAO"%>

<%--
<%
    String login = (String) session.getAttribute("login");

    if (login != null) {
%>
--%>

<%
    try {

        int id = Integer.parseInt(request.getParameter("mess_id"));

        String result = ERPHostelRoomDAO.deleteMess(id);

        out.print(result);

        System.out.println("\n\ndeleteMess.jsp ID: " + id);

    } catch (Exception e) {

        System.out.println("\n\nCatch in deleteMess.jsp\n");
        e.printStackTrace();

        out.print("{\"success\":false}");

    }
%>

<%--<%
} else {
%>

Session Time Out

<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" />

<%
    }
%> --%>