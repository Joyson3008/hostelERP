<%-- 
    Document   : roomMaster
    Created on : Apr 21, 2026, 4:59:56?PM
    Author     : lccerp26
--%>

<%-- 


<%
    // *************** Authentication Block ***************
    String per = "A";
    String mName = "HOSTEL_ROOM_MASTER";
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

                    <!-- FORM -->
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0 text-white">Room Master</h5>
                        </div>

                        <div class="card-body">

                            <div class="row">

                                <div class="col-md-3">
                                    <label>Block</label>
                                    <select id="blockid" class="form-control"></select>
                                </div>

                                <div class="col-md-3">
                                    <label>Floor</label>
                                    <select id="floorid" class="form-control"></select>
                                </div>

                                <div class="col-md-3">
                                    <label>Max Occupants</label>
                                    <input type="text" id="maxOccupants" class="form-control" inputmode="numeric">
                                </div>

                                <div class="col-md-3">
                                    <label>No of Rooms</label>
                                    <div class="input-group">
                                        <input type="text" id="roomCount" class="form-control" inputmode="numeric">
                                        <div class="input-group-append">
                                            <button class="btn btn-primary" id="generateBtn">Generate</button>
                                            <button class="btn btn-info ml-2" id="showAssetsBtn">Assets</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row mt-3 d-flex justify-content-center">
                                <div class="col-auto">
                                    <button class="btn btn-secondary" id="clearBtn">Clear</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- TABLE -->
                    <div class="card mt-3">

                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0 text-white">Room List</h5>
                        </div>

                        <div class="card-body">

                            <!-- ? Search Box -->
                            <div class="mb-2">
                                <input type="text" id="roomSearchInput" class="form-control w-25 mb-3" placeholder="Search rooms...">
                            </div>

                            <!-- ? Scroll applied HERE -->
                            <div class="table-responsive" style="max-height: 500px; overflow-y: auto;">
                                <table class="table table-bordered table-sm">
                                    <thead class="table-light sticky-top">
                                        <tr>
                                            <th>Sl No</th>
                                            <th>Block</th>
                                            <th>Floor</th>
                                            <th>Room</th>
                                            <th>Max Occupants</th>
                                            <th>No of Occupants</th>
                                            <th>Assets</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>

                                    <tbody id="roomTable"></tbody>
                                </table>
                            </div>

                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>


