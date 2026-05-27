<%-- 
    Document   : roomAllocation
    Created on : Apr 18, 2026, 6:30:44?PM
    Author     : lccerp26
--%>

<%--

<%
    // *************** Authentication Block ***************
    String per = "A";
    String mName = "HOSTEL_ROOM_ALLOCATION";
%>

<%@ include file="/usermanager/permission.jsp" %>

<%@page import="java.net.InetAddress"%>
<%@page import="java.net.UnknownHostException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%    response.setDateHeader("Expires", 0);
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
                            <h5 class="mb-0 text-white">Room Allocation</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">

                                <!-- Block -->
                                <div class="form-group col-md-3">
                                    <label>Block</label>
                                    <select id="blockid" class="form-control"></select>
                                </div>

                                <!-- Floor -->
                                <div class="form-group col-md-3">
                                    <label>Floor</label>
                                    <select id="floorid" class="form-control"></select>
                                </div>

                            </div>
                        </div>
                    </div>

                    <hr>

                    <div class="card mt-3">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0 text-white">Room Allocation</h5>
                        </div>

                        <div class="card-body">
                            <div class="row">

                                <!-- LEFT SIDE -->
                                <div class="col-md-6">
                                    <h6>Eligible Students</h6>

                                    <div class="row mb-2">
                                        <div class="col-md-6">
                                            <select id="institutionid" class="form-control">
                                                <option value="">Select Institution</option>
                                            </select>
                                        </div>

                                        <div class="col-md-6">
                                            <input type="text" id="studentSearch" class="form-control" placeholder="Search Student...">
                                        </div>
                                    </div>

                                    <!-- SCROLLABLE TABLE -->
                                    <div class="table-responsive" style="max-height: 400px; overflow-y: auto;">
                                        <table class="table table-bordered table-sm">
                                            <thead class="table-light sticky-top">
                                                <tr>
                                                    <th>Select</th>
                                                    <th>Register No</th>
                                                    <th>Name</th>
                                                    <th>Mess</th>
                                                </tr>
                                            </thead>
                                            <tbody id="studentTable"></tbody>
                                        </table>
                                    </div>
                                </div>

                                <!-- RIGHT SIDE -->
                                <div class="col-md-6">
                                    <h6>Available Rooms</h6>

                                    <input type="text" id="roomSearch" class="form-control mb-2" placeholder="Search Room...">

                                    <!-- SCROLLABLE TABLE -->
                                    <div class="table-responsive" style="max-height: 400px; overflow-y: auto;">
                                        <table class="table table-bordered table-sm">
                                            <thead class="table-light sticky-top">
                                                <tr>
                                                    <th>Sl.No</th>
                                                    <th>Select</th>
                                                    <th>Room</th>
                                                    <th>Capacity</th>
                                                    <th>Occupied</th>
                                                </tr>
                                            </thead>
                                            <tbody id="roomTable"></tbody>
                                        </table>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>

                    <div class="text-center mt-3">
                        <button class="btn btn-info mr-2" id="messBtn">Mess Allocation</button>
                        <button class="btn btn-success mr-2" id="viewBtn">View Selection</button>
                        <button class="btn btn-secondary" id="clearBtn">Clear</button>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<!-- ================= MODALS (UNCHANGED) ================= -->

<div class="modal fade" id="previewModal">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Confirm Allocation</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal">x</button>
            </div>

            <div class="modal-body">
                <div id="previewContent"></div>
            </div>

            <div class="modal-footer text-center">
                <button class="btn btn-primary" id="allocateBtn">Allocate</button>
                <button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="messModal">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title">Mess Allocation</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal">x</button>
            </div>

            <div class="modal-body">

                <label>Select Mess</label>
                <select id="messid" class="form-control mb-3">
                    <option value="">Select</option>
                </select>

                <div id="selectedStudents"></div>

            </div>

            <div class="modal-footer text-center">
                <button class="btn btn-primary" id="allocateMessBtn">Allocate</button>
                <button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>

        </div>
    </div>
</div>
<div class="modal fade" id="resultModal">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title">Room Allocation Result</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal">x</button>
            </div>

            <div class="modal-body" id="resultModalBody"></div>

        </div>
    </div>
