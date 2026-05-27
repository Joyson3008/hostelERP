<%-- 
    Document   : getFloors
    Created on : Apr 18, 2026, 5:12:13 PM
    Author     : lccerp26
--%>
<%@page import="org.json.simple.JSONArray"%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="Dao.ERPHostel.ERPHostelRoomDAO"%>

<%--<%
//    String login = (String) session.getAttribute("login");

    if (login != null) {
%> --%>

<%
    try {
        
        System.out.println("\nTry in getFloors.jsp");
        int blockid = Integer.parseInt(request.getParameter("blockid"));
        
        System.out.println("\n\nBlock ID: "+blockid);
        String result = ERPHostelRoomDAO.getFloorsByBlock(blockid);

        System.out.println("\n\ngetFloors.jsp Response:\n" + result + "\n\n");

        out.print(result);

    } catch (Exception e) {

        System.out.println("\n\n\nCatch in getFloors.jsp\n\n\n" + e);

        out.print("[]"); // always return valid JSON

    }
%>

<%-- <%
} else {
%>

Session Time out

<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" />

<%
    }
%> --%>
