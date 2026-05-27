<%-- 
    Document   : reloadMenu
    Created on : Oct 28, 2025, 10:27:31 AM
    Author     : martin
--%>


<%
    response.setDateHeader("Expires", 0);
    response.addHeader("Cache-Control", "no-cache, no-store, must-revlidate");
    response.addHeader("Cache-Control", "post-check=0, pre-check=0");
    response.setHeader("Pragma", "no-cache");
%>
<%
    // *************** Authentication Block ***************
    String per = "A";
    String mName = "ERP_MODU_RELOAD";
%>
<%@ include file="/usermanager/permission.jsp" %>
<jsp:useBean id="modu" class="erp.module.ModuleMaster" scope="request"/>
<jsp:useBean id="uservalidation" class="user.varification.uservalidation" scope="page"/>

<%@ page import="org.json.simple.*" %>
<%    String login = (String) session.getAttribute("login");

    if (login != null) {
        //out.println(uid);
%>


<jsp:include page="../../lccerpheader.jsp"/>

<%
    String userId = (String) session.getAttribute("username");
    JSONArray ary = uservalidation.getmenulist(userId);
    session.setAttribute("menuAry", ary);
    System.out.println("? Menu reloaded in session for user: " + userId);    
%>
<meta http-equiv="refresh" content="1;URL='<%=request.getContextPath()%>/maindashboard'" /> 

<jsp:include page="../../lccerpfooter.jsp"/>
<% } else {
// out.println(uid);
    out.println("session Time out");
%>
<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" /> 
<%
    }
%>
