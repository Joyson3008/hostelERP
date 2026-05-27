<%-- 
    Document   : officeMaster
    Created on : Jul 4, 2025, 11:29:08 AM
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
    String mName = "ERP_OFFICE_MAST";
%>
<%@ include file="/usermanager/permission.jsp" %>

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
                                                        <h5>Office Master </h5>
                                                        <!--<span>Add class of <code>.form-control</code> with <code>&lt;input&gt;</code> tag</span>-->
                                                    </div>
                                                    <div class="card-block">
                        <div class="col-sm-12">
                            <form id="officeForm" class="form-material">
                                <input type="hidden" id="officeid">
                                <div class="form-group form-default">
                                    <input type="text" name="officename" id="officename" class="form-control" required>
                                    <span class="form-bar"></span>
                                    <label class="float-label">Office Name</label>
                                </div>
                                <div class="form-group">
                                    <button type="button" class="btn btn-primary" onclick="saveOffice()">Save</button>
                                </div>
                            </form>

                            <table class="table table-xs">
                                <thead><tr><th>Office</th><th>Action</th></tr></thead>
                                <tbody id="officeBody"></tbody>
                            </table>


                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function loadOffices() {
  $.get("userrights/officeaction.jsp", { action: "list" }, function (data) {
      console.log(data);
    var html = "";
    data.forEach(function(o) {
      html += "<tr>";
      html += "<td>" + o.officename + "</td>";
      html += "<td>";
      html += "<button class=\"btn btn-warning btn-sm\" onclick=\"editOffice('" + o.officeid + "', '" + o.officename + "')\">Edit</button> ";
      //html += "<button class=\"btn btn-danger btn-sm\" onclick=\"deleteOffice(" + o.officeid + ")\">Delete</button>";
      html += "</td>";
      html += "</tr>";
    });
    $("#officeBody").html(html);
  });
}


function saveOffice() {
  let name = $("#officename").val();
  let id = $("#officeid").val();
  let action = id ? "update" : "insert";

  $.post("officeaction.jsp", {
    action: action,
    officeid: id,
    officename: name
  }, function (res) {
    alert(res);
    $("#officeForm")[0].reset();
    $("#officeid").val("");
    loadOffices();
  });
}

function editOffice(id, name) {
  $("#officeid").val(id);
  $("#officename").val(name);
}

function deleteOffice(id) {
  if (!confirm("Delete this office?")) return;
  $.post("officeaction.jsp", {
    action: "delete",
    officeid: id
  }, function (res) {
    alert(res);
    loadOffices();
  });
}

$(document).ready(loadOffices);

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
