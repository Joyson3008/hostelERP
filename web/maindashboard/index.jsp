<%@ page import="org.json.simple.*" %>
<%@ page import="erp.auth.SessionTracker" %>
<%@ page import="java.util.*" %>
<%@ page import="staffprofile.dashboardCount" %>
<%
    String login = (String) session.getAttribute("login");

    if (login != null) {
        //out.println(uid);
        session.setAttribute("activeMenu", "mq");
        session.setAttribute("activeMenuname", "Dashboard");
%>

<jsp:include page=".././lccerpheader.jsp"/>

<%
    String role = (String) session.getAttribute("userrole");
%>

<div class="pcoded-content">
    <!-- Page-header start -->

    <!--    <div class="page-header">
            <div class="page-block">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <div class="page-header-title">
                            <h5 class="m-b-10">Dashboard</h5>
                            <p class="m-b-0">Welcome to Mega Able</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <ul class="breadcrumb-title">
                            <li class="breadcrumb-item">
                                <a href="index.html"> <i class="fa fa-home"></i> </a>
                            </li>
                            <li class="breadcrumb-item"><a href="#!">Dashboard</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>-->
    <!-- Page-header end -->
    <div class="pcoded-inner-content">
        <!-- Main-body start -->
        <div class="main-body">
            <div class="page-wrapper">
                <!-- Page-body start -->
                <div class="page-body">

                    <%
                        if (role.contains("6")) {
                    %>
                    <div class="row">
                        <div class="col-xl-9" style="border:0px solid #000">
                            
                            <div class="row"  style="border:0px solid #000">
                                <!-- task, page, download counter  start -->
                                <div class="col-xl-6">
                                    <div class="card bg-c-lite-blue">
                                        <div class="card-header">
                                            <h5>User Details</h5>
                                        </div>
                                        <table class="table table-xs">

                                            <tbody>
                                                <tr>
                                                    <td>Name</td>
                                                    <td><%=session.getAttribute("uname")%></td>
                                                </tr>
                                                <tr>
                                                    <td>ID</td>
                                                    <td><%=session.getAttribute("username")%></td>
                                                </tr>

                                                <tr>
                                                    <td>Designation</td>
                                                    <td><%=session.getAttribute("userdesig")%></td>
                                                </tr>
                                                <tr>
                                                    <td>Division</td>
                                                    <td><%=session.getAttribute("userdivision")%></td>
                                                </tr>
                                                <tr>
                                                    <td>IP Address</td>
                                                    <td><%=session.getAttribute("loginipaddress")%></td>
                                                </tr>
                                                <tr>
                                                    <td>Login Date & Time</td>
                                                    <td><%=session.getAttribute("logintime")%></td>
                                                </tr>
                                                <tr>
                                                    <td>Role</td>
                                                    <td><%=session.getAttribute("userrole")%></td>
                                                </tr>
                                                <!-- <tr>
                                                    <td>Designation</td>
                                                    <td><%=session.getAttribute("designationid")%></td>
                                                </tr>
                                                <tr>
                                                    <td>Devision</td>
                                                    <td><%=session.getAttribute("divisionid")%></td>
                                                </tr>
                                                -->
                                            </tbody>
                                        </table>

                                    </div></div>

                                <div class="col-xl-6 col-md-12">
                                    <div class="card mat-stat-card bg-c-orenge">
                                        <div class="card-block">
                                            <div class="row align-items-center b-b-default">
                                                <div class="col-sm-6 b-r-default p-b-20 p-t-20" style="background-color: #b524ff">
                                                    <div class="row align-items-center text-center">
                                                        <div class="col-4 p-r-0">
                                                            <i class="fas fa-share-alt text-c-purple f-24"></i>
                                                        </div>
                                                        <div class="col-8 p-l-0">
                                                            <h5>1000</h5>
                                                            <p class="text-muted m-b-0">Share</p>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-sm-6 p-b-20 p-t-20"  style="background-color: #19f9da">
                                                    <div class="row align-items-center text-center">
                                                        <div class="col-4 p-r-0">
                                                            <i class="fas fa-sitemap text-c-green f-24"></i>
                                                        </div>
                                                        <div class="col-8 p-l-0">
                                                            <h5>600</h5>
                                                            <p class="text-muted m-b-0">Network</p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row align-items-center"  style="background-color: #19f9da">
                                                <div class="col-sm-6 p-b-20 p-t-20 b-r-default">
                                                    <div class="row align-items-center text-center">
                                                        <div class="col-4 p-r-0">
                                                            <i class="fas fa-signal text-c-red f-24"></i>
                                                        </div>
                                                        <div class="col-8 p-l-0">
                                                            <h5>350</h5>
                                                            <p class="text-muted m-b-0">Returns</p>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-sm-6 p-b-20 p-t-20"  style="background-color: #ffce6b">
                                                    <div class="row align-items-center text-center">
                                                        <div class="col-4 p-r-0">
                                                            <i class="fas fa-wifi text-c-blue f-24"></i>
                                                        </div>
                                                        <div class="col-8 p-l-0">
                                                            <h5>100%</h5>
                                                            <p class="text-muted m-b-0">Connections</p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                                                
                            <div class="row">
                                <div class="col-xl-6 col-md-6">
                                    <div class="card  bc-c-lite-orenge">    
                                        <div class="card-header">
                                            <%
                                                Set<String> loggedInUsers = SessionTracker.getActiveUsers();
                                            %>

                                            <h5>Currently Logged-in Users</h5>
                                        </div>

                                        <% if (loggedInUsers.isEmpty()) { %>
                                        <p>No users currently logged in.</p>
                                        <% } else { %>
                                        <ul>
                                            <% for (String user : loggedInUsers) {%>
                                            <li><%= user%></li>
                                                <% } %>
                                        </ul>
                                        <% }%>
                                    </div>

                                </div>

                                <jsp:include page="../maindashboard/dashboard/studentCountDash.jsp"/>

                            </div>
                        </div>
                        <div class="col-xl-3">
                                <div class="card bg-c-lite-yellow">    
                                    <jsp:include page="../maindashboard/dashboard/favoritesmenuload.jsp"/>
                                </div>
                            </div>
                    </div>


                    <%
                        }
                        if (role.contains("1")) {
                    %>

                    <div class="row">
                        <!-- task, page, download counter  start -->
                        <div class="col-xl-4 col-md-6">
                            <div class="card bc-c-lite-info">
                                <div class="card-header">
                                    <h5>User Details</h5>
                                </div>
                                    <table class="table table-xs">

                                        <tbody>
                                            <tr>
                                                <td>Name</td>
                                                <td><%=session.getAttribute("uname")%></td>
                                            </tr>
                                            <tr>
                                                <td>ID</td>
                                                <td><%=session.getAttribute("username")%></td>
                                            </tr>

                                            <tr>
                                                <td>Designation</td>
                                                <td><%=session.getAttribute("designationid")%></td>
                                            </tr>
                                            <tr>
                                                <td>Devision</td>
                                                <td><%=session.getAttribute("divisionid")%></td>
                                            </tr>
                                            <tr>
                                                <td>IP Address</td>
                                                <td><%=session.getAttribute("loginipaddress")%></td>
                                            </tr>
                                            <tr>
                                                <td>Login Date & Time</td>
                                                <td><%=session.getAttribute("logintime")%></td>
                                            </tr>
                                            <tr>
                                                <td>Role</td>
                                                <td><%=session.getAttribute("userrole")%></td>
                                            </tr>
                                            <!-- <tr>
                                                <td>Designation</td>
                                                <td><%=session.getAttribute("designationid")%></td>
                                            </tr>
                                            <tr>
                                                <td>Devision</td>
                                                <td><%=session.getAttribute("divisionid")%></td>
                                            </tr>
                                            -->
                                        </tbody>
                                    </table>
                                
                            </div></div>
                                            
                        <div class="col-xl-4 col-md-6">
                            <div class="card bc-c-lite-pink">    
                                <div class="card-header">
                                    <h5>Academic Summary</h5>
                                </div>
                                <table class="table table-xs">

                                        <tbody>
                                            <tr>
                                                <td>Program Participated</td>
                                                <td><%=dashboardCount.countme("employee_econtent",(String)session.getAttribute("username"))%></td>
                                            </tr>
                                            <tr>
                                                <td>Awards / Fellowships / Recognition</td>
                                                <td><%=dashboardCount.countme("employee_awards",(String)session.getAttribute("username"))%></td>
                                            </tr>
                                            <tr>
                                                <td>E-Content Prepared</td>
                                                <td><%=dashboardCount.countme("employee_econtent",(String)session.getAttribute("username"))%></td>
                                            </tr>
                                            <tr>
                                                <td>Patents Received</td>
                                                <td><%=dashboardCount.countme("employee_patents_received",(String)session.getAttribute("username"))%></td>
                                            </tr>
                                            <tr>
                                                <td>Publications (Books / Manuals)</td>
                                                <td><%=dashboardCount.countme("employee_books_manuals",(String)session.getAttribute("username"))%></td>
                                            </tr>
                                            <tr>
                                                <td>Research Consultancy</td>
                                                <td><%=dashboardCount.countme("employee_research_consultancy",(String)session.getAttribute("username"))%></td>
                                            </tr>
                                            <tr>
                                                <td>Research Projects</td>
                                                <td><%=dashboardCount.countme("employee_research_projects",(String)session.getAttribute("username"))%></td>
                                            </tr>
                                            <tr>
                                                <td>Research Publications</td>
                                                <td><%=dashboardCount.countme("employee_research_publications",(String)session.getAttribute("username"))%></td>
                                            </tr>
                                            <tr>
                                                <td>Research Scholars</td>
                                                <td><%=dashboardCount.countme("employee_research_scholars",(String)session.getAttribute("username"))%></td>
                                            </tr>
                                        </tbody>
                                </table>
                                
                            </div>
                        </div>

                        <div class="col-xl-4 col-md-6">
                            <div class="card bc-c-lite-lime">    
                                <jsp:include page="../maindashboard/dashboard/favoritesmenuload.jsp"/>
                            </div>
                        </div>

                    </div>


                    <%
                        }
                    %>

                    <!-- task, page, download counter  end -->

                    <!--  sale analytics start -->

                </div>
            </div>
        </div>
    </div>
</div>
</div>
</div>

<div id="contentArea">
    <!-- Loaded page content will be injected here -->
</div>



<jsp:include page=".././lccerpfooter.jsp"/>
<% } else {
    // out.println(uid);
    out.println("session Time out");
%>
<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" /> 
<%
    }
%>

