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
String mName = "ERP_USER_VALID";
%>
<%@ include file="/usermanager/permission.jsp" %>
<% // *************** Authentication Block *************** 
%>
