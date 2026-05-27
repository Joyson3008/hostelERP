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
    HttpSession sess = request.getSession(false);
    if (sess != null) {
        String username = (String) sess.getAttribute("uname");
        System.out.println("? Logout requested for: " + username);

        if (username != null) {
            erp.auth.SessionTracker.removeUser(username);
        }

        sess.invalidate();
        System.out.println("? Session invalidated successfully for: " + username);
    }

    response.sendRedirect(request.getContextPath() + "/");
%>
Logout Successfully...<bR>
<a href="<%=request.getContextPath()%>/index.jsp">Login</a>
