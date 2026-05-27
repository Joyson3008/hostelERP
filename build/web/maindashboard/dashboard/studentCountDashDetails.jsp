<%-- 
    Document   : studentCountDashDetails
    Created on : Sep 3, 2025, 2:25:57 PM
    Author     : rm
--%>

<%
    // *************** Authentication Block ***************
    String per = "A";
    String mName = "ERP_ACCOU_MAST";
%>
<%--<%@ include file="/usermanager/permission.jsp" %>--%>
<jsp:useBean id="modu" class="erp.module.ModuleMaster" scope="request"/>

<%@ page import="org.json.simple.*" %>
<%@ page import="java.util.*" %> 
<%  
    session.setAttribute("login","true");

    String login = (String) session.getAttribute("login");

    if (login != null) {
        //out.println(uid);
%>

<%--<jsp:include page="../../lccerpheader.jsp"/>--%>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<%
    String sec = request.getParameter("section");
%>
<div class="pcoded-content">
    <div class="pcoded-inner-content">
        <div class="main-body">
            <div class="page-wrapper">


                <div class="page-body">
                    <div class="row">
                        <div class="col-sm-12">
                            <!-- Bootstrap tab card start -->
                            <div class="card">

                                <div class="card-block">
                                    <!-- Row start -->

                                    <div class="row">
                                        <div class="col-lg-12 col-xl-12">
                                            <div class="table-responsive">

                                                <table id="reportTable" class="table table-bordered table-striped">
                                                    <thead>
                                                        <tr id="headerRow"></tr>
                                                        <tr id="headerRow2"></tr>
                                                    </thead>
                                                    <tbody id="dataBody"></tbody>
                                                    <tfoot id="dataFoot"></tfoot>
                                                </table>

                                            </div>
                                        </div>
                                        <form id="studentFilterForm" method="post" action="studentListJson.jsp" style="display:none;">
                                            <input type="hidden" name="course" id="courseInput">
                                            <input type="hidden" name="community" id="communityInput">
                                            <input type="hidden" name="gender" id="genderInput">
                                            <input type="hidden" name="section" id="sectionInput">
                                        </form>


                                        <script>
                                            $(document).ready(function () {
                                                function loadReport() {
                                                    $.getJSON("dashboard/communityReport.jsp?section=<%=sec%>", function (data) {
                                                        console.log("DATA:", data); // ✅ Debug

                                                        if (!data || data.length === 0) {
                                                            $("#reportTable").hide();
                                                            return;
                                                        }

                                                        $("#reportTable").show();

                                                        // Get all keys except description
                                                        var keys = Object.keys(data[0]).filter(k => k !== "description");

                                                        // Group by community
                                                        var grouped = {};
                                                        keys.forEach(function (k) {
                                                            var parts = k.split("_"); // e.g. SC_Female
                                                            var comm = parts[0];      // SC
                                                            var gender = parts[1];    // Female
                                                            if (!grouped[comm])
                                                                grouped[comm] = [];
                                                            if (!grouped[comm].includes(gender)) {
                                                                grouped[comm].push(gender);
                                                            }
                                                        });

                                                        // --- Build headers ---
                                                        var header1 = "<th rowspan='2'>Course Name</th>";
                                                        var header2 = "";
                                                        $.each(grouped, function (comm, genders) {
                                                            header1 += "<th colspan='" + genders.length + "'>" + comm + "</th>";
                                                            genders.forEach(function (g) {
                                                                header2 += "<th>" + g + "</th>";
                                                            });
                                                        });
                                                        header1 += "<th rowspan='2'>Row Total</th>";

                                                        $("#headerRow").html(header1);
                                                        $("#headerRow2").html(header2);

                                                        // --- Prepare vertical totals ---
                                                        var verticalTotals = {};
                                                        $.each(grouped, function (comm, genders) {
                                                            genders.forEach(function (g) {
                                                                verticalTotals[comm + "_" + g] = 0;
                                                            });
                                                        });
                                                        var grandTotal = 0;

                                                        // --- Build rows ---

                                                        var rows = "";
                                                        $.each(data, function (i, row) {
                                                            var rowTotal = 0;
                                                            rows += "<tr>";
                                                            rows += "<td>" + row.description + "</td>";

                                                            $.each(grouped, function (comm, genders) {
                                                                genders.forEach(function (g) {
                                                                    var colKey = comm + "_" + g;
                                                                    var gen = "";
                                                                    if (g == "Male") {
                                                                        g = "M";
                                                                    } else {
                                                                        g = "F";

                                                                    }
                                                                    var val = row[colKey] !== undefined ? Number(row[colKey]) : 0;

                                                                    // Make the cell clickable
                                                                    rows += "<td style='cursor:pointer; color:blue;' " +
                                                                            "onclick=\"loadStudentList('" + row.description + "','" + comm + "','" + g + "','<%=sec%>')\">" +
                                                                            val +
                                                                            "</td>";

                                                                    // Sum totals
                                                                    rowTotal += val;
                                                                    verticalTotals[colKey] += val;
                                                                    grandTotal += val;
                                                                });
                                                            });

                                                            // Add row total at the end
                                                            rows += "<td>" + rowTotal + "</td>";

                                                            rows += "</tr>";
                                                        });



                                                        $("#dataBody").html(rows);

                                                        // --- Footer totals row ---
                                                        var foot = "<tr class='table-secondary'><th>Column Total</th>";
                                                        $.each(grouped, function (comm, genders) {
                                                            genders.forEach(function (g) {
                                                                var colKey = comm + "_" + g;
                                                                foot += "<th>" + verticalTotals[colKey] + "</th>";
                                                            });
                                                        });
                                                        foot += "<th><b>" + grandTotal + "</b></th></tr>";

                                                        $("#dataFoot").html(foot);

                                                    }).fail(function (xhr, status, error) {
                                                        console.error("AJAX Error:", error);
                                                    });
                                                }

                                                loadReport();
                                            });

                                            function loadStudentList(courseName, community, gender, section) {
                                                // Set hidden input values
                                                document.getElementById("courseInput").value = courseName;
                                                document.getElementById("communityInput").value = community;
                                                document.getElementById("genderInput").value = gender;
                                                document.getElementById("sectionInput").value = section;

                                                // Submit the form
                                                document.getElementById("studentFilterForm").submit();
                                            }


                                        </script>
                                        <!-- Nav tabs -->



                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

            </div>
        </div>
    </div>






    <jsp:include page="../../lccerpfooter.jsp"/>
    <% } else {
        // out.println(uid);
        out.println("session Time out");
    %>
    <meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" /> 
    <%
        }
    %>
