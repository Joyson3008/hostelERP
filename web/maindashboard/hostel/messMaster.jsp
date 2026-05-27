<%-- 
    Document   : messMaster
    Created on : Apr 27, 2026, 1:45:53?PM
    Author     : lccerp26
--%>
<%--

<%
    // *************** Authentication Block ***************
    String per = "A";
    String mName = "HOSTEL_MESS_MASTER";
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

                    <!-- FORM -->
                    <div class="row">
                        <div class="col-md-8 offset-md-2">

                            <div class="card shadow">
                                <div class="card-header bg-primary text-white">
                                    <h5 class="mb-0 text-white">Mess Master</h5>
                                </div>

                                <div class="card-body">

                                    <div id="message"></div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <label>Name of the Mess</label>
                                            <input type="text" id="mess_name" class="form-control">
                                        </div>

                                        <div class="col-md-6">
                                            <label>Mess Short Name</label>
                                            <input type="text" id="mess_short_name" class="form-control">
                                        </div>
                                    </div>

                                    <div class="text-center mt-3">
                                        <button class="btn btn-success" id="saveBtn">Save</button>
                                        <button class="btn btn-secondary ml-2" id="clearBtn">Clear</button>
                                    </div>

                                </div>
                            </div>

                        </div>
                    </div>

                    <!-- TABLE -->
                    <div class="row mt-4">
                        <div class="col-md-10 offset-md-1">

                            <div class="card">

                                <div class="card-header bg-primary text-white">
                                    <h6 class="mb-0 text-white">Mess List</h6>
                                </div>

                                <div class="card-body">

                                    <!-- ? Scrollable Table -->
                                    <div class="table-responsive" style="max-height: 300px; overflow-y: auto;">
                                        <table class="table table-bordered table-striped table-sm">
                                            <thead class="table-light sticky-top">
                                                <tr>
                                                    <th>Sl No</th>
                                                    <th>Mess Name</th>
                                                    <th>Mess Short Name</th>
                                                    <th>Action</th>
                                                </tr>
                                            </thead>
                                            <tbody id="messTableBody"></tbody>
                                        </table>
                                    </div>

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

<script>

    $(document).ready(function () {
        loadMess();
    });

    // LOAD
    function loadMess() {

        $("#messTableBody").html("<tr><td colspan='4' class='text-center'>Loading...</td></tr>");

        $.get("ajax/getMess.jsp", function (res) {

            let html = "";
            let i = 1;

            if (res && res.length > 0) {

                res.forEach(function (obj) {

                    html += "<tr>"
                            + "<td>" + (i++) + "</td>"
                            + "<td>" + obj.mess_name + "</td>"
                            + "<td>" + obj.mess_short_name + "</td>"
                            + "<td>"
                            + "<button class='btn btn-sm btn-warning editBtn' "
                            + "data-id='" + obj.mess_id + "' "
                            + "data-name='" + obj.mess_name + "' "
                            + "data-short='" + obj.mess_short_name + "'>Edit</button> "

                            + "<button class='btn btn-sm btn-danger deleteBtn' "
                            + "data-id='" + obj.mess_id + "'>Delete</button>"
                            + "</td>"
                            + "</tr>";

                });

            } else {

                html = "<tr><td colspan='4' class='text-center'>No Records Found</td></tr>";

            }

            $("#messTableBody").html(html);

        }, "json").fail(function () {

            $("#messTableBody").html("<tr><td colspan='4' class='text-danger text-center'>Cannot load data</td></tr>");

        });

    }

    // SAVE / UPDATE
    $("#saveBtn").click(function () {

        const name = $("#mess_name").val().trim();
        const shortName = $("#mess_short_name").val().trim();
        const id = $(this).data("edit-id") || "";

        if (!name || !shortName) {
            alert("All fields are required");
            return;
        }

        const url = id
                ? "ajax/updateMess.jsp"
                : "ajax/saveMess.jsp";

        $.post(url, {
            mess_id: id,
            mess_name: name,
            mess_short_name: shortName
        }, function (res) {

            if (res.success) {

                $("#message").html('<div class="alert alert-success">Saved Successfully</div>');

                $("#mess_name, #mess_short_name").val("");
                $("#saveBtn").removeData("edit-id").text("Save");

                loadMess();

            } else {

                $("#message").html('<div class="alert alert-danger">' + (res.error || "Error") + '</div>');
            }

        }, "json").fail(function () {

            $("#message").html('<div class="alert alert-danger">Connection not Established</div>');

        });

    });

    // EDIT
    $(document).on("click", ".editBtn", function () {

        $("#mess_name").val($(this).data("name"));
        $("#mess_short_name").val($(this).data("short"));

        $("#saveBtn")
                .data("edit-id", $(this).data("id"))
                .text("Update");

    });

    // DELETE
    $(document).on("click", ".deleteBtn", function () {

        const id = $(this).data("id");

        if (!confirm("Are you sure you want to delete?"))
            return;

        $.post("ajax/deleteMess.jsp", {mess_id: id}, function (res) {

            if (res.success) {

                $("#message").html('<div class="alert alert-success">Deleted Successfully</div>');
                loadMess();

            } else {

                $("#message").html('<div class="alert alert-danger">Delete Failed</div>');
            }

        }, "json");

    });

    // CLEAR
    $("#clearBtn").click(function () {

        $("#mess_name, #mess_short_name").val("");
        $("#saveBtn").removeData("edit-id").text("Save");
        $("#message").html("");

    });

</script>

<jsp:include page="../../lccerpfooter.jsp"/>

<%--

<% } else {%>

session Time out
<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" />

<% }%>

--%>