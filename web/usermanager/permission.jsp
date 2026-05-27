<jsp:useBean id="userpermission" class="user.varification.userpermission" scope="page"/>
<%
try
{

mName = mName.trim();



String usr=(String) session.getAttribute("username");

if (usr!=null) 
{
	String log=(String) session.getAttribute("login");
	if (log.equals("true")) 
	{
		String status = userpermission.getuserpermission(usr, mName);
		if(status.equals("OK")){
			
		}else{
			response.sendRedirect(""+request.getContextPath()+"/usermanager/noview.jsp");
		}
  	}
}
else
{
	response.sendRedirect(""+request.getContextPath()+"/usermanager/loginpage.jsp");	
}
}
catch (Exception e)
{
	out.println("Error: --" + e);
}
%>

