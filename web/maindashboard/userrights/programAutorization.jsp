<%-- 
    Document   : programAutorization
    Created on : Sep 20, 2025, 1:18:04 PM
    Author     : JRMartin <JRMartin at your.org>
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<head>

    <META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">
    <META HTTP-EQUIV="PRAGMA" CONTENT="NO-CACHE">
    <META HTTP-EQUIV="EXPIRES" CONTENT="0">
</head>
<%
    response.setDateHeader("Expires", 0);
    response.addHeader("Cache-Control", "no-cache, no-store, must-revlidate");
    response.addHeader("Cache-Control", "post-check=0, pre-check=0");
    response.setHeader("Pragma", "no-cache");
%>
<%
    // *************** Authentication Block ***************
    String per = "A";
    String mName = "ERP_AUTH_PROGAUTH";
%>


<%
       String login = (String)session.getAttribute("login");

if(login!=null){
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
                                    <div class="card-header">
                                                        <h4>Program and Section Authorization </h4>
                                                        <!--<span>Add class of <code>.form-control</code> with <code>&lt;input&gt;</code> tag</span>-->
                                                    </div>
                                    <!-- Row start -->
                                    <div class="row">
                                        <div class="col-lg-12 col-xl-12">
                                            
                                                
 <div class="form-group form-default">
                                                    <label for="empname">User / Employee Name</label>
                                                    <div class="col-sm-10">
                                                        <input type="text" id="offnameprog" name="offnameprog"  onkeyup="showSuggestions(this.value)" class="form-control" >
                                                        <input type="hidden" id="off_uidprog" name="off_uidprog" readonly=""class="form-control" ></label>
                                                        <div id="suggestions" class="bg-white border" style="display:none; max-height:250px; overflow-y:auto;"></div>
                                                    </div>
 </div>
                                                    <div class="row">
                                                        <div class="col-lg-4">
                                                    <label for="empname">Regulation Year</label>
                                                   
                                                
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
                                                   
                                                    <div class="col-xl-8">
                                                
                                                <table id="tblProgAuth" class="table table-xs">

  <tbody></tbody>
</table>

                                                    </div>
                                                    </div></div></div></div></div>
                      
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


                        function selectUser(userId, userName) {                            
                            $("#offnameprog").val(userName);
                            $("#off_uidprog").val(userId);
                            
                            $("#suggestions").hide();
                            console.log("-----",userId+"----"+userName);

                           
                            }
                            
                            

function loadProgAuth() {
  var userId = $("#off_uidprog").val();
  var regye  = $("#regyear").val();

  if (userId !== "" && regye !== "") {
      //alert("----------------------------");
      
    $.get("userrights/progauthview.jsp", { userid: userId, regy: regye }, function (data) {
      console.log("Fetched Data:-------------------------------------", data);

      var $tbody = $("#tblProgAuth tbody");
      $tbody.empty();

      if (data && data.length > 0) {
        data.forEach(function (row) {
          var tr = "<tr>" +
           "<td>" + row.regulationdesc + "</td>" +
           "<td>" + row.coursedesc +"-"+row.section+"-"+row.officename + "</td>" +
           "<td>" +
             "<button class='btn btn-sm btn-danger' " +
                     "onclick=\"deleteProgAuth('" + userId + "','" + regye + "','" + row.courseid + "','" + row.section + "','" + row.officeids +"')\">" +
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
                            
$(document).ready(function() {
    $.ajax({
        url: 'academic/regulationlist.jsp',
        type: 'GET',
        dataType: 'json',
        success: function(data) {
            var $select = $('#regyear');
            data.forEach(function(option) {
                $select.append('<option value="' + option.regulationid + '">' + option.regulationdesc + '</option>');
            });
        },
        error: function(err) {
            console.error('Error loading regulations:', err);
        }
    });
    
    $('#regyear').change(function() {
        var regulationId = $(this).val();
        if (regulationId) {
            $.ajax({
                url: 'academic/getCourses.jsp',
                type: 'GET',
                data: { regulationid: regulationId },
                dataType: 'json',
                success: function(data) {
                    var $tbody = $('#coursesTable tbody');
                    $tbody.empty();
                    data.forEach(function(course) {
                        var row = '<tr>' +
                            '<td><input type="checkbox" name="selectedCoursesprog" id="selectedCoursesprog" value="' + course.coursecode + '-'+course.section+'">' +
                            '-' + course.description+'-'+course.section+'</td>' +
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

function saveprogauthor(){
  var userId = $("#off_uidprog").val();
  var regye = $("#regyear").val();
  var selected = [];
  $("input[name='selectedCoursesprog']:checked").each(function () {
    selected.push($(this).val());
  });
  var officeIdsCsv = selected.join(",");
console.log("---------------------",officeIdsCsv+"--"+regye);

if(userId !="" && regye !="" && officeIdsCsv!=""){
    
    $.post("userrights/progauthaction.jsp", {
      action: "update",
      userid: userId,
      regy:regye,
      officeids: officeIdsCsv
    }, function (result) {
      alert("Update status: " + result);
    });
  
  }else{
      alert("Select User and Regulation");
  }
  
}

function deleteProgAuth(userid, regy, courseid, section,officeids) {
  if(confirm("Are you sure you want to delete this record?")) {
    $.post("userrights/progauthdelete.jsp", {
      userid: userid,
      regy: regy,
      courseid: courseid,
      section: section,
      officeid: officeids
    }, function(response) {
      alert(response.message);
      loadProgAuth(); // reload table
    }, "json");
  }
}
                            
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
