<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.json.simple.*" %>
<%@page import="org.json.simple.*" %>

<jsp:useBean id="uservalidation" class="user.varification.uservalidation" scope="page"/>
<jsp:useBean id="officedao" class="erp.generalmaster.Office" scope="page"/>
<jsp:useBean id="currdayorder" class="erp.attendance.DatewiseDayOrder" scope="page"/>

<%
    String modu = (String) session.getAttribute("username");
    JSONArray ary = (JSONArray) session.getAttribute("menuAry");
    //out.println(ary);
%>

<!DOCTYPE html>
<html lang="en">

    <head>
        <title><%= application.getInitParameter("pageTitle")%></title>
        <!-- HTML5 Shim and Respond.js IE10 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 10]>
          <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
          <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
          <![endif]-->
        <!-- Meta -->
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimal-ui">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />

        <link rel="icon" href="<%=request.getContextPath()%>/maindashboard/assets/images/favicon.ico" type="image/x-icon">
        <!-- Google font-->
        <link href="https://fonts.googleapis.com/css?family=Roboto:400,500" rel="stylesheet">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Ubuntu:wght@400;700&display=swap" rel="stylesheet">
        <!-- waves.css -->
        <link rel="stylesheet" href="<%=request.getContextPath()%>/maindashboard/assets/pages/waves/css/waves.min.css" type="text/css" media="all">
        <!-- Required Fremwork -->
        <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/maindashboard/assets/css/bootstrap/css/bootstrap.min.css">
        <!-- waves.css -->
        <link rel="stylesheet" href="<%=request.getContextPath()%>/maindashboard/assets/pages/waves/css/waves.min.css" type="text/css" media="all">
        <!-- themify icon -->
        <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/maindashboard/assets/icon/themify-icons/themify-icons.css">
        <!-- Font Awesome -->
        <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/maindashboard/assets/icon/font-awesome/css/font-awesome.min.css">
        <!-- scrollbar.css -->
        <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/maindashboard/assets/css/jquery.mCustomScrollbar.css">

        <!-- Style.css -->
        <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/maindashboard/assets/css/style.css">
        <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/maindashboard/assets/css/custom.css">
        <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/maindashboard/assets/css/timetable.css">

        <!-- DataTables CSS -->

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <!-- ? Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        
<!--bootstrap icon-->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">


<style>
    /* applicantApproval.jsp page styles */
.page-card {
    /*background: #e6f1ff;*/
    background: #fff;
    padding: 15px;
    border-radius: 6px;
}

.summary-box {
    background:#fff;
    padding:8px 12px;
    border-radius:5px;
    margin-bottom:8px;
    border:1px solid #d0d0d0;
    font-size:14px;
}
    .approved-row {
        background-color: #c7f5c4 !important; 
    }
    
    .cancelled-row {
    background-color: #ffcccc !important; 
    font-weight: bold;
}

</style>


        <style>
            /* Tab nav base style */
            .nav-tabs .nav-link {
                color: #555;
                background-color: #f8f9fa;
                border: 1px solid #dee2e6;
                border-bottom: none;
                margin-right: 2px;
            }

            /* Active tab */
            .nav-tabs .nav-link.active {
                color: #fff;
                background-color: #007bff; /* Bootstrap primary */
                border-color: #007bff #007bff #fff;
            }

            /* Hover effect */
            .nav-tabs .nav-link:hover {
                background-color: #e2e6ea;
                color: #000;
            }

            /* Tab content border */
            .tab-content {
                border: 1px solid #dee2e6;
                border-top: none;
                padding: 15px;
                background-color: #fff;
            }

            .role-checkbox {
                width: 18px !important;
                height: 18px !important;
                margin-right: 8px;
                accent-color: #007bff; /* For visible blue tick */
            }

        </style>

        <style>
            .ui-autocomplete {
                max-height: 200px;        /* Set the height you want */
                width:200px;      /* Add vertical scroll */
                overflow-x: hidden;       /* Hide horizontal scroll */
                background-color: #e6f7ff; /* Optional: background color */
                border: 1px solid #0d6efd; /* Optional: Bootstrap primary color */
                z-index: 1000;            /* Ensure dropdown is above other elements */
            }
            .dropdown-menu label {
                cursor: pointer;
            }
        </style>
        
        

