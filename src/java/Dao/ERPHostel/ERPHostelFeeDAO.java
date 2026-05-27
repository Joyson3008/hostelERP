package Dao.ERPHostel;

import Dbs.Connect.CyberCon;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import java.text.SimpleDateFormat;
public class ERPHostelFeeDAO {
    
    
    
    // =========================================
// ASSIGN FEE TO STUDENTS
// =========================================

// =========================================
// ASSIGN FEE TO STUDENTS
// =========================================

public static String assignFeeToStudents(
        String jsonData,
        String allocatedBy,
        String allocatedIp) {

    JSONObject response =
            new JSONObject();

    Connection con = null;

    int assignedCount = 0;

    try {

        JSONParser parser =
                new JSONParser();

        JSONObject obj =
                (JSONObject) parser.parse(jsonData);

        Long feestructureid =
                Long.parseLong(
                        obj.get("feestructureid").toString());

        int blockno =
                Integer.parseInt(
                        obj.get("blockno").toString());

        String blockname =
                obj.get("blockname").toString();

        int roomnofrom =
                Integer.parseInt(
                        obj.get("roomnofrom").toString());

        int roomnoto =
                Integer.parseInt(
                        obj.get("roomnoto").toString());

        con =
                new CyberCon().ErpConnection();

        con.setAutoCommit(false);

        // =====================================
        // GET TOTAL AMOUNT
        // =====================================

        double totalamount = 0;

        String feeSql =
                "SELECT totalamount "
                + "FROM hostel.fee_structure_master "
                + "WHERE feestructureid = ?";

        try (PreparedStatement ps =
                     con.prepareStatement(feeSql)) {

            ps.setLong(1, feestructureid);

            try (ResultSet rs =
                         ps.executeQuery()) {

                if (rs.next()) {

                    totalamount =
                            rs.getDouble("totalamount");
                }
            }
        }

        // =====================================
        // GET STUDENTS
        // =====================================

        String studentSql =
                "SELECT "
                + "    registerno, "
                + "    applicationno, "
                + "    studentname, "
                + "    roomid, "
                + "    roomno, "
                + "    blockname "
                + "FROM hostel.student_room_allocation "
                + "WHERE LOWER(blockname) = LOWER(?) "
                + "AND roomno::INTEGER BETWEEN ? AND ? "
                + "AND isactive = 'Y'";

        try (PreparedStatement ps =
                     con.prepareStatement(studentSql)) {

            ps.setString(1, blockname);

            ps.setInt(2, roomnofrom);

            ps.setInt(3, roomnoto);

            try (ResultSet rs =
                         ps.executeQuery()) {

                while (rs.next()) {

                    String registerno =
                            rs.getString("registerno");

                    // =================================
                    // DUPLICATE CHECK
                    // =================================

                    String checkSql =
                            "SELECT 1 "
                            + "FROM hostel.student_fee_allocation "
                            + "WHERE feestructureid = ? "
                            + "AND registerno = ? "
                            + "AND isactive = 'Y'";

                    boolean alreadyAssigned =
                            false;

                    try (PreparedStatement cps =
                                 con.prepareStatement(checkSql)) {

                        cps.setLong(
                                1,
                                feestructureid);

                        cps.setString(
                                2,
                                registerno);

                        try (ResultSet crs =
                                     cps.executeQuery()) {

                            if (crs.next()) {

                                alreadyAssigned = true;
                            }
                        }
                    }

                    if (alreadyAssigned) {

                        continue;
                    }

                    // =================================
                    // INSERT ALLOCATION
                    // =================================

                    String insertSql =
                            "INSERT INTO hostel.student_fee_allocation "
                            + "("
                            + "feestructureid,"
                            + "registerno,"
                            + "applicationno,"
                            + "studentname,"
                            + "blockno,"
                            + "blockname,"
                            + "roomid,"
                            + "roomno,"
                            + "totalamount,"
                            + "paidamount,"
                            + "dueamount,"
                            + "allocateddate,"
                            + "allocatedby,"
                            + "isactive"
                            + ") "
                            + "VALUES "
                            + "(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

                    try (PreparedStatement ips =
                                 con.prepareStatement(insertSql)) {

                        ips.setLong(
                                1,
                                feestructureid);

                        ips.setString(
                                2,
                                registerno);

                        ips.setString(
                                3,
                                rs.getString(
                                        "applicationno"));

                        ips.setString(
                                4,
                                rs.getString(
                                        "studentname"));

                        ips.setInt(
                                5,
                                blockno);

                        ips.setString(
                                6,
                                rs.getString(
                                        "blockname"));

                        ips.setLong(
                                7,
                                rs.getLong(
                                        "roomid"));

                        ips.setString(
                                8,
                                rs.getString(
                                        "roomno"));

                        ips.setDouble(
                                9,
                                totalamount);

                        ips.setDouble(
                                10,
                                0);

                        ips.setDouble(
                                11,
                                totalamount);

                        ips.setTimestamp(
                                12,
                                new Timestamp(
                                        System.currentTimeMillis()));

                        ips.setString(
                                13,
                                allocatedBy);

                        ips.setString(
                                14,
                                "Y");

                        ips.executeUpdate();

                        assignedCount++;
                    }
                }
            }
        }

        con.commit();

        response.put("success", true);

        response.put("count", assignedCount);

    } catch (Exception e) {

        e.printStackTrace();

        try {

            if (con != null) {

                con.rollback();
            }

        } catch (Exception ex) {

            ex.printStackTrace();
        }

        response.put("success", false);

        response.put(
                "message",
                e.getMessage());

    } finally {

        try {

            if (con != null) {

                con.close();
            }

        } catch (Exception e) {

            e.printStackTrace();
        }
    }

    return response.toJSONString();
}

