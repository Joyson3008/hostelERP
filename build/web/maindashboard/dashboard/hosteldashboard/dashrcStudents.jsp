<%-- 
    Document   : dashrcStudents
    Created on : Apr 28, 2026, 11:17:35?AM
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

    String login = (String) session.getAttribute("login");
    String userId = (String) session.getAttribute("username");
    String currofficeid = (String) session.getAttribute("currentOfficeUid");

    if (login != null) {
%>

--%>

<jsp:include page="../../../lccerpheader.jsp"/>

<div class="pcoded-content">
    <div class="pcoded-inner-content">
        <div class="main-body">
            <div class="page-wrapper">
                <div class="page-body">

                    <!-- HEADER CARD -->
                    <div class="card shadow">
                        <div class="card-header bg-primary text-white">
                            <h3>RC Students (Christian - Roman Catholic)</h3>
                        </div>

                        <div class="card-body">

                            <!-- Search -->
                            <input type="text" id="searchBox" class="form-control w-25 mb-3" placeholder="Search...">

                            <!-- TABLE CARD -->
                            <div class="card mt-3">

                                <div class="table-responsive" style="max-height: 500px; overflow-y: auto;">

                                    <table class="table table-bordered table-striped">

                                        <thead class="table-dark" style="position: sticky; top: 0; z-index: 1;">
                                            <tr>
                                                <th>Slno</th>
                                                <th>Application No</th>
                                                <th>Register No</th>
                                                <th>Hostel No</th>
                                                <th>Student Name</th>
                                                <th>Gender</th>
                                                <th>Mobile</th>
                                                <th>Religion</th>
                                                <th>Mess</th>
                                            </tr>
                                        </thead>

                                        <tbody id="tableBody"></tbody>

                                    </table>

                                </div>

                            </div>
                        </div>
                    </div>

                    <!-- BACK BUTTON -->
                    <div class="d-flex justify-content-center mt-3">
                        <a href="../hosteldashboard.jsp" class="btn btn-secondary">
                            Back to Dashboard
                        </a>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODAL -->
<div class="modal fade" id="studentModal" tabindex="-1">
    <div class="modal-dialog" style="max-width: 80%;">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title">Student Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal">x</button>
            </div>

            <div class="modal-body" id="modalBody">
                Loading...
            </div>

        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>

    $(document).ready(function () {
        loadStudents();
    });

    function loadStudents() {

        $.ajax({
            url: "ajax/getRCStudents.jsp",
            type: "GET",
            dataType: "json",
            success: function (data) {

                let html = "";

                $.each(data, function (i, obj) {

                    html += "<tr onclick=\"viewStudent('" + obj.registerno + "')\" style='cursor:pointer'>";
                    html += "<td>" + (i + 1) + "</td>";
                    html += "<td>" + obj.applicationno + "</td>";
                    html += "<td>" + obj.registerno + "</td>";
                    html += "<td>" + (obj.hostelno || "") + "</td>";
                    html += "<td>" + obj.studentname + "</td>";
                    html += "<td>" + obj.gender + "</td>";
                    html += "<td>" + obj.mobile + "</td>";
                    html += "<td>" + obj.religion + "</td>";
                    html += "<td>" + obj.mess + "</td>";
                    html += "</tr>";

                });

                $("#tableBody").html(html);

            },
            error: function () {
                alert("Cannot load data");
            }
        });
    }

    $("#searchBox").on("keyup", function () {

        var value = $(this).val().toLowerCase();

        $("#tableBody tr").filter(function () {
            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
        });

    });

    function viewStudent(regno) {

        $.ajax({
            url: "ajax/getStudentFullProfile.jsp",
            type: "GET",
            data: {regno: regno},
            dataType: "json",

            success: function (res) {

                let html = "";

                html += "<div class='container-fluid'>";

                html += "<div class='row'>";
                html += "<div class='col-md-4'><b>Application No:</b> " + res.applicationno + "</div>";
                html += "<div class='col-md-4'><b>Register No:</b> " + res.regno + "</div>";
                html += "<div class='col-md-4'><b>Hostel No:</b> " + res.hostelno + "</div>";
                html += "</div>";

                html += "<div class='row'>";
                html += "<div class='col-md-4'><b>Institution:</b> " + res.institution + "</div>";
                
                html += "</div>";

                html += "<hr>";

                html += "<div class='row'>";
                html += "<div class='col-md-4'><b>Name:</b> " + res.name + "</div>";
                html += "<div class='col-md-4'><b>College:</b> " + res.office_name + "</div>";
                html += "<div class='col-md-4'><b>Program:</b> " + res.course_description + "</div>";
                html += "</div>";

                html += "<div class='row mt-2'>";
                html += "<div class='col-md-4'><b>Gender:</b> " + res.gender + "</div>";
                html += "<div class='col-md-4'><b>DOB:</b> " + res.dob + "</div>";
                html += "<div class='col-md-4'><b>Blood Group:</b> " + res.bloodgroup + "</div>";
                html += "</div>";

                html += "<div class='row mt-2'>";
                html += "<div class='col-md-4'><b>Mobile:</b> " + res.mobile + "</div>";
                html += "<div class='col-md-4'><b>Email:</b> " + res.email + "</div>";
                html += "<div class='col-md-4'><b>Religion:</b> " + res.religion + "</div>";
                html += "</div>";

                html += "<div class='row mt-2'>";
                html += "<div class='col-md-4'><b>Category:</b> " + res.community + "</div>";
                html += "<div class='col-md-4'><b>Caste:</b> " + res.caste + "</div>";
                html += "<div class='col-md-4'><b>Mother Tongue:</b> " + res.mothertongue + "</div>";

                html += "<div class='row mt-2'>";
                html += "<div class='col-md-12'><b>Permanent:</b> " +
                        res.address_line1 + " " +
                        res.address_line2 + " " +
                        res.address_line3 + "</div>";
                html += "</div>";

                html += "</div>";

                html += "<hr>";

                html += "<h6>Family Details</h6>";

                html += "<div class='row'>";
                html += "<div class='col-md-4'><b>Father:</b> " + res.fathername + "</div>";
                html += "<div class='col-md-4'><b>Occupation:</b> " + res.father_occupation + "</div>";
                html += "<div class='col-md-4'><b>Income:</b> " + res.father_income + "</div>";
                html += "</div>";

                html += "<div class='row mt-2'>";
                html += "<div class='col-md-4'><b>Mother:</b> " + res.mothername + "</div>";
                html += "<div class='col-md-4'><b>Occupation:</b> " + res.mother_occupation + "</div>";
                html += "<div class='col-md-4'><b>Income:</b> " + res.mother_income + "</div>";
                html += "</div>";

                html += "<hr>";

                html += "<h6>Guardian</h6>";

                html += "<div class='row'>";
                html += "<div class='col-md-4'><b>Name:</b> " + res.guardianName + "</div>";
                html += "<div class='col-md-4'><b>Mobile:</b> " + res.guardian_mobile + "</div>";
                html += "<div class='col-md-4'><b>Email:</b> " + res.guardian_email + "</div>";
                html += "</div>";

                html += "<div class='row mt-2'>";
                html += "<div class='col-md-12'><b>Address:</b> " +
                        res.guard_address_line1 + " " +
                        res.guard_address_line2 + " " +
                        res.guard_address_line3 + "</div>";
                html += "</div>";

                html += "<hr><h6>Hostel Details</h6>";

                html += "<div class='row'>";
                html += "<div class='col-md-4'><b>Applied On:</b> " + res.applied_on + "</div>";
                html += "<div class='col-md-4'><b>Selected Date:</b> " + res.selected_datetime + "</div>";
                html += "<div class='col-md-4'><b>Room Allocated:</b> " + res.room_allocated + "</div>";
                html += "</div>";

                html += "<div class='row mt-2'>";
                html += "<div class='col-md-4'><b>Room No:</b> " + res.room_no + "</div>";
                html += "<div class='col-md-4'><b>Mess Allocated:</b> " + res.mess_allocated + "</div>";
                html += "<div class='col-md-4'><b>Mess Name:</b> " + res.mess_name + "</div>";
                html += "</div>";

                $("#modalBody").html(html);

                var modal = new bootstrap.Modal(document.getElementById('studentModal'));
                modal.show();
            },

            error: function () {
                alert("Cannot load student details");
            }
        });
    }

</script>

<jsp:include page="../../../lccerpfooter.jsp"/>

<%--
<% } else {%>

session Time out
<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" />

<% }%>

--%>