<style>
    
    /* applicaitonPermission.jsp (ALLO STYLES IN THE HEADER) */
    /* Reduce table padding & font size */
    #verifyModal table td, 
    #verifyModal table th {
        padding:6px !important;
        font-size:13px;
    }

    /* Scroll body, not entire modal */
    #verifyModal .modal-body {
        max-height: 70vh;
        overflow-y: auto;
        padding: 15px;
    }

    /* Title Bar Styling */
    .verify-header-title {
        background:#004aad;
        color:white;
        font-weight:bold;
        font-size:18px;
        padding:10px;
        text-align:center;
        border-radius:4px;
    }
    
    #viewerToolbar {
    position: sticky;
    top: 0;
    background: #fff;
    padding-bottom: 6px;
    z-index: 999;
    border-bottom: 1px solid #ccc;
}

#viewerContainer {
    height: calc(100vh - 160px); /* Adjust based on modal size */
    overflow: auto;
    text-align: center;
    display: flex;
    justify-content: center;
    align-items: center;
}

#viewerContainer #docViewer {
    transition: transform 0.2s ease;
    cursor: grab;
}

#viewerContainer #docViewer:active {
    cursor: grabbing;
}

</style>


<style>
/* Make modal rectangular */
#verifyModal .modal-dialog {
    max-width: 95%;
}

#verifyModal .modal-body {
    padding: 0 !important;
}

/* Horizontal split */
.verify-container {
    display: flex;
    height: 80vh;
    overflow: hidden;
    border-radius: 6px;
}

/* Left panel (documents + profile) */
.verify-left {
    width: 32%;
    min-width: 300px;
    max-width: 400px;
    border-right: 1px solid #ddd;
    padding: 15px;
    overflow-y: auto;
}

/* Right panel (subjects + preview) */
.verify-right {
    flex-grow: 1;
    padding: 20px;
    overflow-y: auto;
}

/* Clean preview box */
#verifyFilePreview {
    height: 55vh;
    border: 1px solid #ddd;
    border-radius: 4px;
    overflow-y: auto;
    padding: 10px;
    background: #fafafa;
}

/* Subject table scrollable only horizontally */
.subject-table-wrapper {
    max-width: 100%;
    overflow-x: auto;
}

.list-group-item {
    padding: 8px 10px !important;
}
</style>



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

    <form id="pagecont" method="post" action="pageController.jsp">
        <input type="hidden" id="rePage" name="rePage">
    </form>

    <%
        String officeUidStr = (String) session.getAttribute("officeuid");
        String currofficeid = (String) session.getAttribute("currentOfficeUid");
