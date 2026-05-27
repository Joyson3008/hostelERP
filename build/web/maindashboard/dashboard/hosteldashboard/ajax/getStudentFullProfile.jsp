<%-- 
    Document   : getStudentFullProfile
    Created on : Apr 28, 2026, 11:49:16 AM
    Author     : lccerp26
--%>

<%@ page contentType="application/json" pageEncoding="UTF-8" %>
<%@ page import="Dao.ERPHostel.HostelDashboardDAO" %>

<%
try {

    String regno = request.getParameter("regno");

    String json = HostelDashboardDAO.getFullHostelStudentProfile(regno);

    out.print(json);

} catch (Exception e) {

    System.out.println("\n\n\ngetStudentFullProfile.jsp\n\n\n" + e);

    out.print("{}");
}
%>
