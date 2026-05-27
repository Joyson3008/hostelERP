<%--
    File       : ajax/changeRoom.jsp
    Description: Executes room transfer for an allocated student.
                 Decrements old room occupancy, increments new room occupancy,
                 and updates hostelpersonaldetails with the new roomid.
--%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="Dao.ERPHostel.ERPHostelDAO"%>
<%
    response.setHeader("Cache-Control", "no-cache");

    String registerno = request.getParameter("registerno");
    String oldRoomStr = request.getParameter("oldRoomId");
    String newRoomStr = request.getParameter("newRoomId");

    // ---- Basic validation ----
    if (registerno == null || registerno.trim().isEmpty()
            || oldRoomStr == null || oldRoomStr.trim().isEmpty()
            || newRoomStr == null || newRoomStr.trim().isEmpty()) {

        out.print("{\"success\":false,\"error\":\"Missing required parameters\"}");
        return;
    }

    int oldRoomId;
    int newRoomId;

    try {
        oldRoomId = Integer.parseInt(oldRoomStr.trim());
        newRoomId = Integer.parseInt(newRoomStr.trim());
    } catch (NumberFormatException ex) {
        out.print("{\"success\":false,\"error\":\"Invalid room ID format\"}");
        return;
    }

    if (oldRoomId == newRoomId) {
        out.print("{\"success\":false,\"error\":\"New room is the same as current room\"}");
        return;
    }

    // Capture session / IP for audit
    String updatedBy = (String) session.getAttribute("username");
    String updatedIp = request.getRemoteAddr();

    if (updatedBy == null) { updatedBy = "system"; }

    String result = ERPHostelDAO.changeRoom(
            registerno.trim(), oldRoomId, newRoomId, updatedBy, updatedIp);

    out.print(result);
%>
