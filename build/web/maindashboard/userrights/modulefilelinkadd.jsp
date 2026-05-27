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
 <%
 	String login = (String)session.getAttribute("login");

 if(login!=null){
	 
	 try{
		 String filelink = request.getParameter("filelink");
		 String filenamelink = request.getParameter("filenamelink");
		 String modulelist = request.getParameter("modulelist");
		 String filenamelinkdesc = request.getParameter("filenamelinkdesc");
		 
		 String status = modu.addmodulefilelink(filelink,filenamelink,modulelist,filenamelinkdesc);
		 
		 out.println(status);
		 
		 
	 }catch(Exception e){
		 out.println(e);
	 }
	 %>
	    <% }
	    else{
	    // out.println(uid);
	    out.println("session Time out");
	    %>
	    	<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" /> 
	    <%
	    }
	    %>