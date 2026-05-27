<%--
    updateHostelStudent.jsp
    Receives POST from registeredHostelApplicants.jsp → #updateBtn click
    Calls ERPHostelDAO.updateHostelStudent(JSONObject o)

    Parameter names here MUST match the o.get("key") calls in the DAO
    exactly — any mismatch causes a null write to the database.
--%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="Dao.ERPHostel.ERPHostelDAO"%>
<%
    JSONObject json = new JSONObject();

    try {

        /* ── Safety: registerno is mandatory ── */
        String registerno = request.getParameter("registerno");
        if (registerno == null || registerno.trim().isEmpty()) {
            json.put("success", false);
            json.put("message", "Register number is required");
            out.print(json.toJSONString());
            return;
        }

        /* ══════════════════════════════════════════════════════
           Build JSONObject with EXACT keys the DAO uses in
           o.get("key") — do not rename these keys
        ══════════════════════════════════════════════════════ */
        JSONObject obj = new JSONObject();

        /* Primary key */
        obj.put("registerno",          registerno.trim());

        /* ── hostelpersonaldetails (sql1 in DAO, params 1-23 + WHERE 24) ── */
        obj.put("studentname",         request.getParameter("studentname"));
        obj.put("studentmobilenumber", request.getParameter("studentmobilenumber"));
        obj.put("studentemailid",      request.getParameter("studentemailid"));

        obj.put("fathername",          request.getParameter("fathername"));
        obj.put("mothername",          request.getParameter("mothername"));

        obj.put("fathereducation",     request.getParameter("fathereducation"));
        obj.put("mothereducation",     request.getParameter("mothereducation"));

        obj.put("fatheroccupation",    request.getParameter("fatheroccupation"));
        obj.put("motheroccupation",    request.getParameter("motheroccupation"));

        obj.put("fatherannualincome",  request.getParameter("fatherannualincome"));
        obj.put("motherannualincome",  request.getParameter("motherannualincome"));

        obj.put("premadd1",            request.getParameter("premadd1"));
        obj.put("premadd2",            request.getParameter("premadd2"));
        obj.put("premadd3",            request.getParameter("premadd3"));

        obj.put("pincode",             request.getParameter("pincode"));

        obj.put("parentmobile",        request.getParameter("parentmobile"));
        obj.put("parentemail",         request.getParameter("parentemail"));

        obj.put("village",             request.getParameter("village"));
        obj.put("town",                request.getParameter("town"));
        obj.put("state",               request.getParameter("state"));

        obj.put("religion",            request.getParameter("religion"));
        obj.put("category",            request.getParameter("category"));
        obj.put("bloodgroup",          request.getParameter("bloodgroup"));

        /* ── guardiandetails (sql2 in DAO, params 1-9 + WHERE 10) ── */
        obj.put("guardianrelation",    request.getParameter("guardianrelation"));
        obj.put("guardline1",          request.getParameter("guardline1"));
        obj.put("guardline2",          request.getParameter("guardline2"));
        obj.put("guardline3",          request.getParameter("guardline3"));
        obj.put("guardianmobile",      request.getParameter("guardianmobile"));
        obj.put("guardianemail",       request.getParameter("guardianemail"));
        obj.put("guardstate",          request.getParameter("guardstate"));
        obj.put("guarddist",           request.getParameter("guarddist"));
        obj.put("guard_pincode",       request.getParameter("guard_pincode"));

        /* ── Invoke DAO ── */
        ERPHostelDAO dao = new ERPHostelDAO();
        boolean status   = dao.updateHostelStudent(obj);

        if (status) {
            json.put("success", true);
            json.put("message", "Student Updated Successfully");
        } else {
            json.put("success", false);
            json.put("message", "Update Failed — no rows affected");
        }

    } catch (Exception e) {
        e.printStackTrace();
        json.put("success", false);
        json.put("message", e.getMessage());
    }

    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    out.print(json.toJSONString());
%>
