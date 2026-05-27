<%-- 
    Document   : getDashboardCounts
    Created on : Apr 28, 2026, 10:10:51 AM
    Author     : lccerp26
--%>

<%@ page contentType="application/json" pageEncoding="UTF-8" %>
<%@ page import="Dao.ERPHostel.HostelDashboardDAO" %>
<%@ page import="org.json.simple.JSONObject" %>

<%
try {

    HostelDashboardDAO dao = new HostelDashboardDAO();

    JSONObject obj = dao.getDashboardCounts();

    out.print(obj.toJSONString());

} catch (Exception e) {

    System.out.println("\n\n\ngetDashboardCounts.jsp\n\n\n" + e);

    out.print("{\"total\":0,\"veg\":0,\"nonveg\":0,\"metro\":0,\"rc\":0}");
}
%>
