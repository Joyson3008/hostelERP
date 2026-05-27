<%-- 
    Document   : setactivemenu.jsp
    Created on : Oct 7, 2025, 5:38:10 PM
    Author     : JR Martin
--%>
<%@page contentType="text/plain" pageEncoding="UTF-8"%>
<%
    // Check session
    String login = (String) session.getAttribute("login");

    if (login == null) {
        response.setStatus(401); // Unauthorized
        out.print("Session Timeout");
        return;
    }

    // Read POST parameters
    String activeMenu = request.getParameter("activeMenu");
    String activeMenuname = request.getParameter("activeMenuname");

    System.out.println("Before update --> activeMenu: " + activeMenu + ", activeMenuname: " + activeMenuname);

    if (activeMenu != null && !activeMenu.isEmpty()) {
        session.setAttribute("activeMenu", activeMenu);
        session.setAttribute("activeMenuname", activeMenuname);
        System.out.println("✅ Session updated successfully: " + activeMenu + " / " + activeMenuname);
        out.print("Session updated successfully");
    } else {
        out.print("No data received");
    }
%>

