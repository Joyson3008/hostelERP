/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Dao.ERPHostel;

import java.sql.*;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import Dbs.Connect.CyberCon;

/**
 *
 * @author lccerp26
 */
public class ERPHostelRoomDAO {

 public static String getBlocks() {

    JSONArray arr = new JSONArray();

    try (Connection con = new CyberCon().ErpConnection()) {

     String sql =
        "SELECT "
        + "    blockid, "
        + "    blockname, "
        + "    blockno, "
        + "    no_of_floors "
        + "FROM hostel.hostel_blockmaster "

        + "WHERE blockid IN "
        + "(3,4,5,6,7,8,9,11,12,13,14,15,17,18,19,20,21,22) "

        + "ORDER BY "
        + "    CASE "
        + "        WHEN blockname = 'Special block' THEN 1 "
        + "        WHEN blockname = 'Common block' THEN 2 "
        + "        WHEN blockname = 'A BLOCK' THEN 3 "
        + "        WHEN blockname = 'LOHO2' THEN 4 "
        + "        ELSE 5 "
        + "    END, "

        + "    blockno ASC";
        try (PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                JSONObject obj = new JSONObject();

                obj.put("blockid", rs.getInt("blockid"));

                // =========================================
                // BLOCK DISPLAY FORMAT
                // =========================================

                String blockName = rs.getString("blockname");
                Integer blockNo = (Integer) rs.getObject("blockno");

                String displayName = "";

                // =========================================
                // COMMON / SPECIAL BLOCKS
                // =========================================

             if (blockNo != null) {

    displayName =
            "Block : " + blockNo;

} else {

    displayName = blockName;
}

                obj.put("blockname", displayName);

                obj.put("no_of_floors", rs.getInt("no_of_floors"));

                arr.add(obj);
            }
        }

    } catch (Exception e) {

        System.out.println("\n\nCatch in ERPHostelRoomDAO.getBlocks\n\n");
        e.printStackTrace();
    }

    return arr.toJSONString();
}

    public static String insertBlock(String blockname, int floors, String user, String ip) {

        JSONObject res = new JSONObject();
        System.out.println("\nBlock Name: " + blockname + "\nNo of Floors: " + floors + "\nUser :" + user + "\nIp" + ip);

        try (Connection con = new CyberCon().ErpConnection()) {

            String sql = "INSERT INTO hostel.hostel_blockmaster (blockname, no_of_floors, createdat, createdby, createdby_ip) VALUES (?, ?, NOW(), ?, ?)";

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, blockname);
                ps.setInt(2, floors);
                ps.setString(3, user);
                ps.setString(4, ip);

                System.out.println("\n\nINSERT BLOCK: " + ps);

                int rows = ps.executeUpdate();

                if (rows > 0) {

                    insertFloors(con, blockname, floors, user, ip);

                    res.put("success", true);
                } else {
                    res.put("success", false);
                    res.put("error", "Insert Failed");
                }

            }

        } catch (Exception e) {

            System.out.println("\n\n Catch in ERPHostelRoomDAO.insertBlock\n\n" + e);
            res.put("success", false);
            res.put("error", e.getMessage());
        }

        return res.toJSONString();
    }

    // INSERT FLOORS
    private static void insertFloors(Connection con, String blockname, int floors, String user, String ip) {

        try {

            String blockIdQuery = "SELECT currval('hostel.hostel_blockmaster_blockid_seq')";
            int blockid = 0;

            try (PreparedStatement ps = con.prepareStatement(blockIdQuery); ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    blockid = rs.getInt(1);
                }
            }

            String sql = "INSERT INTO hostel.hostel_floormaster (blockid, floorname, createdat, createdby, createdby_ip) VALUES (?, ?, NOW(), ?, ?)";

            for (int i = 1; i <= floors; i++) {

                try (PreparedStatement ps = con.prepareStatement(sql)) {

                    ps.setInt(1, blockid);
                    ps.setString(2, blockname + " Floor " + i);
                    ps.setString(3, user);
                    ps.setString(4, ip);

                    ps.executeUpdate();
                }
            }

        } catch (Exception e) {
            System.out.println("\n\nCatch in ERPHostelRoomDAO.insertFloors\n\n" + e);
        }
    }
