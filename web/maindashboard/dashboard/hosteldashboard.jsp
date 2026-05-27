<%-- 
    Document   : hosteldashboard
    Created on : Apr 28, 2026, 9:46:42?AM
    Author     : lccerp26
--%>
<%-- 

<%
    String per = "A";
    String mName = "HOSTEL_DASHBOARD";
%>
<%@ include file="/usermanager/permission.jsp" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    response.setDateHeader("Expires", 0);
    response.addHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
session.setAttribute("login","true");
    String login = (String) session.getAttribute("login");

    if (login != null) {
%>

--%>

<%--<jsp:include page="../../lccerpheader.jsp"/>--%>

<div class="pcoded-content">
    <div class="pcoded-inner-content">
        <div class="main-body">
            <div class="page-wrapper">
                <div class="page-body">

                    <!-- Dashboard Cards -->
                    <div class="row g-3">

                        <!-- Total Students -->
                        <div class="col-md-3">
                            <div class="card text-white bg-primary">
                                <div class="card-header">Total Students</div>
                                <div class="card-body text-center">
                                    <a href="hosteldashboard/dashregisteredStudents.jsp"
                                       style="color:white; text-decoration:none;">
                                        <h2 id="total">0</h2>
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Veg -->
                        <div class="col-md-3">
                            <div class="card text-white bg-success">
                                <div class="card-header">Veg Students</div>
                                <div class="card-body text-center">
                                    <a href="hosteldashboard/dashvegStudents.jsp"
                                       style="color:white; text-decoration:none;">
                                        <h2 id="veg">0</h2>
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Non Veg -->
                        <div class="col-md-3">
                            <div class="card text-white bg-danger">
                                <div class="card-header">Non-Veg Students</div>
                                <div class="card-body text-center">
                                    <a href="hosteldashboard/dashnonVegStudents.jsp"
                                       style="color:white; text-decoration:none;">
                                        <h2 id="nonveg">0</h2>
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- Metro -->
                        <div class="col-md-3">
                            <div class="card text-white bg-warning">
                                <div class="card-header">Metro Students</div>
                                <div class="card-body text-center">
                                    <a href="hosteldashboard/dashmetroStudents.jsp"
                                       style="color:white; text-decoration:none;">
                                        <h2 id="metro">0</h2>
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- RC -->
                        <div class="col-md-3">
                            <div class="card text-white" style="background-color:#fd7e14;">
                                <div class="card-header">Catholic (RC) Students</div>
                                <div class="card-body text-center">
                                    <a href="hosteldashboard/dashrcStudents.jsp"
                                       style="color:white; text-decoration:none;">
                                        <h2 id="rc">0</h2>
                                    </a>
                                </div>
                            </div>
                        </div>

                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
    $(document).ready(function () {
        loadDashboard();
    });

    function loadDashboard() {
        $.ajax({
            url: "ajax/getDashboardCounts.jsp",
            type: "GET",
            dataType: "json",
            success: function (res) {

                $("#total").text(res.total || 0);
                $("#veg").text(res.veg || 0);
                $("#nonveg").text(res.nonveg || 0);
                $("#metro").text(res.metro || 0);
                $("#rc").text(res.rc || 0);

            },
            error: function () {
                alert("Failed to load dashboard");
            }
        });
    }
</script>

<jsp:include page="../../lccerpfooter.jsp"/>

<%-- 

<% } else { %>

Session Time Out  
<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" />

<% } %>

--%>