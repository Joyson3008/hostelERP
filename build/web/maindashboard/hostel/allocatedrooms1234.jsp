<%-- 
    Document   : allocatedrooms
    Created on : Apr 27, 2026, 5:37:30?PM
    Author     : lccerp26
--%>

<%-- 


<%
    // *************** Authentication Block ***************
    String per = "A";
    String mName = "HOSTEL_ALLOCATED_ROOMS";
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
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0 text-white">Allocated Rooms</h5>
                        </div>
                        <!-- FILTERS -->
                        <div class="card-body">
                            <div class="row mb-3">

                                <div class="col-md-3">
                                    <label>Block</label>
                                    <select id="blockid" class="form-control">
                                        <option value="">All</option>
                                    </select>
                                </div>

                                <div class="col-md-3">
                                    <label>Floor</label>
                                    <select id="floorid" class="form-control">
                                        <option value="">All</option>
                                    </select>
                                </div>

                                <div class="col-md-3">
                                    <label>Type</label>
                                    <select id="type" class="form-control">
                                        <option value="">All</option>
                                        <option value="empty">Not Occupied</option>
                                        <option value="notempty">Occupied</option>
                                    </select>
                                </div>

                            </div>
                        </div>
                    </div>

                    <!-- TABLE -->
                    <div class="card mt-3">

                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0 text-white">Room Details</h5>
                        </div>

                        <div class="card-body">

                            <!-- ? Search Box -->
                            <div class="mb-2">
                                <input type="text" id="tableSearchInput" class="form-control w-25 mb-3" placeholder="Search...">
                            </div>

                            <!-- ? Scrollable Table -->
                            <div class="table-responsive" style="max-height: 500px; overflow-y: auto;">
                                <table class="table table-bordered table-striped table-sm">
                                    <thead class="table-light sticky-top">
                                        <tr>
                                            <th>Block</th>
                                            <th>Floor</th>
                                            <th>Room</th>
                                            <th>Max</th>
                                            <th>Occupied</th>
                                            <th>Register Numbers</th>
                                        </tr>
                                    </thead>
                                    <tbody id="tableBody"></tbody>
                                </table>
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

    //Search Fucntion
    document.getElementById("tableSearchInput").addEventListener("keyup", function () {
        const filter = this.value.toLowerCase();
        const rows = document.querySelectorAll("#tableBody tr");

        rows.forEach(row => {
            const text = row.innerText.toLowerCase();
            row.style.display = text.includes(filter) ? "" : "none";
        });
    });

    // ================= LOAD BLOCKS =================
    function loadBlocks() {

        $.get("ajax/getBlocks.jsp", function (res) {

            let html = "<option value=''>All</option>";

            res.forEach(function (row) {
                html += "<option value='" + row.blockid + "'>" + row.blockname + "</option>";
            });

            $("#blockid").html(html);

        }, "json").fail(function () {
            alert("Cannot load blocks");
        });
    }

    // ================= LOAD FLOORS =================
    $("#blockid").change(function () {

        let blockid = $(this).val();

        if (!blockid) {
            $("#floorid").html("<option value=''>All</option>");
            return;
        }

        $.get("ajax/getFloors.jsp", {blockid: blockid}, function (res) {

            let html = "<option value=''>All</option>";

            res.forEach(function (row) {
                html += "<option value='" + row.floorid + "'>" + row.floorname + "</option>";
            });

            $("#floorid").html(html);

        }, "json").fail(function () {
            alert("Cannot load floors");
        });

    });

    $("#blockid").change(function () {
        loadRooms();
    });

    $("#floorid").change(function () {
        loadRooms();
    });

    $("#type").change(function () {
        loadRooms();
    });

    // ================= LOAD ROOMS =================
    function loadRooms() {

        var blockid = $("#blockid").val();
        var floorid = $("#floorid").val();
        var type = $("#type").val();

        $.post("ajax/getAllocatedRooms.jsp", {
            blockid: blockid,
            floorid: floorid,
            type: type
        }, function (res) {

            var html = "";

            if (!res || res.length === 0) {

                html = "<tr>"
                        + "<td colspan='6' class='text-center text-danger fw-bold'>No Rooms Found</td>"
                        + "</tr>";

                $("#tableBody").html(html);
                return;
            }

            res.forEach(function (r) {

                html += "<tr>"
                        + "<td>" + r.block + "</td>"
                        + "<td>" + r.floor + "</td>"
                        + "<td>" + r.room + "</td>"
                        + "<td>" + r.max + "</td>"
                        + "<td>" + r.occupied + "</td>"
                        + "<td>" + (r.students || "") + "</td>"
                        + "</tr>";

            });

            $("#tableBody").html(html);

        }, "json").fail(function () {

            $("#tableBody").html(
                    "<tr><td colspan='6' class='text-center text-danger'>Cannot load Rooms</td></tr>"
                    );

        });
    }

    $("#searchBtn").click(function () {
        loadRooms();
    });

    // INIT
    $(document).ready(function () {

        loadBlocks();

        $("#floorid").html("<option value=''>All</option>");
        $("#type").val("");

        loadRooms();

    });

</script>

<jsp:include page="../../lccerpfooter.jsp"/>

<%--
<% } else {%>

session Time out
<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" />

<% }%>

--%>