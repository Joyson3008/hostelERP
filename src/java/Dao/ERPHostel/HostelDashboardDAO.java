/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Dao.ERPHostel;

import java.sql.*;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import Dbs.Connect.CyberCon;
import java.text.SimpleDateFormat;

/**
 *
 * @author lccerp26
 */
public class HostelDashboardDAO {
     @SuppressWarnings("unchecked")
    public static JSONObject saveFeeStructure(JSONObject payload) {

        JSONObject result = new JSONObject();
        Connection con = null;

        try {
            con = new CyberCon().ErpConnection();
            con.setAutoCommit(false);

            long feestructureid = toLong(payload.get("feestructureid"));
            boolean isNew = (feestructureid == 0);

            // ─── MASTER ─────────────────────────────────────
            if (isNew) {
                String ins = "INSERT INTO hostel.fee_structure_master "
                        + "(academicyearid, hosteltype, blockno, blockname, roomtype, "
                        + " structurename, totalamount, effectivedate, createdby, createdip, isactive) "
                        + "VALUES (?,?,?,?,?,?,?,?,?,?,'Y')";
                try (PreparedStatement ps = con.prepareStatement(ins,
                        Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, toInt(payload.get("academicyearid")));
                    ps.setString(2, str(payload.get("hosteltype")));
                    ps.setInt(3, toInt(payload.get("blockno")));
                    ps.setString(4, str(payload.get("blockname")));
                    ps.setString(5, str(payload.get("roomtype")));
                    ps.setString(6, str(payload.get("structurename")));
                    ps.setBigDecimal(7, bd(payload.get("totalamount")));
                    ps.setDate(8, java.sql.Date.valueOf(str(payload.get("effectivedate"))));
                    ps.setString(9, str(payload.get("createdby")));
                    ps.setString(10, str(payload.get("createdip")));
                    ps.executeUpdate();
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) feestructureid = rs.getLong(1);
                    }
                }
            } else {
                String upd = "UPDATE hostel.fee_structure_master SET "
                        + "academicyearid=?, hosteltype=?, blockno=?, blockname=?, "
                        + "roomtype=?, structurename=?, totalamount=?, effectivedate=? "
                        + "WHERE feestructureid=?";
                try (PreparedStatement ps = con.prepareStatement(upd)) {
                    ps.setInt(1, toInt(payload.get("academicyearid")));
                    ps.setString(2, str(payload.get("hosteltype")));
                    ps.setInt(3, toInt(payload.get("blockno")));
                    ps.setString(4, str(payload.get("blockname")));
                    ps.setString(5, str(payload.get("roomtype")));
                    ps.setString(6, str(payload.get("structurename")));
                    ps.setBigDecimal(7, bd(payload.get("totalamount")));
                    ps.setDate(8, java.sql.Date.valueOf(str(payload.get("effectivedate"))));
                    ps.setLong(9, feestructureid);
                    ps.executeUpdate();
                }
                // Delete old details + notes to replace
                try (PreparedStatement ps = con.prepareStatement(
                        "DELETE FROM hostel.fee_structure_details WHERE feestructureid=?")) {
                    ps.setLong(1, feestructureid); ps.executeUpdate();
                }
                try (PreparedStatement ps = con.prepareStatement(
                        "DELETE FROM hostel.fee_structure_notes WHERE feestructureid=?")) {
                    ps.setLong(1, feestructureid); ps.executeUpdate();
                }
            }

