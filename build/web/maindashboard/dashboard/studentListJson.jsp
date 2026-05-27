<%-- 
    Document   : studentListJson
    Created on : Sep 3, 2025, 3:40:35 PM
    Author     : rm
--%>

<%@ page import="erp.dashboard.StudentCountDAO, org.json.simple.JSONArray, org.json.simple.JSONObject" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String login = (String) session.getAttribute("login");

    if (login != null) {
        //out.println(uid);
%>
<jsp:include page="../../lccerpheader.jsp"/>



<script>
    $(document).ready(function () {
        $('.exportTable').DataTable({
            dom: 'Bfrtip',
            buttons: [
                {extend: 'copy', text: 'Copy'},
                {extend: 'csv', text: 'CSV'},
                {extend: 'excel', text: 'Excel'},
                {extend: 'pdf', text: 'PDF'},
                {extend: 'print', text: 'Print'}
            ],
            paging: true,
            searching: true
        });
    });
</script>

<div class="pcoded-content">
    <div class="pcoded-inner-content">
        <!-- Main-body start -->
        <div class="main-body">
            <div class="page-wrapper">
                <!-- Page-body start -->
                <div class="page-body">
                    <div class="row">
                        <div class="col-xl-12 col-md-6">
                            <div class="card">

                                <%
                                    String course = request.getParameter("course") != null ? request.getParameter("course") : "";
                                    String community = request.getParameter("community") != null ? request.getParameter("community") : "";
                                    String gender = request.getParameter("gender") != null ? request.getParameter("gender") : "";
                                    String section = request.getParameter("section") != null ? request.getParameter("section") : "";
                                    String office = (String) session.getAttribute("currentOfficeUid");

//                                    out.println("Course: " + course + "<br>");
//                                    out.println("Community: " + community + "<br>");
//                                    out.println("Gender: " + gender + "<br>");
//                                    out.println("Section: " + section + "<br>");
                                    JSONArray studentsJson = StudentCountDAO.getStudentListJson(course, community, gender, section,office);
                                %>

                                <h3>Student List - <%= course%> | <%= community%> | <%= gender%> | <%= section%></h3>

                                <table class="table table-bordered table-striped exportTable" style="width:100%">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Register No</th>
                                            <th>Student Name</th>
                                            <th>Gender</th>
                                            <th>Community</th>
                                            <th>Course</th>
                                            <th>Section</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            int y = 1;
                                            if (studentsJson != null && !studentsJson.isEmpty()) {
                                                for (Object obj : studentsJson) {
                                                    JSONObject stu = (JSONObject) obj;
                                        %>
                                        <tr>
                                            <td><%= y++%></td>
                                            <td><%= stu.get("registerNo") != null ? stu.get("registerNo") : ""%></td>
                                            <td><%= stu.get("studentName") != null ? stu.get("studentName") : ""%></td>
                                            <td><%= stu.get("gender") != null ? stu.get("gender") : ""%></td>
                                            <td><%= stu.get("community") != null ? stu.get("community") : ""%></td>
                                            <td><%= stu.get("courseName") != null ? stu.get("courseName") : ""%></td>
                                            <td><%= stu.get("section") != null ? stu.get("section") : ""%></td>
                                        </tr>
                                        <%
                                            }
                                        } else {
                                        %>
                                        <tr>
                                            <td colspan="7" class="text-center">No students found for the selected filters.</td>
                                        </tr>
                                        <%
                                            }
                                        %>
                                    </tbody>
                                </table>

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



