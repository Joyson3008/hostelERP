<%-- 
    Document   : allocatedRooms.jsp
    Created on : 25-May-2026, 2:37:54 pm
    Author     : R JOYSON
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // *************** Authentication Block ***************
    String per  = "A";
    String mName = "HOSTEL_ALLOCATED_ROOMS";
%>

<%--<%@ include file="/usermanager/permission.jsp" %>--%>

<%@page import="java.net.InetAddress"%>
<%@page import="java.net.UnknownHostException"%>


<%
    response.setDateHeader("Expires", 0);
    response.addHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.addHeader("Cache-Control", "post-check=0, pre-check=0");
    response.setHeader("Pragma", "no-cache");

    session.setAttribute("login", "true");
    String login  = (String) session.getAttribute("login");
    String userId = (String) session.getAttribute("username");
    String userIp = request.getRemoteAddr();

    if (login != null) {
%>



<%--<jsp:include page="../../lccerpheader.jsp"/>--%>
<link rel="stylesheet" href="../../usermanager/css/bootstrap.min.css">

<style>

    /* ===================================================
       PAGE CHROME
    =================================================== */
    .card-header-primary  { background-color: #0d6efd; color: #fff; }
    .section-title        { font-size: 0.9rem; font-weight: 600; margin-bottom: 8px; }
    .info-label           { font-weight: 600; color: #495057; }

    /* ===================================================
       SUMMARY BADGES
    =================================================== */
    .stat-badge {
        display       : inline-flex;
        flex-direction: column;
        align-items   : center;
        min-width     : 110px;
        padding       : 8px 16px;
        border-radius : 8px;
        font-size     : 0.82rem;
        font-weight   : 600;
        color         : #fff;
    }
    .stat-badge .stat-num {
        font-size  : 1.5rem;
        font-weight: 700;
        line-height: 1.1;
    }
    .stat-badge.bg-rooms    { background-color: #0d6efd; }
    .stat-badge.bg-students { background-color: #6f42c1; }
    .stat-badge.bg-vacant   { background-color: #198754; }

    /* ===================================================
       FLOOR SECTION HEADER
    =================================================== */
    .floor-header {
        background-color: #f0f4ff;
        border-left     : 4px solid #0d6efd;
        padding         : 6px 14px;
        font-size       : 0.95rem;
        font-weight     : 700;
        color           : #0d47a1;
        margin-bottom   : 12px;
        border-radius   : 0 4px 4px 0;
    }

    /* ===================================================
       ROOM CARD LAYOUT
    =================================================== */
    .room-cards-wrap {
        display    : flex;
        flex-wrap  : wrap;
        gap        : 15px;
        margin-bottom: 24px;
    }

    .room-card {
        width        : 220px;
        border       : 2px solid #ccc;
        border-radius: 8px;
        overflow     : hidden;
        box-shadow   : 0 1px 4px rgba(0,0,0,.10);
        background   : #fff;
        font-size    : 0.82rem;
        transition   : box-shadow .15s ease;
    }

    .room-card:hover {
        box-shadow: 0 3px 12px rgba(0,0,0,.18);
    }

    /* Border color by occupancy status */
    .room-card.room-empty   { border-color: #198754; }   /* green  */
    .room-card.room-partial { border-color: #fd7e14; }   /* orange */
    .room-card.room-full    { border-color: #dc3545; }   /* red    */

    /* Room card header stripe */
    .room-card .rc-head {
        padding    : 6px 10px 5px;
        font-weight: 700;
        font-size  : 0.84rem;
        color      : #fff;
    }
    .room-empty   .rc-head { background-color: #198754; }
    .room-partial .rc-head { background-color: #fd7e14; }
    .room-full    .rc-head { background-color: #dc3545; }

    .room-card .rc-meta {
        padding    : 6px 10px 4px;
        border-bottom: 1px solid #e9ecef;
        line-height: 1.55;
        font-size  : 0.79rem;
        color      : #495057;
    }

    .room-card .rc-meta span.lbl { font-weight: 600; }

    /* Student list inside card */
    .room-card .rc-students {
        padding: 5px 10px 8px;
    }

    .room-card .student-row {
        padding      : 4px 0;
        border-bottom: 1px dashed #dee2e6;
        line-height  : 1.45;
    }

    .room-card .student-row:last-child { border-bottom: none; }

    .student-name { font-weight: 600; color: #212529; }
    .student-reg  { color: #6c757d; font-size: 0.76rem; }

    .badge-shift {
        font-size    : 0.70rem;
        padding      : 1px 6px;
        border-radius: 10px;
    }

    /* Empty room placeholder */
    .no-students-msg {
        color      : #adb5bd;
        font-style : italic;
        font-size  : 0.78rem;
        padding    : 4px 0;
    }

    /* ===================================================
       NO DATA / LOADING STATES
    =================================================== */
    #roomDisplay .no-data-msg {
        color      : #6c757d;
        font-style : italic;
        padding    : 30px 0;
        text-align : center;
    }

    /* ===================================================
       HIDDEN FILTER ATTRIBUTE (used by JS search/filter)
    =================================================== */
    .room-card[data-hidden="true"] { display: none !important; }

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
                            <h5 class="mb-0 text-white">Hostel - Allocated Rooms</h5>
                        </div>
                    </div>


                    <!-- ===================================================
                         FILTER ROW
                    =================================================== -->
                    <div class="card mb-3">
                        <div class="card-body py-3">

                            <div class="row align-items-end g-3">

                                <!-- Block -->
                                <div class="col-md-3">
                                    <label class="info-label">Block <span class="text-danger">*</span></label>
                                    <select id="blockid" class="form-control form-select">
                                        <option value="">-- Select Block --</option>
                                    </select>
                                </div>

                                <!-- Search Room -->
                                <div class="col-md-3">
                                    <label class="info-label">Search Room No</label>
                                    <input  type="text"
                                            id="searchRoom"
                                            class="form-control"
                                            placeholder="e.g. 028"
                                            autocomplete="off">
                                </div>

                                <!-- Search Student -->
                                <div class="col-md-3">
                                    <label class="info-label">Search Student Name</label>
                                    <input  type="text"
                                            id="searchStudent"
                                            class="form-control"
                                            placeholder="Enter student name"
                                            autocomplete="off">
                                </div>

                                <!-- Shift Filter -->
                                <div class="col-md-2">
                                    <label class="info-label">Filter by Shift</label>
                                    <select id="shiftFilter" class="form-control form-select">
                                        <option value="ALL">ALL</option>
                                        <option value="SHIFT 1">SHIFT 1</option>
                                        <option value="SHIFT 2">SHIFT 2</option>
                                    </select>
                                </div>

                                <!-- Refresh -->
                                <div class="col-md-1 text-end">
                                    <button class="btn btn-primary w-100" id="refreshBtn"
                                            title="Refresh">
                                        &#8635;
                                    </button>
                                </div>

                            </div>

                        </div>
                    </div>


                    <!-- ===================================================
                         SUMMARY STATS ROW  (hidden until data loads)
                    =================================================== -->
                    <div id="summaryRow" class="mb-3" style="display:none;">
                        <div class="d-flex flex-wrap gap-3 align-items-center">

                            <div class="stat-badge bg-rooms">
                                <span class="stat-num" id="statRooms">0</span>
                                <span>Total Rooms</span>
                            </div>

                            <div class="stat-badge bg-students">
                                <span class="stat-num" id="statStudents">0</span>
                                <span>Total Students</span>
                            </div>

                            <div class="stat-badge bg-vacant">
                                <span class="stat-num" id="statVacant">0</span>
                                <span>Vacant Beds</span>
                            </div>

                            <!-- Legend -->
                            <div class="ms-auto d-flex gap-3 align-items-center
                                        flex-wrap">
                                <span>
                                    <span style="display:inline-block;width:14px;
                                                 height:14px;background:#198754;
                                                 border-radius:3px;
                                                 vertical-align:middle;"></span>
                                    &nbsp;Empty
                                </span>
                                <span>
                                    <span style="display:inline-block;width:14px;
                                                 height:14px;background:#fd7e14;
                                                 border-radius:3px;
                                                 vertical-align:middle;"></span>
                                    &nbsp;Partial
                                </span>
                                <span>
                                    <span style="display:inline-block;width:14px;
                                                 height:14px;background:#dc3545;
                                                 border-radius:3px;
                                                 vertical-align:middle;"></span>
                                    &nbsp;Full
                                </span>
                            </div>

                        </div>
                    </div>


                    <!-- ===================================================
                         ROOM DISPLAY AREA
                    =================================================== -->
                    <div id="roomDisplay">
                        <div class="no-data-msg">
                            &#128205; Please select a Block to view allocated rooms.
                        </div>
                    </div>


                </div>
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
    // STATE
    // =========================================================
    var allRoomsData = [];   // raw JSON from server (room objects)

    // =========================================================
    // ON READY
    // =========================================================
    $(document).ready(function () {
        loadBlocks();
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
    // BLOCK CHANGE  →  load allocated rooms
    // =========================================================
$("#blockid").change(function () {

    var blockname =
            $("#blockid option:selected").text();

    allRoomsData = [];
    resetSummary();
    resetFilters();

    if (!blockname || blockname === "-- Select Block --") {

        $("#roomDisplay").html(
            "<div class='no-data-msg'>"
            + "&#128205; Please select a Block to view allocated rooms."
            + "</div>"
        );

        $("#summaryRow").hide();

        return;
    }

    loadAllocatedRooms(blockname);
});

    // =========================================================
    // REFRESH BUTTON
    // =========================================================
    $("#refreshBtn").click(function () {

        var blockname =
        $("#blockid option:selected").text();

        if (!blockname || blockname === "-- Select Block --") {
            alert("Please select a Block first.");
            return;
        }

        resetFilters();
        loadAllocatedRooms(blockname);
    });

    // =========================================================
    // LOAD ALLOCATED ROOMS  (AJAX)
    // =========================================================
    function loadAllocatedRooms(blockname) {

        $("#roomDisplay").html(
            "<div class='no-data-msg'>"
            + "<div class='spinner-border spinner-border-sm text-primary me-2'></div>"
            + "Loading rooms..."
            + "</div>"
        );

        $.get("ajax/getAllocatedBlocks.jsp",
             { blockname: blockname },
            function (data) {

                if (!data || data.length === 0) {

                    allRoomsData = [];

                    $("#roomDisplay").html(
                        "<div class='no-data-msg'>"
                        + "&#128274; No allocated rooms found for the selected block."
                        + "</div>"
                    );

                    $("#summaryRow").hide();
                    return;
                }

                allRoomsData = data;
                renderAll(data);

            }, "json"
        ).fail(function () {

            allRoomsData = [];

            $("#roomDisplay").html(
                "<div class='no-data-msg text-danger'>"
                + "&#10060; Server error while loading rooms. Please try again."
                + "</div>"
            );

            $("#summaryRow").hide();
        });
    }

    // =========================================================
    // RENDER ALL  (group by floor, then rooms)
    // =========================================================
    function renderAll(data) {

        if (!data || data.length === 0) {
            $("#roomDisplay").html(
                "<div class='no-data-msg'>No rooms to display.</div>"
            );
            $("#summaryRow").hide();
            return;
        }

        // ── Group rooms by floorname  ──────────────────────
        var floors = {};
        var floorOrder = [];

        data.forEach(function (room) {

            var fn = room.floorname || "Unknown Floor";

            if (!floors[fn]) {
                floors[fn] = [];
                floorOrder.push(fn);
            }

            floors[fn].push(room);
        });

        // ── Build HTML  ────────────────────────────────────
        var html = "";

        floorOrder.forEach(function (floorName) {

            var rooms = floors[floorName];

            html += "<div class='floor-section' data-floor='"
                  + escHtml(floorName) + "'>";

            html += "<div class='floor-header'>"
                  + "&#9776;&nbsp;" + escHtml(floorName)
                  + " &nbsp;<small class='fw-normal text-muted'>("
                  + rooms.length + " room" + (rooms.length !== 1 ? "s" : "") + ")"
                  + "</small></div>";

            html += "<div class='room-cards-wrap'>";

            rooms.forEach(function (room) {
                html += buildRoomCard(room);
            });

            html += "</div>";   // .room-cards-wrap
            html += "</div>";   // .floor-section
        });

        $("#roomDisplay").html(html);

        // ── Update summary stats  ──────────────────────────
        updateSummary(data);

        $("#summaryRow").show();
    }

    // =========================================================
    // BUILD ROOM CARD HTML
    // =========================================================
    function buildRoomCard(room) {

        var current = parseInt(room.currentoccupancy) || 0;
        var total   = parseInt(room.totaloccupancy)   || 0;
        var vacant  = parseInt(room.availablebeds)    || 0;
        var students = room.students || [];

        // ── Occupancy class  ──────────────────────────────
        var statusClass = "room-empty";

        if (current >= total && total > 0) {
            statusClass = "room-full";
        } else if (current > 0) {
            statusClass = "room-partial";
        }

        // ── Collect shifts for data attribute (filtering)  ─
        var shiftAttr = "-";

        if (students.length > 0) {
            var shifts = students.map(function (s) {
                return (s.shifttype || "-").toUpperCase();
            });

            // Unique shifts
            shifts = shifts.filter(function (v, i, a) {
                return a.indexOf(v) === i;
            });

            shiftAttr = shifts.join(",");
        }

        // ── Room card wrapper  ────────────────────────────
        var html = "<div class='room-card " + statusClass + "'"
                 + " data-roomno='"    + escHtml(room.roomno || "") + "'"
                 + " data-roomid='"   + (room.roomid || 0) + "'"
                 + " data-shifts='"   + shiftAttr + "'"
                 + " data-studnames='" + escHtml(
                       students.map(function (s) {
                           return s.studentname || "";
                       }).join("|").toLowerCase()
                   ) + "'"
                 + " data-hidden='false'"
                 + ">";

        // Header
        html += "<div class='rc-head'>"
              + "Room : " + escHtml(room.roomno || "—")
              + "</div>";

        // Meta
        html += "<div class='rc-meta'>"
              + "<span class='lbl'>Occupancy</span> : " + current + " / " + total + "<br>"
              + "<span class='lbl'>Available</span>  : " + vacant + "<br>"
              + "<span class='lbl'>Type</span>       : " + escHtml(room.roomtype || "—")
              + "</div>";

        // Students
        html += "<div class='rc-students'>";

        if (students.length === 0) {

            html += "<div class='no-students-msg'>No students allocated</div>";

        } else {

            students.forEach(function (s) {

                var shift    = (s.shifttype || "-").toUpperCase();
                var badgeCls = (shift === "SHIFT 1") ? "bg-primary"
                             : (shift === "SHIFT 2") ? "bg-success"
                             : "bg-secondary";

                html += "<div class='student-row'>"
                      + "<div class='student-name'>"
                      +     escHtml(s.studentname || "—")
                      + "</div>"
                      + "<div class='student-reg'>"
                      +     escHtml(s.registerno || "")
                      + "</div>"
                      + "<span class='badge " + badgeCls + " badge-shift'>"
                      +     shift
                      + "</span>"
                      + "</div>";
            });
        }

        html += "</div>";   // .rc-students
        html += "</div>";   // .room-card

        return html;
    }

    // =========================================================
    // UPDATE SUMMARY STATS
    // =========================================================
    function updateSummary(data) {

        var totalRooms    = data.length;
        var totalStudents = 0;
        var totalVacant   = 0;

        data.forEach(function (room) {
            totalStudents += (room.students || []).length;
            totalVacant   += parseInt(room.availablebeds) || 0;
        });

        $("#statRooms").text(totalRooms);
        $("#statStudents").text(totalStudents);
        $("#statVacant").text(totalVacant);
    }
  // =========================================================
    // LIVE SEARCH  &  FILTER
    // =========================================================

    // ── Search by room number  ────────────────────────────
    $("#searchRoom").on("input", function () {
        applyFilters();
    });

    // ── Search by student name  ───────────────────────────
    $("#searchStudent").on("input", function () {
        applyFilters();
    });

    // ── Shift filter  ─────────────────────────────────────
    $("#shiftFilter").change(function () {
        applyFilters();
    });

    function applyFilters() {

        var roomSearch  = $("#searchRoom").val().trim().toLowerCase();
        var studSearch  = $("#searchStudent").val().trim().toLowerCase();
        var shiftFilter = $("#shiftFilter").val();   // ALL / SHIFT 1 / SHIFT 2

        var visibleRooms    = 0;
        var visibleStudents = 0;
        var visibleVacant   = 0;

        $(".room-card").each(function () {

            var $card      = $(this);
            var roomno     = ($card.data("roomno") + "").toLowerCase();
            var studNames  = ($card.data("studnames") + "").toLowerCase();
            var shifts     = ($card.data("shifts") + "").toUpperCase();

            var roomMatch  = !roomSearch  || roomno.indexOf(roomSearch)   !== -1;
            var studMatch  = !studSearch  || studNames.indexOf(studSearch) !== -1;

            var shiftMatch = true;

            if (shiftFilter !== "ALL") {
                // Card must contain at least one student with matching shift
                shiftMatch = shifts.indexOf(shiftFilter.toUpperCase()) !== -1;
            }

            var visible = roomMatch && studMatch && shiftMatch;

            $card.attr("data-hidden", visible ? "false" : "true");

            if (visible) {

                var roomidVal = parseInt($card.data("roomid")) || 0;

                // Find matching room in allRoomsData for accurate counts
                allRoomsData.forEach(function (room) {
                    if (parseInt(room.roomid) === roomidVal) {
                        visibleRooms++;
                        visibleStudents += (room.students || []).length;
                        visibleVacant   += parseInt(room.availablebeds) || 0;
                    }
                });
            }
        });

        // Update stats to reflect visible cards only
        if (roomSearch || studSearch || shiftFilter !== "ALL") {
            $("#statRooms").text(visibleRooms);
            $("#statStudents").text(visibleStudents);
            $("#statVacant").text(visibleVacant);
        } else {
            // No filter — show full totals
            updateSummary(allRoomsData);
        }

        // Hide floor section if all its cards are hidden
        $(".floor-section").each(function () {

            var anyVisible = $(this).find(".room-card[data-hidden='false']").length > 0;

            $(this).toggle(anyVisible);
        });
    }

    // =========================================================
    // HELPERS
    // =========================================================

    function resetSummary() {
        $("#statRooms").text("0");
        $("#statStudents").text("0");
        $("#statVacant").text("0");
        $("#summaryRow").hide();
    }

    function resetFilters() {
        $("#searchRoom").val("");
        $("#searchStudent").val("");
        $("#shiftFilter").val("ALL");
    }

    // Escape HTML special characters for safe injection
    function escHtml(str) {
        if (!str) { return ""; }
        return String(str)
            .replace(/&/g,  "&amp;")
            .replace(/</g,  "&lt;")
            .replace(/>/g,  "&gt;")
            .replace(/"/g,  "&quot;")
            .replace(/'/g,  "&#39;");
    }

</script>


<%--<jsp:include page="../../lccerpfooter.jsp"/>--%>
<%
    }
%>
