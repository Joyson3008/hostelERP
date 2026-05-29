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

    <!-- Institution -->
    <div class="col-md-4">
        <select id="institutionid" class="form-control">
            <option value="">All Institutions</option>
        </select>
    </div>

    <!-- Shift Filter -->
    <div class="col-md-4">
        <select id="shiftFilter" class="form-control">
            <option value="">All Shifts</option>
            <option value="SHIFT 1">SHIFT 1</option>
            <option value="SHIFT 2">SHIFT 2</option>
        </select>
    </div>

    <!-- Search -->
    <div class="col-md-4">
        <input type="text"
               id="studentSearch"
               class="form-control"
               placeholder="Search Student...">
    </div>

</div>

                                    <div class="table-responsive" style="max-height: 400px; overflow-y: auto;">
                                        <table class="table table-bordered table-sm">
                                            <thead class="table-light sticky-top">
                                                <tr>
                                                    <th>Select</th>
                                                    <th>Register No</th>
                                                    <th>Student Name</th>
                                                    <th>Shift</th>
                                                    <%--
                                                    OLD HEADER (Mess column removed):
                                                    <th>Mess</th>
                                                    --%>
                                                </tr>
                                            </thead>
                                            <tbody id="studentTable"></tbody>
                                        </table>
                                    </div>
                                </div>

                                <!-- RIGHT SIDE -->
                                <div class="col-md-6">
                                    <h6>Available Rooms</h6>

                                 

                                    <!-- SCROLLABLE TABLE -->
                                    <div class="table-responsive" style="max-height: 400px; overflow-y: auto;">
                                        <table class="table table-bordered table-sm">
                                            <thead class="table-light sticky-top">
                                                <tr>
                                                    <th>Select</th>
                                                    <th>Room</th>
                                                    <th>Capacity</th>
                                                    <th>Occupied</th>
                                                    <th>Remaining</th>
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
<!--                        <button class="btn btn-info mr-2" id="messBtn">Mess Allocation</button>-->
                        <button class="btn btn-success mr-2" id="viewBtn">View Selection</button>
                        <button class="btn btn-secondary" id="clearBtn">Clear</button>
        
                        <button class="btn btn-danger"
        id="downloadAllocationPdfBtn">

    <i class="fa-solid fa-file-pdf"></i>
    Download All PDF

</button>
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
                <h5 class="modal-title">Confirm Room Allocation</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal">x</button>
            </div>
            <div class="modal-body">
                <div id="previewContent"></div>
            </div>
            <div class="modal-footer text-center">
                <button class="btn btn-primary" id="allocateBtn">Allocate Rooms</button>
                <button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
        </div>
    </div>
</div>

<!--
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
</div>-->

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.31/jspdf.plugin.autotable.min.js"></script>

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
//    $("#messBtn").click(function () {
//
//        var students = [];
//        var alreadyAssignedList = [];
//
//        $(".stuChk:checked").each(function () {
//
//            var regno = $(this).val();
//            var mess = $(this).data("mess");
//
//            students.push(regno);
//
//            // CHECK EXISTING MESS
//            if (mess && mess.trim() !== "") {
//                alreadyAssignedList.push(regno);
//            }
//        });
//
//        if (students.length === 0) {
//            alert("Select at least one student");
//            return;
//        }
//
//        // CONFIRM IF ALREADY ASSIGNED
//        if (alreadyAssignedList.length > 0) {
//
//            let msg = alreadyAssignedList.length + " student(s) already have a mess assigned.\n\n";
//
//            // Optional: show few student IDs
//            //msg += "Example: " + alreadyAssignedList.slice(0, 5).join(", ") + "\n\n";
//            msg += "Do you want to change the mess?";
//
//            if (!confirm(msg)) {
//                return; // Stop if NO
//            }
//        }

