<%-- 
    Document   : selectHostelApplicants
    Created on : Apr 14, 2026, 10:35:51?AM
    Author     : lccerp26
--%>

<%
    // *************** Authentication Block ***************
    String per = "A";
    String mName = "SELECT_HOSTEL_APPLICANTS";
%>
<%--<%@ include file="/usermanager/permission.jsp" %>--%>
<link rel="stylesheet" href="../../usermanager/css/bootstrap.min.css">
<%@page import="java.net.InetAddress"%>
<%@page import="java.net.UnknownHostException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%    response.setDateHeader("Expires", 0);
    response.addHeader("Cache-Control", "no-cache, no-store, must-revlidate");
    response.addHeader("Cache-Control", "post-check=0, pre-check=0");
    response.setHeader("Pragma", "no-cache");
session.setAttribute("login","true");
    String login = (String) session.getAttribute("login");
    String userId = (String) session.getAttribute("username");
    String currofficeid = (String) session.getAttribute("currentOfficeUid");

    if (login != null) {
%>

<%--<jsp:include page="../../lccerpheader.jsp"/>--%>

<div class="pcoded-content">
    <div class="pcoded-inner-content">
        <div class="main-body">
            <div class="page-wrapper">
                <div class="page-body">

                    <div class="row">
                        <div class="col-md-12">

                            <div class="card shadow">
                                <div class="card-header bg-primary text-white">
                                    <h5 class="mb-0">Hostel Applicants Selection</h5>
                                </div>

                                <div class="card-body">

                                    <!-- Filters -->
                                    <div class="row g-3 mb-3 justify-content-center">
                                        <div class="col-md-2">
                                            <label class="form-label">Institution</label>
                                            <select id="institution" class="form-control d-block w-100">
                                                <option value="">All</option>
                                            </select>
                                        </div>

                                        <div class="col-md-2">
                                            <label class="form-label">Academic Year</label>
                                            <select id="academicyear" class="form-control d-block w-100">
                                                <option value="">All</option>
                                            </select>
                                        </div>

                                        <div class="col-md-2">
                                            <label class="form-label">From Date</label>
                                            <input type="date" id="fromDate" class="form-control">
                                        </div>

                                        <div class="col-md-2">
                                            <label class="form-label">To Date</label>
                                            <input type="date" id="toDate" class="form-control">
                                        </div>

                                        <div class="col-md-2">
                                            <label class="form-label">Search</label>
                                            <input type="text" id="searchBox" placeholder="Search..." class="form-control">
                                        </div>
                                      <div class="col-md-2">
    <label class="form-label">From Application No</label>
    <input type="text"
           id="fromApplicationNo"
           class="form-control"
           placeholder="e.g. 26LMH-001">
</div>

<div class="col-md-2">
    <label class="form-label">To Application No</label>
    <input type="text"
           id="toApplicationNo"
           class="form-control"
           placeholder="e.g. 26LMH-100">
</div>
                                    </div>

                                   <div class="row g-3 mb-3 justify-content-center">
    <div class="col-md-auto d-flex align-items-end flex-wrap gap-2 justify-content-center">
        <button id="searchBtn"  class="btn btn-success">Search</button>
        <button id="viewBtn"    class="btn btn-success">View Selected</button>
        <button id="resetBtn"   class="btn btn-secondary">Reset</button>
        <button id="downloadRangeBtn" class="btn btn-danger">
            &#x21E9; Download Applications PDF
        </button>
    </div>
</div>


                                    <!-- Table -->
                                    <div class="table-responsive" style="overflow-x:auto;">
                                        <table class="table table-bordered table-hover table-sm" style="min-width:2500px;">

                                            <thead class="table-light">
                                                <tr>
                                                    <th>Selection</th>
                                                    <th>View Application</th>
                                                    <th>Application No</th>
                                                    <th>Register No</th>
                                                    <th>Institution</th>
                                                    <th>Student Name</th>
                                                    <th>College</th>
                                                    <th>Program</th>
                                                    <th>Blood Group</th>
                                                    <th>DOB</th>
                                                    <th>Gender</th>
                                                    <th>Student Mobile</th>
                                                    <th>Student Email</th>
                                                    <th>State</th>
                                                    <th>District</th>
                                                    <th>Village</th>
                                                    <th>Town</th>
                                                    <th>Mother Tongue</th>
                                                    <th>Religion</th>
                                                    <th>Category</th>
                                                    <th>Caste</th>
                                                    <th>Father Name</th>
                                                    <th>Father Education</th>
                                                    <th>Father Occupation</th>
                                                    <th>Father Income</th>
                                                    <th>Mother Name</th>
                                                    <th>Mother Education</th>
                                                    <th>Mother Occupation</th>
                                                    <th>Mother Income</th>
                                                    <th>Name of School</th>
                                                    <th>Total Marks in Plus two</th>
                                                    <th>Visually/Physically Challenged</th>
                                                    <th>Permanent Address</th>
                                                    <th>Pincode</th>
                                                    <th>Parent Mobile</th>
                                                    <th>Parent Email</th>
                                                    <th>Office</th>
                                                    <th>Applied On</th>
                                                    <th>Perm State</th>
                                                    <th>Guardian Relation</th>
                                                    <th>Guardian Mobile</th>
                                                    <th>Guardian Email</th>
                                                    <th>Guardian Address</th>
                                                    <th>View Document</th>
                                                </tr>
                                            </thead>

                                            <tbody id="tableBody"></tbody>

                                        </table>
                                    </div>

                                    <div id="recordCount" class="fw-bold mb-2"></div>

                                </div>
                            </div>

                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="selectedModal" tabindex="-1">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">

            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Selected Applicants
                    (<span id="selectedCount">0</span>)</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal">x</button>
            </div>

            <div class="modal-body" style="max-height:500px; overflow:auto;">
                <div style="overflow-x:auto;">
                    <table class="table table-bordered table-sm" style="min-width:2500px;">
                        <thead class="table-light">
                            <tr>
                                <th>View Application</th>
                                <th>Application No</th>
                                <th>Register No</th>
                                <th>Institution</th>
                                <th>Student Name</th>
                                <th>College</th>
                                <th>Program</th>
                                <th>Blood Group</th>
                                <th>DOB</th>
                                <th>Gender</th>
                                <th>Student Mobile</th>
                                <th>Student Email</th>
                                <th>State</th>
                                <th>District</th>
                                <th>Village</th>
                                <th>Town</th>
                                <th>Mother Tongue</th>
                                <th>Religion</th>
                                <th>Category</th>
                                <th>Caste</th>
                                <th>Father Name</th>
                                <th>Father Education</th>
                                <th>Father Occupation</th>
                                <th>Father Income</th>
                                <th>Mother Name</th>
                                <th>Mother Education</th>
                                <th>Mother Occupation</th>
                                <th>Mother Income</th>
                                <th>Name of School</th>
                                <th>Total Marks</th>
                                <th>Physically Challenged</th>
                                <th>Address</th>
                                <th>Pincode</th>
                                <th>Parent Mobile</th>
                                <th>Parent Email</th>
                                <th>Office</th>
                                <th>Applied On</th>
                                <th>Perm State</th>
                                <th>Guardian Relation</th>
                                <th>Guardian Mobile</th>
                                <th>Guardian Email</th>
                                <th>Guardian Address</th>
                                <th>View Document</th>
                            </tr>
                        </thead>
                        <tbody id="selectedTableBody"></tbody>
                    </table>
                </div>
            </div>

            <div class="modal-footer">
                <button id="selectBtn" class="btn btn-success">
                    Save Selected
                </button>
                <button class="btn btn-secondary" data-bs-dismiss="modal">
                    Cancel
                </button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="viewAppModal">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">

            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">Application Details</h5>
                <button class="btn-close btn-close-white" data-bs-dismiss="modal">x</button>
            </div>

            <div class="modal-body" style="max-height:600px; overflow:auto;">
                <div id="applicationContent"></div>
            </div>

        </div>
    </div>
</div>
<div class="modal fade" id="viewDocModal">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">

            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">View Document</h5>
                <button class="btn-close btn-close-white" data-bs-dismiss="modal">x</button>
            </div>

            <div class="modal-body" style="height:600px;">
                <iframe id="docFrame" 
                        style="width:100%; height:100%; border:none;">
                </iframe>
            </div>

        </div>
    </div>
</div>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.31/jspdf.plugin.autotable.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    loadInstitutions();
    loadAcademicYears();
    loadOffices();
    function loadInstitutions()
    {

        $.post("ajax/getInstitutions.jsp", function (res) {

            let html = "<option value=''>All</option>";

            res.forEach(function (row) {

                html += "<option value='" + row.institutionid + "'>"
                        + row.institutename +
                        "</option>";
            });

            $("#institution").html(html);

        }, "json");
    }
    function loadOffices() {

        $.post("ajax/getOffices.jsp", function (res) {

            let html = "<option value=''>All</option>";

            res.forEach(function (row) {

                html += "<option value='" + row.officeid + "'>"
                        + row.officename +
                        "</option>";
            });

            $("#office").html(html);

        }, "json");
    }

    $("#resetBtn").click(function () {
        $("#institution").val("");
        $("#academicyear").val("");
        $("#fromDate").val("");
        $("#toDate").val("");
        $("#office").val("");
        $("#searchBox").val("");
        loadData();
    });
    function loadAcademicYears() {

        $.post("ajax/getAcademicYears.jsp", function (res) {

            let html = "<option value=''>All</option>";

            res.forEach(function (row) {

                html += "<option value='" + row.academicyearid + "'>"
                        + row.academicyear +
                        "</option>";
            });

            $("#academicyear").html(html);

        }, "json");
    }

    $("#searchBox").on("keyup", function () {

        var value = $(this).val().toLowerCase();
        var visibleCount = 0;

        $("#tableBody tr").each(function () {

            var isMatch = $(this).text().toLowerCase().indexOf(value) > -1;
            $(this).toggle(isMatch);

            if (isMatch) {
                visibleCount++;
            }
        });

        // Remove old "No Records" row if exists
        $("#noRecordsRow").remove();

        // If no visible rows ? show message
        if (visibleCount === 0) {

            $("#tableBody").append(
                    "<tr id='noRecordsRow'>" +
                    "<td colspan='45' class='text-center text-danger fw-bold'>" +
                    "No Records Found" +
                    "</td>" +
                    "</tr>"
                    );
        }

    });
    function safe(val) {
        return (val === null || val === "null" || val === undefined) ? "" : val;
    }
    function formatMarks(val) {
        if (!val || val === "null")
            return "";

        let num = parseFloat(val);
        if (isNaN(num))
            return val;

        return (num % 1 === 0) ? num.toString() : num.toFixed(2);
    }
    function formatIncome(val) {
        if (!val || val === "null")
            return "";

        let num = parseFloat(val);

        if (isNaN(num) || num === 0)
            return ""; // ? key condition

        return (num % 1 === 0) ? num.toString() : num.toFixed(2);
    }
    function formatNumber(val) {
        if (val === null || val === undefined || val === "" || val === "null") {
            return "";
        }

        // Convert to number and remove decimals if .00
        var num = parseFloat(val);

        if (isNaN(num))
            return val;

        return (num % 1 === 0) ? num.toString() : num.toFixed(2);
    }
    function loadData() {

        const from = $("#fromDate").val();
        const to = $("#toDate").val();
        const inst = $("#institution option:selected").text();
        const ay = $("#academicyear").val();
        const office = $("#office").val();

        $.post("ajax/getFeespaidApplication.jsp", {
            fromDate: from,
            toDate: to,
            institution: inst,
            academicyear: ay
        }, function (res) {
console.log("RESPONSE:", res);
            let html = "";

            if (!res || res.length === 0) {

                html = "<tr>" +
                        "<td colspan='45' class='text-center text-danger fw-bold'>" +
                        "No Records Found" +
                        "</td>" +
                        "</tr>";

            } else {
                res.forEach(function (row) {

                    html += "<tr>" +

        "<td><input type='checkbox' class='rowCheck' value='" +
        safe(row.registerno) + "'></td>" +

   "<td>" +
"<a href='ajax/generateApplicationPdf.jsp?userid=" + safe(row.registerno) +
"' target='_blank' class='btn btn-sm btn-danger me-1'>PDF</a>" +

"<button class='btn btn-sm btn-warning editBtn me-1'" +
" data-reg='"           + safe(row.registerno)          + "'" +
" data-name='"          + safe(row.studentname)         + "'" +
" data-mobile='"        + safe(row.studentmobilenumber) + "'" +
" data-email='"         + safe(row.studentemailid)      + "'" +
" data-bloodgroup='"    + safe(row.bloodgroup)          + "'" +
" data-religion='"      + safe(row.religion)            + "'" +
" data-category='"      + safe(row.category)            + "'" +
" data-state='"         + safe(row.state)               + "'" +
" data-town='"          + safe(row.town)                + "'" +
" data-village='"       + safe(row.village)             + "'" +
" data-father='"        + safe(row.fathername)          + "'" +
" data-fatheredu='"     + safe(row.fathereducation)     + "'" +
" data-fatherocc='"     + safe(row.fatheroccupation)    + "'" +
" data-fatherincome='"  + safe(row.fatherannualincome)  + "'" +
" data-mother='"        + safe(row.mothername)          + "'" +
" data-motheredu='"     + safe(row.mothereducation)     + "'" +
" data-motherocc='"     + safe(row.motheroccupation)    + "'" +
" data-motherincome='"  + safe(row.motherannualincome)  + "'" +
" data-parentmobile='"  + safe(row.parentmobile)        + "'" +
" data-parentemail='"   + safe(row.parentemail)         + "'" +
" data-address1='"      + safe(row.premadd1)            + "'" +
" data-address2='"      + safe(row.premadd2)            + "'" +
" data-address3='"      + safe(row.premadd3)            + "'" +
" data-pincode='"       + safe(row.pincode)             + "'" +
" data-guardianrelation='" + safe(row.guardianrelation) + "'" +
" data-guardianmobile='"   + safe(row.guardianmobile)   + "'" +
" data-guardianemail='"    + safe(row.guardianemail)    + "'" +
" data-guardline1='"       + safe(row.guardline1)       + "'" +
" data-guardline2='"       + safe(row.guardline2)       + "'" +
" data-guardline3='"       + safe(row.guardline3)       + "'" +
" data-guardstate='"       + safe(row.guardstate)       + "'" +
" data-guarddist='"        + safe(row.guarddist)        + "'" +
">Edit</button>" +
"</td>" +
                            "<td>" + safe(row.applicationno) + "</td>" +
                            "<td>" + safe(row.registerno) + "</td>" +
                            "<td>" + safe(row.institutionname) + "</td>" +
                            "<td>" + safe(row.studentname) + "</td>" +
                            "<td>" + safe(row.college) + "</td>" +
                            "<td>" + safe(row.studentprogram) + "</td>" +
                            "<td>" + safe(row.bloodgroup) + "</td>" +
                            "<td>" + safe(row.dateofbirth) + "</td>" +
                            "<td>" + safe(row.gender) + "</td>" +
                            "<td>" + safe(row.studentmobilenumber) + "</td>" +
                            "<td>" + safe(row.studentemailid) + "</td>" +
                            "<td>" + safe(row.state) + "</td>" +
                            "<td>" + safe(row.distname) + "</td>" +
                            "<td>" + safe(row.village) + "</td>" +
                            "<td>" + safe(row.town) + "</td>" +
                            "<td>" + safe(row.mothertongue) + "</td>" +
                            "<td>" + safe(row.religion) + "</td>" +
                            "<td>" + safe(row.category) + "</td>" +
                            "<td>" + safe(row.casteid) + "</td>" +
                            "<td>" + safe(row.fathername) + "</td>" +
                            "<td>" + safe(row.fathereducation) + "</td>" +
                            "<td>" + safe(row.fatheroccupation) + "</td>" +
                            "<td>" + safe(row.fatherannualincome) + "</td>" +
                            "<td>" + safe(row.mothername) + "</td>" +
                            "<td>" + safe(row.mothereducation) + "</td>" +
                            "<td>" + safe(row.motheroccupation) + "</td>" +
                            "<td>" + safe(row.motherannualincome) + "</td>" +
                            "<td>" + safe(row.nameofschool) + "</td>" +
                            "<td>" + formatNumber(row.marksplustwo) + " / " + formatNumber(row.maxmark) + "</td>" +
                            "<td>" + safe(row.isphysicallychallenged) + "</td>" +
                            "<td>" +
                            safe(row.premadd1) + " " +
                            safe(row.premadd2) + " " +
                            safe(row.premadd3) +
                            "</td>" +
                            "<td>" + safe(row.pincode) + "</td>" +
                            "<td>" + safe(row.parentmobile) + "</td>" +
                            "<td>" + safe(row.parentemail) + "</td>" +
                            "<td>" + safe(row.officename) + "</td>" +
                            //"<td>" + row.studentphoto + "</td>" +
                            //"<td>" + row.isapplicationgenerate + "</td>" +
                            "<td>" + safe(row.updated_on) + "</td>" +
                            "<td>" + safe(row.permstate) + "</td>" +
                            //"<td>" + safe(row.maxmark) + "</td>" +
                            "<td>" + (row.guardianrelation || "") + "</td>" +
                            "<td>" + (row.guardianmobile || "") + "</td>" +
                            "<td>" + (row.guardianemail || "") + "</td>" +
                            "<td>" +
                            (row.guardline1 || "") + " " +
                            (row.guardline2 || "") + " " +
                            (row.guardline3 || "") +
                            "</td>" +
                            "<td>" +
                            "<button class='btn btn-sm btn-info viewDocBtn' data-file='" + safe(row.filename) + "'>" +
                            "View Document</button>" +
                            "</td>" +
                            "</tr>";
                });
            }

            $("#tableBody").html(html);
            $("#recordCount").text("Total Records: " + res.length);

        }, "json");

    }

    $(document).on("click", ".viewDocBtn", function () {

        const file = $(this).data("file");

        if (!file) {
            alert("No document available");
            return;
        }

        let fileUrl = "<%=request.getContextPath()%>hostelprofile_uploads/" + file;
        //let fileUrl = "<%=request.getContextPath()%>/../hostelonline/hostelprofile_uploads/" + file;

        // Set iframe source
        $("#docFrame").attr("src", fileUrl);

        // Open modal
        let modal = new bootstrap.Modal(document.getElementById("viewDocModal"));
        modal.show();
    });

    $('#viewDocModal').on('hidden.bs.modal', function () {
        $("#docFrame").attr("src", "");
    });

    $(document).on("click", ".viewAppBtn", function () {

        const regno = $(this).data("reg");

        fetch("ajax/fetchFullProfile.jsp?registerno=" + regno)
                .then(r => r.json())
                .then(data => {

                    if (data.error) {
                        alert(data.error);
                        return;
                    }

                    let html = "";

                    let photoUrl = "<%=request.getContextPath()%>/hostelERP/hostelprofile_uploads/" + safe(data.studentphoto);

                    html += "<div class='text-center mb-3'>";

                    if (data.studentphoto) {
                        html += "<img src='" + photoUrl + "' style='width:120px;height:120px;border-radius:5px;border:1px solid #ccc;' />";
                    } else {
                        html += "<div class='text-danger'>No Photo</div>";
                    }

                    html += "</div>";

                    html += "<h5 class='text-primary'>Personal Details</h5>";
                    html += "<table class='table table-bordered table-sm'>";
                    html += "<tr><td style='width:25%;'>Name</td><td>" + safe(data.name) + "</td></tr>";
                    html += "<tr><td>Institution</td><td>" + safe(data.institution) + "</td></tr>";
                    html += "<tr><td>Application No</td><td>" + safe(data.applicationno) + "</td></tr>";
                    html += "<tr><td>Dept No</td><td>" + safe(data.regno) + "</td></tr>";
                    html += "<tr><td>Program</td><td>" + safe(data.course_description) + "</td></tr>";
                    html += "<tr><td>College</td><td>" + " LOYOLA HOSTEL" + "</td></tr>";
                    html += "<tr><td>Gender</td><td>" + safe(data.gender) + "</td></tr>";
                    html += "<tr><td>Blood Group</td><td>" + safe(data.bloodgroup) + "</td></tr>";
                    html += "<tr><td>Date of Birth</td><td>" + safe(data.dob) + "</td></tr>";
                    html += "<tr><td>Age</td><td>" + safe(data.age) + "</td></tr>";
                    html += "<tr><td>Mobile Number</td><td>" + safe(data.mobile) + "</td></tr>";
                    html += "<tr><td>Email id</td><td>" + safe(data.email) + "</td></tr>";
                    html += "<tr><td>State</td><td>" + safe(data.statename) + "</td></tr>";
                    html += "<tr><td>District</td><td>" + safe(data.district) + "</td></tr>";
                    html += "<tr><td>Town / Place</td><td>" + safe(data.town) + "</td></tr>";
                    html += "<tr><td>Village</td><td>" + safe(data.village) + "</td></tr>";
                    html += "<tr><td>Religion</td><td>" + safe(data.religion) + "</td></tr>";
                    html += "<tr><td>Community</td><td>" + safe(data.community) + "</td></tr>";
                    html += "<tr><td>Caste</td><td>" + safe(data.caste) + "</td></tr>";
                    html += "<tr><td>Mother Tongue</td><td>" + safe(data.mothertongue) + "</td></tr>";
                    html += "</table>";

                    html += "<h5 class='text-primary'>Family Details</h5>";
                    html += "<table class='table table-bordered table-sm'>";
                    html += "<tr><td style='width:25%;'>Father's Name</td><td>" + safe(data.fathername) + "</td></tr>";
                    html += "<tr><td>Education Name</td><td>" + safe(data.father_education) + "</td></tr>";
                    html += "<tr><td>Occupation</td><td>" + safe(data.father_occupation) + "</td></tr>";
                    html += "<tr><td>Father's Annual Income</td><td>" + formatIncome(data.father_income) + "</td></tr>";
                    html += "<tr><td>Mother's Name</td><td>" + safe(data.mothername) + "</td></tr>";
                    html += "<tr><td>Education</td><td>" + safe(data.mother_education) + "</td></tr>";
                    html += "<tr><td>Occupation</td><td>" + safe(data.mother_occupation) + "</td></tr>";
                    html += "<tr><td>Mother's Annual Income</td><td>" + formatIncome(data.mother_income) + "</td></tr>";
                    html += "<tr><td>Parent's Mobile</td><td>" + safe(data.parent_mobile) + "</td></tr>";
                    html += "<tr><td>Father's Email Id</td><td>" + safe(data.parent_email) + "</td></tr>";
                    html += "<tr><td>Visually / Physically challenged</td><td>" + safe(data.differentlyabled) + "</td></tr>";

                    html += "<tr><td style='width:25%;'>Place of School</td><td>" + safe(data.school) + "</td></tr>";
                    html += "<tr><td>Total Marks in Plus Two</td><td>"
                            + formatMarks(data.mark_200) + " / "
                            + formatMarks(data.mark_100) + "</td></tr>";
                    html += "<tr><td style='width:25%;'>Local Guardian Name and Relation</td><td>" + safe(data.guardianName) + "</td></tr>";
                    html += "</table>";

                    html += "<h5 class='text-primary'>Permanent Address</h5>";
                    html += "<table class='table table-bordered table-sm'>";
                    html += "<tr><td style='width:25%;'>Address</td><td>" +
                            safe(data.address_line1) + " " +
                            safe(data.address_line2) + " " +
                            safe(data.address_line3) +
                            "</td></tr>";
                    html += "<tr><td>District</td><td>" + safe(data.prem_district) + "</td></tr>";
                    html += "<tr><td>State</td><td>" + safe(data.permState) + "</td></tr>";
                    html += "<tr><td>Pincode</td><td>" + safe(data.pincode) + "</td></tr>";
                    html += "</table>";

                    html += "<h5 class='text-primary'>Local Guardian Address</h5>";
                    html += "<table class='table table-bordered table-sm'>";



                    html += "<tr><td style='width:25%;'>Address</td><td>" +
                            safe(data.guard_address_line1) + " " +
                            safe(data.guard_address_line2) + " " +
                            safe(data.guard_address_line3) +
                            "</td></tr>";

                    html += "<tr><td>District</td><td>" + safe(data.guarddistrict) + "</td></tr>";
                    html += "<tr><td>State</td><td>" + safe(data.guardState) + "</td></tr>";
                    html += "<tr><td>Pincode</td><td>" + safe(data.guard_pincode) + "</td></tr>";
                    html += "<tr><td>Mobile</td><td>" + safe(data.guardian_mobile) + "</td></tr>";
                    //html += "<tr><td>Email</td><td>" + safe(data.guardian_email) + "</td></tr>";

                    html += "</table>";

                    html += "<h5 class='text-primary'>Payment</h5>";
                    html += "<table class='table table-bordered table-sm'>";
                    html += "<tr><td style='width:25%;'>Mode</td><td>" + safe(data.paymentmode) + "</td></tr>";
                    html += "<tr><td>Receipt ID</td><td>" + safe(data.receiptid) + "</td></tr>";
                    html += "<tr><td>Transaction ID</td><td>" + safe(data.txnid) + "</td></tr>";
                    html += "<tr><td>Amount</td><td>" + safe(data.amount) + "</td></tr>";
                    html += "</table>";

                    $("#applicationContent").html(html);

                    let modal = new bootstrap.Modal(document.getElementById("viewAppModal"));
                    modal.show();

                })
                .catch(() => {
                    alert("Cannot load the application");
                });

    });

    $("#searchBtn").click(function () {
        loadData();
    });

    $("#selectBtn").click(function () {

        var selectedApps = [];

        $(".rowCheck:checked").each(function () {

            var row = $(this).closest("tr");
            var appno = row.find("td:eq(2)").text(); // applicationno

            if (appno) {
                selectedApps.push(appno);
            }

        });

        if (selectedApps.length === 0) {
            alert("Please select at least one record");
            return;
        }

        // ? CONFIRMATION POPUP
        if (!confirm("Are you sure you want to move selected applicants?")) {
            return;
        }

        $.post("ajax/selectApplicant.jsp", {
            applicationno: selectedApps.join(",")
        }, function (res) {

            if (res.success) {

                alert("Selected applicants updated successfully");

                // CLOSE MODAL (Bootstrap 5 way)
                let modalEl = document.getElementById('selectedModal');
                let modalInstance = bootstrap.Modal.getInstance(modalEl);
                if (modalInstance) {
                    modalInstance.hide();
                }

                // CLEAR MODAL DATA
                $("#selectedTableBody").html("");
                $("#selectedCount").text("0");

                // UNCHECK ALL CHECKBOXES
                $(".rowCheck").prop("checked", false);

                // RELOAD TABLE
                loadData();

            } else {
                alert(res.error || "Unknown error");
            }

        }, "json").fail(function () {
            alert("Connection not Established");
        });

    });

    $("#viewBtn").click(function () {

        let html = "";
        let selectedApps = [];

        $(".rowCheck:checked").each(function () {

            let row = $(this).closest("tr");

            // clone full row
            let clonedRow = row.clone();

            // remove checkbox column (first column)
            clonedRow.find("td:first").remove();

            // collect application no
            let appno = row.find("td:eq(2)").text();
            selectedApps.push(appno);

            html += "<tr>" + clonedRow.html() + "</tr>";
        });

        if (selectedApps.length === 0) {
            alert("Please select at least one applicant");
            return;
        }

        $("#selectedTableBody").html(html);

        $("#selectedCount").text(selectedApps.length);

        $("#confirmMoveBtn").data("apps", selectedApps);

        let modal = new bootstrap.Modal(document.getElementById('selectedModal'));
        modal.show();
    });

    $('#selectedModal').on('hidden.bs.modal', function () {
        $("#selectedCount").text("0");
        $("#selectedTableBody").html("");
    });
    $("#exportBtn").click(function () {

        let table = document.querySelector("table");
        let html = table.outerHTML;

        // Remove unwanted elements (optional cleanup)
        html = html.replace(/<input[^>]*>/gi, "");

        let blob = new Blob([html], {
            type: "application/vnd.ms-excel"
        });

        let url = window.URL.createObjectURL(blob);

        let a = document.createElement("a");
        a.href = url;
        a.download = "Hostel_Applicants.xls";
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);

    });
    $("#csvBtn").click(function () {

        var table = document.querySelector("table");
        var rows = table.querySelectorAll("tr");

        var csv = [];

        for (var i = 0; i < rows.length; i++) {

            var cols = rows[i].querySelectorAll("td, th");
            var row = [];

            for (var j = 0; j < cols.length; j++) {

                var text = cols[j].innerText.replace(/,/g, ""); // remove commas
                row.push('"' + text + '"');

            }

            csv.push(row.join(","));
        }

        var csvString = csv.join("\n");

        var blob = new Blob([csvString], {type: "text/csv"});

        var url = window.URL.createObjectURL(blob);

        var a = document.createElement("a");
        a.href = url;
        a.download = "Hostel_Applicants.csv";
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);

    });

    $("#pdfBtn").click(function () {

        var {jsPDF} = window.jspdf;
        var doc = new jsPDF();

        doc.text("Hostel Applicants", 14, 10);

        doc.autoTable({
            html: "table",
            startY: 20,
            theme: "grid"
        });

        doc.save("Hostel_Applicants.pdf");

    });  
    
      $("#downloadRangeBtn").click(function () {

    var fromApplicationNo = $("#fromApplicationNo").val().trim();
    var toApplicationNo   = $("#toApplicationNo").val().trim();

    if (!fromApplicationNo || !toApplicationNo) {
        alert("Please enter both From Application No and To Application No.");
        return;
    }

    var url = "ajax/downloadAllApplications.jsp"
            + "?fromApplicationNo=" + encodeURIComponent(fromApplicationNo)
            + "&toApplicationNo="   + encodeURIComponent(toApplicationNo);

    window.open(url, "_blank");
});




    loadData();

