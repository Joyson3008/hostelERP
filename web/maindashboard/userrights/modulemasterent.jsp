<%
response.setDateHeader("Expires",0);
response.addHeader("Cache-Control","no-cache, no-store, must-revlidate");
response.addHeader("Cache-Control","post-check=0, pre-check=0");
response.setHeader("Pragma","no-cache");
%>
<%
   // *************** Authentication Block ***************
String per = "A";
String mName = "ERP_MODU_ADD";
%>
<%@ include file="/usermanager/permission.jsp" %>
<jsp:useBean id="modu" class="erp.module.ModuleMaster" scope="request"/>

 <%@ page import="org.json.simple.*" %>
 <%
 	String login = (String)session.getAttribute("login");

 if(login!=null){
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
                                                        <div class="card-header bg-primary text-white">Module Entry</div>
                                                        <!--<span>Add class of <code>.form-control</code> with <code>&lt;input&gt;</code> tag</span>-->
                                                    </div>
                                                    <div class="card-block">
                                                       <!-- moduleform.jsp -->
<form id="moduleForm" method="post" autocomplete="off">
  <div class="form-group">
    <label>Module Name</label>
    <input type="text" class="form-control" name="modulename" id="modulename" required>
  </div>
  <div class="form-group">
    <label>Module Code</label>
    <input type="text" class="form-control" name="modulecode" id="modulecode" required>
  </div>
  <div class="form-group">
    <label>Module Folder</label>
    <input type="text" class="form-control" name="modulefolder" id="modulefolder" required>
  </div>

  <input type="hidden" name="id" id="moduleid">

  <button type="button" class="btn btn-primary" onclick="saveModule()" id="btnSave">Add</button>
</form>

                                                    </div></div>
                                            </div>
                                                
 <div class="col-md-6">
                                                <div class="card">
                                                    <div class="card-header">
<table class="table table-xs">
  <thead>
    <tr>
      <th>Module Name</th>
      <th>Module Code</th>
      <th>Module Folder</th>
      <th>Action</th>
    </tr>
  </thead>
  <tbody id="moduleBody"></tbody>
</table>


                                                    
                                                         </div>
                                                </div>
                                            </div>
                                                    
                                                    
                                                    
                                                    
                                                    
    
    </div>


<script>
    function saveModule() {
  var id = $("#moduleid").val();
  var modulename = $("#modulename").val();
  var modulecode = $("#modulecode").val();
  var modulefolder = $("#modulefolder").val();

  if (modulename === "" || modulecode === "" || modulefolder === "") {
    alert("All fields are required.");
    return;
  }

  $.post("userrights/moduleaction.jsp", {
    id: id,
    modulename: modulename,
    modulecode: modulecode,
    modulefolder: modulefolder
  }, function (res) {
    alert(res.trim());
    $("#moduleForm")[0].reset();
    $("#moduleid").val("");
    $("#modulecode").prop("readonly", false); // make editable after save
    $("#btnSave").text("Add");
    loadModules();
  });
}


function editModule(id, name, code, folder) {
  $("#moduleid").val(id);
  $("#modulename").val(name);
  $("#modulecode").val(code).prop("readonly", true); // make readonly during edit
  $("#modulefolder").val(folder);
  $("#btnSave").text("Update");
}


function loadModules() {
  $.get("userrights/modulelist.jsp", function (data) {
    var list = JSON.parse(data);
    var html = "";
    list.forEach(function (mod) {
      html += "<tr>";
      html += "<td>" + mod.modulename + "</td>";
      html += "<td>" + mod.modulecode + "</td>";
      html += "<td>" + mod.modulefolder + "</td>";
      html += "<td><button class='btn btn-sm btn-warning' onclick=\"editModule('" + mod.id + "', '" + mod.modulename + "', '" + mod.modulecode + "', '" + mod.modulefolder + "')\">Edit</button></td>";
      html += "</tr>";
    });
    $("#moduleBody").html(html);
  });
}

$(document).ready(function () {
  loadModules();
});
</script>






        <jsp:include page="../../lccerpfooter.jsp"/>
    <% }
    else{
    // out.println(uid);
    out.println("session Time out");
    %>
    	<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" /> 
    <%
    }
    %>
		
