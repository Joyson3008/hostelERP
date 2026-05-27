<%-- 
    Document   : moduleuserassignment
    Created on : Jul 7, 2025, 12:18:52?PM
    Author     : rm
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    response.setDateHeader("Expires", 0);
    response.addHeader("Cache-Control", "no-cache, no-store, must-revlidate");
    response.addHeader("Cache-Control", "post-check=0, pre-check=0");
    response.setHeader("Pragma", "no-cache");
%>
<%
    // *************** Authentication Block ***************
    String per = "A";
    String mName = "ERP_MODU_PERM";
%>
<%@ include file="/usermanager/permission.jsp" %>
<jsp:useBean id="modu" class="erp.module.ModuleMaster" scope="request"/>
<%@ page import="org.json.simple.*" %>




<%     String login = (String) session.getAttribute("login");

    if (login != null) {

        //out.println(uid);
%>


<jsp:include page="../../lccerpheader.jsp"/>


<div class="pcoded-content">
    <div class="pcoded-inner-content">
        <div class="main-body">
            <div class="page-wrapper">

                <div class="page-body">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="card">

                                <div class="card-block">
                                    <!-- Row start -->
                                    <div class="row">
                                        <div class="col-lg-12 col-xl-12">

                                            <div class="col-lg-12 col-xl-12">
                                                <ul class="nav nav-tabs  tabs" role="tablist" >
                                                    <li class="nav-item">
                                                        <a class="nav-link active" data-toggle="tab" href="#ppattern" role="tab">Module Permission</a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a class="nav-link" data-toggle="tab" href="#ptype" role="tab">Password Change</a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a class="nav-link" data-toggle="tab" href="#officeenable" role="tab">Office Enable</a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a class="nav-link" data-toggle="tab" href="#progsecauz" role="tab">Program Authorization</a>
                                                    </li>
                                                </ul>


                                                <!-- Tab panes -->


                                                <div class="tab-content tabs card-block">

                                                    <div class="tab-pane active" id="ppattern" role="tabpanel">

                                                        <form id="filePermissionForm" autocomplete="off">

                                                            <div class="form-group form-default">
                                                                <label for="empname">User / Employee Name</label>
                                                                <div class="col-sm-10">
                                                                    <input type="text" name="empname" id="empname" class="form-control" onkeyup="showSuggestions(this.value)">
                                                                    <input type="hidden" name="userid" id="userid">
                                                                    <input type="hidden" name="useridname" id="useridname">
                                                                    <div id="suggestions" class="bg-white border" style="display:none; max-height:250px; overflow-y:auto;"></div>
                                                                </div>
                                                            </div>
                                                            <div class="row">
                                                                <div class="col-sm-4">

                                                                    <!-- Role checkboxes -->
                                                                    <div class="form-group mt-3">
                                                                        <label for="roles">Select Roles</label>
                                                                        <div id="role-checkbox-container" class="p-2 border rounded" style="max-height:500px; overflow-y:auto;">
                                                                            <!-- Roles will load dynamically -->
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <div class="col-sm-4">
                                                                    <div class="form-group mt-3">
                                                                    <!-- Module checkboxes will be loaded here -->
                                                                    <label for="roles">Select Modules</label>
                                                                    <div id="module-checkbox-container" class="mt-3"></div>
                                                                    </div>
                                                                </div></div>

                                                            <button type="button" onclick="saveModules()" class="btn btn-success">Save Modules</button>

                                                    </div>

                                                    <div class="tab-pane" id="ptype" role="tabpanel">

                                                        <div class="form-group form-default">
                                                            <label for="empname">User / Employee Name</label>
                                                            <div class="col-sm-10">
                                                                <input type="text" id="passname" name="passname" readonly=""class="form-control" >
                                                                <input type="hidden" id="uid" name="uid" readonly=""class="form-control" ></label>
                                                            </div>
                                                        </div>
                                                        <div class="form-group form-default">
                                                            <label for="empname">New Password</label>
                                                            <div class="col-sm-10">
                                                                <input type="password" id="upassuid" name="upassuid" class="form-control" ></label>
                                                            </div>
                                                        </div>


                                                        <button type="button" onclick="resetPassword()">Reset Password</button>


                                                    </div>

                                                    <div class="tab-pane" id="officeenable" role="tabpanel">

                                                        <div class="form-group form-default">
                                                            <label for="empname">User / Employee Name</label>
                                                            <div class="col-sm-10">
                                                                <input type="text" id="offname" name="offname" readonly=""class="form-control" >
                                                                <input type="hidden" id="off_uid" name="off_uid" readonly=""class="form-control" ></label>
                                                            </div>
                                                        </div>
                                                        <!--                                                        <input type="hidden" id="userid" value="admin123">-->
                                                        <div id="officeCheckboxList" class="row"></div>
                                                        <button onclick="saveUserOffices()">Save</button>

                                                        </form>


                                                    </div>


                                                    <div class="tab-pane" id="progsecauz" role="tabpanel">
                                                        <!--                                        <div class="card">
                                                                                                    <div class="card-header">
                                                                                                        <div class="card-header bg-primary text-white">Program and Section authorization</div>
                                                                                                        <span>Add class of <code>.form-control</code> with <code>&lt;input&gt;</code> tag</span>
                                                                                                    </div>
                                                                                                    <div class="card-block">-->


                                                        <div class="form-group form-default">
                                                            <label for="empname">User / Employee Name</label>
                                                            <div class="col-sm-10">
                                                                <input type="text" id="offnameprog" name="offnameprog" readonly=""class="form-control" >
                                                                <input type="hidden" id="off_uidprog" name="off_uidprog" readonly=""class="form-control" ></label>
                                                            </div>
                                                            <div class="row">
                                                                <label for="empname">Regulation Year</label>

                                                                <div class="col-sm-4">
                                                                    <select name="regyear" id="regyear">
                                                                        <option value="">--- Select ---</option>
                                                                    </select>

                                                                    <button onclick="loadProgAuth()">View</button>
                                                                    <table border="1" id="coursesTable" class="table table-xs">
                                                                        <thead>
                                                                            <!--        <tr>
                                                                                        <th>Select</th>
                                                                                        <th>Description</th>
                                                                                    </tr>-->
                                                                        </thead>
                                                                        <tbody>

                                                                        </tbody>
                                                                    </table>

                                                                    <button onclick="saveprogauthor()">Save</button>

                                                                </div>
                                                                <div class="col-sm-4">

                                                                    <table id="tblProgAuth" class="table table-xs">

                                                                        <tbody></tbody>
                                                                    </table>




                                                                    <!--                                                    </div>
                                                                                                                        </div>-->

                                                                </div>

                                                                </form>


                                                            </div> 

                                                        </div>
                                                    </div>

                                                    <div class="tab-pane" id="programinstitution" role="tabpanel">
                                                    </div>

                                                </div>
                                                <!-- Row end -->
                                            </div>



                                        </div>
                                    </div>


                                    <script>
                                        function showSuggestions(keyword) {

                                            if (keyword.length < 2) {
                                                $("#suggestions").hide();
                                                return;
                                            }

                                            $.get("userrights/suggest_user.jsp", {q: keyword}, function (data) {
                                                $("#suggestions").html(data).show();
                                            });
                                        }

                                        // Load roles from rolemaster table
// Load roles from rolemaster table
                                        function loadRoles() {
                                            $.ajax({
                                                url: "userrights/get_roles.jsp",
                                                type: "GET",
                                                dataType: "json",
                                                success: function (data) {
                                                    var container = $("#role-checkbox-container");
                                                    container.empty();

                                                    if (data.length > 0) {
                                                        for (var i = 0; i < data.length; i++) {
                                                            var role = data[i];

                                                            var checkbox =
                                                                    "<div class='form-check mb-1'>" +
                                                                    "<label>" +
                                                                    "<input type='checkbox' class='role-checkbox' name='roles' " +
                                                                    "id='role_" + role.roleid + "' value='" + role.roleid + "'> " +
                                                                    role.rolename +
                                                                    "</label>" +
                                                                    "</div>";



                                                            container.append(checkbox);
                                                        }
                                                    } else {
                                                        container.html("<small class='text-muted'>No roles found.</small>");
                                                    }
                                                },
                                                error: function (xhr, status, err) {
                                                    console.error("Error loading roles:", err);
                                                }
                                            });
                                        }

// Call on page load
                                        $(document).ready(function () {
                                            loadRoles();
                                        });


// Call this on page load
                                        $(document).ready(function () {
                                            loadRoles();
                                        });



                                        function selectUser(userId, userName) {
                                            $("#empname").val(userName);
                                            $("#useridname").val(userName);
                                            $("#uid").val(userId);
                                            $("#off_uid").val(userId);
                                            $("#userid").val(userId);  // ✅ SETS THE VALUE USED BY saveModules()
                                            $("#passname").val(userName);
                                            $("#offname").val(userName);

                                            $("#offnameprog").val(userName);
                                            $("#off_uidprog").val(userId);

                                            $("#suggestions").hide();
                                            console.log("-----", userId + "----" + userName);

                                            $.get("userrights/load_user_modules.jsp", {userid: userId}, function (data) {
                                                $("#module-checkbox-container").html(data);
                                            });

                                            // Load assigned roles and mark checkboxes
                                            $.get("userrights/load_user_roles.jsp", {userid: userId}, function (data) {
                                                console.log("User roles:", data);
                                                $(".role-checkbox").prop("checked", false);
                                                if (data && data.length > 0) {
                                                    data.forEach(function (roleId) {
                                                        $("#role_" + roleId).prop("checked", true);
                                                    });
                                                }
                                            }, "json");

                                            loadOfficeCheckboxes();
                                        }


                                        function saveModules() {
                                            const userId = document.getElementById("userid").value;
                                            const userIdname = document.getElementById("useridname").value;

                                            if (!userId) {
                                                alert("Please select a user.");
                                                return;
                                            }

                                            // ✅ Get selected modules
                                            const selectedModules = Array.from(document.querySelectorAll('input[name="modname"]:checked'))
                                                    .map(cb => cb.value)
                                                    .join(",");

                                            // ✅ Get selected roles (ensure they exist and are checked)
                                            const selectedRoles = Array.from(document.querySelectorAll('#role-checkbox-container .role-checkbox:checked'))
                                                    .map(cb => cb.value)
                                                    .join(",");

                                            console.log("Selected Roles:", selectedRoles); // ✅ Debug log

                                            if (!selectedModules && !selectedRoles) {
                                                alert("Please select at least one module or role.");
                                                return;
                                            }

                                            const url = "userrights/update_user_modules.jsp"
                                                    + "?useridname=" + encodeURIComponent(userIdname)
                                                    + "&userid=" + encodeURIComponent(userId)
                                                    + "&modname=" + encodeURIComponent(selectedModules)
                                                    + "&roles=" + encodeURIComponent(selectedRoles);

                                            fetch(url)
                                                    .then(resp => resp.text())
                                                    .then(text => {
                                                        console.log("Server response:", text);
                                                        alert(text.trim());
                                                    })
                                                    .catch(err => alert("AJAX Error: " + err));
                                        }


                                        function resetPassword() {
                                            const userId = $("#uid").val();
                                            const newPassword = $("#upassuid").val();

                                            if (!userId || !newPassword) {
                                                alert("Please enter both User ID and New Password.");
                                                return;
                                            }

                                            $.post("userrights/reset_user_password.jsp", {
                                                userid: userId,
                                                password: newPassword
                                            }, function (response) {
                                                alert(response);
                                            });
                                        }


                                        $(document).ready(function () {
                                            $.ajax({
                                                url: 'academic/regulationlist.jsp',
                                                type: 'GET',
                                                dataType: 'json',
                                                success: function (data) {
                                                    var $select = $('#regyear');
                                                    data.forEach(function (option) {
                                                        $select.append('<option value="' + option.regulationid + '">' + option.regulationdesc + '</option>');
                                                    });
                                                },
                                                error: function (err) {
                                                    console.error('Error loading regulations:', err);
                                                }
                                            });

                                            $('#regyear').change(function () {
                                                var regulationId = $(this).val();
                                                if (regulationId) {
                                                    $.ajax({
                                                        url: 'academic/getCourses.jsp',
                                                        type: 'GET',
                                                        data: {regulationid: regulationId},
                                                        dataType: 'json',
                                                        success: function (data) {
                                                            var $tbody = $('#coursesTable tbody');
                                                            $tbody.empty();
                                                            data.forEach(function (course) {
                                                                var row = '<tr>' +
                                                                        '<td><input type="checkbox" name="selectedCoursesprog" id="selectedCoursesprog" value="' + course.coursecode + '-' + course.section + '">' +
                                                                        '-' + course.description + '-' + course.section + '</td>' +
                                                                        '</tr>';
                                                                $tbody.append(row);
                                                            });
                                                        }
                                                    });
                                                } else {
                                                    $('#coursesTable tbody').empty();
                                                }
                                            });


                                        });


                                    </script>

                                    <script>
                                        function loadOfficeCheckboxes() {
                                            const userId = $("#off_uid").val();
                                            $.get("userrights/officeaction.jsp", {action: "listWithSelected", userid: userId}, function (data) {
                                                var html = "";
                                                console.log("--------------------", data);
                                                data.forEach(function (office) {

                                                    html += "<div class=\"col-md-4\">";
                                                    html += "  <div class=\"form-check\">";
                                                    html += "    <input class=\"form-check-input\" type=\"checkbox\" name=\"officeids\" value=\"" + office.officeid + "\" id=\"office" + office.officeid + "\" " + office.selected + "\>";
                                                    html += "    <label class=\"form-check-label\" for=\"office" + office.officeid + "\">" + office.officename + "</label>";
                                                    html += "  </div>";
                                                    html += "</div>";
                                                });
                                                console.log("--------------------", html);
                                                $("#officeCheckboxList").html(html);
                                            });
                                        }

                                        function saveUserOffices() {
                                            var userId = $("#userid").val();
                                            var selected = [];
                                            $("input[name='officeids']:checked").each(function () {
                                                selected.push($(this).val());
                                            });
                                            var officeIdsCsv = selected.join(",");
                                            console.log("---------------------", officeIdsCsv);
                                            $.post("userrights/userofficeaction.jsp", {
                                                action: "update",
                                                userid: userId,
                                                officeids: officeIdsCsv
                                            }, function (result) {
                                                alert("Update status: " + result);
                                            });
                                        }

                                        function saveprogauthor() {
                                            var userId = $("#off_uidprog").val();
                                            var regye = $("#regyear").val();
                                            var selected = [];
                                            $("input[name='selectedCoursesprog']:checked").each(function () {
                                                selected.push($(this).val());
                                            });
                                            var officeIdsCsv = selected.join(",");
                                            console.log("---------------------", officeIdsCsv + "--" + regye);

                                            if (userId != "" && regye != "" && officeIdsCsv != "") {

                                                $.post("userrights/progauthaction.jsp", {
                                                    action: "update",
                                                    userid: userId,
                                                    regy: regye,
                                                    officeids: officeIdsCsv
                                                }, function (result) {
                                                    alert("Update status: " + result);
                                                });

                                            } else {
                                                alert("Select User and Regulation");
                                            }

                                        }


                                        function loadProgAuth() {
                                            var userId = $("#off_uidprog").val();
                                            var regye = $("#regyear").val();

                                            if (userId !== "" && regye !== "") {
                                                //alert("----------------------------");

                                                $.get("userrights/progauthview.jsp", {userid: userId, regy: regye}, function (data) {
                                                    console.log("Fetched Data:-------------------------------------", data);

                                                    var $tbody = $("#tblProgAuth tbody");
                                                    $tbody.empty();

                                                    if (data && data.length > 0) {
                                                        data.forEach(function (row) {
                                                            var tr = "<tr>" +
                                                                    "<td>" + row.regulationdesc + "</td>" +
                                                                    "<td>" + row.coursedesc + "-" + row.section + "-" + row.officename + "</td>" +
                                                                    "<td>" +
                                                                    "<button class='btn btn-sm btn-danger' " +
                                                                    "onclick=\"deleteProgAuth('" + userId + "','" + regye + "','" + row.courseid + "','" + row.section + "','" + row.officeids + "')\">" +
                                                                    "Delete" +
                                                                    "</button>" +
                                                                    "</td>" +
                                                                    "</tr>";

                                                            $tbody.append(tr);
                                                        });
                                                    } else {
                                                        $tbody.append("<tr><td colspan='4'>No Records Found</td></tr>");
                                                    }

                                                }, "json");
                                            } else {
                                                //alert("Select User and Regulation first");
                                            }
                                        }

                                        function deleteProgAuth(userid, regy, courseid, section, officeids) {
                                            if (confirm("Are you sure you want to delete this record?")) {
                                                $.post("userrights/progauthdelete.jsp", {
                                                    userid: userid,
                                                    regy: regy,
                                                    courseid: courseid,
                                                    section: section,
                                                    officeid: officeids
                                                }, function (response) {
                                                    alert(response.message);
                                                    loadProgAuth(); // reload table
                                                }, "json");
                                            }
                                        }



                                    </script>




                                    <jsp:include page="../../lccerpfooter.jsp"/>
                                    <% } else {
                                        // out.println(uid);
                                        out.println("session Time out");
                                    %>
                                    <meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" /> 
                                    <%
                                        }
                                    %>