            // ─── DETAILS ────────────────────────────────────
            JSONArray heads = (JSONArray) payload.get("heads");
            if (heads != null) {
                String ins2 = "INSERT INTO hostel.fee_structure_details "
                        + "(feestructureid, feehead, amount, orderno) VALUES (?,?,?,?)";
                try (PreparedStatement ps = con.prepareStatement(ins2)) {
                    for (Object o : heads) {
                        JSONObject h = (JSONObject) o;
                        ps.setLong(1, feestructureid);
                        ps.setString(2, str(h.get("feehead")));
                        ps.setBigDecimal(3, bd(h.get("amount")));
                        ps.setInt(4, toInt(h.get("orderno")));
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }

            // ─── NOTES ──────────────────────────────────────
            JSONArray notes = (JSONArray) payload.get("notes");
            if (notes != null) {
                String ins3 = "INSERT INTO hostel.fee_structure_notes (feestructureid, notes) VALUES (?,?)";
                try (PreparedStatement ps = con.prepareStatement(ins3)) {
                    for (Object o : notes) {
                        if (o == null) continue;
                        ps.setLong(1, feestructureid);
                        ps.setString(2, o.toString().trim());
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
            }

            con.commit();
            result.put("success", true);
            result.put("feestructureid", feestructureid);
            result.put("message", "Fee structure saved.");

        } catch (Exception e) {
            rollback(con);
            System.out.println("ERROR saveFeeStructure: " + e.getMessage());
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Save failed: " + e.getMessage());
        } finally {
            close(con);
        }
        return result;
    }

    // =========================================================
    // 2. LOAD FEE STRUCTURE (by blockno + roomtype + ayid OR by id)
    // =========================================================
    @SuppressWarnings("unchecked")
    public static JSONObject loadFeeStructure(int blockno, String roomtype,
            int academicyearid, long feestructureid) {

        JSONObject result = new JSONObject();

        String masterSql;
        Object[] params;
        if (feestructureid > 0) {
            masterSql = "SELECT * FROM hostel.fee_structure_master "
                    + "WHERE feestructureid=? AND isactive='Y'";
            params = new Object[]{feestructureid};
        } else {
            masterSql = "SELECT * FROM hostel.fee_structure_master "
                    + "WHERE blockno=? AND LOWER(roomtype)=LOWER(?) "
                    + "AND academicyearid=? AND isactive='Y' "
                    + "ORDER BY feestructureid DESC LIMIT 1";
            params = new Object[]{blockno, roomtype, academicyearid};
        }

        try (Connection con = new CyberCon().ErpConnection();
             PreparedStatement ps = con.prepareStatement(masterSql)) {

            for (int i = 0; i < params.length; i++) {
                ps.setObject(i + 1, params[i]);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    result.put("success", false);
                    result.put("message", "No fee structure found.");
                    return result;
                }
                long fsid = rs.getLong("feestructureid");
                result.put("success", true);
                result.put("feestructureid", fsid);
                result.put("academicyearid", rs.getInt("academicyearid"));
                result.put("hosteltype",     rs.getString("hosteltype"));
                result.put("blockno",        rs.getInt("blockno"));
                result.put("blockname",      safe(rs.getString("blockname")));
                result.put("roomtype",       safe(rs.getString("roomtype")));
                result.put("structurename",  safe(rs.getString("structurename")));
                result.put("totalamount",    rs.getBigDecimal("totalamount"));
                java.sql.Date eff = rs.getDate("effectivedate");
                result.put("effectivedate",  eff != null ? eff.toString() : "");
                Timestamp cd = rs.getTimestamp("createddate");
                result.put("createddate", cd != null ? new java.text.SimpleDateFormat("dd-MM-yyyy HH:mm").format(cd) : "");

                // details
                JSONArray heads = new JSONArray();
                try (PreparedStatement ps2 = con.prepareStatement(
                        "SELECT * FROM hostel.fee_structure_details "
                        + "WHERE feestructureid=? ORDER BY orderno")) {
                    ps2.setLong(1, fsid);
                    try (ResultSet rs2 = ps2.executeQuery()) {
                        while (rs2.next()) {
                            JSONObject h = new JSONObject();
                            h.put("detailid",  rs2.getLong("detailid"));
                            h.put("feehead",   safe(rs2.getString("feehead")));
                            h.put("amount",    rs2.getBigDecimal("amount"));
                            h.put("orderno",   rs2.getInt("orderno"));
                            heads.add(h);
                        }
                    }
                }
                result.put("heads", heads);

                // notes
                JSONArray notes = new JSONArray();
                try (PreparedStatement ps3 = con.prepareStatement(
                        "SELECT * FROM hostel.fee_structure_notes WHERE feestructureid=?")) {
                    ps3.setLong(1, fsid);
                    try (ResultSet rs3 = ps3.executeQuery()) {
                        while (rs3.next()) {
                            JSONObject n = new JSONObject();
                            n.put("noteid", rs3.getLong("noteid"));
                            n.put("notes",  safe(rs3.getString("notes")));
                            notes.add(n);
                        }
                    }
                }
                result.put("notes", notes);
            }

        } catch (Exception e) {
            System.out.println("ERROR loadFeeStructure: " + e.getMessage());
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Load error: " + e.getMessage());
        }
        return result;
    }

    // =========================================================
    // 3. GET ALL STRUCTURES (for Copy dropdown)
    // =========================================================
    @SuppressWarnings("unchecked")
    public static JSONArray getAllStructures() {
        JSONArray arr = new JSONArray();
        String sql = "SELECT feestructureid, structurename, blockname, roomtype, "
                + "totalamount, effectivedate "
                + "FROM hostel.fee_structure_master WHERE isactive='Y' "
                + "ORDER BY feestructureid DESC";
        try (Connection con = new CyberCon().ErpConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                JSONObject o = new JSONObject();
                o.put("feestructureid", rs.getLong("feestructureid"));
                o.put("structurename",  safe(rs.getString("structurename")));
                o.put("blockname",      safe(rs.getString("blockname")));
                o.put("roomtype",       safe(rs.getString("roomtype")));
                o.put("totalamount",    rs.getBigDecimal("totalamount"));
                java.sql.Date eff = rs.getDate("effectivedate");
                o.put("effectivedate",  eff != null ? eff.toString() : "");
                arr.add(o);
            }
        } catch (Exception e) {
            System.out.println("ERROR getAllStructures: " + e.getMessage());
            e.printStackTrace();
        }
        return arr;
    }