    // =========================================
// UPDATE FEE STRUCTURE
// =========================================

public static String updateFeeStructure(
        String jsonData,
        String updatedBy,
        String updatedIp) {

    JSONObject response =
            new JSONObject();

    Connection con = null;

    try {

        JSONParser parser =
                new JSONParser();

        JSONObject obj =
                (JSONObject) parser.parse(jsonData);

        Long feestructureid =
                Long.parseLong(
                        obj.get("feestructureid").toString());

        JSONArray feeDetails =
                (JSONArray) obj.get("feeDetails");

        JSONArray notes =
                (JSONArray) obj.get("notes");

        con =
            new CyberCon().ErpConnection();

        con.setAutoCommit(false);

        // =========================================
        // UPDATE MASTER
        // =========================================

        String updateMasterSql =
                "UPDATE hostel.fee_structure_master "
                + "SET "
                + "academicyearid = ?, "
                + "hosteltype = ?, "
                + "blockno = ?, "
                + "blockname = ?, "
                + "roomnofrom = ?, "
                + "roomnoto = ?, "
                + "roomtype = ?, "
                + "structurename = ?, "
                + "effectivedate = ?, "
                + "totalamount = ? "
                + "WHERE feestructureid = ?";

        try (PreparedStatement ps =
                     con.prepareStatement(updateMasterSql)) {

            ps.setInt(
                    1,
                    Integer.parseInt(
                            obj.get("academicyearid").toString()));

            ps.setString(
                    2,
                    obj.get("hosteltype").toString());

            ps.setInt(
                    3,
                    Integer.parseInt(
                            obj.get("blockno").toString()));

            ps.setString(
                    4,
                    obj.get("blockname").toString());

            ps.setString(
                    5,
                    obj.get("roomnofrom").toString());

            ps.setString(
                    6,
                    obj.get("roomnoto").toString());

            ps.setString(
                    7,
                    obj.get("roomtype").toString());

            ps.setString(
                    8,
                    obj.get("structurename").toString());

           String effectiveDate =
        obj.get("effectivedate").toString();

SimpleDateFormat sdf =
        new SimpleDateFormat("dd-MM-yyyy");

java.util.Date utilDate =
        sdf.parse(effectiveDate);

java.sql.Date sqlDate =
        new java.sql.Date(utilDate.getTime());

ps.setDate(9, sqlDate);

            ps.setDouble(
                    10,
                    Double.parseDouble(
                            obj.get("totalamount").toString()));

            ps.setLong(
                    11,
                    feestructureid);

            ps.executeUpdate();
        }

        // =========================================
        // DELETE OLD DETAILS
        // =========================================

        String deleteDetailsSql =
                "DELETE FROM hostel.fee_structure_details "
                + "WHERE feestructureid = ?";

        try (PreparedStatement ps =
                     con.prepareStatement(deleteDetailsSql)) {

            ps.setLong(1, feestructureid);

            ps.executeUpdate();
        }

        // =========================================
        // INSERT NEW DETAILS
        // =========================================

        String insertDetailsSql =
                "INSERT INTO hostel.fee_structure_details "
                + "("
                + "feestructureid,"
                + "feehead,"
                + "amount,"
                + "orderno"
                + ") "
                + "VALUES (?,?,?,?)";

        try (PreparedStatement ps =
                     con.prepareStatement(insertDetailsSql)) {

            for (int i = 0;
                    i < feeDetails.size();
                    i++) {

                JSONObject detail =
                        (JSONObject) feeDetails.get(i);

                ps.setLong(
                        1,
                        feestructureid);

                ps.setString(
                        2,
                        detail.get("feehead").toString());

                ps.setDouble(
                        3,
                        Double.parseDouble(
                                detail.get("amount").toString()));

                ps.setInt(
                        4,
                        i + 1);

                ps.addBatch();
            }

            ps.executeBatch();
        }

        // =========================================
        // DELETE OLD NOTES
        // =========================================

        String deleteNotesSql =
                "DELETE FROM hostel.fee_structure_notes "
                + "WHERE feestructureid = ?";

        try (PreparedStatement ps =
                     con.prepareStatement(deleteNotesSql)) {

            ps.setLong(1, feestructureid);

            ps.executeUpdate();
        }

        // =========================================
        // INSERT NEW NOTES
        // =========================================

        String insertNotesSql =
                "INSERT INTO hostel.fee_structure_notes "
                + "("
                + "feestructureid,"
                + "notes"
                + ") "
                + "VALUES (?,?)";

        try (PreparedStatement ps =
                     con.prepareStatement(insertNotesSql)) {

            for (int i = 0;
                    i < notes.size();
                    i++) {

                ps.setLong(
                        1,
                        feestructureid);

                ps.setString(
                        2,
                        notes.get(i).toString());

                ps.addBatch();
            }

            ps.executeBatch();
        }

        con.commit();

        response.put("success", true);

    } catch (Exception e) {

        e.printStackTrace();

        try {

            if (con != null) {

                con.rollback();
            }

        } catch (Exception ex) {

            ex.printStackTrace();
        }

        response.put("success", false);

        response.put(
                "message",
                e.getMessage());

    } finally {

        try {

            if (con != null) {

                con.close();
            }

        } catch (Exception e) {

            e.printStackTrace();
        }
    }

    return response.toJSONString();
}
    // =========================================================
    // GET BLOCK DETAILS
    // =========================================================

