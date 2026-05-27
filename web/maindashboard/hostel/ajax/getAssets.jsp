<%-- 
    Document   : getAssets
    Created on : Apr 27, 2026, 11:08:26 AM
    Author     : lccerp26
--%>

<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="Dao.ERPHostel.ERPHostelRoomDAO"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.parser.JSONParser"%>

<%
try {
    out.print(ERPHostelRoomDAO.getAssets());
} catch(Exception e){
    System.out.println("\n\ngetAssets.jsp ERROR\n\n" + e);
    out.print("[]");
}
%>