//out.println(officeUidStr);

        List<String> officeNames = new ArrayList<>();
        if (officeUidStr != null && !officeUidStr.isEmpty()) {
            String[] officeUids = officeUidStr.split("\\,");

// Call DAO method to get office names
            officeNames = officedao.getOfficeNamesByIds(officeUids);
//out.println(officeUids[0]);

        }
    %>

    <body>
        <!-- Pre-loader start -->
        <div class="theme-loader">
            <div class="loader-track">
                <div class="preloader-wrapper">
                    <div class="spinner-layer spinner-blue">
                        <div class="circle-clipper left">
                            <div class="circle"></div>
                        </div>
                        <div class="gap-patch">
                            <div class="circle"></div>
                        </div>
                        <div class="circle-clipper right">
                            <div class="circle"></div>
                        </div>
                    </div>
                    <div class="spinner-layer spinner-red">
                        <div class="circle-clipper left">
                            <div class="circle"></div>
                        </div>
                        <div class="gap-patch">
                            <div class="circle"></div>
                        </div>
                        <div class="circle-clipper right">
                            <div class="circle"></div>
                        </div>
                    </div>

                    <div class="spinner-layer spinner-yellow">
                        <div class="circle-clipper left">
                            <div class="circle"></div>
                        </div>
                        <div class="gap-patch">
                            <div class="circle"></div>
                        </div>
                        <div class="circle-clipper right">
                            <div class="circle"></div>
                        </div>
                    </div>

                    <div class="spinner-layer spinner-green">
                        <div class="circle-clipper left">
                            <div class="circle"></div>
                        </div>
                        <div class="gap-patch">
                            <div class="circle"></div>
                        </div>
                        <div class="circle-clipper right">
                            <div class="circle"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Pre-loader end -->
        <div id="pcoded" class="pcoded">
            <div class="pcoded-overlay-box"></div>
            <div class="pcoded-container navbar-wrapper">

                <nav class="navbar header-navbar pcoded-header"  style="background: #031A36">


                    <div class="navbar-wrapper">
                        <div class="navbar-logo" style="background-color:#FDC800">
                            <a class="mobile-menu waves-effect waves-light" id="mobile-collapse" href="#!">
                                <i class="ti-menu"></i>
                            </a>
                            <div class="mobile-search waves-effect waves-light">
                                <div class="header-search">
                                    <div class="main-search morphsearch-search">
                                        <div class="input-group">

                                        </div>
                                    </div>
                                </div>
                            </div>
                            <a href="<%=request.getContextPath()%>/maindashboard/"  style="font-family: Ubuntu;color:#031A36;font-weight:bold;font-size: 1.5em">
                                Loyola ERP
                            </a>
                            <a class="mobile-options waves-effect waves-light">
                                <i class="ti-more"></i>
                            </a>
                        </div>

                        <div class="navbar-container container-fluid">

                            <ul class="nav-right">
                                <li>
                                    <div class="sidebar_toggle"><a href="javascript:void(0)"><i class="ti-menu"></i></a></div>
                                </li>
                                <li>
                                    <a href="#!" onclick="javascript:toggleFullScreen()" class="waves-effect waves-light">
                                        <i class="ti-fullscreen"></i>
                                    </a>
                                </li>
                                <li>
                                    <form method="post" action="/newerp/ChangeOfficeServlet">
                                        <select name="currmemarkoffices" id="currmemarkoffices">
                                            <% for (String officeName : officeNames) {%>
                                            <option value="<%= officeName.split("-")[0]%>-<%= officeName.split("-")[1]%>" <%=officeName.split("-")[0].equals(currofficeid) ? "selected" : ""%> ><%= officeName.split("-")[1]%></option>
                                            <% }%>
                                        </select>
                                    </form>

                                    <div id="popupMsg" 
                                         style="display:none; position:fixed; top:20px; right:20px;
                                         background:#FFDF20; color:#800; padding:5px 30px;
                                         border-radius:4px; box-shadow:0 2px 6px rgba(0,0,0,0.2);
                                         z-index:9999;">
                                    </div>
                                </li>
                                <li>
                                    <span id="currentDate"  style="border-radius:4px;padding:5px 5px 5px 5px;; color:#FFF"><%=session.getAttribute("currentdate2")%></span>
                                </li>

                                <li >
                                    <span id="currentdayorder"  style="border-radius:4px;padding:5px 5px 5px 5px;; color:#FFF">Day Order : <%=session.getAttribute("currentdayorder")%> </span>
                                </li>



                                <li class="user-profile header-notification">
                                    <a href="#!" class="waves-effect waves-light">
                                        <img src="<%=request.getContextPath()%>/maindashboard/assets/images/avatar-4.jpg" class="img-radius" alt="User-Profile-Image">
                                        <span><%=(String) session.getAttribute("uname")%></span>
                                        <i class="ti-angle-down"></i>
                                    </a>
                                    <ul class="show-notification profile-notification">
                                        <li class="waves-effect waves-light">
                                            <a href="<%=request.getContextPath()%>/usermanager/logout.jsp">
                                                <i class="ti-layout-sidebar-left"></i> Logout
                                            </a>
                                        </li>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                    </div>
                </nav>

                <div class="pcoded-main-container">

                    <div class="pcoded-wrapper">
                        <nav class="pcoded-navbar">
                            <div class="sidebar_toggle"><a href="#"><i class="icon-close icons"></i></a></div>
                            <div class="pcoded-inner-navbar main-menu">
                                <div class="">
                                    <div class="main-menu-header" style="border:0px solid #000">
                                        <img class="img-100" src="<%=request.getContextPath()%>/images/loyolacollege.png"  alt="User-Profile-Image">

                                    </div>

                                    <div class="main-menu-content">

                                    </div>
                                </div>
                                <div class="pcoded-navigation-label" data-i18n="nav.category.navigation"></div>

                                <ul class="pcoded-item pcoded-left-item" >




                                    <%

                                        String[] iconNames = {
                                            "ti-layout-grid2-alt", "ti-direction-alt", "ti-settings", "ti-user","ti-layout-grid2-alt", "ti-direction-alt", "ti-settings", "ti-user",
                                            "ti-bar-chart", "ti-wallet", "ti-book", "ti-timer", "ti-write", "ti-layers","ti-layout-grid2-alt", "ti-direction-alt", "ti-settings", "ti-user"
                                        };

                                        int m = 0, t = 0, r = 0;

                                        //out.println("------------------"+(String)session.getAttribute("activeMenu")+"---------------"+(String)session.getAttribute("activeMenuname"));
                                        String activemenu = "";//(String)session.getAttribute("activeMenu");
                                        if ((String) session.getAttribute("activeMenu") != null) {
                                            activemenu = (String) session.getAttribute("activeMenu");
                                        }
                                        String activemenuname = "";//(String)session.getAttribute("activemenuname");
                                        if ((String) session.getAttribute("activeMenuname") != null) {
                                            activemenuname = (String) session.getAttribute("activeMenuname");
                                        }
                                        System.out.println("\n \n active menu \n \n" + activemenu + "\n \n " + activemenuname);
                                    %>
                                    <li class="<%=activemenu.equals("mq") ? "active" : ""%>" >
                                        <a href="#"  data-id="mq" class="waves-effect waves-dark" onclick="loadPage('mq', '/maindashboard/index.jsp', 'Dashbord')">

                                            <span class="pcoded-micon"><i class="ti-home"></i><b>D</b></span>
                                            <span class="pcoded-mtext" data-i18n="nav.dash.main">Dashboard</span>
                                            <span class="pcoded-mcaret"></span>
                                        </a>
                                    </li>
                                    <%

                                        for (int j = 0; j < ary.size(); j++) {
                                            JSONObject obj = (JSONObject) ary.get(j);
                                    %>
                                    <li class="pcoded-hasmenu <%=activemenuname.equals(obj.get("menuname")) ? "active pcoded-trigger" : ""%>" >
                                        <a href="javascript:void(0)" class="waves-effect waves-dark" >
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
                                                <a href="#"  data-id="m<%=m%>" onclick="loadPage('m<%=m%>', '<%= obj1.get("submenuurl")%>', '<%= obj.get("menuname")%>')" class="waves-effect waves-dark"  style="<%=activemenu.equals("m" + String.valueOf(m)) ? "font-weight:bold" : ""%>;color:#800;">
                                                    <span class="pcoded-micon"><i class="ti-angle-right"></i></span>

                                                    <span class="pcoded-mtext"><%= obj1.get("submenu")%></span>

                                                </a>
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
                                            <li class="<%=activemenu.equals("t" + String.valueOf(t)) ? "active" : ""%>">
                                                <a href="#" data-id="t<%=t%>" onclick="loadPage('t<%=t%>', '<%= obj1.get("submenuurl")%>', '<%= obj.get("menuname")%>')" class="waves-effect waves-dark"   style="<%=activemenu.equals("t" + String.valueOf(t)) ? "font-weight:bold" : ""%>;color:#800; ">
                                                    <span class="pcoded-micon"><i class="ti-angle-right"></i></span>

                                                    <span class="pcoded-mtext"><%= obj1.get("submenu")%></span>
                                                </a>
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
                                            <li class="<%=activemenu.equals("r" + String.valueOf(r)) ? "active" : ""%>">
                                                <a href="#" data-id="r<%=r%>" onclick="loadPage('r<%=r%>', '<%= obj1.get("submenuurl")%>', '<%= obj.get("menuname")%>')" class="waves-effect waves-dark"   style="<%=activemenu.equals("r" + String.valueOf(r)) ? "font-weight:bold" : ""%>;color:#800; ">
                                                    <span class="pcoded-micon"><i class="ti-angle-right"></i></span>

                                                    <span class="pcoded-mtext"><%= obj1.get("submenu")%></span>
                                                </a>
                                            </li>
                                            <% }

                                                } %>

                                        </ul>
                                    </li>
                                    <% }%>


                                </ul>


                            </div></nav>
