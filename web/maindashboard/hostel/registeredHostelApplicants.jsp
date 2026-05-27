<%-- 
    Document   : registeredHostelApplicants
    Created on : Apr 13, 2026, 1:07:34?PM
    Author     : lccerp26
--%>

<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
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
    
<link rel="stylesheet" href="../../usermanager/css/bootstrap.min.css">


<div class="pcoded-content">
    <div class="pcoded-inner-content">
        <div class="main-body">
            <div class="page-wrapper">
                <div class="page-body">

                    <div class="row">
                        <div class="col-md-12">

                            <div class="card shadow">
                                <div class="card-header bg-primary text-white">
                                    <h5 class="mb-0">Registered Hostel Applicants</h5>
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

<div class="row g-3 mb-3 justify-content-center">
    <div class="col-md-auto d-flex align-items-end flex-wrap gap-2 justify-content-center">
        <button id="downloadRangeBtn" class="btn btn-danger">
            &#x21E9; Download Applications PDF
        </button>
    </div>

                                    </div>

                                    <div class="row g-3 mb-3 justify-content-center">
                                        <div class="col-md-3 d-flex align-items-end justify-content-center">
                                            <button id="searchBtn" class="btn btn-success">Search</button>
                                            <button id="resetBtn" class="btn btn-secondary ml-2">Reset</button>
                                            <button id="exportBtn" class="btn btn-primary ml-2">Excel</button>
                                            <button id="csvBtn" class="btn btn-success ml-2">CSV</button>
                                        </div>
                                    </div>

                                    <!-- Table -->
                                    <div class="table-responsive" style="overflow-x:auto;">
                                        <table class="table table-bordered table-hover table-sm" style="min-width:2500px;">

                                            <thead class="table-light">
                                                <tr>
                                                    <th>Selected Status</th>
                                                    <th>Application</th>
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

                                    <!-- Modal -->
                                    <div class="modal fade" id="viewDocModal">
                                        <div class="modal-dialog modal-xl">
                                            <div class="modal-content">

                                                <div class="modal-header bg-primary text-white">
                                                    <h5 class="modal-title">View Document</h5>
                                                    <button class="btn-close btn-close-white" data-bs-dismiss="modal">x</button>
                                                </div>

                                                <div class="modal-body" style="height:700px;">
                                                    <iframe id="docFrame" style="width:100%; height:100%; border:none;"></iframe>
                                                </div>

                                            </div>
                                        </div>
                                    </div>