<!-- Asset Modal -->
<div class="modal fade" id="assetModal">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">

            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Asset List</h5>
                <button class="close" data-dismiss="modal">&times;</button>
            </div>

            <div class="modal-body">
                <table class="table table-bordered">
                    <thead>
                        <tr>
                            <th>Sl No</th>
                            <th>Asset Name</th>
                            <th>Short Name</th>
                        </tr>
                    </thead>
                    <tbody id="assetTable"></tbody>
                </table>
            </div>

        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>

    $(document).ready(function () {
        loadBlocks();
        $("#maxOccupants, #roomCount").val("");
        $("#roomSearchInput").val("");
    });

    // numeric only
    $("#roomCount, #maxOccupants").on("input", function () {
        this.value = this.value.replace(/[^0-9]/g, '');
    });

    //Search Box
    document.getElementById("roomSearchInput").addEventListener("keyup", function () {
        const filter = this.value.toLowerCase();
        const rows = document.querySelectorAll("#roomTable tr");

        rows.forEach(row => {
            const text = row.innerText.toLowerCase();
            row.style.display = text.includes(filter) ? "" : "none";
        });
    });

    // Load Blocks
    function loadBlocks() {

        $.get("ajax/getBlocks.jsp", function (res) {

            let html = "<option value=''>Select</option>";

            res.forEach(function (row) {
                html += "<option value='" + row.blockid + "'>" + row.blockname + "</option>";
            });

            $("#blockid").html(html);

        }, "json");
    }

    // Load Floors
    $("#blockid").change(function () {

        let blockid = $(this).val();

        $.get("ajax/getFloors.jsp", {blockid: blockid}, function (res) {

            let html = "<option value='ALL' selected>All Floors</option>";

            res.forEach(function (row) {
                html += "<option value='" + row.floorid + "'>" + row.floorname + "</option>";
            });

            $("#floorid").html(html);
            loadRooms();
        }, "json");
    });

    // Generate Rooms
    $("#generateBtn").click(function () {

        let blockid = $("#blockid").val();
        let floorid = $("#floorid").val();
        let roomCount = $("#roomCount").val();
        let maxOccupants = $("#maxOccupants").val();

        if (!blockid || !floorid || !roomCount || !maxOccupants) {
            alert("All fields required");
            return;
        }

        $.post("ajax/saveRooms.jsp", {
            blockid: blockid,
            floorid: floorid,
            roomCount: roomCount,
            maxOccupants: maxOccupants
        }, function (res) {

            if (res.success) {
                alert("Rooms Saved Successfully");
                loadRooms();
            } else {
                alert(res.error || "Cannot save");
            }

        }, "json").fail(() => alert("Server not Connected"));

    });

    // Load Rooms
    $("#floorid").change(loadRooms);

    function loadRooms() {

        let blockid = $("#blockid").val();
        let floorid = $("#floorid").val();

        if (!blockid) {
            $("#roomTable").html("<tr><td colspan='8' class='text-center'>Select Block</td></tr>");
            return;
        }

        $("#roomTable").html("<tr><td colspan='8' class='text-center'>Loading...</td></tr>");

        $.get("ajax/getRooms.jsp", {
            blockid: blockid,
            floorid: (floorid === "ALL") ? 0 : floorid
        }, function (res) {

            let html = "";
            let i = 1;

            if (res && res.length > 0) {

                res.forEach(function (row) {

                    html += "<tr data-id='" + row.roomid + "'>";
                    html += "<td>" + (i++) + "</td>";
                    html += "<td>" + row.blockname + "</td>";
                    html += "<td>" + row.floorname + "</td>";
                    html += "<td>" + row.roomname + "</td>";
                    html += "<td>" + row.max_noofoccupants + "</td>";
                    html += "<td>" + row.no_of_occupants + "</td>";
                    html += "<td>" + (row.facility_assets || "") + "</td>";
                    html += "<td><button class='btn btn-warning btn-sm editBtn'>Edit</button></td>";
                    html += "</tr>";

                });

            } else {
                html = "<tr><td colspan='8' class='text-center'>No Rooms Found</td></tr>";
            }

            $("#roomTable").html(html);

        }, "json").fail(() => {
            $("#roomTable").html("<tr><td colspan='8' class='text-danger text-center'>Error</td></tr>");
        });
    }

    // Edit
    $(document).on("click", ".editBtn", function () {

        let row = $(this).closest("tr");

        let capacity = row.find("td:eq(4)").text();
        let assets = row.find("td:eq(6)").text();

        row.find("td:eq(4)").html("<input class='form-control capacityEdit' value='" + capacity + "'>");
        row.find("td:eq(6)").html("<input class='form-control assetsEdit' value='" + assets + "'>");

        $(this).removeClass("editBtn btn-warning")
                .addClass("saveBtn btn-success")
                .text("Save");

    });

    // Save
    $(document).on("click", ".saveBtn", function () {

        let row = $(this).closest("tr");

        let roomid = row.data("id");
        let capacity = row.find(".capacityEdit").val();
        let assets = row.find(".assetsEdit").val();

        $.post("ajax/updateRoom.jsp", {
            roomid, capacity, assets
        }, function (res) {

            if (res.success) {
                alert("Updated");
                loadRooms();
            } else {
                alert(res.error || "Failed");
            }

        }, "json").fail(() => alert("Connection Error"));

    });

    // Assets
    $("#showAssetsBtn").click(function () {
        loadAssets();
        $("#assetModal").modal("show");
    });

    function loadAssets() {

        $("#assetTable").html("<tr><td colspan='3'>Loading...</td></tr>");

        $.get("ajax/getAssets.jsp", function (res) {

            let html = "";
            let i = 1;

            if (res.length > 0) {

                res.forEach(function (row) {
                    html += "<tr><td>" + (i++) + "</td><td>" + row.asset_name + "</td><td>" + row.asset_short_name + "</td></tr>";
                });

            } else {
                html = "<tr><td colspan='3'>No Assets</td></tr>";
            }

            $("#assetTable").html(html);

        }, "json");
    }
    $("#clearBtn").click(function () {
        $("#maxOccupants").val("");
        $("#roomCount").val("");
        $("#roomSearchInput").val("");
    });

</script>

<jsp:include page="../../lccerpfooter.jsp"/>

<%--

<% } else {%>

session Time out
<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" />

<% }%>

--%>