//        // SHOW SELECTED STUDENTS
//        let html = "<b>Selected Students:</b><ul>";
//
//        students.forEach(function (s) {
//            html += "<li>" + s + "</li>";
//        });
//
//        html += "</ul>";
//
//        $("#selectedStudents").html(html);
//
//        loadMess();
//
//        $("#messModal").modal("show");
//    });
//
//    //==== Allocate Mess
//
//    $("#allocateMessBtn").click(function () {
//
//        var messid = $("#messid").val();
//
//        if (!messid) {
//            alert("Select a mess");
//            return;
//        }
//
//        var students = [];
//        $(".stuChk:checked").each(function () {
//            students.push($(this).val());
//        });
//
//        // CONFIRMATION
//        if (!confirm("Are you sure you want to allocate this mess to selected students?")) {
//            return;
//        }
//
//        $.post("ajax/allocateMess.jsp", {
//            messid: messid,
//            students: students
//        }, function (res) {
//
//            if (res.success) {
//                alert("Mess allocated successfully");
//                $("#messModal").modal("hide");
//                loadStudents(); // refresh
//            } else {
//                alert(res.error);
//            }
//
//        }, "json");
//    });

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
$("#shiftFilter").change(function () {
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

        $.get(
            "ajax/getAvailableRooms.jsp",
            {blockid: blockid, floorid: floorid || 0},
            function (data) {

                console.log("ROOMS:", data);
                $("#roomTable").empty();

                if (!data || data.length === 0) {
                    $("#roomTable").html(
                        "<tr><td colspan='5' class='text-center text-danger'>No Available Rooms</td></tr>"
                    );
                    return;
                }

                for (var i = 0; i < data.length; i++) {

                    var d = data[i];

                    // Sl.No column removed per requirement.
                    // Capacity data stored in data-* attributes on the checkbox
                    // so viewBtn does not depend on fragile td:eq() indices.
                    var row = "<tr>"

                        + "<td>"
                        +   "<input type='checkbox' class='roomChk'"
                        +   " value='" + d.roomid + "'"
                        +   " data-roomno='" + (d.roomno || d.roomname || '') + "'"
                        +   " data-max='" + (d.totaloccupancy || d.max_noofoccupants || 0) + "'"
                        +   " data-occupied='" + (d.currentoccupancy || d.no_of_occupants || 0) + "'"
                        +   " data-available='" + (d.availablebeds || 0) + "'"
                        + ">"
                        + "</td>"

                        + "<td>" + (d.roomno || d.roomname || '') + "</td>"
                        + "<td>" + (d.totaloccupancy || d.max_noofoccupants || 0) + "</td>"
                        + "<td>" + (d.currentoccupancy || d.no_of_occupants || 0) + "</td>"
                        + "<td>" + (d.availablebeds || 0) + "</td>"

                        + "</tr>";

                    $("#roomTable").append(row);
                }
            },
            "json"
        ).fail(function () {
            $("#roomTable").html(
                "<tr><td colspan='5' class='text-center text-danger'>Cannot load rooms</td></tr>"
            );
        });
    }



// =========================================
// FLOOR CHANGE
// =========================================

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
var shiftFilter  = $("#shiftFilter").val();

        $.get(
    "ajax/getEligibleStudents.jsp",
    {
        institutionid: institutionid,
        shifttype: shiftFilter
    },
    function (data) {

            $("#studentTable").empty();

            if (!data || data.length === 0) {
                $("#studentTable").append(
                    "<tr><td colspan='4' class='text-center text-danger'>No Records Found</td></tr>"
                );
                return;
            }

            for (var i = 0; i < data.length; i++) {

                var d = data[i];

                // data-shift replaces old data-mess
                // data-name and data-appno stored for allocation POST
                var row = "<tr>"

                    + "<td>"
                    +   "<input type='checkbox' class='stuChk'"
                    +   " value='" + d.registerno + "'"
                    +   " data-shift='" + (d.shifttype || '') + "'"
                    +   " data-name='" + (d.studentname || '').replace(/'/g, "&#39;") + "'"
                    +   " data-appno='" + (d.applicationno || '') + "'"
                    + ">"
                    + "</td>"

                    + "<td>" + (d.registerno   || '') + "</td>"
                    + "<td>" + (d.studentname  || '') + "</td>"
                    + "<td>" + (d.shifttype    || '-') + "</td>"

                  

                    + "</tr>";

                $("#studentTable").append(row);
            }

        }, "json").fail(function () {
            $("#studentTable").html(
                "<tr><td colspan='4' class='text-center text-danger'>Cannot load data</td></tr>"
            );
        });
    }


    // ================= STUDENT SEARCH =================
    $("#studentSearch").on("keyup", function () {

        var value = $(this).val().toLowerCase();

        // Register No: td:eq(1) | Name: td:eq(2)
        $("#studentTable tr").filter(function () {
            var regNo = $(this).find("td:eq(1)").text().toLowerCase();
            var name  = $(this).find("td:eq(2)").text().toLowerCase();
            $(this).toggle(regNo.indexOf(value) > -1 || name.indexOf(value) > -1);
        });

        var visible = $("#studentTable tr:visible").length;
        if (visible === 0) {
            $("#studentTable").append(
                "<tr class='no-match'><td colspan='4' class='text-center text-danger'>No matching students</td></tr>"
            );
        } else {
            $("#studentTable .no-match").remove();
        }
    });



    $("#viewBtn").click(function () {


        var selectedBlockName = $("#blockid option:selected").text().trim();
var rooms      = [];
var totalSlots = 0;

        $(".roomChk:checked").each(function () {
            var available = parseInt($(this).data("available")) || 0;
            rooms.push({
                roomId   : $(this).val(),
                roomNo   : $(this).data("roomno"),
                max      : parseInt($(this).data("max"))      || 0,
                occupied : parseInt($(this).data("occupied")) || 0,
                available: available,
                students : []
            });
            totalSlots += available;
        });


        var studentList = [];

        $(".stuChk:checked").each(function () {
            studentList.push({
                registerno   : $(this).val(),
                studentname  : $(this).data("name"),
                applicationno: $(this).data("appno") || '',
                shifttype    : $(this).data("shift")  || ''
            });
        });


        if (rooms.length === 0 || studentList.length === 0) {
            alert("Select at least one room and one student.");
            return;
        }

        if (studentList.length > totalSlots) {
            alert(
                "Selected students (" + studentList.length + ") exceed "
                + "total available beds (" + totalSlots + ")."
            );
            return;
        }

        var shiftMap = {};
        studentList.forEach(function (s) {
            if (s.shifttype && s.shifttype !== '' && s.shifttype !== '-') {
                shiftMap[s.shifttype] = true;
            }
        });

        var shiftKeys = Object.keys(shiftMap);
        if (shiftKeys.length > 1) {
            var proceed = confirm(
                "You have selected students from multiple shifts: "
                + shiftKeys.join(", ") + ".\n\n"
                + "Ideally, same-shift students should share a room.\n\n"
                + "Do you still want to proceed with this mixed allocation?"
            );
            if (!proceed) { return; }
        }

        var stuIndex = 0;
        for (var i = 0; i < rooms.length; i++) {
            for (var j = 0; j < rooms[i].available; j++) {
                if (stuIndex < studentList.length) {
                    rooms[i].students.push(studentList[stuIndex]);
                    stuIndex++;
                }
            }
        }
        var html = "<div class='alert alert-info mb-3'>"
            + "<strong>Total Rooms:</strong> " + rooms.length
            + " &nbsp;|&nbsp; "
            + "<strong>Total Students:</strong> " + studentList.length
            + "</div>";

        for (var i = 0; i < rooms.length; i++) {

            var room = rooms[i];

            html += "<div class='card mb-2'>";
            html += "<div class='card-header bg-light'>"
                +   "<b>Room: " + room.roomNo + "</b>"
                +   " &nbsp;|&nbsp; Capacity: " + room.max
                +   " &nbsp;|&nbsp; Already Occupied: " + room.occupied
                +   " &nbsp;|&nbsp; Assigning: " + room.students.length
                + "</div>";
            html += "<div class='card-body p-2'>";

            if (room.students.length === 0) {
                html += "<span class='text-muted'>No students assigned to this room.</span>";
            } else {
                html += "<table class='table table-sm table-bordered mb-0'>"
    +   "<thead class='table-light'><tr>"
    +   "<th>#</th><th>Application No</th><th>Name</th><th style='display:none'>Block</th><th>Room No</th><th>Shift</th>"
    +   "</tr></thead><tbody>";
                for (var k = 0; k < room.students.length; k++) {
                    var stu = room.students[k];
html += "<tr>"
    + "<td>" + (k + 1) + "</td>"
    + "<td class='applicationno'>" + (stu.applicationno || '') + "</td>"
    + "<td class='studentname'>"   + (stu.studentname   || '') + "</td>"
    + "<td class='blockname'>"     + room.roomNo + "</td>"
    + "<td class='roomno'>"        + room.roomNo + "</td>"
    + "<td>" + (stu.shifttype || '-') + "</td>"
    + "</tr>";
                }
                html += "</tbody></table>";
            }

            html += "</div></div>";
        }


        window._allocationData = rooms;

        $("#previewContent").html(html);
        $("#previewModal").modal("show");
    });


      $("#allocateBtn").click(function () {

        var alloc = window._allocationData;

        if (!alloc || alloc.length === 0) {
            alert("No allocation data. Please use 'View Allocation' first.");
            return;
        }

        if (!confirm("Confirm room allocation? This action cannot be undone.")) {
            return;
        }


        var roomIds      = [];
        var studentRegs  = [];
        var studentNames = [];
        var appNos       = [];
        var shiftTypes   = [];

        for (var i = 0; i < alloc.length; i++) {
            var room = alloc[i];
            for (var k = 0; k < room.students.length; k++) {
                var stu = room.students[k];
                roomIds.push(room.roomId);
                studentRegs.push(stu.registerno);
                studentNames.push(stu.studentname  || '');
                appNos.push(stu.applicationno || '');
                shiftTypes.push(stu.shifttype     || '');
            }
        }

        $("#allocateBtn").prop("disabled", true).text("Allocating...");

        $.post("ajax/allocateRooms.jsp", {
            roomIds     : roomIds,
            studentRegs : studentRegs,
            studentNames: studentNames,
            appNos      : appNos,
            shiftTypes  : shiftTypes
        }, function (res) {

            if (res.success) {

                var count = (res.data && res.data.length) ? res.data.length : roomIds.length;
                alert("Room allocation successful! " + count + " student(s) allocated.");

                $("#previewModal").modal("hide");
                window._allocationData = null;
                clearAllocationUI();

            } else {
                alert("Allocation failed: " + (res.error || "Unknown error"));
            }

        }, "json").fail(function (xhr) {

            alert("Server error during allocation.\n" + xhr.statusText);

        }).always(function () {

            $("#allocateBtn").prop("disabled", false).text("Allocate Rooms");
        });
    });


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
    
    

$("#downloadAllocationPdfBtn").click(function () {

    const { jsPDF } = window.jspdf;

    var allRows = [];

    // Collect from all preview tables inside #previewContent
    $("#previewContent table tbody tr").each(function () {

        var appNo    = $(this).find(".applicationno").text().trim();
        var name     = $(this).find(".studentname").text().trim();
        var block    = $(this).find(".blockname").text().trim();
        var roomNo   = $(this).find(".roomno").text().trim();

        if (appNo !== "" || name !== "") {
            allRows.push([appNo, name, block, roomNo]);
        }
    });

    if (allRows.length === 0) {
        alert("No allocation data to download. Please use 'View Selection' first.");
        return;
    }

    var doc = new jsPDF({ orientation: "portrait", unit: "mm", format: "a4" });


    doc.setFillColor(13, 110, 253);
    doc.rect(0, 0, 210, 22, "F");

    doc.setTextColor(255, 255, 255);
    doc.setFontSize(14);
    doc.setFont("helvetica", "bold");
    doc.text("Room Allocation Report", 14, 14);


    doc.setFontSize(9);
    doc.setFont("helvetica", "normal");
    var now = new Date();
    doc.text("Generated: " + now.toLocaleString(), 14, 28);
    doc.text("Total Students: " + allRows.length, 150, 28);

  
    doc.autoTable({
        startY : 34,
        head   : [["Application No", "Student Name", "Block Name", "Room No"]],
        body   : allRows,
        styles : {
            fontSize     : 9,
            cellPadding  : 3,
            valign       : "middle"
        },
        headStyles : {
            fillColor    : [13, 110, 253],
            textColor    : 255,
            fontStyle    : "bold",
            halign       : "center"
        },
        alternateRowStyles : {
            fillColor : [240, 245, 255]
        },
        columnStyles : {
            0 : { halign: "center", cellWidth: 45 },
            1 : { cellWidth: 70 },
            2 : { cellWidth: 40 },
            3 : { halign: "center", cellWidth: 30 }
        },
        didDrawPage: function (data) {
            
            var pageCount = doc.internal.getNumberOfPages();
            doc.setFontSize(8);
            doc.setTextColor(120);
            doc.text(
                "Page " + data.pageNumber + " of " + pageCount,
                105,
                doc.internal.pageSize.height - 8,
                { align: "center" }
            );
        }
    });

    doc.save("Room_Allocation_Report.pdf");
});
// =========================================
// DOWNLOAD ROOM ALLOCATION PDF
// =========================================

$("#downloadAllocationPdfBtn").click(function () {

    $.ajax({

        url :
            "ajax/downloadAllocationPdf.jsp",

        type : "GET",

        dataType : "json",

        success : function (response) {

            console.log(response);

            if (!response.success) {

                alert(response.message);

                return;
            }

            const { jsPDF } = window.jspdf;

            let doc =
                    new jsPDF();

            let y = 20;

            doc.setFontSize(18);

            doc.text(
                "Room Allocation Report",
                14,
                y);

            y += 15;

            response.blocks.forEach(function(block) {

                doc.setFontSize(14);

                doc.text(
                    "BLOCK : " + block.blockname,
                    14,
                    y);

                y += 10;

                let x = 14;

                block.applications.forEach(function(appno) {

                    doc.roundedRect(
                        x,
                        y,
                        35,
                        10,
                        2,
                        2);

                    doc.setFontSize(10);

                    doc.text(
                        appno,
                        x + 5,
                        y + 6);

                    x += 40;

                    if (x > 160) {

                        x = 14;

                        y += 15;
                    }
                });

                y += 25;

                if (y > 260) {

                    doc.addPage();

                    y = 20;
                }
            });

            doc.save(
                "Room_Allocation_Report.pdf");
        },

        error : function (xhr) {

            console.log(xhr.responseText);

            alert("Server Error");
        }
    });

});
</script>

<jsp:include page="../../lccerpfooter.jsp"/>

<%--

<% } else {%>

session Time out
<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" />

<% }%>

--%>