    public static JSONArray getBlocksDetails() {

        JSONArray arr = new JSONArray();

        String sql =
        "SELECT "
        + "    blockid, "
        + "    blockname, "
        + "    blockno, "
        + "    no_of_floors "
        + "FROM hostel.hostel_blockmaster "

        // =========================================
        // ORDER BLOCK TYPES
        // =========================================

        + "ORDER BY "
        + "    CASE "
        + "        WHEN LOWER(blockname) = 'special block' THEN 1 "
        + "        WHEN LOWER(blockname) = 'common block' THEN 2 "
        + "        WHEN LOWER(blockname) = 'a block' THEN 3 "
        + "        WHEN LOWER(blockname) = 'loho2' THEN 4 "
        + "        ELSE 5 "
        + "    END, "

        // =========================================
        // SORT BLOCK NUMBERS
        // =========================================

        + "    blockno ASC NULLS LAST";

        try (Connection con =
                new CyberCon().ErpConnection();

             PreparedStatement ps =
                     con.prepareStatement(sql);

             ResultSet rs =
                     ps.executeQuery()) {

            while (rs.next()) {

    JSONObject obj = new JSONObject();

    obj.put(
            "blockid",
            rs.getInt("blockid"));

    obj.put(
            "blockno",
            rs.getObject("blockno"));

    String blockname =
            rs.getString("blockname");

    Object blockno =
            rs.getObject("blockno");

    String displayName;

    // =====================================
    // A BLOCK / LOHO2
    // =====================================

    if (blockno == null) {

        displayName = blockname;

    } else {

        displayName =
                blockname
                + " "
                + blockno;
    }

    obj.put(
            "blockname",
            displayName);

    obj.put(
            "no_of_floors",
            rs.getInt("no_of_floors"));

    arr.add(obj);
}   
        
        } catch (Exception e) {
    

            System.out.println(
                    "\n\nCatch in ERPHostelFeeDAO.getBlocksDetails\n\n");

            e.printStackTrace();
        }

        return arr;
    }

