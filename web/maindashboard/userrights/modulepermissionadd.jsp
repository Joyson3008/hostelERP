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
		 String empname = request.getParameter("empname");
		 String modulelist = request.getParameter("modulelist");
		 String links = request.getParameter("links");
		out.println(links);
		String status="";
		if(links.contains(",")){
			
			String[] temp=links.split("\\,");
			for(int h=0;h<temp.length;h++){
			 status = modu.moduleuserpermission(empname,modulelist,temp[h]);
			}
			
			
		}else{
			status = modu.moduleuserpermission(empname,modulelist,links);
			
		}
		
		out.println(status);
	
		 
		 
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