<!-- ════════════ EDIT MODAL ════════════ -->
<div class="modal fade" id="editModal" tabindex="-1">
  <div class="modal-dialog modal-xl modal-dialog-scrollable">
    <div class="modal-content">

      <div class="modal-header bg-warning">
        <h5 class="modal-title fw-bold">Edit Hostel Applicant</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>

      <div class="modal-body">

        <input type="hidden" id="edit_registerno">
        <input type="hidden" id="edit_applicationno">

        <h6 class="text-primary fw-bold border-bottom pb-1 mt-1">Personal Details</h6>
        <div class="row g-2 mb-2">
          <div class="col-md-4"><label class="form-label">Student Name</label>
            <input type="text" id="edit_studentname" class="form-control"></div>
          <div class="col-md-4"><label class="form-label">Mobile Number</label>
            <input type="text" id="edit_mobile" class="form-control"></div>
          <div class="col-md-4"><label class="form-label">Email ID</label>
            <input type="text" id="edit_email" class="form-control"></div>
          <div class="col-md-3"><label class="form-label">Blood Group</label>
            <input type="text" id="edit_bloodgroup" class="form-control"></div>
          <div class="col-md-3"><label class="form-label">Religion</label>
            <input type="text" id="edit_religion" class="form-control"></div>
          <div class="col-md-3"><label class="form-label">Community / Category</label>
            <input type="text" id="edit_category" class="form-control"></div>
          <div class="col-md-3"><label class="form-label">State</label>
            <input type="text" id="edit_state" class="form-control"></div>
          <div class="col-md-3"><label class="form-label">Town</label>
            <input type="text" id="edit_town" class="form-control"></div>
          <div class="col-md-3"><label class="form-label">Village</label>
            <input type="text" id="edit_village" class="form-control"></div>
        </div>

        <h6 class="text-primary fw-bold border-bottom pb-1 mt-2">Family Details</h6>
        <div class="row g-2 mb-2">
          <div class="col-md-4"><label class="form-label">Father Name</label>
            <input type="text" id="edit_fathername" class="form-control"></div>
          <div class="col-md-4"><label class="form-label">Father Education</label>
            <input type="text" id="edit_fathereducation" class="form-control"></div>
          <div class="col-md-4"><label class="form-label">Father Occupation</label>
            <input type="text" id="edit_fatheroccupation" class="form-control"></div>
          <div class="col-md-4"><label class="form-label">Father Annual Income</label>
            <input type="text" id="edit_fatherincome" class="form-control"></div>
          <div class="col-md-4"><label class="form-label">Mother Name</label>
            <input type="text" id="edit_mothername" class="form-control"></div>
          <div class="col-md-4"><label class="form-label">Mother Education</label>
            <input type="text" id="edit_mothereducation" class="form-control"></div>
          <div class="col-md-4"><label class="form-label">Mother Occupation</label>
            <input type="text" id="edit_motheroccupation" class="form-control"></div>
          <div class="col-md-4"><label class="form-label">Mother Annual Income</label>
            <input type="text" id="edit_motherincome" class="form-control"></div>
          <div class="col-md-4"><label class="form-label">Parent Mobile</label>
            <input type="text" id="edit_parentmobile" class="form-control"></div>
          <div class="col-md-4"><label class="form-label">Parent Email</label>
            <input type="text" id="edit_parentemail" class="form-control"></div>
        </div>

        <h6 class="text-primary fw-bold border-bottom pb-1 mt-2">Permanent Address</h6>
        <div class="row g-2 mb-2">
          <div class="col-md-4"><label class="form-label">Address Line 1</label>
            <input type="text" id="edit_address1" class="form-control"></div>
          <div class="col-md-4"><label class="form-label">Address Line 2</label>
            <input type="text" id="edit_address2" class="form-control"></div>
          <div class="col-md-4"><label class="form-label">Address Line 3</label>
            <input type="text" id="edit_address3" class="form-control"></div>
          <div class="col-md-3"><label class="form-label">Pincode</label>
            <input type="text" id="edit_pincode" class="form-control"></div>
        </div>

        <h6 class="text-primary fw-bold border-bottom pb-1 mt-2">Local Guardian Details</h6>
        <div class="row g-2 mb-2">
          <div class="col-md-4"><label class="form-label">Guardian Name / Relation</label>
            <input type="text" id="edit_guardianrelation" class="form-control"></div>
          <div class="col-md-4"><label class="form-label">Guardian Mobile</label>
            <input type="text" id="edit_guardianmobile" class="form-control"></div>
          <div class="col-md-4"><label class="form-label">Guardian Email</label>
            <input type="text" id="edit_guardianemail" class="form-control"></div>
          <div class="col-md-4"><label class="form-label">Guard Address Line 1</label>
            <input type="text" id="edit_guardline1" class="form-control"></div>
          <div class="col-md-4"><label class="form-label">Guard Address Line 2</label>
            <input type="text" id="edit_guardline2" class="form-control"></div>
          <div class="col-md-4"><label class="form-label">Guard Address Line 3</label>
            <input type="text" id="edit_guardline3" class="form-control"></div>
          <div class="col-md-3"><label class="form-label">Guardian State</label>
            <input type="text" id="edit_guardstate" class="form-control"></div>
          <div class="col-md-3"><label class="form-label">Guardian District</label>
            <input type="text" id="edit_guarddist" class="form-control"></div>
          <div class="col-md-3"><label class="form-label">Guardian Pincode</label>
            <input type="text" id="edit_guard_pincode" class="form-control"></div>
        </div>

      </div><!-- /modal-body -->

      <div class="modal-footer">
        <button id="updateBtn" class="btn btn-primary px-4">Update</button>
        <button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
      </div>

    </div>
  </div>
