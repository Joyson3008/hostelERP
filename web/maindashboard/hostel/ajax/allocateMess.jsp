<%-- 
    Document   : allocateMess
    Created on : Apr 27, 2026, 6:28:51?PM
    Author     : lccerp26
--%>

<%@page contentType="application/json"%>
<%@page import="Dao.ERPHostel.ERPHostelRoomDAO"%>
<%@page import="org.json.simple.JSONObject"%>

<%
    try {

        String[] students = request.getParameterValues("students[]");
        int messid = Integer.parseInt(request.getParameter("messid"));

        JSONObject res = ERPHostelRoomDAO.allocateMess(messid, students);

        out.print(res.toJSONString());

    } catch (Exception e) {

        JSONObject obj = new JSONObject();
        obj.put("success", false);
        obj.put("error", e.getMessage());

        out.print(obj.toJSONString());
    }
%>
