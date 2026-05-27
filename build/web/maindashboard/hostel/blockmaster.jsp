<%-- 
    Document   : blockmaster
    Created on : Apr 20, 2026, 4:06:11?PM
    Author     : lccerp26
--%>
<%--
<%
    // *************** Authentication Block ***************
    String per = "A";
    String mName = "HOSTEL_BLOCK_MASTER";
%>

<%@ include file="/usermanager/permission.jsp" %>

<%@page import="java.net.InetAddress"%>
<%@page import="java.net.UnknownHostException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    response.setDateHeader("Expires", 0);
    response.addHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.addHeader("Cache-Control", "post-check=0, pre-check=0");
    response.setHeader("Pragma", "no-cache");
session.setAttribute("login","true");
    String login = (String) session.getAttribute("login");
    String userId = (String) session.getAttribute("username");
    String currofficeid = (String) session.getAttribute("currentOfficeUid");

    if (login != null) {
%>
--%>
<%--<jsp:include page="../../lccerpheader.jsp"/>--%>
<link rel="stylesheet" href="../../usermanager/css/bootstrap.min.css">
<div class="pcoded-content">
    <div class="pcoded-inner-content">
        <div class="main-body">
            <div class="page-wrapper">
                <div class="page-body">

                    <div class="row">
                        <div class="col-md-6 offset-md-3">

                            <div class="card shadow">
                                <div class="card-header bg-primary text-white">
                                    <h5 class="mb-0 text-white">Hostel Block Master</h5>
                                </div>

                                <div class="card-body">

                                    <div id="msg"></div>

                                    <div class="form-group">
                                        <label>Block Name</label>
                                        <input type="text" id="blockname" class="form-control">
                                    </div>

                                    <div class="form-group">
                                        <label>No of Floors</label>
                                        <input type="text" id="floors" class="form-control" inputmode="numeric" pattern="[0-9]*">
                                    </div>

                                    <div class="text-center mt-3">
                                        <button class="btn btn-primary" id="saveBtn">Create</button>
                                        <button class="btn btn-secondary ml-2" id="clearBtn">Clear</button>
                                    </div>

                                </div>
                            </div>

                        </div>
                    </div>

                    <div class="row mt-4">
                        <div class="col-md-8 offset-md-2">

                            <div class="card">

                                <div class="card-header bg-primary text-white">
                                    <h6 class="mb-0 text-white">Block List</h6>
                                </div>

                                <div class="card-body">

                                    <!-- ? Scrollable Table -->
                                    <div class="table-responsive" style="max-height: 300px; overflow-y: auto;">
                                        <table class="table table-bordered table-sm">
                                            <thead class="table-light sticky-top">
                                                <tr>
                                                    <th>Sl No</th>
                                                    <th>Block Name</th>
                                                    <th>No of Floors</th>
                                                </tr>
                                            </thead>
                                            <tbody id="blockTable"></tbody>
                                        </table>
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

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>

    $(document).ready(function () {
        loadBlocks();
    });

    // Numeric only
    $("#floors").on("input", function () {
        this.value = this.value.replace(/[^0-9]/g, '');
    });

    // Clear
    $("#clearBtn").click(function () {
        $("#blockname").val("");
        $("#floors").val("");
        $("#msg").html("");
    });

    // Save
    $("#saveBtn").click(function () {

        const name = $("#blockname").val().trim();
        const floors = $("#floors").val();

        if (!name || !floors) {
            alert("All fields required");
            return;
        }

        $.post("ajax/saveBlock.jsp", {
            blockname: name,
            floors: floors
        }, function (res) {

            if (res.success) {

                $("#msg").html('<div class="alert alert-success">Saved Successfully</div>');
                $("#blockname").val("");
                $("#floors").val("");

                loadBlocks();

            } else {

                $("#msg").html('<div class="alert alert-danger">' + (res.error || "Error") + '</div>');
            }

        }, "json").fail(function () {

            $("#msg").html('<div class="alert alert-danger">No Connection</div>');

        });

    });

    // Load Data
    function loadBlocks() {

        $("#blockTable").html("<tr><td colspan='3' class='text-center'>Loading...</td></tr>");

        $.get("ajax/getBlocks.jsp", function (res) {

            let html = "";
            let i = 1;

            if (res && res.length > 0) {

                res.forEach(function (row) {

                    html += "<tr>";
                    html += "<td>" + (i++) + "</td>";
                    html += "<td>" + row.blockname + "</td>";
                    html += "<td>" + row.no_of_floors + "</td>";
                    html += "</tr>";

                });

            } else {

                html = "<tr><td colspan='3' class='text-center'>No Records Found</td></tr>";

            }

            $("#blockTable").html(html);

        }, "json").fail(function () {

            $("#blockTable").html("<tr><td colspan='3' class='text-danger text-center'>Cannot load data</td></tr>");

        });

    }

</script>

<jsp:include page="../../lccerpfooter.jsp"/>

<%--

<% } else {%>

session Time out
<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" />

<% }%>
--%>