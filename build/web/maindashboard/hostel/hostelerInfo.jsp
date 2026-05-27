<%-- 
    Document   : hostelerInfo
    Created on : 25-May-2026, 4:10:20 pm
    Author     : R JOYSON
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hosteler Information</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        /* ── ROOT PALETTE ─────────────────────────────────── */
        :root {
            --erp-blue:        #1a3f6f;
            --erp-blue-mid:    #1e4f8c;
            --erp-blue-light:  #2d6cc0;
            --erp-accent:      #f0f6ff;
            --erp-border:      #cde0f7;
            --erp-header-bg:   #1a3f6f;
            --erp-sidebar-bg:  #1e4f8c;
            --sidebar-width:   210px;
            --right-width:     320px;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            font-size: 13px;
            background: #eaf2fb;
            color: #222;
        }

        /* ── TOP NAV BAR ──────────────────────────────────── */
        .erp-topbar {
            background: var(--erp-header-bg);
            color: #fff;
            padding: 6px 16px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 999;
            box-shadow: 0 2px 6px rgba(0,0,0,.35);
        }
        .erp-topbar .brand {
            font-size: 15px;
            font-weight: 700;
            letter-spacing: .5px;
        }
        .erp-topbar .topbar-links a {
            color: #cde0f7;
            text-decoration: none;
            margin-left: 14px;
            font-size: 12px;
        }
        .erp-topbar .topbar-links a:hover { color: #fff; }

        /* ── PAGE TITLE STRIP ─────────────────────────────── */
        .page-title-strip {
            background: #d6e8fa;
            border-bottom: 2px solid var(--erp-border);
            padding: 6px 18px;
            font-weight: 700;
            font-size: 13px;
            color: var(--erp-blue);
            letter-spacing: .3px;
        }

        /* ── SEARCH BAR ───────────────────────────────────── */
        .search-bar-section {
            background: #fff;
            padding: 10px 18px;
            border-bottom: 1px solid var(--erp-border);
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }
        .search-bar-section label {
            font-weight: 600;
            color: var(--erp-blue);
            white-space: nowrap;
            font-size: 12.5px;
        }
        .search-bar-section input[type="text"] {
            border: 1.5px solid var(--erp-blue-light);
            border-radius: 5px;
            padding: 5px 10px;
            font-size: 13px;
            width: 280px;
            outline: none;
            transition: border .2s;
        }
        .search-bar-section input[type="text"]:focus {
            border-color: var(--erp-blue);
            box-shadow: 0 0 0 2px rgba(26,63,111,.15);
        }
        .btn-search {
            background: var(--erp-blue);
            color: #fff;
            border: none;
            border-radius: 5px;
            padding: 5px 18px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: background .2s;
        }
        .btn-search:hover { background: var(--erp-blue-light); }
        .btn-clear {
            background: #6c757d;
            color: #fff;
            border: none;
            border-radius: 5px;
            padding: 5px 14px;
            font-size: 13px;
            cursor: pointer;
        }
        .btn-clear:hover { background: #5a6268; }

        /* ── MAIN 3-COLUMN LAYOUT ─────────────────────────── */
        .main-wrapper {
            display: flex;
            height: calc(100vh - 115px);
            overflow: hidden;
        }

        /* ── LEFT SIDEBAR ─────────────────────────────────── */
        .sidebar {
            width: var(--sidebar-width);
            min-width: var(--sidebar-width);
            background: var(--erp-sidebar-bg);
            overflow-y: auto;
            flex-shrink: 0;
        }
        .sidebar-menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .sidebar-menu li a {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 11px 16px;
            color: #cde0f7;
            text-decoration: none;
            font-size: 12.5px;
            border-bottom: 1px solid rgba(255,255,255,.08);
            transition: background .18s, color .18s;
        }
        .sidebar-menu li a:hover {
            background: rgba(255,255,255,.14);
            color: #fff;
        }
        .sidebar-menu li a.active {
            background: #fff;
            color: var(--erp-blue);
            font-weight: 700;
            border-left: 4px solid #f0a500;
        }
        .sidebar-menu li a i { font-size: 14px; width: 18px; }

        /* ── CENTER CONTENT ───────────────────────────────── */
        .content-area {
            flex: 1;
            overflow-y: auto;
            padding: 14px 16px;
            background: #eaf2fb;
        }

        /* ── RIGHT PANEL ──────────────────────────────────── */
        .right-panel {
            width: var(--right-width);
            min-width: var(--right-width);
            background: #fff;
            border-left: 2px solid var(--erp-border);
            overflow-y: auto;
            padding: 14px 12px;
            flex-shrink: 0;
        }

        /* ── CARD STYLES ──────────────────────────────────── */
        .erp-card {
            background: #fff;
            border: 1px solid var(--erp-border);
            border-radius: 7px;
            margin-bottom: 14px;
            overflow: hidden;
            box-shadow: 0 1px 4px rgba(26,63,111,.07);
        }
        .erp-card-header {
            background: var(--erp-blue);
            color: #fff;
            padding: 7px 14px;
            font-weight: 700;
            font-size: 12.5px;
            display: flex;
            align-items: center;
            gap: 7px;
        }
        .erp-card-body { padding: 10px 14px; }

        /* ── INFO TABLE ───────────────────────────────────── */
        .info-table {
            width: 100%;
            border-collapse: collapse;
        }
        .info-table tr td {
            padding: 5px 8px;
            border-bottom: 1px solid #e8f0fb;
            vertical-align: top;
            font-size: 12.5px;
        }
        .info-table tr:last-child td { border-bottom: none; }
        .info-table td.lbl {
            width: 42%;
            color: #555;
            font-weight: 600;
            white-space: nowrap;
        }
        .info-table td.val {
            color: #1a1a1a;
        }
        .info-table tr:hover { background: #f5f9ff; }

        /* ── STATUS BADGE ─────────────────────────────────── */
        .badge-active {
            display: inline-block;
            background: #198754;
            color: #fff;
            border-radius: 12px;
            padding: 2px 12px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: .5px;
        }
        .badge-inactive {
            display: inline-block;
            background: #dc3545;
            color: #fff;
            border-radius: 12px;
            padding: 2px 12px;
            font-size: 11px;
            font-weight: 700;
        }

        /* ── PHOTO BOX ────────────────────────────────────── */
        .photo-box {
            text-align: center;
            margin-bottom: 12px;
        }
        .photo-box img {
            width: 110px;
            height: 130px;
            object-fit: cover;
            border: 3px solid var(--erp-blue);
            border-radius: 6px;
            background: #dde8f8;
        }
        .status-bar {
            margin-top: 6px;
            text-align: center;
        }

        /* ── ROOM DETAIL TABLE ────────────────────────────── */
        .room-detail-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 12px;
        }
        .room-detail-table th {
            background: var(--erp-accent);
            color: var(--erp-blue);
            font-weight: 700;
            padding: 5px 7px;
            border: 1px solid var(--erp-border);
            text-align: left;
        }
        .room-detail-table td {
            padding: 5px 7px;
            border: 1px solid var(--erp-border);
            color: #222;
        }
        .room-detail-table tr:hover { background: #f5f9ff; }

        /* ── PLACEHOLDER / EMPTY STATE ────────────────────── */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #888;
        }
        .empty-state i { font-size: 52px; color: #cde0f7; }
        .empty-state p { margin-top: 12px; font-size: 14px; }

        /* ── SPINNER ──────────────────────────────────────── */
        .spinner-wrap {
            text-align: center;
            padding: 40px;
            display: none;
        }

        /* ── ALERT ────────────────────────────────────────── */
        .erp-alert {
            padding: 9px 14px;
            border-radius: 5px;
            font-size: 12.5px;
            margin-bottom: 10px;
        }
        .erp-alert-danger  { background: #fdecea; color: #b71c1c; border: 1px solid #f5c6cb; }
        .erp-alert-success { background: #e8f5e9; color: #1b5e20; border: 1px solid #c3e6cb; }

        /* ── RESPONSIVE ───────────────────────────────────── */
        @media (max-width: 900px) {
            .right-panel { display: none; }
            :root { --sidebar-width: 44px; }
            .sidebar-menu li a span { display: none; }
        }
    </style>
</head>
<body>

<!-- ════════════════════════════════════════════════════════
     TOP NAV BAR
═══════════════════════════════════════════════════════════ -->
<div class="erp-topbar">
    <div class="brand">
        <i class="bi bi-building"></i> LOYOLA HOSTEL ERP
    </div>
    <div class="topbar-links">
        <a href="#">Home</a>
        <a href="#">Menu</a>
        <a href="#">Favorites menu</a>
        <a href="#">Logout</a>
        <a href="#" style="color:#f0a500; font-weight:700;">LOYOLA HOSTEL</a>
    </div>
</div>

<!-- ════════════════════════════════════════════════════════
     PAGE TITLE
═══════════════════════════════════════════════════════════ -->
<div class="page-title-strip">
    <i class="bi bi-person-badge"></i>&nbsp; HOSTELER INFORMATION
</div>

<!-- ════════════════════════════════════════════════════════
     SEARCH BAR
═══════════════════════════════════════════════════════════ -->
<div class="search-bar-section">
    <label for="searchInput">
        <i class="bi bi-search"></i> Member Name / Reg No / App No :
    </label>
    <input type="text" id="searchInput" placeholder="Enter Register No / Application No / Student Name"
           onkeydown="if(event.key==='Enter') searchHosteler()">
    <button class="btn-search" onclick="searchHosteler()">
        <i class="bi bi-search"></i> Search
    </button>
    <button class="btn-clear" onclick="clearSearch()">
        <i class="bi bi-x-circle"></i> Clear
    </button>
    <span id="searchStatus" style="font-size:12px; color:#666;"></span>
</div>

<!-- ════════════════════════════════════════════════════════
     MAIN 3-COLUMN LAYOUT
═══════════════════════════════════════════════════════════ -->
<div class="main-wrapper">

    <!-- ── LEFT SIDEBAR ──────────────────────────────────── -->
    <nav class="sidebar">
        <ul class="sidebar-menu" id="sidebarMenu">

            <li>
                <a href="#" class="active" onclick="setActiveMenu(this, 'personalDetails'); return false;">
                    <i class="bi bi-person-lines-fill"></i>
                    <span>Personal Details</span>
                </a>
            </li>
            <li>
                <a href="#" onclick="setActiveMenu(this, 'financeDetails'); return false;">
                    <i class="bi bi-cash-coin"></i>
                    <span>Finance Details</span>
                </a>
            </li>
            <li>
                <a href="#" onclick="setActiveMenu(this, 'outstandingAdjustments'); return false;">
                    <i class="bi bi-exclamation-triangle"></i>
                    <span>Outstanding Adjustments</span>
                </a>
            </li>
            <li>
                <a href="#" onclick="setActiveMenu(this, 'printChallan'); return false;">
                    <i class="bi bi-printer"></i>
                    <span>Print Challan</span>
                </a>
            </li>
            <li>
                <a href="#" onclick="setActiveMenu(this, 'messBills'); return false;">
                    <i class="bi bi-receipt"></i>
                    <span>Mess Bills</span>
                </a>
            </li>
            <li>
                <a href="#" onclick="setActiveMenu(this, 'creditsDebits'); return false;">
                    <i class="bi bi-bar-chart-line"></i>
                    <span>Student Wise Credits &amp; Debits</span>
                </a>
            </li>
            <li>
                <a href="#" onclick="setActiveMenu(this, 'hostelAdvance'); return false;">
                    <i class="bi bi-wallet2"></i>
                    <span>Hostel Advance/Adjustments</span>
                </a>
            </li>
            <li>
                <a href="#" onclick="setActiveMenu(this, 'hostelAttendance'); return false;">
                    <i class="bi bi-calendar-check"></i>
                    <span>Hostel Attendance</span>
                </a>
            </li>
            <li>
                <a href="#" onclick="setActiveMenu(this, 'cumulativeAttendance'); return false;">
                    <i class="bi bi-graph-up"></i>
                    <span>Cumulative Attendance</span>
                </a>
            </li>
            <li>
                <a href="#" onclick="setActiveMenu(this, 'examDetails'); return false;">
                    <i class="bi bi-journal-text"></i>
                    <span>Exam Details</span>
                </a>
            </li>

        </ul>
    </nav>

    <!-- ── CENTER CONTENT ────────────────────────────────── -->
    <div class="content-area" id="mainContent">

        <!-- SPINNER -->
        <div class="spinner-wrap" id="spinner">
            <div class="spinner-border text-primary" role="status" style="width:2.5rem;height:2.5rem;"></div>
            <p style="margin-top:10px; color:#555;">Fetching student data...</p>
        </div>

        <!-- ALERT -->
        <div id="alertBox" style="display:none;"></div>

        <!-- DEFAULT EMPTY STATE -->
        <div class="empty-state" id="emptyState">
            <i class="bi bi-person-bounding-box"></i>
            <p>Search for a hosteler using Register No, Application No, or Student Name.</p>
        </div>

        <!-- ═══ PERSONAL DETAILS SECTION ═══════════════════ -->
        <div id="personalDetails" style="display:none;">

            <!-- SECTION HEADER -->
            <div class="erp-card-header" style="border-radius:7px 7px 0 0; margin-bottom:0;">
                <i class="bi bi-person-lines-fill"></i>
                <span id="headerStudentName">Personal Details</span>
            </div>

            <!-- ROW 1: BASIC + ACADEMIC -->
            <div style="display:flex; gap:12px; margin-top:12px; flex-wrap:wrap;">

                <!-- Basic Info -->
                <div class="erp-card" style="flex:1; min-width:260px;">
                    <div class="erp-card-header">
                        <i class="bi bi-person-fill"></i> Basic Information
                    </div>
                    <div class="erp-card-body">
                        <table class="info-table">
                            <tr>
                                <td class="lbl">Member Name</td>
                                <td class="val" id="d_studentname">—</td>
                            </tr>
                            <tr>
                                <td class="lbl">Member Code</td>
                                <td class="val" id="d_membercode">—</td>
                            </tr>
                            <tr>
                                <td class="lbl">Account No.</td>
                                <td class="val" id="d_accountno">—</td>
                            </tr>
                            <tr>
                                <td class="lbl">Member Category</td>
                                <td class="val">STUDENT</td>
                            </tr>
                            <tr>
                                <td class="lbl">Hostel Name</td>
                                <td class="val" id="d_institutionname">—</td>
                            </tr>
                            <tr>
                                <td class="lbl">Block / Floor / Room</td>
                                <td class="val" id="d_blockfloorroom">—</td>
                            </tr>
                            <tr>
                                <td class="lbl">Mess Name</td>
                                <td class="val" id="d_messname">—</td>
                            </tr>
                            <tr>
                                <td class="lbl">Member Type</td>
                                <td class="val">HOSTEL MEMBER</td>
                            </tr>
                            <tr>
                                <td class="lbl">Special Category</td>
                                <td class="val" id="d_specialcategory">—</td>
                            </tr>
                            <tr>
                                <td class="lbl">Sex / Date of Birth</td>
                                <td class="val" id="d_genderdob">—</td>
                            </tr>
                            <tr>
                                <td class="lbl">Father / Mother Name</td>
                                <td class="val" id="d_parentnames">—</td>
                            </tr>
                        </table>
                    </div>
                </div>

                <!-- Contact & Academic -->
                <div class="erp-card" style="flex:1; min-width:260px;">
                    <div class="erp-card-header">
                        <i class="bi bi-telephone-fill"></i> Contact & Academic
                    </div>
                    <div class="erp-card-body">
                        <table class="info-table">
                            <tr>
                                <td class="lbl">Address</td>
                                <td class="val" id="d_address">—</td>
                            </tr>
                            <tr>
                                <td class="lbl">Member Mobile No.</td>
                                <td class="val" id="d_mobile">—</td>
                            </tr>
                            <tr>
                                <td class="lbl">Parent Mobile No.</td>
                                <td class="val" id="d_parentmobile">—</td>
                            </tr>
                            <tr>
                                <td class="lbl">Member Email</td>
                                <td class="val" id="d_email">—</td>
                            </tr>
                            <tr>
                                <td class="lbl">Occupation / Annual Income</td>
                                <td class="val" id="d_occupation">—</td>
                            </tr>
                            <tr>
                                <td class="lbl">Nationality / Religion / Category / Caste</td>
                                <td class="val" id="d_nrcc">—</td>
                            </tr>
                            <tr>
                                <td class="lbl">District / State Name</td>
                                <td class="val" id="d_diststate">—</td>
                            </tr>
                            <tr>
                                <td class="lbl">Institution</td>
                                <td class="val" id="d_college">—</td>
                            </tr>
                            <tr>
                                <td class="lbl">Programme</td>
                                <td class="val" id="d_program">—</td>
                            </tr>
                            <tr>
                                <td class="lbl">Shift</td>
                                <td class="val" id="d_shift">—</td>
                            </tr>
                            <tr>
                                <td class="lbl">Blood Group</td>
                                <td class="val" id="d_bloodgroup">—</td>
                            </tr>
                        </table>
                    </div>
                </div>

            </div><!-- /row 1 -->

            <!-- ROW 2: GUARDIAN -->
            <div class="erp-card">
                <div class="erp-card-header">
                    <i class="bi bi-people-fill"></i> Guardian Details
                </div>
                <div class="erp-card-body">
                    <table class="info-table">
                        <tr>
                            <td class="lbl" style="width:25%;">Relation</td>
                            <td class="val" id="d_guardianrelation">—</td>
                            <td class="lbl" style="width:25%;">Mobile</td>
                            <td class="val" id="d_guardianmobile">—</td>
                        </tr>
                        <tr>
                            <td class="lbl">Address</td>
                            <td class="val" id="d_guardaddress" colspan="3">—</td>
                        </tr>
                        <tr>
                            <td class="lbl">State</td>
                            <td class="val" id="d_guardstate">—</td>
                            <td class="lbl">District</td>
                            <td class="val" id="d_guarddist">—</td>
                        </tr>
                        <tr>
                            <td class="lbl">Email</td>
                            <td class="val" id="d_guardianemail" colspan="3">—</td>
                        </tr>
                    </table>
                </div>
            </div>

        </div><!-- /personalDetails -->

        <!-- ═══ PLACEHOLDER SECTIONS (future modules) ══════ -->
        <div id="financeDetails"          style="display:none;" class="erp-card">
            <div class="erp-card-header"><i class="bi bi-cash-coin"></i> Finance Details</div>
            <div class="erp-card-body empty-state" style="padding:40px;">
                <i class="bi bi-tools" style="font-size:36px;"></i>
                <p>Finance Details module — Coming soon.</p>
            </div>
        </div>

        <div id="outstandingAdjustments"  style="display:none;" class="erp-card">
            <div class="erp-card-header"><i class="bi bi-exclamation-triangle"></i> Outstanding Adjustments</div>
            <div class="erp-card-body empty-state" style="padding:40px;">
                <i class="bi bi-tools" style="font-size:36px;"></i>
                <p>Outstanding Adjustments module — Coming soon.</p>
            </div>
        </div>

        <div id="printChallan"            style="display:none;" class="erp-card">
            <div class="erp-card-header"><i class="bi bi-printer"></i> Print Challan</div>
            <div class="erp-card-body empty-state" style="padding:40px;">
                <i class="bi bi-tools" style="font-size:36px;"></i>
                <p>Print Challan module — Coming soon.</p>
            </div>
        </div>

        <div id="messBills"               style="display:none;" class="erp-card">
            <div class="erp-card-header"><i class="bi bi-receipt"></i> Mess Bills</div>
            <div class="erp-card-body empty-state" style="padding:40px;">
                <i class="bi bi-tools" style="font-size:36px;"></i>
                <p>Mess Bills module — Coming soon.</p>
            </div>
        </div>

        <div id="creditsDebits"           style="display:none;" class="erp-card">
            <div class="erp-card-header"><i class="bi bi-bar-chart-line"></i> Student Wise Credits &amp; Debits</div>
            <div class="erp-card-body empty-state" style="padding:40px;">
                <i class="bi bi-tools" style="font-size:36px;"></i>
                <p>Credits &amp; Debits module — Coming soon.</p>
            </div>
        </div>

        <div id="hostelAdvance"           style="display:none;" class="erp-card">
            <div class="erp-card-header"><i class="bi bi-wallet2"></i> Hostel Advance/Adjustments</div>
            <div class="erp-card-body empty-state" style="padding:40px;">
                <i class="bi bi-tools" style="font-size:36px;"></i>
                <p>Hostel Advance module — Coming soon.</p>
            </div>
        </div>

        <div id="hostelAttendance"        style="display:none;" class="erp-card">
            <div class="erp-card-header"><i class="bi bi-calendar-check"></i> Hostel Attendance</div>
            <div class="erp-card-body empty-state" style="padding:40px;">
                <i class="bi bi-tools" style="font-size:36px;"></i>
                <p>Hostel Attendance module — Coming soon.</p>
            </div>
        </div>

        <div id="cumulativeAttendance"    style="display:none;" class="erp-card">
            <div class="erp-card-header"><i class="bi bi-graph-up"></i> Cumulative Attendance</div>
            <div class="erp-card-body empty-state" style="padding:40px;">
                <i class="bi bi-tools" style="font-size:36px;"></i>
                <p>Cumulative Attendance module — Coming soon.</p>
            </div>
        </div>

        <div id="examDetails"             style="display:none;" class="erp-card">
            <div class="erp-card-header"><i class="bi bi-journal-text"></i> Exam Details</div>
            <div class="erp-card-body empty-state" style="padding:40px;">
                <i class="bi bi-tools" style="font-size:36px;"></i>
                <p>Exam Details module — Coming soon.</p>
            </div>
        </div>

    </div><!-- /content-area -->

    <!-- ── RIGHT PANEL ───────────────────────────────────── -->
    <div class="right-panel">

        <!-- PHOTO & STATUS -->
        <div class="photo-box">
            <img id="studentPhoto" src="images/default_student.png" alt="Student Photo">
            <div class="status-bar">
                <span id="statusBadge" class="badge-inactive">—</span>
            </div>
        </div>

        <!-- ROOM ALLOCATED DETAILS -->
        <div class="erp-card">
            <div class="erp-card-header">
                <i class="bi bi-door-closed-fill"></i> Room Allocated Details
            </div>
            <div class="erp-card-body" style="padding:8px;">
                <table class="room-detail-table">
                    <thead>
                        <tr>
                            <th>Allocated Date</th>
                            <th>Room Type</th>
                            <th>Room No.</th>
                            <th>Block</th>
                            <th>Hostel Name</th>
                        </tr>
                    </thead>
                    <tbody id="roomTableBody">
                        <tr>
                            <td colspan="5" style="text-align:center; color:#aaa; padding:12px;">
                                No allocation data
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- QUICK STATS -->
        <div class="erp-card" id="quickStatsCard" style="display:none;">
            <div class="erp-card-header">
                <i class="bi bi-info-circle-fill"></i> Quick Info
            </div>
            <div class="erp-card-body">
                <table class="info-table">
                    <tr>
                        <td class="lbl">App No.</td>
                        <td class="val" id="qs_appno">—</td>
                    </tr>
                    <tr>
                        <td class="lbl">Hostel No.</td>
                        <td class="val" id="qs_hostelno">—</td>
                    </tr>
                    <tr>
                        <td class="lbl">Fee Paid</td>
                        <td class="val" id="qs_feepaid">—</td>
                    </tr>
                    <tr>
                        <td class="lbl">Room Allotted</td>
                        <td class="val" id="qs_roomallotted">—</td>
                    </tr>
                    <tr>
                        <td class="lbl">Mess Allotted</td>
                        <td class="val" id="qs_messallotted">—</td>
                    </tr>
                    <tr>
                        <td class="lbl">Applied On</td>
                        <td class="val" id="qs_appliedon">—</td>
                    </tr>
                </table>
            </div>
        </div>

    </div><!-- /right-panel -->

</div><!-- /main-wrapper -->

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
// ═══════════════════════════════════════════════════════════
// GLOBAL STATE
// ═══════════════════════════════════════════════════════════
let currentSection  = 'personalDetails';
let studentData     = null;

// All content sections (excluding emptyState & spinner)
const ALL_SECTIONS = [
    'personalDetails','financeDetails','outstandingAdjustments',
    'printChallan','messBills','creditsDebits','hostelAdvance',
    'hostelAttendance','cumulativeAttendance','examDetails'
];

// ═══════════════════════════════════════════════════════════
// SIDEBAR: SET ACTIVE MENU ITEM
// ═══════════════════════════════════════════════════════════
function setActiveMenu(anchor, sectionId) {

    // Update sidebar highlight
    document.querySelectorAll('#sidebarMenu a').forEach(a => a.classList.remove('active'));
    anchor.classList.add('active');

    currentSection = sectionId;

    // Show correct section (only if data loaded)
    if (studentData) {
        showSection(sectionId);
    }
}

function showSection(sectionId) {
    document.getElementById('emptyState').style.display  = 'none';
    document.getElementById('spinner').style.display     = 'none';

    ALL_SECTIONS.forEach(id => {
        const el = document.getElementById(id);
        if (el) el.style.display = (id === sectionId) ? 'block' : 'none';
    });
}

// ═══════════════════════════════════════════════════════════
// SEARCH
// ═══════════════════════════════════════════════════════════
function searchHosteler() {

    const txt = document.getElementById('searchInput').value.trim();

    if (!txt) {
        showAlert('danger', 'Please enter a Register No, Application No, or Student Name.');
        return;
    }

    // Reset UI
    hideAlert();
    document.getElementById('emptyState').style.display  = 'none';
    document.getElementById('spinner').style.display     = 'block';
    ALL_SECTIONS.forEach(id => {
        const el = document.getElementById(id);
        if (el) el.style.display = 'none';
    });
    document.getElementById('searchStatus').textContent = 'Searching…';

    fetch('ajax/getHostelerInfo.jsp?searchText=' + encodeURIComponent(txt))
        .then(r => {
            if (!r.ok) throw new Error('HTTP ' + r.status);
            return r.json();
        })
        .then(data => {
            document.getElementById('spinner').style.display = 'none';
            document.getElementById('searchStatus').textContent = '';

            if (!data.success) {
                showAlert('danger', data.message || 'No student found.');
                document.getElementById('emptyState').style.display = 'block';
                resetRightPanel();
                return;
            }

            studentData = data;
            populatePage(data);
            showSection(currentSection);
        })
        .catch(err => {
            document.getElementById('spinner').style.display  = 'none';
            document.getElementById('searchStatus').textContent = '';
            showAlert('danger', 'Error: ' + err.message);
            document.getElementById('emptyState').style.display = 'block';
        });
}

function clearSearch() {
    document.getElementById('searchInput').value = '';
    document.getElementById('searchStatus').textContent  = '';
    studentData = null;
    hideAlert();
    ALL_SECTIONS.forEach(id => {
        const el = document.getElementById(id);
        if (el) el.style.display = 'none';
    });
    document.getElementById('emptyState').style.display = 'block';
    resetRightPanel();
}

// ═══════════════════════════════════════════════════════════
// POPULATE PAGE
// ═══════════════════════════════════════════════════════════
function populatePage(d) {

    // ── Header ──────────────────────────────────────────────
    const memberCode = (d.applicationno || '') + '-' + (d.studentname || '');
    document.getElementById('searchInput').value        = d.registerno || '';
    document.getElementById('headerStudentName').textContent =
        (d.applicationno||'') + '-' + (d.studentname||'');

    // ── Basic Info ─────────────────────────────────────────
    set('d_studentname',  d.studentname);
    set('d_membercode',   d.applicationno);
    set('d_accountno',    d.registerno);

    // Institution / hostel name
    set('d_institutionname', d.institutionname || d.college || '—');

    // Block / Floor / Room
    const bfr = buildBlockFloorRoom(d);
    set('d_blockfloorroom', bfr);

    set('d_messname', d.mess_name || '—');

    // Special category (differently abled)
    set('d_specialcategory', d.isphysicallychallenged === 'Yes' ? 'Differently Abled' : 'NA');

    // Gender / DOB
    set('d_genderdob', joinNonEmpty([d.gender, d.dateofbirth], ' / '));

    // Parent names
    set('d_parentnames', joinNonEmpty([d.fathername, d.mothername], ' / '));

    // ── Contact & Academic ─────────────────────────────────
    // Address
    const addr = joinNonEmpty([d.premadd1, d.premadd2, d.premadd3, d.village, d.town, d.state, d.pincode], ', ');
    set('d_address', addr || '—');

    set('d_mobile',       d.studentmobilenumber || '—');
    set('d_parentmobile', d.parentmobile        || '—');
    set('d_email',        d.studentemailid      || '—');

    // Occupation / income
    const occ = joinNonEmpty([d.fatheroccupation, d.fatherannualincome ? 'Rs. ' + d.fatherannualincome : ''], ' / ');
    set('d_occupation', occ || '—');

    // Nationality / Religion / Category / Caste
    const nrcc = joinNonEmpty(['Indian', d.religion, d.category, d.casteid], ' / ');
    set('d_nrcc', nrcc || '—');

    // District / State
    set('d_diststate', joinNonEmpty([d.village || d.town, d.state], ' / ') || '—');

    set('d_college',   d.college        || d.institutionname || '—');
    set('d_program',   d.studentprogram || '—');
    set('d_shift',     d.shifttype      || '—');
    set('d_bloodgroup',d.bloodgroup     || '—');

    // ── Guardian ───────────────────────────────────────────
    set('d_guardianrelation', d.guardianrelation || '—');
    set('d_guardianmobile',   d.guardianmobile   || '—');
    const ga = joinNonEmpty([d.guardline1, d.guardline2, d.guardline3], ', ');
    set('d_guardaddress', ga || '—');
    set('d_guardstate',   d.guardstate || '—');
    set('d_guarddist',    d.guarddist  || '—');
    set('d_guardianemail',d.guardianemail || '—');

    // ── RIGHT PANEL: Photo ─────────────────────────────────
    const photoEl = document.getElementById('studentPhoto');
    if (d.studentphoto && d.studentphoto.trim() !== '') {
        // Adjust path prefix to match your ERP file storage
        photoEl.src = 'hostelPhotos/' + d.studentphoto;
    } else if (d.filename && d.filename.trim() !== '') {
        photoEl.src = 'hostelPhotos/' + d.filename;
    } else {
        photoEl.src = 'images/default_student.png';
    }
    photoEl.onerror = function () { this.src = 'images/default_student.png'; };

    // ── RIGHT PANEL: Status Badge ──────────────────────────
    const badge = document.getElementById('statusBadge');
    if (d.currentstatus === 'Active') {
        badge.className   = 'badge-active';
        badge.textContent = 'Current Status: Active';
    } else {
        badge.className   = 'badge-inactive';
        badge.textContent = 'Current Status: Inactive';
    }

    // ── RIGHT PANEL: Room Table ────────────────────────────
    const tbody = document.getElementById('roomTableBody');
    if (d.roomno && d.roomno.trim() !== '') {
        tbody.innerHTML =
            '<tr>'
          + '<td>' + (d.allocateddate || '—') + '</td>'
          + '<td>' + (d.roomtype      || '—') + '</td>'
          + '<td><strong>' + (d.roomno || '—') + '</strong></td>'
          + '<td>' + (d.blockname || (d.sra_blockname || '—')) + '</td>'
          + '<td>' + (d.institutionname || 'LOYOLA MEN\'S HOSTEL') + '</td>'
          + '</tr>';
    } else {
        tbody.innerHTML =
            '<tr><td colspan="5" style="text-align:center;color:#aaa;padding:12px;">No room allocated yet</td></tr>';
    }

    // ── RIGHT PANEL: Quick Stats ───────────────────────────
    document.getElementById('quickStatsCard').style.display = 'block';
    set('qs_appno',       d.applicationno || '—');
    set('qs_hostelno',    d.hostelno      || '—');
    set('qs_feepaid',     yesNo(d.ishostelfeespaid));
    set('qs_roomallotted',yesNo(d.isroomallocated));
    set('qs_messallotted',yesNo(d.ismessallocated));
    set('qs_appliedon',   d.registereddate || '—');
}

// ═══════════════════════════════════════════════════════════
// HELPERS
// ═══════════════════════════════════════════════════════════
function set(id, val) {
    const el = document.getElementById(id);
    if (el) el.textContent = (val && val.toString().trim() !== '') ? val : '—';
}

function joinNonEmpty(arr, sep) {
    return arr.filter(v => v && v.toString().trim() !== '').join(sep);
}

function yesNo(flag) {
    if (!flag) return '—';
    return flag.toUpperCase() === 'Y' ? 'Yes' : 'No';
}

function buildBlockFloorRoom(d) {
    const block = d.blockname || d.sra_blockname || '';
    const floor = d.floorname || d.sra_floorname || '';
    const room  = d.roomno   || '';
    if (!block && !floor && !room) return '—';
    return joinNonEmpty([block, floor, room], ' / ');
}

function resetRightPanel() {
    document.getElementById('studentPhoto').src = 'images/default_student.png';
    document.getElementById('statusBadge').className   = 'badge-inactive';
    document.getElementById('statusBadge').textContent = '—';
    document.getElementById('roomTableBody').innerHTML  =
        '<tr><td colspan="5" style="text-align:center;color:#aaa;padding:12px;">No allocation data</td></tr>';
    document.getElementById('quickStatsCard').style.display = 'none';
}

function showAlert(type, msg) {
    const box = document.getElementById('alertBox');
    box.className = 'erp-alert erp-alert-' + type;
    box.innerHTML = '<i class="bi bi-' + (type==='danger'?'exclamation-circle':'check-circle') + '-fill"></i> ' + msg;
    box.style.display = 'block';
}
function hideAlert() {
    document.getElementById('alertBox').style.display = 'none';
}

// Allow Enter key in search box (already set via onkeydown inline)
</script>

</body>
</html>

