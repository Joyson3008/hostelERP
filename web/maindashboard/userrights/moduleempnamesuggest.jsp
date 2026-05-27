<head>

  <META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">
  <META HTTP-EQUIV="PRAGMA" CONTENT="NO-CACHE">
  <META HTTP-EQUIV="EXPIRES" CONTENT="0">
</head>
<%
response.setDateHeader("Expires",0);
response.addHeader("Cache-Control","no-cache, no-store, must-revlidate");
response.addHeader("Cache-Control","post-check=0, pre-check=0");
response.setHeader("Pragma","no-cache");
%>
<jsp:useBean id="modu" class="erp.module.ModuleMaster" scope="request"/>

 <%@ page import="org.json.simple.*" %>
<table class="table table-bordered">
 <%
 	String login = (String)session.getAttribute("login");

 if(login!=null){
	 
	 try{
		 String query = request.getParameter("q");
		// out.println(query);
		 if (query != null && !query.trim().isEmpty()) {
			 
			 JSONObject obj = modu.moduleusersugg(query);
			 JSONArray ary = (JSONArray) obj.get("data");
			 for(int y=0;y<ary.size();y++){
				 JSONObject obj1 = (JSONObject) ary.get(y);
				 %>				
				 <tr onclick="selectModule('<%=obj1.get("uid")%>', '<%=obj1.get("uname")%>')" >
			 	<td><%=obj1.get("uid")%></td>
			 	<td><%=obj1.get("uname")%></td>
			 	<td><%=obj1.get("modu")%></td>
			 	</tr>
				 
				 <%
				 
			 }
			 
		 }
		 
		 
	 }catch(Exception e){
		 out.println(e);
	 }
	 %>
	 </table>
	    <% }
	    else{
	    // out.println(uid);
	    out.println("session Time out");
	    %>
	    	<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" /> 
	    <%
	    }
	    %>