<%-- 
    Document   : getEligibleStudents
    Created on : Apr 20, 2026, 2:11:57 PM
    Author     : lccerp26
--%>

<%@page import="org.json.simple.JSONArray"%>
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

        // =====================================
        // GET PARAMETERS
        // =====================================

        String instIdStr =
                request.getParameter("institutionid");

        String shiftType =
                request.getParameter("shifttype");

        JSONArray arr;

        System.out.println(
                "\n=================================");
        System.out.println("getEligibleStudents.jsp");
        System.out.println("=================================");

        System.out.println(
                "Institution ID : " + instIdStr);

        System.out.println(
                "Shift Filter   : " + shiftType);

        // =====================================
        // ALL INSTITUTIONS
        // =====================================

        if (instIdStr == null
                || instIdStr.trim().equals("")) {

            System.out.println(
                    "\nInstitution : ALL");

            arr =
                    ERPHostelRoomDAO
                            .getEligibleStudentsAll(
                                    shiftType);

        } else {

            // =================================
            // SPECIFIC INSTITUTION
            // =================================

            int institutionid =
                    Integer.parseInt(instIdStr);

            System.out.println(
                    "\nInstitution ID : "
                    + institutionid);

            arr =
                    ERPHostelRoomDAO
                            .getEligibleStudents(
                                    institutionid,
                                    shiftType);
        }

        // =====================================
        // RESPONSE
        // =====================================

        out.print(arr.toJSONString());

        System.out.println(
                "\n\ngetEligibleStudents.jsp OUTPUT :\n"
                + arr.toJSONString());

        System.out.println(
                "\n=================================");
        System.out.println("END");
        System.out.println("=================================\n");

    } catch (Exception e) {

        System.out.println(
                "\n\nCatch in getEligibleStudents.jsp\n\n");

        e.printStackTrace();

        out.print("[]");
    }
%>

<%--
<%
} else {
%>

Session Time Out

<meta http-equiv="refresh"
      content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" />

<%
    }
%>
--%>