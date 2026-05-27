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
                        <div class="col-md-12">
                            <div class="card">
                                <div class="card-header">
                                    <h5>Module Permission</h5>
                                    <!--<span>Add class of <code>.form-control</code> with <code>&lt;input&gt;</code> tag</span>-->
                                </div>
                                <div class="card-block">

                                    <form class="form-material" name="filePermissionForm" id="filePermissionForm" method="post" autocomplete="off">


                                        <div class="form-group form-default">
                                            <label for="empname">User / Employee Name</label>
                                            <div class="col-sm-10">
                                                <input type="text" name="empname" id="empname" class="form-control" autocomplete="off" onkeyup="showSuggestions(this.value)">
                                                <input type="hidden" name="empnameid" id="empnameid" >
                                                <div id="suggestions" style="display:none; position:absolute; top:100%; left:0; width:100%; background:white; border:1px solid #ccc; z-index:1000;"></div>
                                            </div>
                                        </div>

                                        <div class="form-group form-default">
                                            <label class="col-sm-2 col-form-label">Module</label>
                                            <div class="col-sm-10">
                                                <select name="modulelist" id="modulelist" class="form-control" onchange="call_filelink()" required>
                                                    <option value="">---Select Module---</option>
                                                    <%@ include file="load_module_options.jsp" %>
                                                </select>



                                            </div>
                                        </div>
                                        <div id="filelist" class="mt-3"></div>

                                    </form>






                                </div>



                                <div id="permissionList" class="mt-3"></div>




                            </div>

                        </div>
                    </div>

                    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                    <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js"></script>
                    <link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
                    <script>
                                                    function addPermission() {
                                                        let empid = $("#empname").val();
                                                        let modulecode = $("#modulelist").val();
                                                        let permission = $("#permtype").val();

                                                        if (!empid || !modulecode || !permission) {
                                                            alert("All fields are required.");
                                                            return;
                                                        }

                                                        $.post("userrights/permissionaction.jsp", {
                                                            empid: empid,
                                                            modulecode: modulecode,
                                                            permission: permission
                                                        }, function (res) {
                                                            alert(res.trim());
                                                            loadPermissions();
                                                        });
                                                    }

                                                    function call_filelink() {
                                                        let moduleId = $("#modulelist").val();
                                                        let empid = $("#empnameid").val();
                                                        if (!moduleId || !empid)
                                                            return;
                                                        console.log(moduleId);

                                                        $.get("userrights/modulefilelist.jsp", {modulecode: moduleId, empid: empid}, function (data) {
                                                            let list = JSON.parse(data);
                                                            let html = "";
                                                            html += "<table class=\"table table-xs\">";
                                                            html += "<thead><tr bgcolor='#fbeca3'><th>Description</th><th>Permission</th><th>Select</th></tr></thead><tbody>";

                                                            list.forEach((item, i) => {
                                                                html += "<tr>";
                                                                html += "<td><input type=\"hidden\" name=\"filecode\" value=\"" + item.code + "\">" + item.desc + "</td>";
                                                                //html += "<td>" + item.source + "</td>";
                                                                //html += "<td>" + item.desc + "</td>";

                                                                // Permission input (RW default)
                                                                html += "<td><input type=\"text\" name=\"perm_" + i + "\" class=\"form-control\" value=\"1\" placeholder=\"e.g. R, W, RW\" readonly></td>";
                                                               // html += "<td><input type=\"text\" name=\"userorder_" + i + "\" class=\"form-control\" value=\"" + i + "\" placeholder=\"e.g. R, W, RW\"></td>";

                                                                // Checkbox to select this permission
                                                                html += "<td><input type=\"checkbox\" class=\"file-checkbox\" value=\"" + item.code + "\"></td>";
                                                                html += "</tr>";
                                                            });

                                                            html += "</tbody></table>";
                                                            html += "<button type=\"button\" class=\"btn btn-success\" onclick=\"submitPermissions()\">Save Permissions</button>";
                                                            html += "";

                                                            $("#filelist").html(html);
                                                        });
                                                        call_modulepermissionlist();
                                                    }

                                                    function submitPermissions() {
                                                        const empid = $("#empnameid").val();
                                                        const moduleId = $("#modulelist").val();
                                                        //alert(empid);

                                                        if (!empid || !moduleId) {
                                                            alert("Please select employee and module.");
                                                            return;
                                                        }

                                                        console.log("-------------------------", $("#filePermissionForm input[type='checkbox']").length);

                                                        console.log("Checked:", $("#filePermissionForm input[type='checkbox']:checked").length);


                                                        const data = [];
                                                        let anyChecked = false;

                                                        // Loop through all checked checkboxes
                                                        $("#filelist input[type='checkbox']:checked").each(function () {
                                                            anyChecked = true;
                                                            const row = $(this).closest("tr");

                                                            const filecode = $(this).val(); // checkbox value is filecode
                                                            const permInput = row.find("input[name^='perm_']"); // find permission input in same row
                                                            const userOrder = row.find("input[name^='userorder_']"); // find permission input in same row
                                                            let perm = permInput.val().trim();
                                                            //let uorder = userOrder.val().trim();

                                                            if (perm === "") {
                                                                perm = "R"; // Assign default permission
                                                                permInput.val("R"); // Also reflect in input field
                                                            }

                                                            data.push({
                                                                empid: empid,
                                                                moduleid: moduleId,
                                                                filecode: filecode,
                                                                perm: perm
                                                            });
                                                            console.log("--------------------" + data.toString());
                                                        });

                                                        if (!anyChecked) {
                                                            alert("Please select at least one file.");
                                                            return;
                                                        }

                                                        $.ajax({
                                                            url: "userrights/insert_permission.jsp",
                                                            method: "POST",
                                                            data: {permissionData: JSON.stringify(data)},
                                                            success: function (response) {
                                                                alert("Permissions saved successfully.");
                                                                call_modulepermissionlist();
                                                            },
                                                            error: function () {
                                                                alert("Error saving permissions.");
                                                            }
                                                        });
                                                    }


                                                    function call_modulepermissionlist() {
                                                        var empid = $("#empnameid").val();
                                                        var moduleId = $("#modulelist").val();

                                                        if (!empid || !moduleId)
                                                            return;

                                                        $.get("userrights/permissionlist.jsp",
                                                                {empid: empid, mid: moduleId},
                                                                function (data) {

                                                                    var list = JSON.parse(data);

                                                                    var html = "";
                                                                    html += "<h4>Existing Permissions (Drag to Reorder)</h4>";
                                                                    html += "<table class=\"table table-bordered table-hover\">";
                                                                    html += "<thead class=\"bg-info text-white\">";
                                                                    html += "<tr>";
                                                                    html += "<th width=\"40\">&#8645;</th>";
                                                                    html += "<th>Module Name</th>";
                                                                    html += "<th>Permission</th>";
                                                                    html += "<th>Action</th>";
                                                                    html += "</tr>";
                                                                    html += "</thead>";
                                                                    html += "<tbody id=\"sortableMenu\">";

                                                                    for (var i = 0; i < list.length; i++) {
                                                                        var p = list[i];

                                                                        html += "<tr data-mcode=\"" + p.code + "\">";
                                                                        html += "<td class=\"text-center\"><i class=\"bi bi-list\"></i></td>";
                                                                        html += "<td>" + p.name + "</td>";
                                                                        html += "<td>" + p.perm + "</td>";
                                                                        html += "<td>";
                                                                        html += "<button class=\"btn btn-danger btn-sm\" ";
                                                                        html += "onclick=\"deletePermission('" + empid + "','" + p.code + "')\">";
                                                                        html += "Delete</button>";
                                                                        html += "</td>";
                                                                        html += "</tr>";
                                                                    }

                                                                    html += "</tbody></table>";

                                                                    $("#permissionList").html(html);

                                                                    enableSortable(); // attach drag AFTER DOM is ready
                                                                }
                                                        );
                                                    }
                                                    function enableSortable() {
                                                        $("#sortableMenu").sortable({
                                                            cursor: "move",
                                                            opacity: 0.8,
                                                            update: function () {
                                                                updateMenuOrder();
                                                            }
                                                        });
                                                    }






                                                    function deletePermission(empid, modulecode) {
                                                        if (!confirm("Are you sure?"))
                                                            return;

                                                        $.post("userrights/permissiondelete.jsp", {empid: empid, modulecode: modulecode}, function (res) {
                                                            alert(res.trim());
                                                            loadPermissions();
                                                        });
                                                    }




                                                    function showSuggestions(value) {
                                                        console.log("Typing: ", value);

                                                        if (value.trim().length < 1) {
                                                            $("#suggestions").hide();
                                                            return;
                                                        }

                                                        $.get("userrights/user_autosuggest.jsp", {query: value}, function (data) {
                                                            console.log("Response data: ", data);

                                                            let list;
                                                            try {
                                                                list = JSON.parse(data);
                                                            } catch (e) {
                                                                console.error("Invalid JSON from JSP:", data);
                                                                $("#suggestions").hide();
                                                                return;
                                                            }

                                                            if (!list || list.length === 0) {
                                                                $("#suggestions").hide();
                                                                return;
                                                            }

                                                            let html = "<table class='table table-sm table-hover mb-0'>";
                                                            html += "<thead><tr><th>User ID</th><th>User Name</th></tr></thead><tbody>";

                                                            list.forEach(function (item) {
                                                                html += "<tr style='cursor:pointer' onclick=\"selectUser('" + item.id + "', '" + item.name + "')\">";
                                                                html += "<td>" + item.id + "</td><td>" + item.name + "</td></tr>";
                                                            });

                                                            html += "</tbody></table>";

                                                            $("#suggestions").html(html).show();
                                                        }).fail(function (xhr, status, error) {
                                                            console.error("AJAX error:", error);
                                                            $("#suggestions").hide();
                                                        });
                                                    }


                                                    function selectUser(id, name) {
                                                        $("#empname").val(name);
                                                        $("#empnameid").val(id);
                                                        $("#suggestions").hide();
                                                        console.log("Selected:", id, name);
                                                    }



                                                    function updateMenuOrder() {
                                                        let orderData = [];

                                                        $("#sortableMenu tr").each(function (index) {
                                                            orderData.push({
                                                                empid : $("#empnameid").val(),
                                                                moduleId : $("#modulelist").val(),
                                                                mcode: $(this).data("mcode"),
                                                                order: index + 1
                                                            });

                                                        });

                                                        $.ajax({
                                                            url: "userrights/updateMenuOrder.jsp",
                                                            type: "POST",
                                                            contentType: "application/json",
                                                            data: JSON.stringify(orderData),
                                                            success: function () {
                                                                console.log("Menu order updated");
                                                            },
                                                            error: function () {
                                                                alert("Failed to update menu order");
                                                            }
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