    // =========================================================
    // SAVE FEE STRUCTURE
    // =========================================================

   public static String saveFeeStructure(
        String jsonData,
        String createdBy,
        String createdIp) {

    JSONObject result =
            new JSONObject();

    Connection con = null;

    try {

        JSONParser parser =
                new JSONParser();

        JSONObject data =
                (JSONObject) parser.parse(jsonData);

        con =
                new CyberCon().ErpConnection();

        con.setAutoCommit(false);

        // =================================================
        // GET VALUES
        // =================================================

        int academicyearid =
                Integer.parseInt(
                        data.get("academicyearid")
                                .toString());

        String hosteltype =
                data.get("hosteltype")
                        .toString();

        int blockno =
                Integer.parseInt(
                        data.get("blockno")
                                .toString());

        String blockname =
                data.get("blockname")
                        .toString();

        String roomnofrom =
                data.get("roomnofrom")
                        .toString();

        String roomnoto =
                data.get("roomnoto")
                        .toString();

        String roomtype =
                data.get("roomtype")
                        .toString();

        String structurename =
                data.get("structurename")
                        .toString();

        double totalamount =
                Double.parseDouble(
                        data.get("totalamount")
                                .toString());

        String effectivedate =
                data.get("effectivedate")
                        .toString();

        // =================================================
        // MASTER INSERT
        // =================================================

        String masterSql =
                "INSERT INTO hostel.fee_structure_master ( "
                + "academicyearid, "
                + "hosteltype, "
                + "blockno, "
                + "blockname, "
                + "roomnofrom, "
                + "roomnoto, "
                + "roomtype, "
                + "structurename, "
                + "totalamount, "
                + "effectivedate, "
                + "createddate, "
                + "createdby, "
                + "createdip, "
                + "isactive "
                + ") VALUES (?,?,?,?,?,?,?,?,?, ?, NOW(), ?, ?, 'Y')";

        long feestructureid = 0;

        try (PreparedStatement ps =
                con.prepareStatement(
                        masterSql,
                        PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, academicyearid);

            ps.setString(2, hosteltype);

            ps.setInt(3, blockno);

            ps.setString(4, blockname);

            ps.setString(5, roomnofrom);

            ps.setString(6, roomnoto);

            ps.setString(7, roomtype);

            ps.setString(8, structurename);

            ps.setDouble(9, totalamount);

            ps.setDate(
                    10,
                    java.sql.Date.valueOf(effectivedate));

            ps.setString(11, createdBy);

            ps.setString(12, createdIp);

            ps.executeUpdate();

            ResultSet rs =
                    ps.getGeneratedKeys();

            if (rs.next()) {

                feestructureid =
                        rs.getLong(1);
            }
        }

        // =================================================
        // INSERT FEE DETAILS
        // =================================================

        JSONArray feeDetails =
                (JSONArray) data.get("feeDetails");

        String detailSql =
                "INSERT INTO hostel.fee_structure_details ( "
                + "feestructureid, "
                + "feehead, "
                + "amount, "
                + "orderno "
                + ") VALUES (?,?,?,?)";

        try (PreparedStatement ps =
                con.prepareStatement(detailSql)) {

            for (int i = 0;
                    i < feeDetails.size();
                    i++) {

                JSONObject obj =
                        (JSONObject)
                                feeDetails.get(i);

                ps.setLong(
                        1,
                        feestructureid);

                ps.setString(
                        2,
                        obj.get("feehead")
                                .toString());

                ps.setDouble(
                        3,
                        Double.parseDouble(
                                obj.get("amount")
                                        .toString()));

                ps.setInt(
                        4,
                        i + 1);

                ps.addBatch();
            }

            ps.executeBatch();
        }

        // =================================================
        // INSERT NOTES
        // =================================================

        JSONArray notes =
                (JSONArray) data.get("notes");

        String noteSql =
                "INSERT INTO hostel.fee_structure_notes ( "
                + "feestructureid, "
                + "notes "
                + ") VALUES (?,?)";

        try (PreparedStatement ps =
                con.prepareStatement(noteSql)) {

            for (Object noteObj : notes) {

                ps.setLong(
                        1,
                        feestructureid);

                ps.setString(
                        2,
                        noteObj.toString());

                ps.addBatch();
            }

            ps.executeBatch();
        }

        // =================================================
        // COMMIT
        // =================================================

        con.commit();

        result.put("success", true);

        result.put(
                "message",
                "Fee Structure Saved Successfully");

        result.put(
                "feestructureid",
                feestructureid);

    } catch (Exception e) {

        try {

            if (con != null) {

                con.rollback();
            }

        } catch (Exception ex) {

            ex.printStackTrace();
        }

        System.out.println(
                "\n\nCatch in ERPHostelFeeDAO.saveFeeStructure\n\n");

        e.printStackTrace();

        result.put("success", false);

        result.put(
                "message",
                e.getMessage());

    } finally {

        try {

            if (con != null) {

                con.close();
            }

        } catch (Exception e) {

            e.printStackTrace();
        }
    }

    return result.toJSONString();
}