public static String getFloorsByBlock(int blockid) {

    JSONArray arr = new JSONArray();

    try (Connection con = new CyberCon().ErpConnection()) {

        String sql =
                "SELECT "
                + "    f.floorid, "
                + "    f.floorname "
                + "FROM hostel.hostel_floormaster f "
                + "WHERE f.blockid = ? "
                + "ORDER BY f.floorid ASC";

        try (PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, blockid);

            System.out.println("\n\ngetFloorsByBlock Query : " + ps);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    JSONObject obj = new JSONObject();

                    obj.put("floorid", rs.getInt("floorid"));

                    // =========================================
                    // FLOOR NAME
                    // =========================================

                    String floorName = rs.getString("floorname");

                    obj.put("floorname", floorName);

                    arr.add(obj);
                }
            }
        }

    } catch (Exception e) {

        System.out.println("\n\nCatch in RoomDAO.getFloorsByBlock\n\n");
        e.printStackTrace();
    }

    return arr.toJSONString();
}
    public static String insertRooms(int blockid, int floorid, int roomCount, int maxOccupants, String user, String ip) {

        JSONObject res = new JSONObject();

        try (Connection con = new CyberCon().ErpConnection()) {

            con.setAutoCommit(false);

            int start = 1;

            // 🔹 Step 1: Get last room number
            String maxSql = "SELECT MAX(CAST(roomname AS INTEGER)) AS maxroom FROM hostel.room_master";

            try (PreparedStatement ps = con.prepareStatement(maxSql)) {

                System.out.println("\n\nFetching last room number: " + ps);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next() && rs.getString("maxroom") != null) {

                        String maxRoom = rs.getString("maxroom"); // e.g. "003"

                        try {
                            start = Integer.parseInt(maxRoom) + 1;
                        } catch (Exception e) {
                            start = 1;
                        }
                    }
                }
            }

            System.out.println("Starting room number from: " + start);

            // 🔹 Step 2: Insert rooms
            String sql = "INSERT INTO hostel.room_master "
                    + "(blockid, floorid, roomname, max_noofoccupants, no_of_occupants, facility_assets, createdby, createdby_ip) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                for (int i = 0; i < roomCount; i++) {

                    String roomName = String.format("%03d", (start + i));

                    ps.setInt(1, blockid);
                    ps.setInt(2, floorid);
                    ps.setString(3, roomName);
                    ps.setInt(4, maxOccupants); // default capacity
                    ps.setInt(5, 0); // occupants
                    ps.setString(6, "");
                    ps.setString(7, user);
                    ps.setString(8, ip);

                    System.out.println("INSERT ROOM: " + ps);

                    ps.addBatch();
                }

                ps.executeBatch();
            }

            con.commit();

            res.put("success", true);

        } catch (Exception e) {

            System.out.println("\n\nRoomDAO.insertRooms ERROR\n\n");
            e.printStackTrace();

            res.put("success", false);
            res.put("error", e.getMessage());
        }

        return res.toJSONString();
    }

    public static String getRooms(int blockid, int floorid) {

        JSONArray arr = new JSONArray();

        try (Connection con = new CyberCon().ErpConnection()) {

            String sql = "SELECT rm.roomid, rm.roomname, rm.max_noofoccupants, rm.no_of_occupants, rm.facility_assets, "
                    + "bm.blockname, f.floorname "
                    + "FROM hostel.room_master rm "
                    + "JOIN hostel.hostel_blockmaster bm ON rm.blockid = bm.blockid "
                    + "JOIN hostel.hostel_floormaster f ON rm.floorid = f.floorid "
                    + "WHERE rm.blockid = ? ";
            if (floorid != 0) {
                sql += " AND rm.floorid = ? ";
            }

            sql += " ORDER BY rm.roomid";

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, blockid);
                if (floorid != 0) {
                    ps.setInt(2, floorid);
                }

                System.out.println("\n\ngetRooms Query: " + ps);

                try (ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {

                        JSONObject obj = new JSONObject();

                        obj.put("roomid", rs.getInt("roomid"));
                        obj.put("roomname", rs.getString("roomname"));
                        obj.put("max_noofoccupants", rs.getInt("max_noofoccupants"));
                        obj.put("no_of_occupants", rs.getInt("no_of_occupants"));
                        obj.put("facility_assets", rs.getString("facility_assets"));

                        // NEW FIELDS
                        obj.put("blockname", rs.getString("blockname"));
                        obj.put("floorname", rs.getString("floorname"));

                        arr.add(obj);
                    }
                }
            }

        } catch (Exception e) {

            System.out.println("\n\nCatch in RoomDAO.getRooms\n\n" + e);
            e.printStackTrace();
        }

        return arr.toJSONString();
    }

    //Update Room method
    public static String updateRoom(int roomid, int capacity, String assets, String user, String ip) {

        JSONObject res = new JSONObject();

        System.out.println("\n\nUPDATE ROOM INPUT");
        System.out.println("roomid: " + roomid);
        System.out.println("capacity: " + capacity);
        System.out.println("assets: " + assets);
        System.out.println("user: " + user);
        System.out.println("ip: " + ip);

        try (Connection con = new CyberCon().ErpConnection()) {

            String sql = "UPDATE hostel.room_master "
                    + "SET max_noofoccupants = ?, "
                    + "facility_assets = ?, "
                    + "updatedby = ?, "
                    + "updatedip = ?, "
                    + "updateddate = CURRENT_TIMESTAMP "
                    + "WHERE roomid = ?";

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, capacity);

                // ✅ HANDLE NULL / EMPTY FOR ASSETS
                if (assets == null || assets.trim().equals("")) {
                    ps.setNull(2, Types.VARCHAR);
                } else {
                    ps.setString(2, assets.trim());
                }

                // USER
                if (user == null || user.trim().equals("")) {
                    ps.setNull(3, Types.VARCHAR);
                } else {
                    ps.setString(3, user.trim());
                }

                // IP
                if (ip == null || ip.trim().equals("")) {
                    ps.setNull(4, Types.VARCHAR);
                } else {
                    ps.setString(4, ip.trim());
                }
                ps.setInt(5, roomid);

                System.out.println("\n\nUPDATE ROOM QUERY:\n" + ps);

                int rows = ps.executeUpdate();

                res.put("success", rows > 0);

                if (rows == 0) {
                    res.put("error", "No rows updated");
                }

            }

        } catch (Exception e) {

            System.out.println("\n\nCatch in updateRoom\n\n");
            e.printStackTrace();

            res.put("success", false);
            res.put("error", e.getMessage());
        }

        return res.toJSONString();
    }

    public static String getAssets() {

        JSONArray arr = new JSONArray();

        try (Connection con = new CyberCon().ErpConnection()) {

            String sql = "SELECT asset_id, asset_name, asset_short_name "
                    + "FROM hostel.asset_master WHERE status='A' ORDER BY asset_name";

            try (PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    JSONObject obj = new JSONObject();
                    obj.put("asset_id", rs.getInt("asset_id"));
                    obj.put("asset_name", rs.getString("asset_name"));
                    obj.put("asset_short_name", rs.getString("asset_short_name"));

                    arr.add(obj);
                }
            }

        } catch (Exception e) {
            System.out.println("\n\nRoomDAO.getAssets ERROR\n\n" + e);
        }

        return arr.toJSONString();
    }

    //Mess Master- Mess Related Methods
    public static JSONArray getMessList() {

        JSONArray arr = new JSONArray();

        try (Connection con = new CyberCon().ErpConnection()) {

            String sql = "SELECT mess_id, mess_name, mess_short_name FROM hostel.hostel_messmaster ORDER BY mess_id ASC";

            try (PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

                System.out.println("\n\ngetMessList: " + ps);

                while (rs.next()) {

                    JSONObject obj = new JSONObject();

                    obj.put("mess_id", rs.getString("mess_id"));
                    obj.put("mess_name", rs.getString("mess_name"));
                    obj.put("mess_short_name", rs.getString("mess_short_name"));

                    arr.add(obj);
                }
            }

        } catch (Exception e) {

            System.out.println("Catch in getMessList:");
            e.printStackTrace();
        }

        return arr;
    }

    // =================MESS INSERT =================
    public static String insertMess(String name, String shortName, String createdBy, String ip) {

        JSONObject res = new JSONObject();

        try (Connection con = new CyberCon().ErpConnection()) {

            // ===== DUPLICATE CHECK =====
            String checkSql = "SELECT COUNT(*) FROM hostel.hostel_messmaster WHERE LOWER(mess_name)=LOWER(?)";

            try (PreparedStatement ps = con.prepareStatement(checkSql)) {

                ps.setString(1, name);

                System.out.println("\n\nDuplicate Check (insertMess): " + ps);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next() && rs.getInt(1) > 0) {

                        res.put("success", false);
                        res.put("error", "Mess name already exists");

                        return res.toJSONString();
                    }
                }
            }

            // ===== INSERT =====
            String sql = "INSERT INTO hostel.hostel_messmaster (mess_name, mess_short_name, createdby, createdby_ip) VALUES (?, ?, ?, ?)";

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, name);
                ps.setString(2, shortName);
                ps.setString(3, createdBy);
                ps.setString(4, ip);

                System.out.println("\n\ninsertMess: " + ps);

                int rows = ps.executeUpdate();

                res.put("success", rows > 0);

                if (rows == 0) {
                    res.put("error", "Insert failed");
                }
            }

        } catch (Exception e) {

            System.out.println("Catch in insertMess:");
            e.printStackTrace();

            res.put("success", false);
            res.put("error", e.getMessage());
        }

        return res.toJSONString();
    }

    // ================= MESS UPDATE =================
    public static String updateMess(int id, String name, String shortName) {

        JSONObject res = new JSONObject();

        try (Connection con = new CyberCon().ErpConnection()) {

            String sql = "UPDATE hostel.hostel_messmaster SET mess_name=?, mess_short_name=? WHERE mess_id=?";

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, name);
                ps.setString(2, shortName);
                ps.setInt(3, id);

                System.out.println("\n\nupdateMess: " + ps);

                int rows = ps.executeUpdate();

                res.put("success", rows > 0);
            }

        } catch (Exception e) {

            System.out.println("catch in updateMess:");
            e.printStackTrace();

            res.put("success", false);
            res.put("error", e.getMessage());
        }

        return res.toJSONString();
    }

    // =================MESS DELETE =================
    public static String deleteMess(int id) {

        JSONObject res = new JSONObject();

        try (Connection con = new CyberCon().ErpConnection()) {

            String sql = "DELETE FROM hostel.hostel_messmaster WHERE mess_id=?";

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, id);

                System.out.println("\n\ndeleteMess: " + ps);

                int rows = ps.executeUpdate();

                res.put("success", rows > 0);
            }

        } catch (Exception e) {

            System.out.println("catch in deleteMess:");
            e.printStackTrace();

            res.put("success", false);
            res.put("error", e.getMessage());
        }

        return res.toJSONString();
    }
