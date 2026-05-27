<%-- 
    Document   : roomChange.jsp
    Created on : 25-May-2026, 1:03:22 pm
    Author     : R JOYSON
--%>


<%
    // *************** Authentication Block ***************
    String per = "A";
    String mName = "HOSTEL_ROOM_CHANGE";
%>

<%--<%@ include file="/usermanager/permission.jsp" %>--%>

<%@page import="java.net.InetAddress"%>
<%@page import="java.net.UnknownHostException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    response.setDateHeader("Expires", 0);
    response.addHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.addHeader("Cache-Control", "post-check=0, pre-check=0");
    response.setHeader("Pragma", "no-cache");

    session.setAttribute("login","true");
    String login     = (String) session.getAttribute("login");
    String userId    = (String) session.getAttribute("username");
    String userIp    = request.getRemoteAddr();

    if (login != null) {
%>



<%--<jsp:include page="../../lccerpheader.jsp"/>--%>
<link rel="stylesheet" href="../../usermanager/css/bootstrap.min.css">

<style>
    .card-header-primary { background-color: #0d6efd; color: #fff; }
    .section-title       { font-size: 0.9rem; font-weight: 600; margin-bottom: 8px; }
    .info-label          { font-weight: 600; color: #495057; }
    .badge-shift         { font-size: 0.8rem; }
    .arrow-icon          { font-size: 1.4rem; color: #6c757d; }

    /* Scrollable student / room tables */
    .scroll-table        { max-height: 380px; overflow-y: auto; }

    /* Highlight selected room row */
    .room-selected td    { background-color: #d1e7dd !important; }

    /* Current allocation card */
    #currentAllocationCard { display: none; }
</style>

<div class="pcoded-content">
    <div class="pcoded-inner-content">
        <div class="main-body">
            <div class="page-wrapper">
                <div class="page-body">

                    <!-- ===================================================
                         PAGE HEADER
                    =================================================== -->
                    <div class="card mb-3">
                        <div class="card-header card-header-primary">
                            <h5 class="mb-0 text-white">Hostel Room Change / Transfer</h5>
                        </div>
                    </div>

                    <!-- ===================================================
                         TOP ROW: Search (LEFT) | New Room Selection (RIGHT)
                    =================================================== -->
                    <div class="row">

                        <!-- =================== LEFT PANEL =================== -->
                        <div class="col-md-5">

                            <!-- Search Card -->
                            <div class="card mb-3">
                                <div class="card-header bg-secondary text-white py-2">
                                    <span class="section-title mb-0 text-white">Search Allocated Student</span>
                                </div>
                                <div class="card-body">

                                    <div class="input-group">
                                        <input  type="text"
                                                id="searchInput"
                                                class="form-control"
                                                placeholder="Register No / Application No / Name"
                                                autocomplete="off">
                                        <button class="btn btn-primary" id="searchBtn">
                                            <i class="feather icon-search"></i> Search
                                        </button>
                                    </div>

                                    <small class="text-muted">Search among students who already have a room allocated.</small>

                                </div>
                            </div>

                            <!-- Current Allocation Display Card (hidden until search) -->
                            <div class="card" id="currentAllocationCard">
                                <div class="card-header bg-info text-white py-2">
                                    <span class="section-title mb-0 text-white">Current Room Details</span>
                                </div>
                                <div class="card-body p-3" id="currentAllocationBody">
                                    <!-- Filled by JS -->
                                </div>
                            </div>

                        </div>

                        <!-- =================== RIGHT PANEL =================== -->
                        <div class="col-md-7">

                            <div class="card mb-3">
                                <div class="card-header card-header-primary py-2">
                                    <span class="section-title mb-0 text-white">Select New Room</span>
                                </div>
                                <div class="card-body">

                                    <div class="row mb-2">
                                        <div class="form-group col-md-6">
                                            <label class="info-label">Block</label>
                                            <select id="blockid" class="form-control form-select">
                                                <option value="">-- Select Block --</option>
                                            </select>
                                        </div>
                                        <div class="form-group col-md-6">
                                            <label class="info-label">Floor</label>
                                            <select id="floorid" class="form-control form-select">
                                                <option value="0">-- Select Floor --</option>
                                            </select>
                                        </div>
                                    </div>

                                    <!-- Available Rooms Table -->
                                    <div class="section-title">Available Rooms</div>
                                    <div class="scroll-table table-responsive">
                                        <table class="table table-bordered table-sm table-hover mb-0">
                                            <thead class="table-light sticky-top">
                                                <tr>
                                                    <th>Select</th>
                                                    <th>Room No</th>
                                                    <th>Capacity</th>
                                                    <th>Occupied</th>
                                                    <th>Available</th>
                                                </tr>
                                            </thead>
                                            <tbody id="roomTable">
                                                <tr>
                                                    <td colspan="5" class="text-center text-muted">
                                                        Select Block and Floor to load rooms
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                </div>
                            </div>

                        </div>
                        <!-- END RIGHT PANEL -->

                    </div>
                    <!-- END TOP ROW -->

                    <!-- ===================================================
                         ACTION BUTTONS
                    =================================================== -->
                    <div class="text-center mt-2 mb-4">
                        <button class="btn btn-warning me-2" id="previewBtn">
                            &#128065; Preview Room Change
                        </button>
                        <button class="btn btn-secondary" id="clearBtn">
                            &#10006; Clear
                        </button>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<!-- ===================================================
     PREVIEW MODAL
=================================================== -->
<div class="modal fade" id="previewModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">

            <div class="modal-header bg-warning">
                <h5 class="modal-title">&#9888; Confirm Room Change</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <div id="previewContent"></div>
            </div>

            <div class="modal-footer">
                <button class="btn btn-success" id="confirmChangeBtn">
                    &#10003; Confirm Change
                </button>
                <button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>

        </div>
    </div>
</div>

<!-- ===================================================
     SCRIPTS
=================================================== -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>

    // =========================================================
    // STATE — holds data for the currently found student
    // =========================================================
    var currentStudent = null;   // JSON object from getAllocatedStudent.jsp
    var selectedRoom   = null;   // JSON object from the room table row

    // =========================================================
    // ON READY
    // =========================================================
    $(document).ready(function () {
        loadBlocks();

        // Allow pressing Enter in search box
        $("#searchInput").on("keypress", function (e) {
            if (e.which === 13) { $("#searchBtn").trigger("click"); }
        });
    });

    // =========================================================
    // LOAD BLOCKS
    // =========================================================
    function loadBlocks() {
        $.get("ajax/getBlocks.jsp", function (res) {
            var html = "<option value=''>-- Select Block --</option>";
            res.forEach(function (row) {
                html += "<option value='" + row.blockid + "'>"
                      + row.blockname + "</option>";
            });
            $("#blockid").html(html);
        }, "json").fail(function () {
            console.error("Failed to load blocks");
        });
    }

    // =========================================================
    // BLOCK CHANGE → load floors
    // =========================================================
    $("#blockid").change(function () {
        var blockid = $(this).val();

        $("#floorid").html("<option value='0'>-- Select Floor --</option>");
        clearRoomTable("Select Floor to view rooms");
        selectedRoom = null;

        if (!blockid) { return; }

        $.get("ajax/getFloors.jsp", { blockid: blockid }, function (res) {
            var html = "<option value='0'>All Floors</option>";
            res.forEach(function (row) {
                html += "<option value='" + row.floorid + "'>"
                      + row.floorname + "</option>";
            });
            $("#floorid").html(html);
            loadAvailableRooms();
        }, "json");
    });

    // =========================================================
    // FLOOR CHANGE → load rooms
    // =========================================================
    $("#floorid").change(function () {
        selectedRoom = null;
        loadAvailableRooms();
    });

    // =========================================================
    // LOAD AVAILABLE ROOMS
    // =========================================================
    function loadAvailableRooms() {
        var blockid = $("#blockid").val();
        var floorid = $("#floorid").val() || 0;

        if (!blockid) {
            clearRoomTable("Select Block first");
            return;
        }

        clearRoomTable("Loading...");

        $.get("ajax/getAvailableRooms.jsp",
            { blockid: blockid, floorid: floorid },
            function (data) {

                $("#roomTable").empty();

                if (!data || data.length === 0) {
                    clearRoomTable("No rooms with available beds in this selection");
                    return;
                }

                data.forEach(function (d) {
                    var roomno = d.roomno || d.roomname || "";
                    var max      = d.totaloccupancy    || d.max_noofoccupants || 0;
                    var occupied = d.currentoccupancy  || d.no_of_occupants   || 0;
                    var avail    = d.availablebeds     || (max - occupied)    || 0;

                    var row = "<tr class='room-row' style='cursor:pointer;'>"
                        + "<td class='text-center'>"
                        +   "<input type='radio' name='roomRadio' class='roomRadio'"
                        +   " value='" + d.roomid + "'"
                        +   " data-roomno='"   + roomno   + "'"
                        +   " data-max='"      + max      + "'"
                        +   " data-occupied='" + occupied + "'"
                        +   " data-available='" + avail   + "'"
                        +   ">"
                        + "</td>"
                        + "<td>" + roomno   + "</td>"
                        + "<td>" + max      + "</td>"
                        + "<td>" + occupied + "</td>"
                        + "<td><span class='badge bg-success'>" + avail + "</span></td>"
                        + "</tr>";

                    $("#roomTable").append(row);
                });

                // Clicking entire row selects the radio
                $("#roomTable .room-row").on("click", function () {
                    $(this).find(".roomRadio").prop("checked", true).trigger("change");
                });

                $(".roomRadio").on("change", function () {
                    $(".room-row").removeClass("room-selected");
                    $(this).closest("tr").addClass("room-selected");

                    selectedRoom = {
                        roomId   : $(this).val(),
                        roomNo   : $(this).data("roomno"),
                        max      : parseInt($(this).data("max"))      || 0,
                        occupied : parseInt($(this).data("occupied")) || 0,
                        available: parseInt($(this).data("available"))|| 0
                    };
                });

            }, "json"
        ).fail(function () {
            clearRoomTable("Failed to load rooms — server error");
        });
    }

    function clearRoomTable(msg) {
        $("#roomTable").html(
            "<tr><td colspan='5' class='text-center text-muted'>" + msg + "</td></tr>"
        );
    }

    // =========================================================
    // SEARCH STUDENT
    // =========================================================
    $("#searchBtn").click(function () {
        var query = $.trim($("#searchInput").val());

        if (!query) {
            alert("Please enter a Register No, Application No, or Student Name to search.");
            return;
        }

        currentStudent = null;
        selectedRoom   = null;
        $("#currentAllocationCard").hide();
        $("#currentAllocationBody").html(
            "<div class='text-center text-muted'>Searching...</div>"
        );
        $("#currentAllocationCard").show();

        $.get("ajax/getAllocatedStudent.jsp", { searchText: query }, function (res) {

            if (!res || res.error) {
                $("#currentAllocationBody").html(
                    "<div class='alert alert-warning mb-0'>"
                    + (res ? res.error : "Student not found.")
                    + "</div>"
                );
                return;
            }

            currentStudent = res;
            renderCurrentAllocation(res);

        }, "json").fail(function () {
            $("#currentAllocationBody").html(
                "<div class='alert alert-danger mb-0'>Server error while searching.</div>"
            );
        });
    });

    // =========================================================
    // RENDER CURRENT ALLOCATION DETAILS
    // =========================================================
    function renderCurrentAllocation(s) {

        var shiftBadge = s.shifttype && s.shifttype !== '-'
            ? "<span class='badge bg-primary badge-shift'>" + s.shifttype + "</span>"
            : "<span class='badge bg-secondary badge-shift'>Unknown</span>";

        var html = ""
            + "<table class='table table-sm table-borderless mb-0'>"
            + "<tbody>"
            + row2col("Register No",    s.registerno)
            + row2col("Application No", s.applicationno)
            + row2col("Student Name",   "<strong>" + (s.studentname || "") + "</strong>")
            + row2col("Shift",          shiftBadge)
            + "<tr><td colspan='2'><hr class='my-1'></td></tr>"
            + row2col("Current Block",  s.blockname  || "<span class='text-muted'>—</span>")
            + row2col("Current Floor",  s.floorname  || "<span class='text-muted'>—</span>")
            + row2col("Current Room",   s.roomname   || "<span class='text-muted'>—</span>")
            + row2col("Occupancy",      (s.no_of_occupants || 0) + " / " + (s.max_noofoccupants || 0))
            + "</tbody></table>";

        $("#currentAllocationBody").html(html);
        $("#currentAllocationCard").show();
    }

    function row2col(label, value) {
        return "<tr>"
            + "<td class='info-label' style='width:45%'>" + label + "</td>"
            + "<td>" + (value !== null && value !== undefined ? value : "<span class='text-muted'>—</span>") + "</td>"
            + "</tr>";
    }

    // =========================================================
    // PREVIEW BUTTON
    // =========================================================
    $("#previewBtn").click(function () {

        // --- Validate student
        if (!currentStudent) {
            alert("Please search and select a student first.");
            return;
        }

        // --- Validate new room
        if (!selectedRoom) {
            alert("Please select a new room from the right panel.");
            return;
        }

        // --- Same room check
        if (parseInt(selectedRoom.roomId) === parseInt(currentStudent.roomid)) {
            alert("The selected room is the same as the student's current room. Please choose a different room.");
            return;
        }

        // --- Available beds check
        if (selectedRoom.available < 1) {
            alert("The selected room has no available beds.");
            return;
        }

        // --- Build preview HTML
        var html = ""

            // Student info
            + "<div class='alert alert-secondary mb-3'>"
            + "<strong>Student:</strong> "
            + (currentStudent.studentname || "") + "&nbsp;&nbsp;"
            + "<span class='text-muted'>" + (currentStudent.registerno || "") + "</span>"
            + "</div>"

            // Transfer direction
            + "<div class='row text-center'>"

            +   "<div class='col-md-5'>"
            +     "<div class='card border-danger'>"
            +       "<div class='card-header bg-danger text-white py-1'>FROM (Current Room)</div>"
            +       "<div class='card-body py-2'>"
            +         "<p class='mb-1'><strong>Block:</strong> "  + (currentStudent.blockname || "—") + "</p>"
            +         "<p class='mb-1'><strong>Floor:</strong> "  + (currentStudent.floorname || "—") + "</p>"
            +         "<p class='mb-0'><strong>Room:</strong> "   + (currentStudent.roomname  || "—") + "</p>"
            +       "</div>"
            +     "</div>"
            +   "</div>"

            +   "<div class='col-md-2 d-flex align-items-center justify-content-center'>"
            +     "<span class='arrow-icon'>&#10142;</span>"
            +   "</div>"

            +   "<div class='col-md-5'>"
            +     "<div class='card border-success'>"
            +       "<div class='card-header bg-success text-white py-1'>TO (New Room)</div>"
            +       "<div class='card-body py-2'>"
            +         "<p class='mb-1'><strong>Block:</strong> " + ($("#blockid option:selected").text()) + "</p>"
            +         "<p class='mb-1'><strong>Floor:</strong> " + ($("#floorid option:selected").text()) + "</p>"
            +         "<p class='mb-0'><strong>Room:</strong> "  + selectedRoom.roomNo + "</p>"
            +       "</div>"
            +     "</div>"
            +   "</div>"

            + "</div>"

            + "<div class='alert alert-warning mt-3 mb-0'>"
            + "&#9888; This action will update the student's room allocation. "
            + "The old room occupancy will decrease by 1 and the new room occupancy will increase by 1."
            + "</div>";

        $("#previewContent").html(html);
        $("#previewModal").modal("show");
    });

    // =========================================================
    // CONFIRM ROOM CHANGE
    // =========================================================
    $("#confirmChangeBtn").click(function () {

        if (!currentStudent || !selectedRoom) {
            alert("Missing data. Please start over.");
            return;
        }

        if (!confirm("Are you sure you want to transfer "
                + currentStudent.studentname
                + " to Room " + selectedRoom.roomNo + "?")) {
            return;
        }

        $("#confirmChangeBtn").prop("disabled", true).text("Processing...");

        $.post("ajax/changeRoom.jsp", {
            registerno : currentStudent.registerno,
            oldRoomId  : currentStudent.roomid,
            newRoomId  : selectedRoom.roomId
        }, function (res) {

            if (res && res.success) {
                alert("Room change successful!\n"
                    + currentStudent.studentname
                    + " has been moved to Room " + selectedRoom.roomNo + ".");

                // Close modal and reset UI
                $("#previewModal").modal("hide");
                clearAll();

            } else {
                alert("Room change failed: " + (res ? res.error : "Unknown error"));
            }

        }, "json").fail(function (xhr) {
            alert("Server error: " + xhr.statusText);
        }).always(function () {
            $("#confirmChangeBtn").prop("disabled", false).text("✓ Confirm Change");
        });
    });

    // =========================================================
    // CLEAR BUTTON
    // =========================================================
    $("#clearBtn").click(function () {
        clearAll();
    });

    function clearAll() {
        currentStudent = null;
        selectedRoom   = null;

        $("#searchInput").val("");
        $("#currentAllocationCard").hide();
        $("#currentAllocationBody").html("");

        $("#blockid").val("");
        $("#floorid").html("<option value='0'>-- Select Floor --</option>");
        clearRoomTable("Select Block and Floor to load rooms");
    }

</script>

<%--<jsp:include page="../../lccerpfooter.jsp"/>--%>
<%
    }
%>