</div>
<!-- ════════════ END EDIT MODAL ════════════ -->
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>

    /* SAME ORIGINAL JS — NO CHANGE */

    loadInstitutions();
    loadAcademicYears();
    loadOffices();

    function loadInstitutions() {
        $.post("hostel/ajax/getInstitutions.jsp", function (res) {

            let html = "<option value=''>All</option>";

            res.forEach(function (row) {
                html += "<option value='" + row.institutionid + "'>" + row.institutename + "</option>";
            });

            $("#institution").html(html);

        }, "json");
    }

    function loadOffices() {

        $.post("hostel/ajax/getOffices.jsp", function (res) {

            let html = "<option value=''>All</option>";

            res.forEach(function (row) {
                html += "<option value='" + row.officeid + "'>" + row.officename + "</option>";
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

        $.post("hostel/ajax/getAcademicYears.jsp", function (res) {

            let html = "<option value=''>All</option>";

            res.forEach(function (row) {
                html += "<option value='" + row.academicyearid + "'>" + row.academicyear + "</option>";
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

            if (isMatch)
                visibleCount++;
        });

        $("#noRecordsRow").remove();

        if (visibleCount === 0) {
            $("#tableBody").append(
                    "<tr id='noRecordsRow'><td colspan='45' class='text-center text-danger fw-bold'>No Records Found</td></tr>"
                    );
        }
    });

    function safe(val) {
        return (val === null || val === "null" || val === undefined) ? "" : val;
    }

    function formatNumber(val) {
        if (!val)
            return "";
        var num = parseFloat(val);
        return isNaN(num) ? val : (num % 1 === 0 ? num.toString() : num.toFixed(2));
    }

    function loadData() {

        $.post("hostel/ajax/getRegisteredApplicants.jsp", {
            fromDate: $("#fromDate").val(),
            toDate: $("#toDate").val(),
            institution: $("#institution option:selected").text(),
            academicyear: $("#academicyear").val()
        }, function (res) {

            let html = "";

            if (!res || res.length === 0) {
                html = "<tr><td colspan='45' class='text-center text-danger fw-bold'>No Records Found</td></tr>";
            } else {

                res.forEach(function (row) {

                    html += "<tr>" +
                            "<td>" + (row.status === "Y"
                                    ? "<span style='color:green;font-weight:bold;'>Yes</span>"
                                    : "<span style='color:red;font-weight:bold;'>No</span>") + "</td>" +
                                             "<td>" +

"<button class='btn btn-sm btn-primary viewAppBtn me-1' " +
"data-reg='" + safe(row.registerno) + "'>" +
"View</button> " +

"<a href='ajax/generateApplicationPdf.jsp?userid=" +
safe(row.registerno) +
"' target='_blank' class='btn btn-sm btn-danger'>" +
"PDF</a>" +

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
                            "<td>" + safe(row.premadd1) + " " + safe(row.premadd2) + " " + safe(row.premadd3) + "</td>" +
                            "<td>" + safe(row.pincode) + "</td>" +
                            "<td>" + safe(row.parentmobile) + "</td>" +
                            "<td>" + safe(row.parentemail) + "</td>" +
                            "<td>" + safe(row.officename) + "</td>" +
                            "<td>" + safe(row.updated_on) + "</td>" +
                            "<td>" + safe(row.permstate) + "</td>" +
                            "<td>" + (row.guardianrelation || "") + "</td>" +
                            "<td>" + (row.guardianmobile || "") + "</td>" +
                            "<td>" + (row.guardianemail || "") + "</td>" +
                            "<td>" + (row.guardline1 || "") + " " + (row.guardline2 || "") + " " + (row.guardline3 || "") + "</td>" +
                            "<td><button class='btn btn-sm btn-info viewDocBtn' data-file='" + safe(row.filename) + "'>View Document</button></td>" +
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
        $("#docFrame").attr("src", fileUrl);

        let modal = new bootstrap.Modal(document.getElementById("viewDocModal"));
        modal.show();
    });

    $('#viewDocModal').on('hidden.bs.modal', function () {
        $("#docFrame").attr("src", "");
    });

    $("#searchBtn").click(function () {
        loadData();
    });

    $("#exportBtn").click(function () {

        let table = document.querySelector("table");
        let html = table.outerHTML;

        html = html.replace(/<input[^>]*>/gi, "");

        let blob = new Blob([html], {type: "application/vnd.ms-excel"});
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
                var text = cols[j].innerText.replace(/,/g, "");
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

    loadData();

</script>

<jsp:include page="../../lccerpfooter.jsp"/>

<% } else {%>

session Time out
<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" />

<% }%>