public static JSONArray getAvailableRooms(
        int blockid,
        int floorid) {

    JSONArray arr = new JSONArray();

    try (Connection con =
            new CyberCon().ErpConnection()) {

        String roomBlockName = "";
        String floorKeyword = "";

        // =====================================
        // GET BLOCK + FLOOR INFO
        // =====================================

        String infoSql =
                "SELECT "
                + "b.blockname, "
                + "b.blockno, "
                + "f.floorname "
                + "FROM hostel.hostel_floormaster f "
                + "JOIN hostel.hostel_blockmaster b "
                + "ON f.blockid = b.blockid "
                + "WHERE f.floorid = ?";

        try (PreparedStatement ps =
                con.prepareStatement(infoSql)) {

            ps.setInt(1, floorid);

            try (ResultSet rs =
                    ps.executeQuery()) {

                if (rs.next()) {

                    String blockName =
                            rs.getString("blockname");

                    Integer blockNo =
                            (Integer) rs.getObject(
                                    "blockno");

                    String floorName =
                            rs.getString("floorname");

                    // =========================
                    // BLOCK MAPPING
                    // =========================

                    if (blockName.equalsIgnoreCase(
                            "Special block")
                            || blockName.equalsIgnoreCase(
                                    "Common block")) {

                        roomBlockName =
                                "Block : " + blockNo;

                    } else if (blockName.equalsIgnoreCase(
                            "LOHO2")) {

                        roomBlockName = "LOHO-2";

                    } else {

                        roomBlockName = blockName;
                    }

                    // =========================
                    // FLOOR MAPPING
                    // =========================

                    if (floorName.toLowerCase()
                            .contains("ground")) {

                        floorKeyword = "GROUND";

                    } else if (floorName.toLowerCase()
                            .contains("floor 1")) {

                        floorKeyword = "FIRST";

                    } else if (floorName.toLowerCase()
                            .contains("floor 2")) {

                        floorKeyword = "SECOND";

                    } else if (floorName.toLowerCase()
                            .contains("floor 3")) {

                        floorKeyword = "THIRD";

                    } else if (floorName.toLowerCase()
                            .contains("floor 4")) {

                        floorKeyword = "FOURTH";
                    }
                }
            }
        }

        // =====================================
        // MAIN QUERY
        // =====================================

        String sql =
                "SELECT "
                + "roomid, "
                + "roomno, "
                + "roomtype, "
                + "totaloccupancy, "
                + "currentoccupancy, "
                + "availablebeds, "
                + "blockname, "
                + "floorname "

                + "FROM hostel.room_master "

                + "WHERE LOWER(blockname)=LOWER(?) "
                + "AND LOWER(floorname)=LOWER(?) "
                + "AND availablebeds > 0 "
                + "AND isactive='Y' "

                + "ORDER BY roomno ASC";

        try (PreparedStatement ps =
                con.prepareStatement(sql)) {

            ps.setString(1, roomBlockName);

            ps.setString(2, floorKeyword);

            System.out.println(
                    "\n\nROOM SQL : " + ps);

            try (ResultSet rs =
                    ps.executeQuery()) {

                while (rs.next()) {

                    JSONObject obj =
                            new JSONObject();

                    obj.put("roomid",
                            rs.getInt("roomid"));

                    obj.put("roomno",
                            rs.getString("roomno"));

                    obj.put("roomtype",
                            rs.getString("roomtype"));

                    obj.put("totaloccupancy",
                            rs.getInt("totaloccupancy"));

                    obj.put("currentoccupancy",
                            rs.getInt("currentoccupancy"));

                    obj.put("availablebeds",
                            rs.getInt("availablebeds"));

                    arr.add(obj);
                }
            }
        }

    } catch (Exception e) {

        System.out.println(
                "\n\nCatch in getAvailableRooms\n\n");

        e.printStackTrace();
    }

    return arr;
}
    //-------------Getting the Eligible Students method -----------------
