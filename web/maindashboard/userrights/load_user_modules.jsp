<%-- 
    Document   : load_module_options_1
    Created on : Jul 7, 2025, 12:26:13 PM
    Author     : rm
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="erp.auth.UserModule, erp.auth.ModuleListLoader, java.util.*" %>
<%
    String userId = request.getParameter("userid");
    String modu = UserModule.getUserModules(userId);

    Set<String> selectedModules = new HashSet<>();
    if (modu != null && !modu.isEmpty()) {
        selectedModules = new HashSet<>(Arrays.asList(modu.split(",")));
    }

    ModuleListLoader loader = new ModuleListLoader();
    List<ModuleListLoader.Module> moduleList = loader.getAllModules();
%>



<div class="module-checkbox-group">
<%
    for (ModuleListLoader.Module m : moduleList) {
        boolean checked = selectedModules.contains(m.key);
%>
    <div class="module-checkbox">
        <input type="checkbox" name="modname" value="<%= m.key %>" <%= checked ? "checked" : "" %>>
        <label><%= m.desc %></label>
    </div>
<%
    }
%>
</div>





