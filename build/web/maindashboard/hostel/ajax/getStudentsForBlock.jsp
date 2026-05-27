<%-- ajax/getStudentsForBlock.jsp --%>
<%@page contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="Dao.ERPHostel.HostelFeeStructureDAO"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%
    response.setHeader("Cache-Control","no-cache");
    JSONObject result = new JSONObject();
    try {
        int  blockno        = Integer.parseInt(request.getParameter("blockno"));
        long feestructureid = Long.parseLong(request.getParameter("feestructureid"));
        JSONArray students  = HostelFeeStructureDAO.getStudentsForBlock(blockno, feestructureid);
        result.put("success",  true);
        result.put("students", students);
    } catch (Exception e) {
        result.put("success", false);
        result.put("message", e.getMessage());
        e.printStackTrace();
    }
    out.print(result.toJSONString());
%>
