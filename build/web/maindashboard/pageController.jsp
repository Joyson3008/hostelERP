<%-- 
    Document   : pageComtroller
    Created on : Sep 15, 2025, 2:55:33 PM
    Author     : JRMartin <JRMartin at your.org>
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String login = (String) session.getAttribute("login");

    if (login != null) {
        
    
        String repage=request.getParameter("rePage");
         System.out.println("\n ----------- pagecontroller -----------------------\n"+repage);
        if(repage!=null){
           
            %>
            
            <jsp:forward page="<%=repage%>" />
            
            <%
        }else{
        response.sendRedirect(request.getContextPath()+"/maindashboard/");

}
        
%>
<% } else {
    // out.println(uid);
    out.println("session Time out");
%>
<meta http-equiv="refresh" content="3;URL='<%=request.getContextPath()%>/usermanager/logout.jsp'" /> 
<%
    }
%>