    // =========================================================
    // GET FEE STRUCTURE
    // =========================================================

    public static JSONObject getFeeStructure(
            int blockno,
            String roomtype,
            int academicyearid) {

        JSONObject result =
                new JSONObject();

        JSONArray feeArray =
                new JSONArray();

        JSONArray noteArray =
                new JSONArray();

        String sql =
                "SELECT * "
                + "FROM hostel.fee_structure_master "
                + "WHERE blockno = ? "
                + "AND roomtype = ? "
                + "AND academicyearid = ? "
                + "AND isactive = 'Y' "
                + "ORDER BY feestructureid DESC "
                + "LIMIT 1";

        try (Connection con =
                new CyberCon().ErpConnection();

             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setInt(1, blockno);

            ps.setString(2, roomtype);

            ps.setInt(3, academicyearid);

            ResultSet rs =
                    ps.executeQuery();

            if (rs.next()) {

                long feestructureid =
                        rs.getLong("feestructureid");

                result.put(
                        "feestructureid",
                        feestructureid);

                result.put(
                        "structurename",
                        rs.getString("structurename"));

                result.put(
                        "totalamount",
                        rs.getDouble("totalamount"));

                result.put(
                        "effectivedate",
                        rs.getString("effectivedate"));

                // =====================================
                // GET FEE DETAILS
                // =====================================

                String detailSql =
                        "SELECT * "
                        + "FROM hostel.fee_structure_details "
                        + "WHERE feestructureid = ? "
                        + "ORDER BY orderno ASC";

                try (PreparedStatement ps2 =
                        con.prepareStatement(detailSql)) {

                    ps2.setLong(
                            1,
                            feestructureid);

                    ResultSet rs2 =
                            ps2.executeQuery();

                    while (rs2.next()) {

                        JSONObject obj =
                                new JSONObject();

                        obj.put(
                                "feehead",
                                rs2.getString("feehead"));

                        obj.put(
                                "amount",
                                rs2.getDouble("amount"));

                        feeArray.add(obj);
                    }
                }

                // =====================================
                // GET NOTES
                // =====================================

                String noteSql =
                        "SELECT * "
                        + "FROM hostel.fee_structure_notes "
                        + "WHERE feestructureid = ?";

                try (PreparedStatement ps3 =
                        con.prepareStatement(noteSql)) {

                    ps3.setLong(
                            1,
                            feestructureid);

                    ResultSet rs3 =
                            ps3.executeQuery();

                    while (rs3.next()) {

                        noteArray.add(
                                rs3.getString("notes"));
                    }
                }
            }

            result.put("feeDetails", feeArray);

            result.put("notes", noteArray);

        } catch (Exception e) {

            System.out.println(
                    "\n\nCatch in ERPHostelFeeDAO.getFeeStructure\n\n");

            e.printStackTrace();
        }

        return result;
    }

    // =========================================================
    // DELETE FEE STRUCTURE
    // =========================================================

