<%-- 
    Document   : favoritesmenuload
    Created on : Oct 14, 2025, 5:06:28 PM
    Author     : JR Martin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.json.simple.*" %>
<jsp:useBean id="uservalidation" class="user.varification.uservalidation" scope="page"/>
<jsp:useBean id="officedao" class="erp.generalmaster.Office" scope="page"/>

<%
    String login = (String) session.getAttribute("login");

    if (login != null) {
        //out.println(uid);
%>
<%
    String officeUidStr = (String) session.getAttribute("officeuid");
    String currofficeid = (String) session.getAttribute("currentOfficeUid");
    String modu = (String) session.getAttribute("username");

    JSONArray ary = uservalidation.getmenulistfat(modu);
//out.println(officeUidStr);

    List<String> officeNames = new ArrayList<>();
    if (officeUidStr != null && !officeUidStr.isEmpty()) {
        String[] officeUids = officeUidStr.split("\\,");

// Call DAO method to get office names
        officeNames = officedao.getOfficeNamesByIds(officeUids);
//out.println(officeUids[0]);

    }
%>

<%
    int m = 0, t = 0, r = 0;


%>
<div class="card-header">
    <h5>Favorites Menu</h5>
</div>
<table class="table table-xs">

    <tbody>

        <%                                           for (int j = 0; j < ary.size(); j++) {
                JSONObject obj = (JSONObject) ary.get(j);
                //out.println(obj);
        %>
        <tr><td>
                <a href="#"  onclick="loadPage('m<%=m%>', '<%= obj.get("menuUrl")%>', '<%= obj.get("menuName")%>')"  style="color:#800; font-size: 0.8em">
                    <span class="pcoded-mtext"><%= obj.get("menuName")%></span>
                </a>
            </td></tr>

        <% }%>


    </tbody></table>

<% } else {
// out.println(uid);
    out.println("session Time out");
%>
<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" />
<%
    }
%>
