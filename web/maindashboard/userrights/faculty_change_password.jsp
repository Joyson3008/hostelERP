<%-- 
    Document   : faculty_change_password
    Created on : Oct 14, 2025, 3:59:40?PM
    Author     : JR Martin
--%>

<%
    // *************** Authentication Block ***************
    String per = "A";
    String mName = "ERP_USER_PASSWD";
%>

<%
    String login = (String) session.getAttribute("login");
    String modu = (String) session.getAttribute("username");
    //out.println(modu);

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
                            <!-- Bootstrap tab card start -->
                            <div class="card">
                                <div class="card-block">
                                    <!-- Row start -->
                                    <div class="row">
                                        <div class="col-lg-12 col-xl-12">
                                            
            <h5 class="mb-0">Change Password</h5>
        </div>
        <div class="card-body">
            <form id="changePasswordForm">
                <div class="mb-3">
                    <label class="form-label">User ID : </label>
                    <%=modu%>
                </div>
                <div class="mb-3">
                    <label class="form-label">Old Password</label>
                    <input type="password" name="oldPassword" id="oldPassword" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">New Password</label>
                    <input type="password" name="newPassword" id="newPassword" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Confirm Password</label>
                    <input type="password" name="confirmPassword" id="confirmPassword" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-success w-100">Update Password</button>
            </form>

            <div id="messageBox" class="alert mt-3" style="display:none;"></div>
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
        </div>
    </div>
</div>

<script>
$(document).ready(function(){
    $("#changePasswordForm").on("submit", function(e){
        e.preventDefault();

        let oldPwd = $("#oldPassword").val().trim();
        let newPwd = $("#newPassword").val().trim();
        let confirmPwd = $("#confirmPassword").val().trim();

        if(newPwd !== confirmPwd){
            showMessage("New passwords do not match!", "danger");
            return;
        }

        $.ajax({
            url: "userrights/changePasswordAction.jsp",
            type: "POST",
            data: { oldPassword: oldPwd, newPassword: newPwd },
            success: function(response){
                let res = response.trim();
                if(res === "SUCCESS") showMessage("Password updated successfully!", "success");
                else if(res === "INCORRECT_OLD_PASSWORD") showMessage("Old password is incorrect!", "danger");
                else if(res === "USER_NOT_FOUND") showMessage("User not found!", "warning");
                else showMessage("Update failed: " + res, "danger");
            },
            error: function(){
                showMessage("Server error. Please try again later.", "danger");
            }
        });
    });

    function showMessage(msg, type){
        $("#messageBox").removeClass().addClass("alert alert-" + type).text(msg).show();
    }
});
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