    public static String deleteFeeStructure(
            long feestructureid) {

        JSONObject result =
                new JSONObject();

        String sql =
                "UPDATE hostel.fee_structure_master "
                + "SET isactive = 'N' "
                + "WHERE feestructureid = ?";

        try (Connection con =
                new CyberCon().ErpConnection();

             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setLong(1, feestructureid);

            int rows =
                    ps.executeUpdate();

            if (rows > 0) {

                result.put("success", true);

                result.put(
                        "message",
                        "Fee Structure Deleted");

            } else {

                result.put("success", false);

                result.put(
                        "message",
                        "No Record Found");
            }

        } catch (Exception e) {

            System.out.println(
                    "\n\nCatch in ERPHostelFeeDAO.deleteFeeStructure\n\n");

            e.printStackTrace();

            result.put("success", false);

            result.put(
                    "message",
                    e.getMessage());
        }

        return result.toJSONString();
    }
    public static String loadFeeStructure(
        String academicyearid,
        String blockno,
        String roomnofrom,
        String roomnoto) {

    JSONObject result =
            new JSONObject();

    JSONObject master =
            new JSONObject();

    JSONArray details =
            new JSONArray();

    JSONArray notes =
            new JSONArray();

    Connection con = null;

    try {

        con =
                new CyberCon().ErpConnection();

        // =================================================
        // LOAD MASTER
        // =================================================

       String masterSql =
        "SELECT * "
        + "FROM hostel.fee_structure_master "
        + "WHERE academicyearid = ? "
        + "AND blockno = ? "
        + "ORDER BY feestructureid DESC "
        + "LIMIT 1";
        long feestructureid = 0;

    try (PreparedStatement ps =
        con.prepareStatement(masterSql)) {

    ps.setInt(
            1,
            Integer.parseInt(academicyearid));

    ps.setInt(
            2,
            Integer.parseInt(blockno));

    ResultSet rs =
            ps.executeQuery();


            if (rs.next()) {

                feestructureid =
                        rs.getLong("feestructureid");

                master.put(
                        "feestructureid",
                        feestructureid);

                master.put(
                        "hosteltype",
                        rs.getString("hosteltype"));

                master.put(
                        "blockno",
                        rs.getInt("blockno"));

                master.put(
                        "blockname",
                        rs.getString("blockname"));

                master.put(
                        "roomnofrom",
                        rs.getString("roomnofrom"));

                master.put(
                        "roomnoto",
                        rs.getString("roomnoto"));

                master.put(
                        "roomtype",
                        rs.getString("roomtype"));

                master.put(
                        "structurename",
                        rs.getString("structurename"));

                master.put(
                        "totalamount",
                        rs.getDouble("totalamount"));

                master.put(
                        "effectivedate",
                        rs.getDate("effectivedate")
                                .toString());
            }
        }

        // =================================================
        // NO DATA
        // =================================================

        if (feestructureid == 0) {

            result.put("success", false);

            result.put(
                    "message",
                    "No Fee Structure Found");

            return result.toJSONString();
        }

        // =================================================
        // LOAD DETAILS
        // =================================================

        String detailSql =
                "SELECT * "
                + "FROM hostel.fee_structure_details "
                + "WHERE feestructureid = ? "
                + "ORDER BY orderno ASC";

        try (PreparedStatement ps =
                con.prepareStatement(detailSql)) {

            ps.setLong(1, feestructureid);

            ResultSet rs =
                    ps.executeQuery();

            while (rs.next()) {

                JSONObject obj =
                        new JSONObject();

                obj.put(
                        "detailid",
                        rs.getLong("detailid"));

                obj.put(
                        "feehead",
                        rs.getString("feehead"));

                obj.put(
                        "amount",
                        rs.getDouble("amount"));

                obj.put(
                        "orderno",
                        rs.getInt("orderno"));

                details.add(obj);
            }
        }

        // =================================================
        // LOAD NOTES
        // =================================================

        String noteSql =
                "SELECT * "
                + "FROM hostel.fee_structure_notes "
                + "WHERE feestructureid = ? "
                + "ORDER BY noteid ASC";

        try (PreparedStatement ps =
                con.prepareStatement(noteSql)) {

            ps.setLong(1, feestructureid);

            ResultSet rs =
                    ps.executeQuery();

            while (rs.next()) {

                JSONObject obj =
                        new JSONObject();

                obj.put(
                        "noteid",
                        rs.getLong("noteid"));

                obj.put(
                        "notes",
                        rs.getString("notes"));

                notes.add(obj);
            }
        }

        // =================================================
        // FINAL RESPONSE
        // =================================================

        result.put("success", true);

        result.put("master", master);

        result.put("details", details);

        result.put("notes", notes);

    } catch (Exception e) {

        System.out.println(
                "\n\nCatch in ERPHostelFeeDAO.loadFeeStructure\n\n");

        e.printStackTrace();

        result.put("success", false);

        result.put(
                "message",
                e.getMessage());

    } finally {

        try {

            if (con != null) {

                con.close();
            }

        } catch (Exception e) {

            e.printStackTrace();
        }
    }

    return result.toJSONString();
}

}