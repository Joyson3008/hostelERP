<%-- 
    Document   : officeaction
    Created on : Jul 4, 2025, 3:30:32 PM
    Author     : rm
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="erp.generalmaster.Office"%>
<%@page import="erp.auth.UserModule"%>
<%@page import="org.json.simple.*"%>
<%
    String action = request.getParameter("action");
    Office office = new Office();
    String result = "invalid";

    if ("insert".equals(action)) {
        String name = request.getParameter("officename");
        result = office.insertOffice(name);
    } else if ("update".equals(action)) {
        int id = Integer.parseInt(request.getParameter("officeid"));
        String name = request.getParameter("officename");
        result = office.updateOffice(id, name);
    } else if ("delete".equals(action)) {
        int id = Integer.parseInt(request.getParameter("officeid"));
        result = office.deleteOffice(id);
    } else if ("list".equals(action)) {
        JSONArray list = office.listOffices();
        response.setContentType("application/json");
        out.print(list.toJSONString());
        return;
    }
    
    if ("listWithSelected".equals(action)) {
        String userid = request.getParameter("userid");
        
        // Get user's selected office IDs using Java class
        UserModule user = new UserModule();
        String selectedOfficesCsv = user.getUserOfficeIds(userid);  // returns "1,2,3"
        System.out.println("--------------------------"+selectedOfficesCsv);

        // Get all offices
        JSONArray allOffices = office.listOffices();

        // Mark selected offices
        java.util.List<String> selectedList = java.util.Arrays.asList(selectedOfficesCsv.split(","));
        for (Object obj : allOffices) {
            JSONObject officeObj = (JSONObject) obj;
            String oid = String.valueOf(officeObj.get("officeid"));
            officeObj.put("selected", selectedList.contains(oid) ? "checked" : "no");
        }
        response.setContentType("application/json");
        out.print(allOffices.toJSONString());
        return;
    }
    
    out.print(result);
%>

