<%-- ajax/getAllStructures.jsp --%>
<%@page contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="Dao.ERPHostel.HostelFeeStructureDAO"%>
<%@page import="org.json.simple.JSONArray"%>
<%
    response.setHeader("Cache-Control","no-cache");
    JSONArray arr = HostelFeeStructureDAO.getAllStructures();
    out.print(arr.toJSONString());
%>