public static JSONArray getEligibleStudents(
        int institutionid,
        String shiftType) {

    JSONArray arr = new JSONArray();

    String sql =
            "SELECT "
            + "    r.applicationno, "
            + "    r.registerno, "
            + "    p.studentname, "

            // =====================================
            // SHIFT
            // =====================================

            + "    CASE "
            + "        WHEN s1.userid IS NOT NULL THEN 'SHIFT 1' "
            + "        WHEN s2.userid IS NOT NULL THEN 'SHIFT 2' "
            + "        ELSE '-' "
            + "    END AS shifttype, "

            // =====================================
            // COURSE
            // =====================================

            + "    COALESCE(s1.courseid, s2.courseid) "
            + "    AS courseid "

            + "FROM hostel.mens_hostelregistration r "

            + "JOIN hostel.hostelpersonaldetails p "
            + "    ON r.applicationno = p.applicationno "

            + "LEFT JOIN onlineapplication.coursesapply_s1 s1 "
            + "    ON r.registerno = s1.userid "

            + "LEFT JOIN onlineapplication.coursesapply_s2 s2 "
            + "    ON r.registerno = s2.userid "

            // =====================================
            // CONDITIONS
            // =====================================

            + "WHERE r.ishostelfeespaid = 'Y' "
            + "AND p.isroomallocated = 'N' "
            + "AND r.isselected = 'Y' "
            + "AND r.institutionid = ? ";

    // =========================================
    // SHIFT FILTER
    // =========================================

    if (shiftType != null
            && !shiftType.trim().equals("")) {

        if (shiftType.equals("SHIFT 1")) {

            sql += "AND s1.userid IS NOT NULL ";

        } else if (shiftType.equals("SHIFT 2")) {

            sql += "AND s2.userid IS NOT NULL ";
        }
    }

    sql += "ORDER BY p.studentname ASC";

    try (Connection con =
            new CyberCon().ErpConnection()) {

        try (PreparedStatement ps =
                con.prepareStatement(sql)) {

            ps.setInt(1, institutionid);

            System.out.println(
                    "\n\ngetEligibleStudents SQL :\n"
                    + ps);

            try (ResultSet rs =
                    ps.executeQuery()) {

                while (rs.next()) {

                    JSONObject obj =
                            new JSONObject();

                    obj.put(
                            "applicationno",
                            rs.getString("applicationno"));

                    obj.put(
                            "registerno",
                            rs.getString("registerno"));

                    obj.put(
                            "studentname",
                            rs.getString("studentname"));

                    obj.put(
                            "shifttype",
                            rs.getString("shifttype"));

                    obj.put(
                            "courseid",
                            rs.getString("courseid"));

                    arr.add(obj);
                }
            }

        }

    } catch (Exception e) {

        System.out.println(
                "\n\nCatch in getEligibleStudents\n\n");

        e.printStackTrace();
    }

    return arr;
}
 public static JSONArray getEligibleStudentsAll(
        String shiftType) {

    JSONArray arr = new JSONArray();

    String sql =
            "SELECT "
            + "    r.applicationno, "
            + "    r.registerno, "
            + "    p.studentname, "

            // =====================================
            // SHIFT TYPE
            // =====================================

            + "    CASE "
            + "        WHEN s1.userid IS NOT NULL THEN 'SHIFT 1' "
            + "        WHEN s2.userid IS NOT NULL THEN 'SHIFT 2' "
            + "        ELSE '-' "
            + "    END AS shifttype, "

            // =====================================
            // COURSE
            // =====================================

            + "    COALESCE(s1.courseid, s2.courseid) "
            + "    AS courseid "

            + "FROM hostel.mens_hostelregistration r "

            + "JOIN hostel.hostelpersonaldetails p "
            + "    ON r.applicationno = p.applicationno "

            + "LEFT JOIN onlineapplication.coursesapply_s1 s1 "
            + "    ON r.registerno = s1.userid "

            + "LEFT JOIN onlineapplication.coursesapply_s2 s2 "
            + "    ON r.registerno = s2.userid "

            // =====================================
            // CONDITIONS
            // =====================================

            + "WHERE r.ishostelfeespaid = 'Y' "
            + "AND p.isroomallocated = 'N' "
            + "AND r.isselected = 'Y' ";

    // =========================================
    // SHIFT FILTER
    // =========================================

    if (shiftType != null
            && !shiftType.trim().equals("")) {

        if (shiftType.equals("SHIFT 1")) {

            sql += "AND s1.userid IS NOT NULL ";

        } else if (shiftType.equals("SHIFT 2")) {

            sql += "AND s2.userid IS NOT NULL ";
        }
    }

    sql += "ORDER BY p.studentname ASC";

    try (Connection con =
            new CyberCon().ErpConnection()) {

        try (PreparedStatement ps =
                con.prepareStatement(sql)) {

            System.out.println(
                    "\n\ngetEligibleStudentsAll SQL :\n"
                    + ps);

            try (ResultSet rs =
                    ps.executeQuery()) {

                while (rs.next()) {

                    JSONObject obj =
                            new JSONObject();

                    obj.put(
                            "applicationno",
                            rs.getString("applicationno"));

                    obj.put(
                            "registerno",
                            rs.getString("registerno"));

                    obj.put(
                            "studentname",
                            rs.getString("studentname"));

                    obj.put(
                            "shifttype",
                            rs.getString("shifttype"));

                    obj.put(
                            "courseid",
                            rs.getString("courseid"));

                    arr.add(obj);
                }
            }

        }

    } catch (Exception e) {

        System.out.println(
                "\n\nCatch in getEligibleStudentsAll\n\n");

        e.printStackTrace();
    }

    return arr;
}
 
 public JSONArray getInstitutions() {

        JSONArray arr = new JSONArray();

        String sql = "SELECT institutionid, institutename FROM lccerp.institution ORDER BY institutename";

        try (Connection con = new CyberCon().ErpConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            System.out.println("\n\n\ngetInstitutions:\n" + ps.toString());

            while (rs.next()) {

                JSONObject obj = new JSONObject();

                obj.put("institutionid", rs.getInt("institutionid"));
                obj.put("institutename", rs.getString("institutename"));

                arr.add(obj);
            }

        } catch (Exception e) {

            System.out.println("\n\n\nInstitutionDAO.getInstitutions ERROR\n\n\n");
            e.printStackTrace();
        }

        return arr;
    }

    //===================Room Allocation Method=================
