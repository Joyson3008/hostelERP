<%-- 
    Document   : selectedHostelAppliciants
    Created on : Apr 14, 2026, 11:19:02?AM
    Author     : lccerp26
--%>

<%
    // *************** Authentication Block ***************
    String per = "A";
    String mName = "SELECTED_HOSTEL_APPLICANTS";
%>
<%--<%@ include file="/usermanager/permission.jsp" %>--%>

<%@page import="java.net.InetAddress"%>
<%@page import="java.net.UnknownHostException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="../../usermanager/css/bootstrap.min.css">
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
                                    <h5 class="mb-0">Selected Hostel Applicants</h5>
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
                                    </div>

                                    <div class="row g-3 mb-3 justify-content-center">
                                        <div class="col-md-3 d-flex align-items-end justify-content-center">
                                            <button id="searchBtn" class="btn btn-success ml-2">Search</button>
                                            <button id="resetBtn" class="btn btn-secondary ml-2">Reset</button>
                                            <button id="exportBtn" class="btn btn-primary ml-2">Excel</button>
                                            <button id="csvBtn" class="btn btn-success ml-2">CSV</button>
                                            <button id="exportAll" class="btn btn-primary ml-2">Export All in PDF</button>
                                        </div>
                                    </div>

                                    <!-- Table -->
                                    <div class="table-responsive" style="overflow-x:auto;">
                                        <table class="table table-bordered table-hover table-sm" style="min-width:2500px;">

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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.31/jspdf.plugin.autotable.min.js"></script>