</script>

<style>

.scroll-helper {
    position: fixed;
    right: 20px;
    bottom: 25px;
    z-index: 9999;
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.scroll-helper button {
    width: 48px;
    height: 48px;
    border: none;
    border-radius: 50%;
    background: #0d6efd;
    color: white;
    font-size: 20px;
    font-weight: bold;
    cursor: pointer;
    box-shadow: 0 2px 8px rgba(0,0,0,0.3);
    transition: 0.2s;
}

.scroll-helper button:hover {
    background: #084298;
    transform: scale(1.08);
}

</style>

<div class="scroll-helper">

    <!-- TOP -->
    <button id="scrollTopBtn" title="Go Top">
        ↑
    </button>

    <!-- BOTTOM -->
    <button id="scrollBottomBtn" title="Go Bottom">
        ↓
    </button>

    <!-- LEFT -->
    <button id="scrollLeftBtn" title="Go Left">
        ←
    </button>

    <!-- RIGHT -->
    <button id="scrollRightBtn" title="Go Right">
        →
    </button>

</div>

<script>

// ==========================================
// SCROLL TO BOTTOM
// ==========================================

$("#scrollBottomBtn").click(function () {

    window.scrollBy({
        top: 500,
        behavior: "smooth"
    });

});

// ==========================================
// SCROLL TO TOP
// ==========================================

$("#scrollTopBtn").click(function () {

    window.scrollBy({
        top: -500,
        behavior: "smooth"
    });

});

// ==========================================
// SCROLL RIGHT
// ==========================================

$("#scrollRightBtn").click(function () {

    $(".table-responsive").animate({
        scrollLeft: $(".table-responsive").scrollLeft() + 500
    }, 300);

});

// ==========================================
// SCROLL LEFT
// ==========================================

$("#scrollLeftBtn").click(function () {

    $(".table-responsive").animate({
        scrollLeft: $(".table-responsive").scrollLeft() - 500
    }, 300);

});

</script>
<jsp:include page="../../lccerpfooter.jsp"/>

<% } else { %>

session Time out
<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" />

<% } %>