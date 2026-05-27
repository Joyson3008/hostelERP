<%-- 
    Document   : favorites_menu
    Created on : Oct 14, 2025, 4:29:15 PM
    Author     : JR Martin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.json.simple.*" %>
<jsp:useBean id="uservalidation" class="user.varification.uservalidation" scope="page"/>
<jsp:useBean id="officedao" class="erp.generalmaster.Office" scope="page"/>
<%
    // *************** Authentication Block ***************
    String per = "A";
    String mName = "ERP_USER_FATMENU";
%>

<%
    String login = (String) session.getAttribute("login");

    if (login != null) {
        //out.println(uid);
%>
    <%
        String officeUidStr = (String) session.getAttribute("officeuid");
        String currofficeid = (String) session.getAttribute("currentOfficeUid");
        String modu = (String) session.getAttribute("username");
        
        JSONArray ary = uservalidation.getmenulist(modu);
//out.println(officeUidStr);

        List<String> officeNames = new ArrayList<>();
        if (officeUidStr != null && !officeUidStr.isEmpty()) {
            String[] officeUids = officeUidStr.split("\\,");

// Call DAO method to get office names
            officeNames = officedao.getOfficeNamesByIds(officeUids);
//out.println(officeUids[0]);

        }
    %>
<jsp:include page="../../lccerpheader.jsp"/>

<div class="pcoded-content">
    <div class="pcoded-inner-content">
        <div class="main-body">
            <div class="page-wrapper">
                <div class="page-body">
                    <div class="row">
                        <div class="col-sm-12">
                            <!-- Bootstrap tab card start -->
                            <div class="card">
                                <div class="card-block">
                                    <!-- Row start -->
                                    <div class="row">
                                        <div class="col-lg-12 col-xl-12">
                                            
                                             <ul class="pcoded-item pcoded-left-item" >
                     



                                    <%

                                        String[] iconNames = {
                                            "ti-layout-grid2-alt", "ti-direction-alt", "ti-settings", "ti-user",
                                            "ti-bar-chart", "ti-wallet", "ti-book", "ti-timer", "ti-write", "ti-layers","ti-bar-chart", "ti-wallet", "ti-book", "ti-timer", "ti-write", "ti-layers","ti-bar-chart", "ti-wallet", "ti-book", "ti-timer", "ti-write", "ti-layers"
                                        };

                                        int m = 0, t = 0, r = 0;

                                      //  out.println("------------------"+(String)session.getAttribute("activeMenu")+"---------------"+(String)session.getAttribute("activemenuname"));
                                        String activemenu = "";//(String)session.getAttribute("activeMenu");
                                        if ((String) session.getAttribute("activeMenu") != null) {
                                            activemenu = (String) session.getAttribute("activeMenu");
                                        }
                                        String activemenuname = "";//(String)session.getAttribute("activemenuname");
                                        if ((String) session.getAttribute("activemenuname") != null) {
                                            activemenuname = (String) session.getAttribute("activemenuname");
                                        }

                                        for (int j = 0; j < ary.size(); j++) {
                                            JSONObject obj = (JSONObject) ary.get(j);
                                            //out.println(obj);
                                    %>
                                    <li class="pcoded-hasmenu <%=activemenuname.equals(obj.get("menuname")) ? "active pcoded-trigger" : ""%>" >
                                        <a href="javascript:void(0)" class="waves-effect waves-dark"  style="font-size: 0.9em">
                                            <span class="pcoded-micon"><i class="<%=iconNames[j]%>"></i><b>M</b></span>
                                            <span class="pcoded-mtext" data-i18n="nav.basic-components.main">
                                                <%= obj.get("menuname")%>
                                            </span>
                                            <span class="pcoded-mcaret"></span>
                                        </a>

                                        <ul class="pcoded-submenu">
                                            <%
                                                JSONObject submenus = (JSONObject) obj.get("submenus");

                                                // MASTER
                                                JSONArray master = (JSONArray) submenus.get("MASTER");
                                                if (master != null && master.size() > 0) {
                                            %>

                                            <li class="pcoded-navigation-label" style="color:#0c8940;font-weight: bold">Master</li>
                                                <%
                                                    for (int k = 0; k < master.size(); k++) {
                                                        JSONObject obj1 = (JSONObject) master.get(k);
                                                        m++;
                                                %>
                                            <li class="<%=activemenu.equals("m" + String.valueOf(m)) ? "active" : ""%>">
                                                <input type="checkbox" class="form-check-input me-2" onchange="updateMenuPermission('<%= obj1.get("submenuurlid")%>', this.checked)" <%=obj1.get("submenufat").toString().equals("Y")?"checked":""%> >
                                                

                                                    <span class="pcoded-mtext"><%= obj1.get("submenu")%></span>
                                            </li>
                                            <% }

                                                } %>

                                            <%
                                                // TRANSACTION
                                                JSONArray txn = (JSONArray) submenus.get("TRANSACTION");
                                                if (txn != null && txn.size() > 0) {
                                            %>
                                            <li class="pcoded-navigation-label" style="color:#fa2c2c;font-weight: bold">Transaction</li>
                                                <%
                                                    for (int k = 0; k < txn.size(); k++) {
                                                        JSONObject obj1 = (JSONObject) txn.get(k);
                                                        t++;
                                                %>
                                            <li class=" ">
                                                <input type="checkbox" class="form-check-input me-2" onchange="updateMenuPermission('<%= obj1.get("submenuurlid")%>', this.checked)" <%=obj1.get("submenufat").toString().equals("Y")?"checked":""%> >
                 

                                                    <span class="pcoded-mtext"><%= obj1.get("submenu")%></span>
                                            </li>
                                            <% }

                                                } %>

                                            <%
                                                // REPORT
                                                JSONArray report = (JSONArray) submenus.get("REPORT");
                                                if (report != null && report.size() > 0) {
                                            %>
                                            <li class="pcoded-navigation-label" style="color:#9850fb;font-weight: bold">Report</li>
                                                <%
                                                    for (int k = 0; k < report.size(); k++) {
                                                        JSONObject obj1 = (JSONObject) report.get(k);
                                                        r++;
                                                %>
                                            <li class=" ">
                                                <input type="checkbox" class="form-check-input me-2" onchange="updateMenuPermission('<%= obj1.get("submenuurlid")%>', this.checked)" <%=obj1.get("submenufat").toString().equals("Y")?"checked":""%> >

                                                    <span class="pcoded-mtext"><%= obj1.get("submenu")%></span>
                                            </li>
                                            <% }

                                                } %>

                                        </ul>
                                    </li>
                                    <% }%>


                                </ul>


                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function updateMenuPermission(menuCode, isChecked) {
    let status = isChecked ? 'Y' : 'N';
    $.ajax({
        url: "userrights/updateMenuPermission.jsp",
        type: "POST",
        data: { mcode: menuCode, status: status },
        success: function(res) {
            console.log("Menu update:", res);
        },
        error: function(err) {
            console.error("Error updating menu:", err);
        }
    });
}
</script>

<jsp:include page="../../lccerpfooter.jsp"/>
<% } else {
// out.println(uid);
    out.println("session Time out");
%>
<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" />
<%
    }
%>
