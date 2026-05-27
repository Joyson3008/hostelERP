<%-- ajax/assignFeeStructure.jsp --%>
<%@page contentType="application/json;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="Dao.ERPHostel.HostelFeeStructureDAO"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@page import="java.io.BufferedReader"%>
<%
    response.setHeader("Cache-Control","no-cache");
    JSONObject result = new JSONObject();
    try {
        StringBuilder sb = new StringBuilder();
        String line;
        BufferedReader reader = request.getReader();
        while ((line = reader.readLine()) != null) sb.append(line);

        JSONParser parser = new JSONParser();
        JSONObject payload = (JSONObject) parser.parse(sb.toString());

        result = HostelFeeStructureDAO.assignFeeStructure(payload);
    } catch (Exception e) {
        result.put("success", false);
        result.put("message", "Assign error: " + e.getMessage());
        e.printStackTrace();
    }
    out.print(result.toJSONString());
%>
