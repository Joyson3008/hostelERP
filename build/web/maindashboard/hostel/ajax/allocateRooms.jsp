<%-- 
    Document   : allocateRooms
    Created on : Apr 27, 2026, 4:53:25 PM
    Author     : lccerp26
--%>

<%@page contentType="application/json" pageEncoding="UTF-8"%>

<%@page import="Dao.ERPHostel.ERPHostelRoomDAO"%>
<%@page import="org.json.simple.JSONObject"%>

<%
    // =========================================
    // SESSION DETAILS
    // =========================================

    String login = (String) session.getAttribute("login");

    String userId =
            (String) session.getAttribute("username");

    // TEMPORARY FOR TESTING
    if (userId == null || userId.trim().equals("")) {

        userId = "admin";
    }

    // =========================================
    // CLIENT IP
    // =========================================

    String ip = request.getRemoteAddr();

    try {

        // =====================================
        // GET DATA FROM AJAX
        // =====================================

        String[] rooms =
                request.getParameterValues("roomIds[]");

        String[] students =
                request.getParameterValues("studentRegs[]");

        // =====================================
        // DEBUG LOGS
        // =====================================

        System.out.println("\n\n=================================");
        System.out.println("allocateRooms.jsp START");
        System.out.println("=================================");

        System.out.println("USER : " + userId);
        System.out.println("IP   : " + ip);

        // =====================================
        // ROOMS
        // =====================================

        System.out.println("\nROOM IDS :");

        if (rooms != null) {

            for (String r : rooms) {

                System.out.println(r);
            }

        } else {

            System.out.println("ROOM ARRAY IS NULL");
        }

        // =====================================
        // STUDENTS
        // =====================================

        System.out.println("\nSTUDENT REGISTER NOS :");

        if (students != null) {

            for (String s : students) {

                System.out.println(s);
            }

        } else {

            System.out.println("STUDENT ARRAY IS NULL");
        }

        // =====================================
        // VALIDATION
        // =====================================

        if (rooms == null || rooms.length == 0) {

            JSONObject err = new JSONObject();

            err.put("success", false);
            err.put("error", "No rooms selected");

            out.print(err.toJSONString());

            return;
        }

        if (students == null || students.length == 0) {

            JSONObject err = new JSONObject();

            err.put("success", false);
            err.put("error", "No students selected");

            out.print(err.toJSONString());

            return;
        }

        // =====================================
        // CALL DAO METHOD
        // =====================================

        JSONObject res =
                ERPHostelRoomDAO.allocateRooms(
                        rooms,
                        students,
                        userId,
                        ip);

        // =====================================
        // RESPONSE
        // =====================================

        out.print(res.toJSONString());

        System.out.println(
                "\nallocateRooms.jsp RESPONSE :\n"
                + res.toJSONString());

        System.out.println(
                "\n=================================");
        System.out.println("allocateRooms.jsp END");
        System.out.println("=================================\n");

    } catch (Exception e) {

        System.out.println(
                "\n\nCatch in allocateRooms.jsp\n\n");

        e.printStackTrace();

        JSONObject err = new JSONObject();

        err.put("success", false);

        err.put("error",
                e.getMessage() != null
                ? e.getMessage()
                : "Unknown server error");

        out.print(err.toJSONString());
    }
%>