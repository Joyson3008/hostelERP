<%-- 
    Document   : studentDashboard
    Created on : Nov 3, 2025, 3:55:57 PM
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
    String mName = "ERP_STUD_DASHBOARD";
%>
<%@ include file="/usermanager/permission.jsp" %>
<jsp:useBean id="modu" class="erp.module.ModuleMaster" scope="request"/>

<%@ page import="org.json.simple.*" %>
<%    String login = (String) session.getAttribute("login");

    if (login != null) {
        //out.println(uid);
%>
<div class="pcoded-inner-content">
    <!-- Main-body start -->
    <div class="main-body">
        <div class="page-wrapper">
            <!-- Page-body start -->
            <div class="page-body">
                <div class="row">
                    <div class="col-xl-3 col-md-6">
                        <div class="card">
                            <div class="card-block">
                                <div class="row align-items-center">                                                           

                                    <jsp:include page="../maindashboard/dashboard/studentCountDashS1.jsp"/>
                                </div>
                            </div>
                            <div class="card-footer bg-c-blue">
                                <div class="row align-items-center">
                                    <div class="col-9">

                                        <p class="text-white m-b-0">Student's Strength : <%=(String) session.getAttribute("currentOfficeUidname")%> </p>
                                    </div>
                                    <div class="col-3 text-right">
                                        <i class="fa fa-line-chart text-white f-16"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>




                </div>
                <div class="row">

                    <div class="col-xl-3 col-md-6">
                        <div class="card">
                            <div class="card-block">
                                <div class="row align-items-center">
                                    <jsp:include page="../maindashboard/dashboard/studentCountGenderDash.jsp"/>


                                    <!--                                                            <div class="col-4 text-right">
                                                                                                    <i class="fa fa-calendar-check-o f-28"></i>
                                                                                                </div>-->
                                </div>
                            </div>
                            <div class="card-footer bg-c-red">
                                <div class="row align-items-center">
                                    <div class="col-9">
                                        <p class="text-white m-b-0">Male Students  : <%=(String) session.getAttribute("currentOfficeUidname")%></p>
                                    </div>
                                    <div class="col-3 text-right">
                                        <!--                                                                <i class="fa fa-line-chart text-white f-16"></i>-->
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xl-3 col-md-6">
                        <div class="card">
                            <div class="card-block">
                                <div class="row align-items-center">
                                    <jsp:include page="../maindashboard/dashboard/studentCountGenderDashFemale.jsp"/>
                                    <!--                                                            <div class="col-4 text-right">
                                                                                                    <i class="fa fa-hand-o-down f-28"></i>
                                                                                                </div>-->
                                </div>
                            </div>
                            <div class="card-footer bg-c-blue">
                                <div class="row align-items-center">
                                    <div class="col-9">
                                        <p class="text-white m-b-0">Female Students : <%=(String) session.getAttribute("currentOfficeUidname")%></p>
                                    </div>
                                    <div class="col-3 text-right">
                                        <!--                                                                <i class="fa fa-line-chart text-white f-16"></i>-->
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div> 

                    <div class="col-xl-3 col-md-6">
                        <div class="card">
                            <div class="card-block">
                                <div class="row align-items-center">
                                    <jsp:include page="../maindashboard/dashboard/studentCountPhysicalCha.jsp"/>
                                    <!--                                                            <div class="col-4 text-right">
                                                                                                    <i class="fa fa-hand-o-down f-28"></i>
                                                                                                </div>-->
                                </div>
                            </div>
                            <div class="card-footer bg-c-green">
                                <div class="row align-items-center">
                                    <div class="col-9">
                                        <p class="text-white m-b-0">PwD : <%=(String) session.getAttribute("currentOfficeUidname")%></p>
                                    </div>
                                    <div class="col-3 text-right">
                                        <!--                                                                <i class="fa fa-line-chart text-white f-16"></i>-->
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div> 

                    <div class="col-xl-3 col-md-6">
                        <div class="card">
                            <div class="card-block">
                                <div class="row align-items-center">
                                    <jsp:include page="../maindashboard/dashboard/studentCountGenderDashFemale.jsp"/>
                                    <!--                                                            <div class="col-4 text-right">
                                                                                                    <i class="fa fa-hand-o-down f-28"></i>
                                                                                                </div>-->
                                </div>
                            </div>
                            <div class="card-footer bg-c-blue">
                                <div class="row align-items-center">
                                    <div class="col-9">
                                        <p class="text-white m-b-0">Sports Students : <%=(String) session.getAttribute("currentOfficeUidname")%></p>
                                    </div>
                                    <div class="col-3 text-right">
                                        <!--                                                                <i class="fa fa-line-chart text-white f-16"></i>-->
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div> 
                </div>
            </div>
        </div>
    </div></div>

<% } else {
// out.println(uid);
    out.println("session Time out");
%>
<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" /> 
<%
    }
%>
