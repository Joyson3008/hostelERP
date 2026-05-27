
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
<%
   // *************** Authentication Block ***************
String per = "A";
String mName = "ERP_USER_PER";
%>
<%@ include file="/usermanager/permission.jsp" %>
 <%@ page import="org.json.simple.*" %>
 <%
 	String login = (String)session.getAttribute("login");

 if(login!=null){
	 //out.println(uid);
	 %>
 
<jsp:include page="../../lccerpheader.jsp"/>



        <jsp:include page="../../lccerpfooter.jsp"/>
    <% }
    else{
    // out.println(uid);
    out.println("session Time out");
    %>
    	<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" /> 
    <%
    }
    %>
		