public static JSONObject allocateRooms(
        String[] rooms,
        String[] students,
        String allocatedBy,
        String ip) {

    JSONObject obj = new JSONObject();

    Connection con = null;

    try {

        con = new CyberCon().ErpConnection();

        con.setAutoCommit(false);

        System.out.println("\n=================================");
        System.out.println("ALLOCATE ROOMS DAO START");
        System.out.println("=================================");

        // =====================================
        // VALIDATION
        // =====================================

        if (rooms == null || rooms.length == 0) {

            obj.put("success", false);
            obj.put("error", "Room array empty");

            return obj;
        }

        if (students == null || students.length == 0) {

            obj.put("success", false);
            obj.put("error", "Student array empty");

            return obj;
        }

        System.out.println("ROOM COUNT : " + rooms.length);
        System.out.println("STUDENT COUNT : " + students.length);

        int stuIndex = 0;

        // =====================================
        // LOOP ROOMS
        // =====================================

        for (String roomIdStr : rooms) {

            long roomid = Long.parseLong(roomIdStr);

            System.out.println("\nROOM ID : " + roomid);

            // =================================
            // GET ROOM DETAILS
            // =================================

            String roomSql =
                    "SELECT "
                    + "roomid, "
                    + "roomno, "
                    + "blockname, "
                    + "floorname, "
                    + "availablebeds, "
                    + "currentoccupancy "

                    + "FROM hostel.room_master "

                    + "WHERE roomid = ?";

            PreparedStatement roomPs =
                    con.prepareStatement(roomSql);

            roomPs.setLong(1, roomid);

            ResultSet roomRs = roomPs.executeQuery();

            if (!roomRs.next()) {

                obj.put("success", false);
                obj.put("error",
                        "Room not found : " + roomid);

                return obj;
            }

            int availableBeds =
                    roomRs.getInt("availablebeds");

            String roomNo =
                    roomRs.getString("roomno");

            String blockname =
                    roomRs.getString("blockname");

            String floorname =
                    roomRs.getString("floorname");

            int currentOcc =
                    roomRs.getInt("currentoccupancy");

            System.out.println("ROOM : " + roomNo);
            System.out.println("AVAILABLE BEDS : "
                    + availableBeds);

            // =================================
            // ALLOCATE STUDENTS
            // =================================

            for (int i = 0;
                    i < availableBeds
                    && stuIndex < students.length;
                    i++) {

                String registerno =
                        students[stuIndex];

                System.out.println(
                        "\nALLOCATING : "
                        + registerno);

                // =============================
                // GET STUDENT DETAILS
                // =============================

                String stuSql =
                        "SELECT "
                        + "r.applicationno, "
                        + "r.registerno, "
                        + "p.studentname, "

                        + "CASE "
                        + "WHEN s1.userid IS NOT NULL "
                        + "THEN 'SHIFT 1' "

                        + "WHEN s2.userid IS NOT NULL "
                        + "THEN 'SHIFT 2' "

                        + "ELSE '-' "
                        + "END AS shifttype "

                        + "FROM hostel.mens_hostelregistration r "

                        + "JOIN hostel.hostelpersonaldetails p "
                        + "ON r.applicationno = p.applicationno "

                        + "LEFT JOIN onlineapplication.coursesapply_s1 s1 "
                        + "ON r.registerno = s1.userid "

                        + "LEFT JOIN onlineapplication.coursesapply_s2 s2 "
                        + "ON r.registerno = s2.userid "

                        + "WHERE r.registerno = ?";

                PreparedStatement stuPs =
                        con.prepareStatement(stuSql);

                stuPs.setString(1, registerno);

                ResultSet stuRs =
                        stuPs.executeQuery();

                if (!stuRs.next()) {

                    obj.put("success", false);
                    obj.put("error",
                            "Student not found : "
                            + registerno);

                    return obj;
                }

                String applicationno =
                        stuRs.getString("applicationno");

                String studentname =
                        stuRs.getString("studentname");

                String shifttype =
                        stuRs.getString("shifttype");

                // =============================
                // INSERT ALLOCATION
                // =============================

                String insertSql =
                        "INSERT INTO hostel.student_room_allocation ("
                        + "applicationno, "
                        + "registerno, "
                        + "studentname, "
                        + "shifttype, "
                        + "roomid, "
                        + "roomno, "
                        + "floorid, "
                        + "floorname, "
                        + "blockid, "
                        + "blockname, "
                        + "allocatedby "
                        + ") VALUES (?,?,?,?,?,?,?,?,?,?,?)";

                PreparedStatement insertPs =
                        con.prepareStatement(insertSql);

                insertPs.setString(1, applicationno);
                insertPs.setString(2, registerno);
                insertPs.setString(3, studentname);
                insertPs.setString(4, shifttype);
                insertPs.setLong(5, roomid);
                insertPs.setString(6, roomNo);

                // TABLE DOES NOT HAVE IDS
                insertPs.setInt(7, 0);

                insertPs.setString(8, floorname);

                insertPs.setInt(9, 0);

                insertPs.setString(10, blockname);

                insertPs.setString(11, allocatedBy);

                insertPs.executeUpdate();

                System.out.println(
                        "INSERTED SUCCESSFULLY");

                // =============================
                // UPDATE ROOM
                // =============================

                String updateRoom =
                        "UPDATE hostel.room_master "
                        + "SET "
                        + "currentoccupancy = currentoccupancy + 1, "
                        + "availablebeds = availablebeds - 1 "
                        + "WHERE roomid = ?";

                PreparedStatement updRoomPs =
                        con.prepareStatement(updateRoom);

                updRoomPs.setLong(1, roomid);

                updRoomPs.executeUpdate();

                // =============================
                // UPDATE STUDENT
                // =============================

                String updateStudent =
                        "UPDATE hostel.hostelpersonaldetails "
                        + "SET isroomallocated = 'Y' "
                        + "WHERE applicationno = ?";

                PreparedStatement updStuPs =
                        con.prepareStatement(updateStudent);

                updStuPs.setString(1, applicationno);

                updStuPs.executeUpdate();

                stuIndex++;
            }
        }

        con.commit();

        obj.put("success", true);
        obj.put("message",
                "Rooms allocated successfully");

        System.out.println("\nCOMMIT SUCCESS");

    } catch (Exception e) {

        e.printStackTrace();

        try {

            if (con != null) {

                con.rollback();

                System.out.println(
                        "\nTRANSACTION ROLLBACK");
            }

        } catch (Exception ex) {

            ex.printStackTrace();
        }

        obj.put("success", false);

        obj.put("error",
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

    return obj;
}       

    //===========  Allocated Rooms ===========
    public static JSONArray getAllocatedRooms(String blockid, String floorid, String type) {

        JSONArray arr = new JSONArray();

        try (Connection con = new CyberCon().ErpConnection()) {

            String sql = "SELECT rm.roomid, rm.roomname, rm.max_noofoccupants, rm.no_of_occupants, "
                    + "b.blockname, f.floorname, "
                    + "STRING_AGG(h.registerno, ', ') AS students "
                    + "FROM hostel.room_master rm "
                    + "LEFT JOIN hostel.hostel_blockmaster b ON rm.blockid = b.blockid "
                    + "LEFT JOIN hostel.hostel_floormaster f ON rm.floorid = f.floorid "
                    + "LEFT JOIN hostel.hostelpersonaldetails h ON rm.roomid = h.roomid "
                    + "WHERE 1=1 ";

            // Dynamic filters
            if (blockid != null && !blockid.equals("")) {
                sql += " AND rm.blockid = " + blockid;
            }

            if (floorid != null && !floorid.equals("")) {
                sql += " AND rm.floorid = " + floorid;
            }

            if ("empty".equals(type)) {
                sql += " AND rm.no_of_occupants = 0";
            } else if ("notempty".equals(type)) {
                sql += " AND rm.no_of_occupants > 0";
            }

            sql += " GROUP BY rm.roomid, b.blockname, f.floorname";
            sql += " ORDER BY rm.roomname ASC";

            try (PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

                System.out.println("\n\nAllocated Rooms Query:\n" + ps);

                while (rs.next()) {

                    JSONObject obj = new JSONObject();

                    obj.put("block", rs.getString("blockname"));
                    obj.put("floor", rs.getString("floorname"));
                    obj.put("room", rs.getString("roomname"));
                    obj.put("max", rs.getInt("max_noofoccupants"));
                    obj.put("occupied", rs.getInt("no_of_occupants"));
                    obj.put("students", rs.getString("students"));

                    arr.add(obj);
                }
            }

        } catch (Exception e) {
            System.out.println("\n\nCatch in getAllocatedRooms\n\n");
            e.printStackTrace();
        }

        return arr;
    }

    public static JSONObject allocateMess(int messid, String[] students) {

        JSONObject res = new JSONObject();

        try (Connection con = new CyberCon().ErpConnection()) {

            con.setAutoCommit(false);

            String sql = "UPDATE hostel.hostelpersonaldetails "
                    + "SET messid = ?, ismessallocated = 'Y' "
                    + "WHERE registerno = ?";

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                for (String regNo : students) {

                    ps.setInt(1, messid);
                    ps.setString(2, regNo);

                    ps.addBatch();
                }

                ps.executeBatch();
            }

            con.commit();
            System.out.println("Mess Allocation Success");
            res.put("success", true);

        } catch (Exception e) {

            e.printStackTrace();
            System.out.println("\n\nCatch in Allocate Mess method : " + e + "\n\n");
            res.put("success", false);
            res.put("error", e.getMessage());
        }

        return res;
    }
/*
 * =========================================================
 * ADD THIS METHOD INSIDE ERPHostelRoomDAO.java
 * =========================================================
 */

    // =========================================================
    // GET ALLOCATED ROOMS - grouped by room, with students array
    // =========================================================
public static JSONArray getAllocatedBlocks(String blockname) {

    JSONArray arr = new JSONArray();

    String sql =
            "SELECT "
            + "    sra.allocationid, "
            + "    sra.registerno, "
            + "    sra.studentname, "
            + "    sra.shifttype, "
            + "    sra.roomid, "
            + "    sra.roomno, "
            + "    sra.floorid, "
            + "    sra.floorname, "
            + "    sra.blockid, "
            + "    sra.blockname, "

            + "    rm.totaloccupancy, "
            + "    rm.currentoccupancy, "
            + "    rm.availablebeds, "
            + "    rm.roomtype "

            + "FROM hostel.student_room_allocation sra "

            + "LEFT JOIN hostel.room_master rm "
            + "    ON LOWER(rm.roomno) = LOWER(sra.roomno) "
            + "   AND LOWER(rm.blockname) = LOWER(sra.blockname) "
            + "   AND LOWER(rm.floorname) = LOWER(sra.floorname) "

            + "WHERE sra.isactive = 'Y' "
            + "AND LOWER(sra.blockname) = LOWER(?) "

            + "ORDER BY "
            + "    sra.floorname ASC, "
            + "    sra.roomno ASC, "
            + "    sra.studentname ASC";

    java.util.LinkedHashMap<String, JSONObject> roomMap
            = new java.util.LinkedHashMap<>();

    try (Connection con = new CyberCon().ErpConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, blockname);

        System.out.println(
                "\n\n=================================");
        System.out.println("getAllocatedBlocks SQL");
        System.out.println("=================================");
        System.out.println(ps);

        try (ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

               String roomKey =
        (rs.getString("blockname") != null
            ? rs.getString("blockname") : "")
        + "_"
        + (rs.getString("floorname") != null
            ? rs.getString("floorname") : "")
        + "_"
        + (rs.getString("roomno") != null
            ? rs.getString("roomno") : "");

                // =====================================
                // CREATE ROOM OBJECT
                // =====================================

                if (!roomMap.containsKey(roomKey)) {

                    JSONObject room = new JSONObject();

                    room.put(
                            "roomid",
                            rs.getObject("roomid"));

                    room.put(
                            "roomno",
                            rs.getString("roomno"));

                    room.put(
                            "floorid",
                            rs.getObject("floorid"));

                    room.put(
                            "floorname",
                            rs.getString("floorname"));

                    room.put(
                            "blockid",
                            rs.getObject("blockid"));

                    room.put(
                            "blockname",
                            rs.getString("blockname"));

                    room.put(
                            "roomtype",
                            rs.getString("roomtype") != null
                                    ? rs.getString("roomtype")
                                    : "");

                    room.put(
                            "totaloccupancy",
                            rs.getInt("totaloccupancy"));

                    room.put(
                            "currentoccupancy",
                            rs.getInt("currentoccupancy"));

                    room.put(
                            "availablebeds",
                            rs.getInt("availablebeds"));

                    room.put(
                            "students",
                            new JSONArray());

                    roomMap.put(roomKey, room);
                }

                // =====================================
                // STUDENT OBJECT
                // =====================================

                JSONObject student = new JSONObject();

                student.put(
                        "allocationid",
                        rs.getInt("allocationid"));

                student.put(
                        "registerno",
                        rs.getString("registerno"));

                student.put(
                        "studentname",
                        rs.getString("studentname"));

                student.put(
                        "shifttype",
                        rs.getString("shifttype") != null
                                ? rs.getString("shifttype")
                                : "-");

                // =====================================
                // ADD STUDENT TO ROOM
                // =====================================

                ((JSONArray) roomMap.get(roomKey)
                        .get("students"))
                        .add(student);
            }
        }

        // =====================================
        // FINAL ARRAY
        // =====================================

        arr.addAll(roomMap.values());

        System.out.println(
                "\nLoaded Rooms : " + arr.size());

    } catch (Exception e) {

        System.out.println(
                "\n\nCatch in getAllocatedBlocks\n");

        e.printStackTrace();
    }

    return arr;
}

}