    // =========================================================
    // 4. GET STUDENTS FOR BLOCK (for assign preview)
    // =========================================================
    @SuppressWarnings("unchecked")
    public static JSONArray getStudentsForBlock(int blockno, long feestructureid) {
        JSONArray arr = new JSONArray();
        String sql =
            "SELECT "
          + "  sra.registerno, sra.applicationno, sra.studentname, "
          + "  sra.roomno, sra.floorname, sra.blockname, sra.roomid, "
          + "  CASE WHEN sfa.allocationid IS NOT NULL THEN true ELSE false END AS alreadyassigned "
          + "FROM hostel.student_room_allocation sra "
          + "LEFT JOIN hostel.student_fee_allocation sfa "
          + "  ON sfa.registerno = sra.registerno "
          + "  AND sfa.feestructureid = ? "
          + "  AND sfa.isactive = 'Y' "
          + "WHERE sra.isactive = 'Y' "
          + "AND sra.blockname IN ("
          + "  SELECT COALESCE('Block : '||CAST(blockno AS VARCHAR), blockname) "
          + "  FROM hostel.hostel_blockmaster WHERE blockno = ?"
          + ") "
          + "ORDER BY sra.studentname";

        try (Connection con = new CyberCon().ErpConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setLong(1, feestructureid);
            ps.setInt(2, blockno);
            System.out.println("getStudentsForBlock: " + ps);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    JSONObject o = new JSONObject();
                    o.put("registerno",     safe(rs.getString("registerno")));
                    o.put("applicationno",  safe(rs.getString("applicationno")));
                    o.put("studentname",    safe(rs.getString("studentname")));
                    o.put("roomno",         safe(rs.getString("roomno")));
                    o.put("floorname",      safe(rs.getString("floorname")));
                    o.put("blockname",      safe(rs.getString("blockname")));
                    o.put("roomid",         rs.getLong("roomid"));
                    o.put("alreadyassigned",rs.getBoolean("alreadyassigned"));
                    arr.add(o);
                }
            }
        } catch (Exception e) {
            System.out.println("ERROR getStudentsForBlock: " + e.getMessage());
            e.printStackTrace();
        }
        return arr;
    }

    // =========================================================
    // 5. ASSIGN FEE STRUCTURE TO STUDENTS (transaction)
    // =========================================================
    @SuppressWarnings("unchecked")
    public static JSONObject assignFeeStructure(JSONObject payload) {

        JSONObject result = new JSONObject();
        Connection con = null;

        try {
            con = new CyberCon().ErpConnection();
            con.setAutoCommit(false);

            long   fsid      = toLong(payload.get("feestructureid"));
            int    blockno   = toInt(payload.get("blockno"));
            String blockname = str(payload.get("blockname"));
            java.math.BigDecimal total = bd(payload.get("totalamount"));
            String allocatedby = str(payload.get("allocatedby"));

            JSONArray students = (JSONArray) payload.get("students");
            if (students == null || students.isEmpty()) {
                result.put("success", false);
                result.put("message", "No students provided.");
                return result;
            }

            String ins = "INSERT INTO hostel.student_fee_allocation "
                    + "(feestructureid, registerno, applicationno, studentname, "
                    + " blockno, blockname, roomid, roomno, "
                    + " totalamount, paidamount, dueamount, allocatedby, isactive) "
                    + "VALUES (?,?,?,?,?,?,?,?,?,0,?,?,'Y')";

            int assigned = 0;
            try (PreparedStatement ps = con.prepareStatement(ins)) {
                for (Object obj : students) {
                    JSONObject s = (JSONObject) obj;
                    String regno = str(s.get("registerno"));

                    // Duplicate prevention
                    boolean exists = false;
                    try (PreparedStatement chk = con.prepareStatement(
                            "SELECT 1 FROM hostel.student_fee_allocation "
                            + "WHERE feestructureid=? AND registerno=? AND isactive='Y'")) {
                        chk.setLong(1, fsid);
                        chk.setString(2, regno);
                        try (ResultSet cr = chk.executeQuery()) {
                            if (cr.next()) exists = true;
                        }
                    }
                    if (exists) continue; // skip already assigned

                    ps.setLong(1, fsid);
                    ps.setString(2, regno);
                    ps.setString(3, str(s.get("applicationno")));
                    ps.setString(4, str(s.get("studentname")));
                    ps.setInt(5, blockno);
                    ps.setString(6, blockname);
                    long roomid = toLong(s.get("roomid"));
                    if (roomid > 0) ps.setLong(7, roomid);
                    else            ps.setNull(7, Types.BIGINT);
                    ps.setString(8, str(s.get("roomno")));
                    ps.setBigDecimal(9, total);
                    ps.setBigDecimal(10, total); // dueamount = total initially
                    ps.setString(11, allocatedby);
                    ps.addBatch();
                    assigned++;
                }
                ps.executeBatch();
            }

            con.commit();
            result.put("success", true);
            result.put("assignedcount", assigned);
            result.put("message", assigned + " students assigned.");

        } catch (Exception e) {
            rollback(con);
            System.out.println("ERROR assignFeeStructure: " + e.getMessage());
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Assignment failed: " + e.getMessage());
        } finally {
            close(con);
        }
        return result;
    }

    // =========================================================
    // 6. GET BLOCKS (for dropdown)
    // =========================================================
    @SuppressWarnings("unchecked")
    public static JSONArray getBlocks() {
        JSONArray arr = new JSONArray();
        String sql = "SELECT blockid, blockname, blockno, no_of_floors "
                + "FROM hostel.hostel_blockmaster "
                + "ORDER BY CASE "
                + "  WHEN blockname='Special block' THEN 1 "
                + "  WHEN blockname='Common block'  THEN 2 "
                + "  WHEN blockname='A BLOCK'       THEN 3 "
                + "  WHEN blockname='LOHO2'         THEN 4 "
                + "  ELSE 5 END, blockno ASC";
        try (Connection con = new CyberCon().ErpConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                JSONObject o = new JSONObject();
                String name  = rs.getString("blockname");
                Integer bno  = (Integer) rs.getObject("blockno");
                String display = (bno != null) ? "Block : " + bno : name;
                o.put("blockid",   rs.getInt("blockid"));
                o.put("blockno",   bno != null ? bno : 0);
                o.put("blockname", display);
                arr.add(o);
            }
        } catch (Exception e) {
            System.out.println("ERROR getBlocks: " + e.getMessage());
            e.printStackTrace();
        }
        return arr;
    }

    // =========================================================
    // PRIVATE HELPERS
    // =========================================================
    private static String safe(String s) { return s != null ? s.trim() : ""; }
    private static String str(Object o)  { return o != null ? o.toString().trim() : ""; }
    private static int    toInt(Object o){ try{ return Integer.parseInt(str(o)); }catch(Exception e){ return 0; } }
    private static long   toLong(Object o){ try{ return Long.parseLong(str(o)); }catch(Exception e){ return 0L; } }
    private static java.math.BigDecimal bd(Object o){
        try{ return new java.math.BigDecimal(str(o)); }
        catch(Exception e){ return java.math.BigDecimal.ZERO; }
    }
    private static void rollback(Connection con){
        try{ if(con!=null) con.rollback(); }catch(Exception e){ e.printStackTrace(); }
    }
    private static void close(Connection con){
        try{ if(con!=null) con.close(); }catch(Exception e){ e.printStackTrace(); }
    }

    
    
    
    

    public static JSONObject getDashboardCounts() {

        JSONObject obj = new JSONObject();

        String totalSql
                = "SELECT COUNT(*) AS total "
                + "FROM hostel.mens_hostelregistration "
                + "WHERE ishostelfeespaid = 'Y'";

        String vegSql
                = "SELECT COUNT(*) AS veg "
                + "FROM hostel.mens_hostelregistration hr "
                + "JOIN hostel.hostelpersonaldetails hp ON hr.applicationno = hp.applicationno "
                + "WHERE hr.ishostelfeespaid = 'Y' AND hp.messid = 1";

        String nonVegSql
                = "SELECT COUNT(*) AS nonveg "
                + "FROM hostel.mens_hostelregistration hr "
                + "JOIN hostel.hostelpersonaldetails hp ON hr.applicationno = hp.applicationno "
                + "WHERE hr.ishostelfeespaid = 'Y' AND hp.messid = 2";

        String metroSql
                = "SELECT COUNT(*) AS metro "
                + "FROM hostel.mens_hostelregistration hr "
                + "JOIN hostel.hostelpersonaldetails hp ON hr.applicationno = hp.applicationno "
                + "WHERE hr.ishostelfeespaid = 'Y' AND hp.messid = 3";

        String rcSql
                = "SELECT COUNT(*) AS rc "
                + "FROM hostel.mens_hostelregistration hr "
                + "JOIN hostel.hostelpersonaldetails hp ON hr.applicationno = hp.applicationno "
                + "WHERE hr.ishostelfeespaid = 'Y' "
                + "AND LOWER(hp.religion) LIKE '%roman catholic%'";

        try (Connection con = new CyberCon().ErpConnection()) {

            // -------- TOTAL --------
            try (PreparedStatement ps = con.prepareStatement(totalSql); ResultSet rs = ps.executeQuery()) {

                System.out.println("\nTOTAL SQL: " + ps);

                if (rs.next()) {
                    System.out.println("\nTotal Fees paid Students: " + rs.getLong("total"));
                    obj.put("total", rs.getLong("total"));
                }
            }

            // -------- VEG --------
            try (PreparedStatement ps = con.prepareStatement(vegSql); ResultSet rs = ps.executeQuery()) {

                System.out.println("\nVEG SQL: " + ps);

                if (rs.next()) {
                    System.out.println("\nTotal Veg Mess Students: " + rs.getLong("veg"));
                    obj.put("veg", rs.getLong("veg"));
                }
            }

            // -------- NON VEG --------
            try (PreparedStatement ps = con.prepareStatement(nonVegSql); ResultSet rs = ps.executeQuery()) {

                System.out.println("\nNON VEG SQL: " + ps);

                if (rs.next()) {
                    System.out.println("\nTotal Non Veg Mess Students: " + rs.getLong("nonveg"));
                    obj.put("nonveg", rs.getLong("nonveg"));
                }
            }

            // -------- METRO --------
            try (PreparedStatement ps = con.prepareStatement(metroSql); ResultSet rs = ps.executeQuery()) {

                System.out.println("\nMETRO SQL: " + ps);

                if (rs.next()) {
                    System.out.println("\nTotal Metro Mess Students: " + rs.getLong("metro"));
                    obj.put("metro", rs.getLong("metro"));
                }
            }

            // -------- RC --------
            try (PreparedStatement ps = con.prepareStatement(rcSql); ResultSet rs = ps.executeQuery()) {

                System.out.println("\nRC SQL: " + ps);

                if (rs.next()) {
                    System.out.println("\nTotal Catholic Students: " + rs.getLong("rc"));
                    obj.put("rc", rs.getLong("rc"));
                }
            }

        } catch (Exception e) {

            System.out.println("\nCatch in HostelDashboardDAO.getDashboardCounts");
            e.printStackTrace();
        }

        return obj;
    }

    public static JSONArray getRegisteredStudentsdash() {

        JSONArray arr = new JSONArray();

        String sql
                = "SELECT hr.applicationno, hp.registerno, hp.studentname, hp.gender, hp.hostelno, "
                + "hp.studentmobilenumber, hp.religion, hm.mess_name "
                + "FROM hostel.mens_hostelregistration hr "
                + "JOIN hostel.hostelpersonaldetails hp ON hr.applicationno = hp.applicationno "
                + "LEFT JOIN hostel.hostel_messmaster hm ON hp.messid = hm.mess_id "
                + "WHERE hr.ishostelfeespaid = 'Y' "
                + "ORDER BY hp.studentname";

        try (Connection con = new CyberCon().ErpConnection(); 
                PreparedStatement ps = con.prepareStatement(sql); 
                ResultSet rs = ps.executeQuery()) {

            System.out.println("\nRegistered Students SQL: " + ps);

            while (rs.next()) {

                JSONObject obj = new JSONObject();

                obj.put("applicationno", rs.getString("applicationno"));
                obj.put("registerno", rs.getString("registerno"));
                obj.put("hostelno", rs.getString("hostelno"));
                obj.put("studentname", rs.getString("studentname"));
                obj.put("gender", rs.getString("gender"));
                obj.put("mobile", rs.getString("studentmobilenumber"));
                obj.put("religion", rs.getString("religion"));
                obj.put("mess", rs.getString("mess_name"));

                arr.add(obj);
            }

        } catch (Exception e) {

            System.out.println("\nCatch in getRegisteredStudents");
            e.printStackTrace();
        }

        return arr;
    }

    public static JSONArray getVegStudentsdash() {

        JSONArray arr = new JSONArray();

        String sql
                = "SELECT hr.applicationno, hp.registerno, hp.studentname, hp.gender, hp.hostelno, "
                + "hp.studentmobilenumber, hp.religion, hm.mess_name "
                + "FROM hostel.mens_hostelregistration hr "
                + "JOIN hostel.hostelpersonaldetails hp ON hr.applicationno = hp.applicationno "
                + "LEFT JOIN hostel.hostel_messmaster hm ON hp.messid = hm.mess_id "
                + "WHERE hr.ishostelfeespaid = 'Y' "
                + "AND hp.messid = 1 "
                + "ORDER BY hp.studentname";

        try (Connection con = new CyberCon().ErpConnection(); 
                PreparedStatement ps = con.prepareStatement(sql); 
                ResultSet rs = ps.executeQuery()) {

            System.out.println("\nVeg Students SQL: " + ps);

            while (rs.next()) {

                JSONObject obj = new JSONObject();

                obj.put("applicationno", rs.getString("applicationno"));
                obj.put("registerno", rs.getString("registerno"));
                obj.put("hostelno", rs.getString("hostelno"));
                obj.put("studentname", rs.getString("studentname"));
                obj.put("gender", rs.getString("gender"));
                obj.put("mobile", rs.getString("studentmobilenumber"));
                obj.put("religion", rs.getString("religion"));
                obj.put("mess", rs.getString("mess_name"));

                arr.add(obj);
            }

        } catch (Exception e) {

            System.out.println("\nCatch in getVegStudents");
            e.printStackTrace();
        }

        return arr;
    }

    public static JSONArray getNonVegStudents() {

        JSONArray arr = new JSONArray();

        String sql
                = "SELECT hr.applicationno, hp.registerno, hp.studentname, hp.gender, hp.hostelno, "
                + "hp.studentmobilenumber, hp.religion, hm.mess_name "
                + "FROM hostel.mens_hostelregistration hr "
                + "JOIN hostel.hostelpersonaldetails hp ON hr.applicationno = hp.applicationno "
                + "LEFT JOIN hostel.hostel_messmaster hm ON hp.messid = hm.mess_id "
                + "WHERE hr.ishostelfeespaid = 'Y' "
                + "AND hp.messid = 2 "
                + "ORDER BY hp.studentname";

        try (Connection con = new CyberCon().ErpConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            System.out.println("\nNon-Veg Students SQL: " + ps);

            while (rs.next()) {

                JSONObject obj = new JSONObject();

                obj.put("applicationno", rs.getString("applicationno"));
                obj.put("registerno", rs.getString("registerno"));
                obj.put("hostelno", rs.getString("hostelno"));
                obj.put("studentname", rs.getString("studentname"));
                obj.put("gender", rs.getString("gender"));
                obj.put("mobile", rs.getString("studentmobilenumber"));
                obj.put("religion", rs.getString("religion"));
                obj.put("mess", rs.getString("mess_name"));

                arr.add(obj);
            }

        } catch (Exception e) {

            System.out.println("\nCatch in getNonVegStudents");
            e.printStackTrace();
        }

        return arr;
    }

    public static JSONArray getMetroStudents() {

        JSONArray arr = new JSONArray();

        String sql
                = "SELECT hr.applicationno, hp.registerno, hp.studentname, hp.gender, hp.hostelno, "
                + "hp.studentmobilenumber, hp.religion, hm.mess_name "
                + "FROM hostel.mens_hostelregistration hr "
                + "JOIN hostel.hostelpersonaldetails hp ON hr.applicationno = hp.applicationno "
                + "LEFT JOIN hostel.hostel_messmaster hm ON hp.messid = hm.mess_id "
                + "WHERE hr.ishostelfeespaid = 'Y' "
                + "AND hp.messid = 3 "
                + "ORDER BY hp.studentname";

        try (Connection con = new CyberCon().ErpConnection(); 
                PreparedStatement ps = con.prepareStatement(sql); 
                ResultSet rs = ps.executeQuery()) {

            System.out.println("\nMetro Students SQL: " + ps);

            while (rs.next()) {

                JSONObject obj = new JSONObject();

                obj.put("applicationno", rs.getString("applicationno"));
                obj.put("registerno", rs.getString("registerno"));
                obj.put("hostelno", rs.getString("hostelno"));
                obj.put("studentname", rs.getString("studentname"));
                obj.put("gender", rs.getString("gender"));
                obj.put("mobile", rs.getString("studentmobilenumber"));
                obj.put("religion", rs.getString("religion"));
                obj.put("mess", rs.getString("mess_name"));

                arr.add(obj);
            }

        } catch (Exception e) {

            System.out.println("\nCatch in getMetroStudents");
            e.printStackTrace();
        }

        return arr;
    }

    public static JSONArray getRCStudents() {

        JSONArray arr = new JSONArray();

        String sql
                = "SELECT hr.applicationno, hp.registerno, hp.studentname, hp.gender, hp.hostelno, "
                + "hp.studentmobilenumber, hp.religion, hm.mess_name "
                + "FROM hostel.mens_hostelregistration hr "
                + "JOIN hostel.hostelpersonaldetails hp ON hr.applicationno = hp.applicationno "
                + "LEFT JOIN hostel.hostel_messmaster hm ON hp.messid = hm.mess_id "
                + "WHERE hr.ishostelfeespaid = 'Y' "
                + "AND LOWER(hp.religion) LIKE '%roman catholic%' "
                + "ORDER BY hp.studentname";

        try (Connection con = new CyberCon().ErpConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            System.out.println("\nRC Students SQL: " + ps);

            while (rs.next()) {

                JSONObject obj = new JSONObject();

                obj.put("applicationno", rs.getString("applicationno"));
                obj.put("registerno", rs.getString("registerno"));
                obj.put("hostelno", rs.getString("hostelno"));
                obj.put("studentname", rs.getString("studentname"));
                obj.put("gender", rs.getString("gender"));
                obj.put("mobile", rs.getString("studentmobilenumber"));
                obj.put("religion", rs.getString("religion"));
                obj.put("mess", rs.getString("mess_name"));

                arr.add(obj);
            }

        } catch (Exception e) {

            System.out.println("\nCatch in getRCStudents");
            e.printStackTrace();
        }

        return arr;
    }

    private static String nullToEmpty(String s) {
        return s != null ? s.trim() : "";
    }

    private static String formatDate(java.sql.Date date) {
        if (date == null) {
            return "";
        }
        return new SimpleDateFormat("dd-MM-yyyy").format(date);
    }

    private static String formatDateTime(java.sql.Timestamp timestamp) {
        if (timestamp == null) {
            return "";
        }
        return new SimpleDateFormat("dd-MM-yyyy HH:mm:ss").format(timestamp);
    }

    public static String getFullHostelStudentProfile(String userid) {
        System.out.println("Register NO: " + userid);
        JSONObject result = new JSONObject();
//        if (userid == null || userid.trim().isEmpty()) {
//            result.put("error", "Invalid session");
//            return result.toJSONString();
//        }

        String sql = """
SELECT
    hr.applicationno,
    hr.registerno,
    hr.institutionid,
    hp.village,
    hp.town,
    hp.maxmark,
    hp.fatheroccupationid,
    hp.motheroccupationid,
    hp.prem_distid,
    hp.hostelno,
    sm.differentlyabledtypeid,
                     
    -- ✅ REGISTRATION
    hr.registereddate,
    hp.selecteddatetime,
    
    -- ✅ ROOM
    hp.isroomallocated,
    rm.roomname,
    
    -- ✅ MESS
    hp.ismessallocated,
    hm.mess_name,

    -- NAME
    COALESCE(sm.studentname, hp.studentname) AS studentname,

    -- DOB
    COALESCE(sm.dob, hp.dateofbirth) AS dob,

    -- GENDER
    COALESCE(g.gender, hp.gender, '') AS gender_name,

    -- MOBILE ( keep alias consistent with DAO)
    COALESCE(sd.studentmobilenumber, hp.studentmobilenumber) AS studentmobilenumber,

    -- EMAIL
    COALESCE(sd.studentemail, hp.studentemailid) AS studentemail,

    -- COLLEGE
    COALESCE(o.officename, hp.college) AS office_name,

    -- OFFICE ID
    sm.officeid AS officeid,

    -- COURSE
    COALESCE(c.description, hp.studentprogram) AS course_description,
    
    hp.permstate,
                                     
    -- DISTRICT
    COALESCE(dl.distname, dl2.distname) AS district_name,
    dl3.distname AS prem_district,

    -- DISTRICT ID
    COALESCE(sd.distid, hp.distid) AS distid,

    -- STATE
    COALESCE(st.statename, hp.state) AS state_name,
    COALESCE(st.stateid, st2.stateid) AS stateid,
    
    COALESCE(sd.mothertongueid, lang2.langid) AS mothertongueid,
    COALESCE(sd.religionid, r2.religionid) AS religionid,
    COALESCE(r1.religion, r2.religion, hp.religion) AS religion,
              
    COALESCE(sd.categoryid, cat2.categoryid) AS categoryid,
    COALESCE(cat1.category, cat2.category, hp.category) AS category,              
                     
    COALESCE(sd.casteid::text, hp.casteid) AS casteid,

    -- ✅ BLOOD GROUP
    COALESCE(bg.bloodgroup, hp.bloodgroup) AS bloodgroup,
    COALESCE(sd.bloodgroupid, hp.bloodgroupid) AS bloodgroupid,

    -- ✅ MOTHER TONGUE
    COALESCE(lang1.lang, lang2.lang, hp.mothertongue) AS mothertongue,

    -- ✅ PARENTS
    COALESCE(sd.fathername, hp.fathername) AS fathername,
    COALESCE(sd.mothername, hp.mothername) AS mothername,

    COALESCE(sd.fathereducation, hp.fathereducation) AS fathereducation,
    COALESCE(sd.mothereducation, hp.mothereducation) AS mothereducation,

    COALESCE(sd.occupation, hp.fatheroccupation) AS father_occupation,
    COALESCE(sd.motheroccupation, hp.motheroccupation) AS motheroccupation,

    COALESCE(sd.annualincome, hp.fatherannualincome) AS father_income,
    COALESCE(sd.motherannualincome, hp.motherannualincome) AS motherannualincome,

    -- ✅ ACADEMIC
    COALESCE(sd.school_name_12, hp.nameofschool) AS school_name_12,
    COALESCE(sd.overall_obtain, hp.marksplustwo) AS overall_obtain,

    -- ✅ ADDRESS
    COALESCE(
        sd.address,
        CONCAT_WS(',', hp.premadd1, hp.premadd2, hp.premadd3)
    ) AS address,

    COALESCE(sd.pincode, hp.pincode) AS pincode,
    COALESCE(hp.studentphoto, '') AS studentphoto,

    -- ✅ CONTACT
    COALESCE(sd.parentmobilenumber, hp.parentmobile) AS parentmobilenumber,
    COALESCE(sd.parentemail, hp.parentemail) AS parentemail,

    -- ✅ GUARDIAN
    gd.guardianrelation AS guardianname,
    gd.guardline1,
    gd.guardline2,
    gd.guardline3,
    gd.distid AS guard_distid,
    gd.pincode AS guard_pincode,
    gd.guardianmobile,
    gd.guardianemail,
    gd.guardstate,
    gd.guarddist,

    -- ✅ INSTITUTION
    ins.institutename

FROM hostel.mens_hostelregistration hr

-- STUDENT MASTER
LEFT JOIN lccerp.student_studentmaster sm
    ON sm.registerno = hr.registerno 
    AND sm.activestatus = 1

LEFT JOIN lccerp.student_studentmasterdetails sd
    ON sd.studentid = sm.studentid

-- PERSONAL DETAILS
LEFT JOIN hostel.hostelpersonaldetails hp
    ON hp.registerno = hr.registerno
                     
LEFT JOIN lccerp.state st2 ON st2.statename = hp.state
                     
-- ✅ LOOKUPS
LEFT JOIN lccerp.gender g 
    ON g.genderid = sm.sex

LEFT JOIN lccerp.religion r1 
    ON r1.religionid = sd.religionid

LEFT JOIN lccerp.religion r2 
    ON LOWER(TRIM(r2.religion)) = LOWER(TRIM(hp.religion))

LEFT JOIN lccerp.category cat1 
    ON cat1.categoryid = sd.categoryid

LEFT JOIN lccerp.category cat2 
    ON LOWER(TRIM(cat2.category)) = LOWER(TRIM(hp.category))

LEFT JOIN lccerp.bloodgroup bg 
    ON bg.bloodgroupid = sd.bloodgroupid 

LEFT JOIN lccerp.languages lang1 
    ON lang1.langid = sd.mothertongueid

LEFT JOIN lccerp.languages lang2 
    ON LOWER(TRIM(lang2.lang)) = LOWER(TRIM(hp.mothertongue))

-- ✅ DISTRICT
LEFT JOIN lccerp.distlist dl 
    ON dl.distid = sd.distid

LEFT JOIN lccerp.distlist dl2 
    ON dl2.distid = hp.distid
                     
LEFT JOIN lccerp.distlist dl3 
    ON dl3.distid = hp.prem_distid

-- ✅ STATE
LEFT JOIN lccerp.state st 
    ON st.stateid = dl.stateid

-- ✅ COURSE / OFFICE
LEFT JOIN lccerp.courses c 
    ON c.courseid = sm.courseid

LEFT JOIN lccerp.officemaster o 
    ON o.officeid = sm.officeid

-- ✅ GUARDIAN
LEFT JOIN hostel.guardiandetails gd 
    ON gd.registerno = hr.registerno

-- ✅ INSTITUTION
LEFT JOIN lccerp.institution ins 
    ON ins.institutionid = hr.institutionid
                     
-- ROOM
LEFT JOIN hostel.room_master rm
    ON rm.roomid = hp.roomid

-- MESS
LEFT JOIN hostel.hostel_messmaster hm
    ON hm.mess_id = hp.messid

WHERE hr.registerno = ?
""";

        try (Connection conn = new CyberCon().ErpConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            System.out.println("Fetch details DAO " + userid);
            ps.setString(1, userid);
            //ps.setInt(2, 1); // or pass academicyearid dynamically
            try (ResultSet rs = ps.executeQuery()) {
                System.out.println("\n\n" + rs);
                if (!rs.next()) {
                    result.put("error", "No hostel registration found.");
                    return result.toJSONString();
                }

                // === BASIC INFO ===
                result.put("studentphoto", nullToEmpty(rs.getString("studentphoto")));
                //Photo
                result.put("applicationno", nullToEmpty(rs.getString("applicationno")));
                result.put("regno", nullToEmpty(rs.getString("registerno")));
                result.put("hostelno",nullToEmpty(rs.getString("hostelno")));
                result.put("name", nullToEmpty(rs.getString("studentname")));
                result.put("institution", nullToEmpty(rs.getString("institutename")));
                result.put("officeid", rs.getObject("officeid"));
                result.put("stateid", rs.getObject("stateid"));
                result.put("dob", formatDate(rs.getDate("dob")));
                result.put("gender", nullToEmpty(rs.getString("gender_name")));
                result.put("mobile", nullToEmpty(rs.getString("studentmobilenumber")));
                result.put("email", nullToEmpty(rs.getString("studentemail")));

                // === COURSE & COLLEGE ===
                result.put("course_description", nullToEmpty(rs.getString("course_description")));
                result.put("office_name", nullToEmpty(rs.getString("office_name")));

                // === STATE & DISTRICT ===
                result.put("statename", nullToEmpty(rs.getString("state_name")));
                result.put("district", nullToEmpty(rs.getString("district_name")));
                result.put("districtid", rs.getObject("distid"));

                result.put("village", nullToEmpty(rs.getString("village")));
                result.put("town", nullToEmpty(rs.getString("town")));

                // === MASTER DATA ===
                //result.put("batch", nullToEmpty(rs.getString("batch")));
                result.put("differentlyabled",
                        rs.getInt("differentlyabledtypeid") > 0 ? "Yes" : "No");

                // === PARENTS & FAMILY ===
                result.put("fathername", nullToEmpty(rs.getString("fathername")));
                result.put("mothername", nullToEmpty(rs.getString("mothername")));
                result.put("guardianname", nullToEmpty(rs.getString("guardianname")));
                result.put("father_occupation", nullToEmpty(rs.getString("father_occupation")));
                result.put("mother_occupation", nullToEmpty(rs.getString("motheroccupation")));
                result.put("fatheroccupationid", rs.getObject("fatheroccupationid"));
                result.put("motheroccupationid", rs.getObject("motheroccupationid"));
                result.put("father_income", rs.getObject("father_income") != null ? rs.getString("father_income") : "0");
                result.put("mother_income", rs.getObject("motherannualincome") != null ? rs.getString("motherannualincome") : "0");
                result.put("father_education", nullToEmpty(rs.getString("fathereducation")));
                result.put("mother_education", nullToEmpty(rs.getString("mothereducation")));

                // === ACADEMIC - PRIORITIZE SAVED VALUES ===
                result.put("school", nullToEmpty(rs.getString("school_name_12")));
                result.put("mark_200", nullToEmpty(rs.getString("overall_obtain")));
                result.put("mark_100", nullToEmpty(rs.getString("maxmark")));
                // === CONTACT ===
                result.put("parent_mobile", nullToEmpty(rs.getString("parentmobilenumber")));
                result.put("parent_email", nullToEmpty(rs.getString("parentemail")));

                // === LOOKUP VALUES ===
                result.put("bloodgroup", nullToEmpty(rs.getString("bloodgroup")));
                result.put("bloodgroupid", rs.getObject("bloodgroupid"));
                result.put("mothertongueid", rs.getObject("mothertongueid"));
                result.put("mothertongue", nullToEmpty(rs.getString("mothertongue")));
                result.put("religion", nullToEmpty(rs.getString("religion")));
                result.put("community", nullToEmpty(rs.getString("category")));
//                result.put("caste", nullToEmpty(rs.getString("castename")));
//                String castename = nullToEmpty(rs.getString("castename"));
//                System.out.println("Caste Name: " + castename);
                result.put("caste", rs.getObject("casteid"));
                result.put("religionid", rs.getObject("religionid"));
                result.put("communityid", rs.getObject("categoryid"));

                // === ADDRESS SPLIT (Permanent) ===
                String fullAddr = nullToEmpty(rs.getString("address"));
                //String[] lines = fullAddr.split(",", 4);
                String[] lines = fullAddr.isEmpty() ? new String[0] : fullAddr.split(",", 4);
                result.put("address_line1", lines.length > 0 ? lines[0].trim() : "");
                result.put("address_line2", lines.length > 1 ? lines[1].trim() : "");
                result.put("address_line3", lines.length > 2 ? lines[2].trim() : "");
                result.put("permState", nullToEmpty(rs.getString("permstate")));
                result.put("prem_distid", rs.getObject("prem_distid"));
                result.put("prem_district", rs.getString("prem_district"));
                result.put("pincode", nullToEmpty(rs.getString("pincode")));

                // === GUARDIAN SAVED VALUES (Highest Priority) ===
                result.put("guardianName", nullToEmpty(rs.getString("guardianname")));
                //result.put("guardian_relation", nullToEmpty(rs.getString("guardian_relation")));
                result.put("guard_address_line1", nullToEmpty(rs.getString("guardline1")));
                result.put("guard_address_line2", nullToEmpty(rs.getString("guardline2")));
                result.put("guard_address_line3", nullToEmpty(rs.getString("guardline3")));
                result.put("guardState", nullToEmpty(rs.getString("guardstate")));
                result.put("guarddistrict", nullToEmpty(rs.getString("guarddist")));
                result.put("guarddistid", rs.getObject("guard_distid"));
                result.put("guard_pincode", nullToEmpty(rs.getString("guard_pincode")));
                result.put("guardian_mobile", nullToEmpty(rs.getString("guardianmobile")));
                result.put("guardian_email", nullToEmpty(rs.getString("guardianemail")));
                // === REGISTRATION ===
                result.put("applied_on", formatDateTime(rs.getTimestamp("registereddate")));
                result.put("selected_datetime", formatDateTime(rs.getTimestamp("selecteddatetime")));

                // === ROOM ===
                result.put("room_allocated", "Y".equals(rs.getString("isroomallocated")) ? "Yes" : "No");
                result.put("room_no", nullToEmpty(rs.getString("roomname")));

                // === MESS ===
                result.put("mess_allocated", "Y".equals(rs.getString("ismessallocated")) ? "Yes" : "No");
                result.put("mess_name", nullToEmpty(rs.getString("mess_name")));
                // === AGE CALCULATION ===
                String dobStr = result.get("dob").toString();
                if (dobStr.matches("^\\d{2}-\\d{2}-\\d{4}$")) {
                    String[] p = dobStr.split("-");
                    int day = Integer.parseInt(p[0]);
                    int month = Integer.parseInt(p[1]);
                    int year = Integer.parseInt(p[2]);
                    java.util.Calendar dobCal = java.util.Calendar.getInstance();
                    dobCal.set(year, month - 1, day);
                    java.util.Calendar todayCal = java.util.Calendar.getInstance();
                    int years = todayCal.get(java.util.Calendar.YEAR) - dobCal.get(java.util.Calendar.YEAR);
                    int months = todayCal.get(java.util.Calendar.MONTH) - dobCal.get(java.util.Calendar.MONTH);
                    int daysDiff = todayCal.get(java.util.Calendar.DAY_OF_MONTH) - dobCal.get(java.util.Calendar.DAY_OF_MONTH);
                    if (daysDiff < 0) {
                        months--;
                        java.util.Calendar lastMonth = (java.util.Calendar) todayCal.clone();
                        lastMonth.add(java.util.Calendar.MONTH, -1);
                        daysDiff += lastMonth.getActualMaximum(java.util.Calendar.DAY_OF_MONTH);
                    }
                    if (months < 0) {
                        years--;
                        months += 12;
                    }
                    result.put("age", years + " Years " + months + " Months");
                } else {
                    result.put("age", "");
                }
            }
        } catch (Exception e) {
            result.put("error", "Connection not established: " + e.getMessage());
            e.printStackTrace();
        }
        return result.toJSONString();
    }
}
