<%@page import="org.json.simple.JSONArray"%>
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
<jsp:useBean id="uservalidation" class="user.varification.uservalidation" scope="page"/>
<jsp:useBean id="officedao" class="erp.generalmaster.Office" scope="page"/>
<jsp:useBean id="currdo" class="erp.attendance.DatewiseDayOrder" scope="page"/>
<%
    try {
        String userId = "", userPwd = "";

        userId = request.getParameter("erpuserId");
        userPwd = request.getParameter("erpuserPwd");

        if (userId != null && userPwd != null) {
            String status = uservalidation.getuserstatus(userId, userPwd);
            out.println(status);
            if (status.equals("OK")) {

                String ipAddress = request.getRemoteAddr();

                // Update last login info
                user.varification.uservalidation dao = new user.varification.uservalidation();
                dao.updateLoginDetails(userId, ipAddress);

                String para = "";
                String uname = "";
                String sname = "";
                String[] userdetails = uservalidation.getuserdetails(userId);
                
                JSONArray ary = uservalidation.getmenulist(userId);
                session.setAttribute("menuAry", ary);
                System.out.println("? Menu cached in session for user: " + userId);

                session.setAttribute("username", userId);
                session.setAttribute("uname", userdetails[1]);
                session.setAttribute("para", userdetails[2]);
                session.setAttribute("modu", userdetails[3]);
                session.setAttribute("lastlogin", userdetails[4]);
                session.setAttribute("officeuid", userdetails[5]);
                session.setAttribute("loginipaddress", userdetails[7]);
                session.setAttribute("logintime", userdetails[6]);
                session.setAttribute("userrole", userdetails[8]);
                
                session.setAttribute("userdivision", userdetails[9]);
                
                session.setAttribute("userdesig", userdetails[10]);
                
                session.setAttribute("activeMenu", "mq");
                session.setAttribute("activeMenuname", "Dashboard");
                
                session.setAttribute("login", "true");
                String[] officeuid = userdetails[5].split("\\,");
                session.setAttribute("currentOfficeUid", officeuid[0]);
                String offid = officeuid[0];
                
                int currdayorder[] = currdo.getTodayDayOrderId(Integer.parseInt(officeuid[0]));
                String[] currdate = currdo.getCurrentDate();
                
                session.setAttribute("currentdayorder", currdayorder[0]);
                session.setAttribute("currentdayorderweak", currdayorder[1]);
                
                session.setAttribute("currentdate1", currdate[0]);
                session.setAttribute("currentdate2", currdate[1]);
                
                session.setAttribute("currentOfficeUidname", officedao.getOfficeNamesById(offid));

                erp.auth.SessionTracker.addUser(userdetails[1]);

                response.sendRedirect(""+request.getContextPath()+"/maindashboard/");

            } else {
                out.println("Invalid Userid and Password");
%>
<meta http-equiv="refresh" content="3;url=<%=request.getContextPath()%>" />
<%
    }
} else {
    out.println("Invalid Userid and Password");
%>
<meta http-equiv="refresh" content="3;url=<%=request.getContextPath()%>" />
<%
        }

    } catch (Exception e) {
        out.println(e);
%>
<meta http-equiv="refresh" content="3;url=<%=request.getContextPath()%>" />
<%
    }
%>
