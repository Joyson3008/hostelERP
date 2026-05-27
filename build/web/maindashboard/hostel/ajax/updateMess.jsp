<%-- 
    Document   : updateMess
    Created on : Apr 27, 2026, 2:02:43 PM
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
        String name = request.getParameter("mess_name");
        String shortName = request.getParameter("mess_short_name");

        String result = ERPHostelRoomDAO.updateMess(id, name, shortName);

        out.print(result);

        System.out.println("\n\nupdateMess.jsp ID: " + id);

    } catch (Exception e) {

        System.out.println("\n\nCatch in updateMess.jsp\n");
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
