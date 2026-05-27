<%--
    Document   : getAllocatedBlocks.jsp
    Location   : ajax/
    Purpose    : Returns allocated rooms grouped by room with student list
    Input      : blockname (String)
    Output     : JSONArray
--%>

<%@page import="Dao.ERPHostel.ERPHostelRoomDAO"%>
<%@page import="org.json.simple.JSONArray"%>

<%@page contentType="application/json"
        pageEncoding="UTF-8"%>

<%

    // =====================================
    // GET BLOCK NAME
    // =====================================

    String blockname =
            request.getParameter("blockname");

    if (blockname == null) {
        blockname = "";
    }

    blockname = blockname.trim();

    System.out.println(
            "\n\n=================================");

    System.out.println(
            "getAllocatedBlocks.jsp");

    System.out.println(
            "=================================");

    System.out.println(
            "BLOCK NAME : " + blockname);

    // =====================================
    // VALIDATION
    // =====================================

    if (blockname.equals("")) {

        out.print("[]");

        return;
    }

    // =====================================
    // DAO CALL
    // =====================================

    JSONArray result =
            ERPHostelRoomDAO
                    .getAllocatedBlocks(blockname);

    // =====================================
    // RESPONSE
    // =====================================

    out.print(result.toJSONString());

    System.out.println(
            "\nTOTAL ROOMS : "
            + result.size());

    System.out.println(
            "\n=================================\n");

%>