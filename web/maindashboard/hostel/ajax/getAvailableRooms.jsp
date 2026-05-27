<%-- 
    Document   : getAvailableRooms
    Created on : Apr 20, 2026
    Author     : lccerp26
--%>

<%@page contentType="application/json" pageEncoding="UTF-8"%>

<%@page import="Dao.ERPHostel.ERPHostelRoomDAO"%>
<%@page import="org.json.simple.JSONArray"%>

<%
    response.setContentType("application/json");

    try {

        // =========================================
        // GET PARAMETERS
        // =========================================

        String blockParam =
                request.getParameter("blockid");

        String floorParam =
                request.getParameter("floorid");

        // =========================================
        // VALIDATION
        // =========================================

        if (blockParam == null || blockParam.equals("")) {

            System.out.println(
                    "\n\nBlock ID Missing\n\n");

            out.print("[]");

            return;
        }

        int blockid =
                Integer.parseInt(blockParam);

        int floorid = 0;

        // =========================================
        // FLOOR FILTER
        // =========================================

        if (floorParam != null
                && !floorParam.equals("")) {

            try {

                floorid =
                        Integer.parseInt(floorParam);

            } catch (Exception e) {

                floorid = 0;
            }
        }

        System.out.println(
                "\n\nBLOCK ID : " + blockid);

        System.out.println(
                "FLOOR ID : " + floorid);

        // =========================================
        // GET AVAILABLE ROOMS
        // =========================================

        JSONArray arr =
                ERPHostelRoomDAO.getAvailableRooms(
                        blockid,
                        floorid
                );

        System.out.println(
                "\n\nROOM RESPONSE :\n"
                + arr.toJSONString());

        out.print(arr.toJSONString());

        out.flush();

    } catch (Exception e) {

        System.out.println(
                "\n\nCatch in getAvailableRooms.jsp\n\n");

        e.printStackTrace();

        out.print("[]");
    }
%>