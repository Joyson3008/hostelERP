<%
    response.setDateHeader("Expires", 0);
    response.addHeader("Cache-Control", "no-cache, no-store, must-revlidate");
    response.addHeader("Cache-Control", "post-check=0, pre-check=0");
    response.setHeader("Pragma", "no-cache");
%>
<%
    // *************** Authentication Block ***************
    String per = "A";
    String mName = "ERP_MODU_FILE";
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
        <!-- Main-body start -->
        <div class="main-body">
            <div class="page-wrapper">

                <div class="page-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">
                                    <h5>Module File Entry</h5>
                                    <!--<span>Add class of <code>.form-control</code> with <code>&lt;input&gt;</code> tag</span>-->
                                </div>
                                <div class="card-block">
                                    <form class="form-material" method="post" autocomplete="off">
                                        <input type="hidden" id="formMode" name="formMode" value="add">
                                        <div class="form-group form-default">
                                            <label>Select Module</label>
                                            <select name="modulelist" id="modulelist" class="form-control" onchange="call_filelink()" required>
                                                <option value="">---Select Module Name---</option>
                                                <!-- Options from DB -->
                                            </select>
                                        </div>

                                        <div class="form-group form-default">
                                            <input type="text" name="filelink" id="filelink" class="form-control" required>
                                            <span class="form-bar"></span>
                                            <label class="float-label">Module File Link</label>
                                        </div>

                                        <div class="form-group form-default">
                                            <input type="text" name="filenamelink" id="filenamelink" class="form-control" required>
                                            <span class="form-bar"></span>
                                            <label class="float-label">Module File Name</label>
                                        </div>

                                        <div class="form-group form-default">
                                            <label>Select Module</label>
                                            <select name="moduletype" id="moduletype" class="form-control"  required>
                                                <option value="">---Select Module Type---</option>
                                                <option value="Master">Master</option>
                                                <option value="Transaction">Transaction</option>
                                                <option value="Report">Report</option>
                                            </select>
                                        </div>

                                        <div class="form-group form-default">
                                            <input type="text" name="filenamelinkdesc" id="filenamelinkdesc" class="form-control" required>
                                            <span class="form-bar"></span>
                                            <label class="float-label">File Link Description</label>
                                        </div>

                                        <div class="form-group form-default">
                                            <input type="button" name="submit" id="submitBtn" value="Add" onclick="call_addmodulefilelink()" class="btn btn-primary">
                                        </div>
                                    </form>

                                    <!-- Display file links -->


                                </div>



                            </div>
                        </div>
                    </div>
                    <div class="col-md-12">
                        <div class="card">
                            <div id="fileList" class="mt-3"></div>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                $(document).ready(function () {
                    // Load module dropdown
                    $.get("userrights/load_module_options.jsp", function (data) {
                        console.log("--------------------------------", data);
                        $("#modulelist").append(data);
                    });
                });

                function call_addmodulefilelink() {
                    let code = $("#modulelist").val();
                    let filelink = $("#filelink").val();
                    let filename = $("#filenamelink").val();
                    let desc = $("#filenamelinkdesc").val();
                    let moduletype = $("#moduletype").val();
                    let mode = $("#formMode").val(); // add or modify

                    if (!code || !filelink || !filename || !desc || !moduletype) {
                        alert("All fields are required.");
                        return;
                    }

                    $.post("userrights/modulefileaction.jsp", {
                        modulelist: code,
                        filelink: filelink,
                        filenamelink: filename,
                        filenamelinkdesc: desc,
                        filetype: moduletype,
                        mode: mode
                    }, function (res) {
                        alert(res.trim());
                        call_filelink();

                        // Reset form after add/update
                        $("#modulelist").prop("disabled", false);
                        $("#filenamelink").prop("readonly", false);
                        $("#filelink, #filenamelink, #filenamelinkdesc").val("");
                        $("#moduletype").val("");
                        $("#submitBtn").val("Add");
                        $("#formMode").val("add");
                    });
                }


                function call_filelink() {
                    let code = $("#modulelist").val();
                    if (!code)
                        return;

                    $.get("userrights/modulefilelist.jsp", {modulecode: code}, function (data) {
                        let list = JSON.parse(data);

                        let html = "<table class=\"table table-xs\">";
                        html += "<thead><tr><th>File Link</th><th>Description</th><th>Action</th><th>File Type</th></tr></thead><tbody>";

                        list.forEach(function (item) {
                            html += "<tr>";

                            html += "<td>" + item.source + "</td>";
                            html += "<td>" + item.desc + "</td>";
                            html += "<td>" + item.filetype + "</td>";
                            html += "<td>";
                            html += "<button class=\"btn btn-warning btn-sm\" onclick=\"editModuleFile('" + item.code + "', '" + item.name + "', '" + item.source + "', '" + item.desc + "', '" + item.filetype + "')\">Edit</button> ";

                            html += "</td>";
                            html += "</tr>";
                        });

                        html += "</tbody></table>";
                        $("#fileList").html(html);
                    });
                }


                function editModuleFile(code, name, source, desc, filetype) {
                    let found = false;

                    $("#modulelist option").each(function () {
                        if ($(this).val().trim() === code.trim()) {
                            found = true;
                        }
                    });

                    if (!found) {
                        $("#modulelist").append("<option value=\"" + code + "\">" + code + "</option>");
                    }

                    $("#modulelist").val(code.trim()).prop("disabled", true);
                    $("#filenamelink").val(name).prop("readonly", true);
                    $("#filelink").val(source);
                    $("#filenamelinkdesc").val(desc);
                    $("#moduletype").val(filetype);

                    $("#formMode").val("modify");
                    $("#submitBtn").val("Update");
                }

                function deleteModuleFile(code, filename) {
                    if (!confirm("Are you sure you want to delete file: " + filename + "?"))
                        return;

                    $.post("modulefiledelete.jsp", {
                        modulelist: code,
                        filenamelink: filename
                    }, function (res) {
                        alert(res.trim());
                        call_filelink(); // refresh list
                    });
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
