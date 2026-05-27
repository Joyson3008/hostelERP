<head>

    <META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">
    <META HTTP-EQUIV="PRAGMA" CONTENT="NO-CACHE">
    <META HTTP-EQUIV="EXPIRES" CONTENT="0">
</head>
<%
    response.setDateHeader("Expires", 0);
    response.addHeader("Cache-Control", "no-cache, no-store, must-revlidate");
    response.addHeader("Cache-Control", "post-check=0, pre-check=0");
    response.setHeader("Pragma", "no-cache");
%>
<jsp:useBean id="modu" class="erp.module.ModuleMaster" scope="request"/>

<%@ page import="org.json.simple.*" %>
<h2>Existing Permissions</h2>
<table class="table table-striped">
    <%
        String login = (String) session.getAttribute("login");

        if (login != null) {

            try {
                String mcode = request.getParameter("empname");

                JSONObject obj = modu.modulepermissionlist(mcode);
                //out.println(obj);
                JSONArray ary = (JSONArray) obj.get("data");

                for (int h = 0; h < ary.size(); h++) {
                    JSONObject obj1 = (JSONObject) ary.get(h);
    %>
    <tr><td>

            <form name="" method="post" action="">
                <input type="hidden" name="mcode" id="mcode" value="<%=obj1.get("mcode")%>">
                <input type="hidden" name="userid" id="userid" value="<%=mcode%>">
                </td>

                <td><%=obj1.get("desc")%></td>
                <td><%=obj1.get("mtype")%></td>
                <td><input type="button" name="submit" value="Remove" onclick="call_moduleremove()" class="btn btn-danger"></td>
    </tr>
    <%

            }

            //out.println(status);
        } catch (Exception e) {
            out.println(e);
        }
    %>
</table>


<% } else {
    // out.println(uid);
    out.println("session Time out");
%>
<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" /> 
<%
    }
%>