</div>
<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>

    // ================= LOAD BLOCK =================
    function loadBlocks() {

        $.get("ajax/getBlocks.jsp", function (res) {

            let html = "<option value=''>Select</option>";

            res.forEach(function (row) {
                html += "<option value='" + row.blockid + "'>" + row.blockname + "</option>";
            });

            $("#blockid").html(html);

        }, "json");
    }

    function loadMess() {

        $.get("ajax/getMess.jsp", function (res) {

            let html = "<option value=''>Select</option>";

            res.forEach(function (row) {
                html += "<option value='" + row.mess_id + "'>" + row.mess_name + "</option>";
            });

            $("#messid").html(html);

        }, "json");
    }

    //Mess Button
    $("#messBtn").click(function () {

        var students = [];
        var alreadyAssignedList = [];

        $(".stuChk:checked").each(function () {

            var regno = $(this).val();
            var mess = $(this).data("mess");

            students.push(regno);

            // CHECK EXISTING MESS
            if (mess && mess.trim() !== "") {
                alreadyAssignedList.push(regno);
            }
        });

        if (students.length === 0) {
            alert("Select at least one student");
            return;
        }

        // CONFIRM IF ALREADY ASSIGNED
        if (alreadyAssignedList.length > 0) {

            let msg = alreadyAssignedList.length + " student(s) already have a mess assigned.\n\n";

            // Optional: show few student IDs
            //msg += "Example: " + alreadyAssignedList.slice(0, 5).join(", ") + "\n\n";
            msg += "Do you want to change the mess?";

            if (!confirm(msg)) {
                return; // Stop if NO
            }
        }

        // SHOW SELECTED STUDENTS
        let html = "<b>Selected Students:</b><ul>";

        students.forEach(function (s) {
            html += "<li>" + s + "</li>";
        });

        html += "</ul>";

        $("#selectedStudents").html(html);

        loadMess();

        $("#messModal").modal("show");
    });

    //==== Allocate Mess

    $("#allocateMessBtn").click(function () {

        var messid = $("#messid").val();

        if (!messid) {
            alert("Select a mess");
            return;
        }

        var students = [];
        $(".stuChk:checked").each(function () {
            students.push($(this).val());
        });

        // CONFIRMATION
        if (!confirm("Are you sure you want to allocate this mess to selected students?")) {
            return;
        }

        $.post("ajax/allocateMess.jsp", {
            messid: messid,
            students: students
        }, function (res) {

            if (res.success) {
                alert("Mess allocated successfully");
                $("#messModal").modal("hide");
                loadStudents(); // refresh
            } else {
                alert(res.error);
            }

        }, "json");
    });

    // ================= LOAD FLOORS =================
    $("#blockid").change(function () {

        let blockid = $(this).val();

        console.log("\nblockid\n" + blockid);

        $.get("ajax/getFloors.jsp", {blockid: blockid}, function (res) {

            let html = "<option value='0'>All Floors</option>";

            res.forEach(function (row) {
                html += "<option value='" + row.floorid + "'>" + row.floorname + "</option>";
            });

            $("#floorid").html(html);
            $("#floorid").val("0");
            loadAvailableRooms();

        }, "json");

    });

    // ================= CLEAR =================
    function clearAllocationUI() {

        // Uncheck all rooms
        $(".roomChk").prop("checked", false);

        // Uncheck all students
        $(".stuChk").prop("checked", false);

        // Reset dropdowns
        $("#blockid").val("");
        $("#studentSearch").val("");
        $("#roomSearch").val("");
        $("#floorid").html("<option value=''>Select</option>");

        // Clear tables
        $("#roomTable").empty();
        $("#studentTable").empty();

        // Reload initial data
        loadBlocks();
        loadStudents();

        // Default message
        $("#roomTable").html(
                "<tr><td colspan='5' class='text-center text-danger'>Select Block and Floor</td></tr>"
                );
    }

    $("#clearBtn").click(function () {
        clearAllocationUI();
    });
    // ================= LOAD INSTITUTIONS =================
    function loadInstitutions() {

        $.get("ajax/getInstitutions.jsp", function (res) {

            console.log("Institutions:", res);
            let html = "<option value=''>All Institutions</option>";

            res.forEach(function (row) {
                html += "<option value='" + row.institutionid + "'>" + row.institutename + "</option>";
            });

            $("#institutionid").html(html);

        }, "json");
    }

    $("#institutionid").change(function () {
        loadStudents();
    });

    // ================= LOAD ROOMS =================

    function loadAvailableRooms() {

        var blockid = $("#blockid").val();
        var floorid = $("#floorid").val();

        if (!blockid) {
            $("#roomTable").html(
                    "<tr><td colspan='5' class='text-center text-danger'>Select Block</td></tr>"
                    );
            return;
        }

        $("#roomTable").html(
                "<tr><td colspan='5' class='text-center'>Loading...</td></tr>"
                );

        $.get("ajax/getAvailableRooms.jsp", {
            blockid: blockid,
            floorid: (floorid === "0") ? 0 : floorid
        }, function (data) {

            $("#roomTable").empty();

            if (!data || data.length === 0) {
                $("#roomTable").html(
                        "<tr><td colspan='5' class='text-center text-danger'>No Available Rooms</td></tr>"
                        );
                return;
            }

            for (var i = 0; i < data.length; i++) {

                var d = data[i];

                var row = "<tr>"
                        + "<td>" + (i + 1) + "</td>"
                        + "<td><input type='checkbox' class='roomChk' value='" + d.room_id + "'></td>"
                        + "<td>" + d.room_name + "</td>"
                        + "<td>" + d.max_capacity + "</td>"
                        + "<td>" + d.occupied_count + "</td>"
                        + "</tr>";

                $("#roomTable").append(row);
            }

        }, "json").fail(function () {

            $("#roomTable").html(
                    "<tr><td colspan='5' class='text-center text-danger'>Cannot load rooms</td></tr>"
                    );
        });
    }
    $("#floorid").change(function () {
        loadAvailableRooms();
    });

    // ================= ROOM SEARCH =================
    $("#roomSearch").on("keyup", function () {

        var value = $(this).val().toLowerCase();

        $("#roomTable tr").filter(function () {

            // Room name is in 3rd column (index 2)
            var roomName = $(this).find("td:eq(2)").text().toLowerCase();

            $(this).toggle(roomName.indexOf(value) > -1);
        });

    });


    // ================= LOAD STUDENTS =================
    function loadStudents() {

        var institutionid = $("#institutionid").val();

        // VALIDATION
//                if (!institutionid) {
//
//                    $("#studentTable").html(
//                            "<tr><td colspan='3' class='text-center text-warning'>Select Institution</td></tr>"
//                            );
//                    return;
//                }
        $.get("ajax/getEligibleStudents.jsp", {institutionid: institutionid}, function (data) {

            $("#studentTable").empty();

            // NO RECORDS CASE
            if (!data || data.length === 0) {

                var row = "<tr>"
                        + "<td colspan='3' class='text-center text-danger'>No Records Found</td>"
                        + "</tr>";

                $("#studentTable").append(row);
                return;
            }

            // DATA EXISTS
            for (var i = 0; i < data.length; i++) {

                var d = data[i];

                var row = "<tr>"
                        + "<td><input type='checkbox' class='stuChk' value='" + d.registerno + "' data-mess='" + (d.mess_name || '') + "'></td>"
                        + "<td>" + d.registerno + "</td>"
                        + "<td>" + d.studentname + "</td>"
                        + "<td>" + (d.mess_name || '') + "</td>"
                        + "</tr>";

                $("#studentTable").append(row);
            }

        }, "json").fail(function () {

            // NETWORK / SERVER ERROR
            $("#studentTable").html(
                    "<tr><td colspan='3' class='text-center text-danger'>Cannot load data</td></tr>"
                    );
        });
    }

    // ================= STUDENT SEARCH =================
    $("#studentSearch").on("keyup", function () {

        var value = $(this).val().toLowerCase();

        $("#studentTable tr").filter(function () {

            var regNo = $(this).find("td:eq(1)").text().toLowerCase();
            var name = $(this).find("td:eq(2)").text().toLowerCase();

            $(this).toggle(
                    regNo.indexOf(value) > -1 || name.indexOf(value) > -1
                    );
        });

        var visible = $("#studentTable tr:visible").length;

        if (visible === 0) {
            $("#studentTable").append(
                    "<tr class='no-match'><td colspan='3' class='text-center text-danger'>No matching students</td></tr>"
                    );
        } else {
            $("#studentTable .no-match").remove();
        }

    });

    // ================= VIEW =================
    $("#viewBtn").click(function () {

        var rooms = [];
        var totalSlots = 0; // ADD THIS

        $(".roomChk:checked").each(function () {

            rooms.push($(this).val());

            // GET ROW DATA FOR CAPACITY CALCULATION
            var row = $(this).closest("tr");

            var max = parseInt(row.find("td:eq(3)").text());
            var occupied = parseInt(row.find("td:eq(4)").text());

            var available = max - occupied;

            totalSlots += available; // SUM AVAILABLE SLOTS
        });

        var students = [];
        $(".stuChk:checked").each(function () {
            students.push($(this).val());
        });

        // EXISTING VALIDATION
        if (rooms.length === 0 || students.length === 0) {
            alert("Select at least one room and student");
            return;
        }

        // ? MESS VALIDATION
        var studentsWithoutMess = [];

        $(".stuChk:checked").each(function () {

            var mess = $(this).data("mess");

            if (!mess || mess === "" || mess === "-") {
                studentsWithoutMess.push($(this).val());
                $(this).closest("tr").addClass("table-danger");
            }
        });

        if (studentsWithoutMess.length > 0) {
            alert("Mess not allocated for: " + studentsWithoutMess.join(", "));
            return;
        }

        // NEW VALIDATION (IMPORTANT)
        if (students.length > totalSlots) {
            alert("Selected students exceed available room capacity!");
            return;
        }

        // BUILD ROOM-STUDENT MAPPING
        var roomData = [];
        var studentList = [];

        // Collect rooms with capacity
        $(".roomChk:checked").each(function () {

            var row = $(this).closest("tr");

            var roomId = $(this).val();
            var roomName = row.find("td:eq(2)").text();
            var max = parseInt(row.find("td:eq(3)").text());
            var occupied = parseInt(row.find("td:eq(4)").text());

            var available = max - occupied;

            roomData.push({
                roomId: roomId,
                roomName: roomName,
                slots: available,
                students: []
            });
        });

        // Collect students
        $(".stuChk:checked").each(function () {
            studentList.push($(this).val());
        });

        // Distribute students into rooms
        var stuIndex = 0;

        for (var i = 0; i < roomData.length; i++) {

            var room = roomData[i];

            for (var j = 0; j < room.slots; j++) {

                if (stuIndex < studentList.length) {
                    room.students.push(studentList[stuIndex]);
                    stuIndex++;
                }
            }
        }

        // Build UI
        var html = "<div class='alert alert-info'>"
                + "Total Rooms: " + roomData.length + " | "
                + "Total Students: " + studentList.length
                + "</div>";

        for (var i = 0; i < roomData.length; i++) {

            var room = roomData[i];

            html += "<div class='card mb-2'>";
            html += "<div class='card-header'><b>Room: " + room.roomName + "</b></div>";
            html += "<div class='card-body'>";

            if (room.students.length === 0) {
                html += "<span class='text-muted'>No students assigned</span>";
            } else {
                html += "<ul>";
                for (var k = 0; k < room.students.length; k++) {
                    html += "<li>" + room.students[k] + "</li>";
                }
                html += "</ul>";
            }

            html += "</div></div>";
        }

        $("#previewContent").html(html);

        $("#previewModal").modal("show");
    });


    // ================= ALLOCATE =================
    $("#allocateBtn").click(function () {

        var rooms = [];
        $(".roomChk:checked").each(function () {
            rooms.push($(this).val());
        });

        var students = [];
        $(".stuChk:checked").each(function () {
            students.push($(this).val());
        });

        $.post("ajax/allocateRooms.jsp", {
            rooms: rooms,
            students: students
        }, function (res) {

            if (res.success) {

                // ? Build Result Table
                let html = "<table class='table table-bordered'>";
                html += "<tr><th>Register No</th><th>Room</th><th>Hostel No</th></tr>";

                res.data.forEach(function (s) {
                    html += "<tr>"
                            + "<td>" + s.registerno + "</td>"
                            + "<td>" + s.roomname + "</td>"
                            + "<td>" + s.hostelno + "</td>"
                            + "</tr>";
                });

                html += "</table>";

                // ? Show Popup
                $("#resultModalBody").html(html);
                var resultModal = new bootstrap.Modal(document.getElementById('resultModal'));
                resultModal.show();

                // ? Close preview modal
                $("#previewModal").modal("hide");

                // ? Reload UI
                loadStudents();
                clearAllocationUI();

            } else {

                alert(res.error || "Allocation failed");

            }

        }, "json").fail(function () {

            alert("Network error");

        });

    });

    // INIT
    $(document).ready(function () {
        loadBlocks();
        loadStudents();
        loadInstitutions();
        $("#studentSearch").val("");
        $("#roomSearch").val("");
        $("#roomTable").html(
                "<tr><td colspan='5' class='text-center text-danger'>Select Block and Floor</td></tr>"
                );
    });


</script>

<jsp:include page="../../lccerpfooter.jsp"/>

<%--

<% } else {%>

session Time out
<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" />

<% }%>

--%>