<script>
    loadInstitutions();
    loadAcademicYears();
    loadOffices();
    function loadInstitutions()
    {

        $.post("hostel/ajax/getInstitutions.jsp", function (res) {

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

        $.post("hostel/ajax/getOffices.jsp", function (res) {

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

        $.post("hostel/ajax/getAcademicYears.jsp", function (res) {

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
    function loadData() {

        const from = $("#fromDate").val();
        const to = $("#toDate").val();
        const inst = $("#institution option:selected").text();
        const ay = $("#academicyear").val();
        const office = $("#office").val();

        $.post("hostel/ajax/getSelectedApplicants.jsp", {
            fromDate: from,
            toDate: to,
            institution: inst,
            academicyear: ay
        }, function (res) {

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
                            "<td><button id='fixbtn' class='btn btn-sm btn-primary viewAppBtn' data-reg='" + safe(row.registerno) + "'>View</button></td>" +
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

        fetch("hostel/ajax/fetchFullProfile.jsp?registerno=" + regno)
                .then(r => r.json())
                .then(data => {

                    if (data.error) {
                        alert(data.error);
                        return;
                    }

                    let html = "";
                    let photoUrl = "<%=request.getContextPath()%>/hostelprofile_uploads/" + safe(data.studentphoto);
                    //let photoUrl = "<%=request.getContextPath()%>/../hostelonline/hostelprofile_uploads/" + safe(data.studentphoto);
                    console.log(photoUrl);

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
                .catch(err => {
                    alert("Cannot load the application");
                });

    });

    $("#searchBtn").click(function () {
        loadData();
    });
    $("#exportBtn").click(function () {

        let table = document.querySelector("table");

        // Clone table so original UI is untouched
        let clone = table.cloneNode(true);

        // Remove first column from all rows
        clone.querySelectorAll("tr").forEach(row => {
            if (row.children.length > 0) {
                row.removeChild(row.children[0]);
            }
        });

        let html = clone.outerHTML;

        // Remove inputs if needed
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

            for (var j = 1; j < cols.length; j++) {

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

    $("#exportAll").click(async function () {

        const {jsPDF} = window.jspdf;
        const doc = new jsPDF({orientation: "portrait", unit: "mm", format: "a4"});

        let rows = $("#tableBody tr");

        let first = true;

        for (let i = 0; i < rows.length; i++) {

            let regno = $(rows[i]).find(".viewAppBtn").data("reg");

            if (!regno)
                continue;

            let res = await fetch("hostel/ajax/fetchFullProfile.jsp?registerno=" + regno);
            let data = await res.json();

            if (!first)
                doc.addPage();
            first = false;

            await generatePDFPage(doc, data);
        }

        doc.save("All_Selected_HostelApplications.pdf");
    });

    async function generatePDFPage(doc, data) {

        let y = 13;

        // ? LOGO + STUDENT PHOTO
        function toBase64(url) {
            return fetch(url)
                    .then(res => res.blob())
                    .then(blob => new Promise((resolve) => {
                            const reader = new FileReader();
                            reader.onloadend = () => resolve(reader.result);
                            reader.readAsDataURL(blob);
                        }));
        }

        async function loadImagesAndDraw() {

            const logoURL = "<%=request.getContextPath()%>/maindashboard/hostel/images/logoMH.jpg";

            let studentURL = null;
            if (data.studentphoto && data.studentphoto !== "") {
                studentURL = "<%=request.getContextPath()%>/hostelERP/hostelprofile_uploads/" + data.studentphoto;
            }

            const logoBase64 = await toBase64(logoURL);
            let studentBase64 = null;

            if (studentURL) {
                studentBase64 = await toBase64(studentURL);
            }

            doc.addImage(logoBase64, "JPEG", 15, 10, 25, 25);

            if (studentBase64) {
                doc.addImage(studentBase64, "JPEG", 170, 10, 25, 25);
            }
        }

        await loadImagesAndDraw();

        // ===== HEADER =====
        doc.setFontSize(14);
        doc.setFont("helvetica", "bold");
        doc.text("Loyola College (Autonomous)", 105, y, {align: "center"});
        y += 5;

        doc.setFontSize(12);
        doc.text("Chennai-34", 105, y, {align: "center"});
        y += 5;

        doc.setFontSize(12);
        doc.text("Hostel Application 2026-2027", 105, y, {align: "center"});
        y += 7;

        doc.setFont("helvetica", "bold");
        doc.setFontSize(12);
        doc.text("LOYOLA MEN'S HOSTEL", 105, y, {align: "center"});
        y += 5.5;

        doc.setFontSize(10);
        doc.text("Application No: " + (data.applicationno || ""), 110, y);
        y += 2.5;

        // ================= KEEP EVERYTHING BELOW SAME =================

        let rowHeight = 7;

        function drawSectionHeader(title) {
            doc.setFillColor(200, 220, 255);
            doc.rect(15, y, 180, 7, "F");
            doc.setFont("helvetica", "bold");
            doc.setFontSize(10);
            doc.text(title, 17, y + 5);
            y += 7;
        }

        function drawCenterSplitRow(label, value) {
            const lineHeight = 6;
            let splitValue = doc.splitTextToSize(value || "", 70);
            let height = splitValue.length * lineHeight;

            doc.rect(15, y, 90, height);
            doc.rect(105, y, 90, height);

            doc.setFont("helvetica", "normal");
            doc.text(label, 17, y + 4);
            doc.text(splitValue, 107, y + 4);

            y += height;
        }

        function drawCenterSplit1Row(label, value) {
            const lineHeight = 6;
            let splitValue = doc.splitTextToSize(value || "", 70);
            let height = splitValue.length * lineHeight;
            doc.setFont("helvetica", "normal");
            doc.rect(15, y, 30, height);
            doc.rect(45, y, 150, height);

            doc.text(label, 17, y + 4);
            doc.text(splitValue, 47, y + 4);

            y += height;
        }

        function drawTwoColRow(l1, v1, l2, v2) {

            const lineHeight = 6;
            let leftVal = doc.splitTextToSize(v1 || "", 45);
            let rightVal = doc.splitTextToSize(v2 || "", 45);
            let height = Math.max(leftVal.length, rightVal.length) * lineHeight;
            doc.setFont("helvetica", "normal");
            doc.rect(15, y, 30, height);
            doc.rect(45, y, 60, height);

            doc.rect(105, y, 35, height);
            doc.rect(140, y, 55, height);

            doc.text(l1, 17, y + 4);
            doc.text(l2, 107, y + 4);

            doc.text(leftVal, 47, y + 4);
            doc.text(rightVal, 142, y + 4);

            y += height;
        }

        function drawAddressRow(l1, v1, l2, v2) {

            const lineHeight = 6;
            let leftVal = doc.splitTextToSize(v1 || "", 50);
            let rightVal = doc.splitTextToSize(v2 || "", 50);
            let height = Math.max(leftVal.length, rightVal.length) * lineHeight;
            doc.setFont("helvetica", "normal");
            doc.rect(15, y, 32, height);
            doc.rect(47, y, 58, height);

            doc.rect(105, y, 35, height);
            doc.rect(140, y, 55, height);

            doc.text(l1, 17, y + 4);
            doc.text(l2, 107, y + 4);

            doc.text(leftVal, 49, y + 4);
            doc.text(rightVal, 142, y + 4);

            y += height;
        }

        function drawHalfSectionHeaders(leftTitle, rightTitle) {
            const height = 7;

            doc.setFillColor(200, 220, 255);
            doc.rect(15, y, 90, height, "F");
            doc.rect(105, y, 90, height, "F");

            doc.setFont("helvetica", "bold");
            doc.setFontSize(10);

            doc.text(leftTitle, 17, y + 5);
            doc.text(rightTitle, 107, y + 5);

            y += height;
        }

        // ===== YOUR SAME FLOW =====

        drawSectionHeader("PERSONAL DETAILS");
        y += 0.5;
        drawCenterSplit1Row("Name", data.name);

        drawTwoColRow("Institution", data.institution, "Dept No", data.regno);
        drawTwoColRow("Program", data.course_description, "College", "LOYOLA HOSTEL");
        drawTwoColRow("Gender", data.gender, "Blood Group", data.bloodgroup);
        drawTwoColRow("Date of Birth", data.dob, "Age", data.age);
        drawTwoColRow("Mobile Number", data.mobile, "Email Id", data.email);
        drawTwoColRow("State", data.statename, "District", data.district);
        drawTwoColRow("Town / Place", data.town, "Village", data.village);
        drawTwoColRow("Religion", data.religion, "Community", data.community);
        drawTwoColRow("Caste", data.caste, "Mother Tongue", data.mothertongue);

        y += 0.5;
        drawSectionHeader("FAMILY DETAILS");
        y += 0.5;
        drawTwoColRow("Father Name", data.fathername, "Mother Name", data.mothername);
        drawTwoColRow("Education", data.father_education, "Education", data.mother_education);
        drawTwoColRow("Occupation", data.father_occupation, "Occupation", data.mother_occupation);

        drawTwoColRow("Annual Income", data.father_income, "Annual Income", data.mother_income);

        drawTwoColRow("Mobile Number", data.parent_mobile, "Father's Email id", data.parent_email);

        drawCenterSplitRow("Whether you are Visually/Physically Challenged", data.differentlyabled);
        drawCenterSplitRow("Name of the School & Place Studied?", data.school);

        let mark200 = data.mark_200 ? parseInt(data.mark_200) : "-";
        let mark100 = data.mark_100 ? parseInt(data.mark_100) : "-";

        drawCenterSplitRow("Total Marks in Plus Two", mark200 + " / " + mark100);
        drawCenterSplitRow("Local Guardian Name and Relation", data.guardianName);

        y += 0.3;
        drawSectionHeader("COMMUNICATION DETAILS");
        y += 0.5;
        drawHalfSectionHeaders("PERMANENT ADDRESS", "LOCAL GUARDIAN ADDRESS");
        y += 0.5;
        drawAddressRow("Address Line 1", data.address_line1, "Address Line 1", data.guard_address_line1);
        drawAddressRow("Address Line 2", data.address_line2, "Address Line 2", data.guard_address_line2);
        drawAddressRow("Address Line 3", data.address_line3, "Address Line 3", data.guard_address_line3);
        drawAddressRow("District", data.prem_district, "District", data.guarddistrict);
        drawAddressRow("State Name", data.statename, "State Name", data.guardState);
        drawAddressRow("Pin Code", data.pincode, "Pin Code", data.guard_pincode);
        drawAddressRow("Parent Mobile No.", data.parent_mobile, "Mobile no.", data.guardian_mobile);

        // ===== PRINT TIME =====
        let now = new Date();
        let printText = "Printed on: " + now.toLocaleString();

        doc.setFontSize(8);
        doc.text(printText, 195, 290, {align: "right"});
    }

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

    loadData();

</script>

<jsp:include page="../../lccerpfooter.jsp"/>

<% } else {%>

session Time out
<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" />

<% }%>