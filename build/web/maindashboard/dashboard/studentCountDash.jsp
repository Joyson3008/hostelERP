<%-- 
    Document   : studentCountDash
    Created on : Sep 3, 2025, 12:34:59?PM
    Author     : rm
--%>

<%@ page import="erp.dashboard.StudentCountDAO" %>

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
<%@ page import="java.util.*" %> 
<%     
    session.setAttribute("login","true");

    String login = (String) session.getAttribute("login");

    if (login != null) {
        //out.println(uid);
        String officeid = (String) session.getAttribute("currentOfficeUid");
%>

<div class="col-xl-6 col-md-12">
    <div class="card table-card">
        <div class="card-header">
            <h5>Male Students</h5>
            <div class="card-header-right">
                <ul class="list-unstyled card-option">
                    <li><i class="fa fa fa-wrench open-card-option"></i></li>
                    <li><i class="fa fa-window-maximize full-card"></i></li>
                    <li><i class="fa fa-minus minimize-card"></i></li>
                    <li><i class="fa fa-refresh reload-card"></i></li>
                    <li><i class="fa fa-trash close-card"></i></li>
                </ul>
            </div>
        </div>
        <div class="card-block">
            <div class="table-responsive">
                <table class="table table-hover m-b-0 without-header">
                    <tbody>
                        <tr>
                            <td>
                                <div class="d-inline-block align-middle">
<!--                                    <img src="assets/images/avatar-4.jpg" alt="user image" class="img-radius img-40 align-top m-r-15">-->
                                    <div class="d-inline-block">
                                        <h6>2025</h6>
                                        <p class="text-muted m-b-0"></p>
                                    </div>
                                </div>
                            </td>
                            <td class="text-right">
                                <h6 class="f-w-700"><%= StudentCountDAO.getCount("ug_2025_student",officeid) %><i class="fas fa-level-down-alt text-c-red m-l-10"></i></h6>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="d-inline-block align-middle">
<!--                                    <img src="assets/images/avatar-2.jpg" alt="user image" class="img-radius img-40 align-top m-r-15">-->
                                    <div class="d-inline-block">
                                        <h6>2024</h6>
                                        <p class="text-muted m-b-0"></p>
                                    </div>
                                </div>
                            </td>
                            <td class="text-right">
                                <h6 class="f-w-700"><%= StudentCountDAO.getCount("ug_2024_student",officeid) %><i class="fas fa-level-up-alt text-c-green m-l-10"></i></h6>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class="d-inline-block align-middle">
<!--                                    <img src="assets/images/avatar-4.jpg" alt="user image" class="img-radius img-40 align-top m-r-15">-->
                                    <div class="d-inline-block">
                                        <h6>2023</h6>
                                        <p class="text-muted m-b-0"></p>
                                    </div>
                                </div>
                            </td>
                            <td class="text-right">
                                <h6 class="f-w-700"><%= StudentCountDAO.getCount("ug_2023_student",officeid) %><i class="fas fa-level-up-alt text-c-green m-l-10"></i></h6>
                            </td>
                        </tr>
                        
                    </tbody>
                </table>

            </div>
        </div>
    </div>
</div>


<% } else {
    // out.println(uid);
    out.println("session Time out");
%>
<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" /> 
<%
    }
%>