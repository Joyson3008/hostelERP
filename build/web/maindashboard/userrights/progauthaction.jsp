<%-- 
    Document   : progauthaction
    Created on : Sep 18, 2025, 10:46:01 AM
    Author     : JRMartin <JRMartin at your.org>
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="erp.programAuthor.ProgAuthDAO" %>
<%
String action = request.getParameter("action");
String userId = request.getParameter("userid");
String regy = request.getParameter("regy");
String officeIds = request.getParameter("officeids");
String cuuroffice = (String) session.getAttribute("currentOfficeUid");

boolean status = false;
if ("update".equals(action)) {
    status = ProgAuthDAO.saveOrUpdateProgAuth(userId, regy, officeIds,Integer.parseInt(cuuroffice));
}

out.print(status ? "SUCCESS" : "FAIL");
%>

