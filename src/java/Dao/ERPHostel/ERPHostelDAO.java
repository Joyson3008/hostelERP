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
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author lccerp26
 */
public class ERPHostelDAO {

    public static JSONObject getHostelerInfo(String searchText) {

    JSONObject result = new JSONObject();

    if (searchText == null || searchText.trim().isEmpty()) {
        result.put("success", false);
        result.put("message", "Search text is empty");
        return result;
    }

    String like = "%" + searchText.trim() + "%";

    SimpleDateFormat dfDate     = new SimpleDateFormat("dd-MM-yyyy");
    SimpleDateFormat dfDateTime = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

    // ─────────────────────────────────────────────────────────
    // MAIN QUERY  — hostel tables only (no lccerp joins that
    // may be unavailable), plus room_master & shift tables.
    // ─────────────────────────────────────────────────────────
 String sql =
    "SELECT "
  + "    hp.registerno, "
  + "    hp.applicationno, "
  + "    hp.studentname, "
  + "    hp.institutionname, "
  + "    hp.college, "
  + "    hp.studentprogram, "
  + "    hp.gender, "
  + "    hp.dateofbirth, "
  + "    hp.bloodgroup, "
  + "    hp.religion, "
  + "    hp.category, "
  + "    hp.casteid, "
  + "    hp.mothertongue, "
  + "    hp.state, "
  + "    hp.village, "
  + "    hp.town, "
  + "    hp.premadd1, "
  + "    hp.premadd2, "
  + "    hp.premadd3, "
  + "    hp.pincode, "
  + "    hp.studentmobilenumber, "
  + "    hp.studentemailid, "
  + "    hp.parentmobile, "
  + "    hp.parentemail, "
  + "    hp.fathername, "
  + "    hp.mothername, "
  + "    hp.fatheroccupation, "
  + "    hp.fatherannualincome, "
  + "    hp.isphysicallychallenged, "
  + "    hp.studentphoto, "
  + "    hp.filename, "
  + "    hp.isroomallocated, "
  + "    hp.ismessallocated, "
  + "    hp.officename, "
  + "    hp.updated_on, "

      // ── REGISTRATION STATUS ──
      + "    mr.isselected, "
      + "    mr.isappfeespaid, "
      + "    mr.ishostelfeespaid, "
      + "    mr.registereddate, "
      + "    hp.selecteddatetime, "

      // ── MESS ──
      + "    hm.mess_name, "

      // ── ROOM ALLOCATION ──
      + "    sra.allocationid, "
      + "    sra.roomid      AS sra_roomid, "
      + "    sra.roomno, "
      + "    sra.floorname   AS sra_floorname, "
      + "    sra.blockname   AS sra_blockname, "
      + "    sra.allocateddate, "
      + "    sra.shifttype, "

      // ── ROOM MASTER ──
      + "    rm.roomtype, "
      + "    rm.totaloccupancy, "
      + "    rm.currentoccupancy, "

      // ── GUARDIAN ──
      + "    gd.guardianrelation, "
      + "    gd.guardline1, "
      + "    gd.guardline2, "
      + "    gd.guardline3, "
      + "    gd.guardianmobile, "
      + "    gd.guardianemail, "
      + "    gd.guardstate, "
      + "    gd.guarddist "

      + "FROM hostel.hostelpersonaldetails hp "

      + "LEFT JOIN hostel.mens_hostelregistration mr "
      + "    ON mr.registerno = hp.registerno "

      + "LEFT JOIN hostel.guardiandetails gd "
      + "    ON gd.registerno = hp.registerno "

      + "LEFT JOIN hostel.hostel_messmaster hm "
      + "    ON hm.mess_id = hp.messid "

      // Latest active room allocation
      + "LEFT JOIN hostel.student_room_allocation sra "
      + "    ON sra.registerno = hp.registerno "
      + "   AND sra.isactive = 'Y' "

      + "LEFT JOIN hostel.room_master rm "
      + "    ON rm.roomid = sra.roomid "

      + "WHERE ( "
      + "    LOWER(hp.registerno)   LIKE LOWER(?) "
      + " OR LOWER(hp.applicationno) LIKE LOWER(?) "
      + " OR LOWER(hp.studentname) LIKE LOWER(?) "
      + ") "

      + "ORDER BY sra.allocationid DESC "
      + "LIMIT 1";

    try (Connection con = new CyberCon().ErpConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, like);
        ps.setString(2, like);
        ps.setString(3, like);

        System.out.println("\n\ngetHostelerInfo SQL:\n" + ps);

        try (ResultSet rs = ps.executeQuery()) {

            if (!rs.next()) {
                result.put("success", false);
                result.put("message", "No student found for: " + searchText);
                return result;
            }

            result.put("success", true);

            // ── BASIC ────────────────────────────────────────────
            result.put("registerno",           safe(rs.getString("registerno")));
            result.put("applicationno",        safe(rs.getString("applicationno")));
            result.put("studentname",          safe(rs.getString("studentname")));
            result.put("institutionname",      safe(rs.getString("institutionname")));
            result.put("college",              safe(rs.getString("college")));
            result.put("studentprogram",       safe(rs.getString("studentprogram")));
            result.put("gender",               safe(rs.getString("gender")));
            result.put("bloodgroup",           safe(rs.getString("bloodgroup")));
            result.put("religion",             safe(rs.getString("religion")));
            result.put("category",             safe(rs.getString("category")));
            result.put("casteid",              safe(rs.getString("casteid")));
            result.put("mothertongue",         safe(rs.getString("mothertongue")));
            result.put("state",                safe(rs.getString("state")));
            result.put("village",              safe(rs.getString("village")));
            result.put("town",                 safe(rs.getString("town")));
            result.put("premadd1",             safe(rs.getString("premadd1")));
            result.put("premadd2",             safe(rs.getString("premadd2")));
            result.put("premadd3",             safe(rs.getString("premadd3")));
            result.put("pincode",              safe(rs.getString("pincode")));
            result.put("studentmobilenumber",  safe(rs.getString("studentmobilenumber")));
            result.put("studentemailid",       safe(rs.getString("studentemailid")));
            result.put("parentmobile",         safe(rs.getString("parentmobile")));
            result.put("parentemail",          safe(rs.getString("parentemail")));
            result.put("fathername",           safe(rs.getString("fathername")));
            result.put("mothername",           safe(rs.getString("mothername")));
            result.put("fatheroccupation",     safe(rs.getString("fatheroccupation")));
            result.put("fatherannualincome",   safe(rs.getString("fatherannualincome")));
            result.put("officename",           safe(rs.getString("officename")));
          

            // ── PHOTO ────────────────────────────────────────────
            result.put("studentphoto",  safe(rs.getString("studentphoto")));
            result.put("filename",      safe(rs.getString("filename")));

            // ── DOB ──────────────────────────────────────────────
            java.sql.Date dob = rs.getDate("dateofbirth");
            result.put("dateofbirth", dob != null ? dfDate.format(dob) : "");

            // ── DIFFERENTLY ABLED ────────────────────────────────
            String pc = rs.getString("isphysicallychallenged");
            result.put("isphysicallychallenged", "Y".equalsIgnoreCase(pc) ? "Yes" : "No");

            // ── STATUS FLAGS ─────────────────────────────────────
            result.put("isselected",       safe(rs.getString("isselected")));
            result.put("isappfeespaid",    safe(rs.getString("isappfeespaid")));
            result.put("ishostelfeespaid", safe(rs.getString("ishostelfeespaid")));
            result.put("isroomallocated",  safe(rs.getString("isroomallocated")));
            result.put("ismessallocated",  safe(rs.getString("ismessallocated")));

            // Active status derived
            String feePaid = rs.getString("ishostelfeespaid");
            result.put("currentstatus", "Y".equalsIgnoreCase(feePaid) ? "Active" : "Inactive");

            // ── DATES ────────────────────────────────────────────
            Timestamp regDate = rs.getTimestamp("registereddate");
            result.put("registereddate",    regDate != null ? dfDateTime.format(regDate) : "");

            Timestamp selDate = rs.getTimestamp("selecteddatetime");
            result.put("selecteddatetime",  selDate != null ? dfDateTime.format(selDate) : "");

            Timestamp updDate = rs.getTimestamp("updated_on");
            result.put("updated_on",        updDate != null ? dfDateTime.format(updDate) : "");

            // ── MESS ─────────────────────────────────────────────
            result.put("mess_name", safe(rs.getString("mess_name")));

            // ── SHIFT (from allocation record) ───────────────────
            result.put("shifttype", safe(rs.getString("shifttype")));

            // ── ROOM ALLOCATION ──────────────────────────────────
            Object roomid = rs.getObject("sra_roomid");
            result.put("roomid",      roomid);
            result.put("roomno",      safe(rs.getString("roomno")));
            result.put("floorname",   safe(rs.getString("sra_floorname")));
            result.put("blockname",   safe(rs.getString("sra_blockname")));
            result.put("roomtype",    safe(rs.getString("roomtype")));
            result.put("totaloccupancy",   rs.getInt("totaloccupancy"));
            result.put("currentoccupancy", rs.getInt("currentoccupancy"));

            Timestamp allocDate = rs.getTimestamp("allocateddate");
            result.put("allocateddate", allocDate != null ? dfDate.format(allocDate) : "");

            // ── GUARDIAN ─────────────────────────────────────────
            result.put("guardianrelation", safe(rs.getString("guardianrelation")));
            result.put("guardline1",       safe(rs.getString("guardline1")));
            result.put("guardline2",       safe(rs.getString("guardline2")));
            result.put("guardline3",       safe(rs.getString("guardline3")));
            result.put("guardianmobile",   safe(rs.getString("guardianmobile")));
            result.put("guardianemail",    safe(rs.getString("guardianemail")));
            result.put("guardstate",       safe(rs.getString("guardstate")));
            result.put("guarddist",        safe(rs.getString("guarddist")));
        }

    } catch (Exception e) {
        System.out.println("\n\nERROR in getHostelerInfo\n\n");
        e.printStackTrace();
        result.put("success", false);
        result.put("message", "Database error: " + e.getMessage());
    }

    return result;
}

// private helper — add only if not already present in the class
private static String safe(String s) {
    return (s != null) ? s.trim() : "";
}

    
    
    
    public static JSONArray getApplicants(String fromDate, String toDate, String institution, String academicyear, String office) {

        JSONArray arr = new JSONArray();

        SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy");
        SimpleDateFormat dateTimeFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

        String sql = "SELECT * FROM hostel.hostelpersonaldetails h "
                + "LEFT JOIN hostel.guardiandetails g ON h.registerno = g.registerno "
                + "INNER JOIN hostel.mens_hostelregistration m ON h.registerno = m.registerno AND m.isappfeespaid = 'Y' "
                + "LEFT JOIN lccerp.student_studentmaster s ON h.registerno = s.registerno "
                + "LEFT JOIN lccerp.student_studentmasterdetails sd ON s.studentid = sd.studentid "
                + "LEFT JOIN lccerp.distlist d ON h.distid = d.distid "
                + "WHERE 1=1 ";

        System.out.println("\n\n Debug the institution " + institution + "\n\n");

        if (institution != null && !institution.trim().isEmpty() && !institution.equals("All")) {
            sql += " AND h.institutionname = ?";
        }

        if (academicyear != null && !academicyear.trim().isEmpty() && !academicyear.equals("All")) {
            sql += " AND m.academicyearid = ?";
        }

        if (office != null && !office.trim().isEmpty() && !office.equals("All")) {
            sql += " AND s.officeid = ?";
        }

        if (fromDate != null && !fromDate.isEmpty()) {
            sql += " AND h.updated_on >= ?";
        }

        if (toDate != null && !toDate.isEmpty()) {
            sql += " AND h.updated_on <= ?";
        }

        sql += " ORDER BY h.updated_on DESC";

        try (Connection con = new CyberCon().ErpConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            int index = 1;
            System.out.println("SQL: " + sql);

            if (institution != null && !institution.trim().isEmpty() && !institution.equals("All")) {
                ps.setString(index++, institution);
            }

            if (academicyear != null && !academicyear.trim().isEmpty() && !academicyear.equals("All")) {
                ps.setInt(index++, Integer.parseInt(academicyear));
            }

            if (office != null && !office.trim().isEmpty() && !office.equals("All")) {
                ps.setInt(index++, Integer.parseInt(office));
            }

            if (fromDate != null && !fromDate.isEmpty()) {
                ps.setTimestamp(index++, Timestamp.valueOf(fromDate + " 00:00:00"));
            }

            if (toDate != null && !toDate.isEmpty()) {
                ps.setTimestamp(index++, Timestamp.valueOf(toDate + " 23:59:59"));
            }

            System.out.println("\n\nDEBUG SQL:\n" + ps.toString());

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    JSONObject obj = new JSONObject();

                    // ALL FIELDS FROM hostelpersonaldetails
                    obj.put("status", rs.getString("isselected"));
                    obj.put("registerno", rs.getString("registerno"));
                    obj.put("applicationno", rs.getString("applicationno"));
                    obj.put("institutionname", rs.getString("institutionname"));
                    obj.put("studentname", rs.getString("studentname"));
                    obj.put("college", rs.getString("college"));
                    obj.put("studentprogram", rs.getString("studentprogram"));
                    obj.put("bloodgroup", rs.getString("bloodgroup"));
                    java.sql.Date dob = rs.getDate("dateofbirth");

                    obj.put("dateofbirth", dob != null ? dateFormat.format(dob) : "");
                    obj.put("gender", rs.getString("gender"));
                    obj.put("studentmobilenumber", rs.getString("studentmobilenumber"));
                    obj.put("studentemailid", rs.getString("studentemailid"));
                    obj.put("state", rs.getString("state"));
                    obj.put("distname", rs.getString("distname"));
                    obj.put("village", rs.getString("village"));
                    obj.put("town", rs.getString("town"));
                    obj.put("mothertongue", rs.getString("mothertongue"));
                    obj.put("religion", rs.getString("religion"));
                    obj.put("category", rs.getString("category"));
                    obj.put("casteid", rs.getString("casteid"));
                    obj.put("fathername", rs.getString("fathername"));
                    obj.put("fathereducation", rs.getString("fathereducation"));
                    obj.put("fatheroccupation", rs.getString("fatheroccupation"));
                    obj.put("fatherannualincome", rs.getString("fatherannualincome"));
                    obj.put("mothername", rs.getString("mothername"));
                    obj.put("mothereducation", rs.getString("mothereducation"));
                    obj.put("motheroccupation", rs.getString("motheroccupation"));
                    obj.put("motherannualincome", rs.getString("motherannualincome"));
                    obj.put("nameofschool", rs.getString("nameofschool"));
                    obj.put("marksplustwo", rs.getString("marksplustwo"));

                    // Differently abled Student
                    String differentlyabledid = rs.getString("differentlyabledtypeid");
                    System.out.println("Diff ID " + differentlyabledid);

                    String hostelValue = rs.getString("isphysicallychallenged");
                    System.out.println("Diff Y/N " + hostelValue);

                    String finalValue = "No"; // default

                    if (differentlyabledid != null) {

                        // ERP student exists
                        if ("8".equals(differentlyabledid)) {
                            finalValue = "No";
                        } else {
                            finalValue = "Yes";
                        }

                    } else {

                        // fallback to hostel table
                        if ("Y".equalsIgnoreCase(hostelValue)) {
                            finalValue = "Yes";
                        } else {
                            finalValue = "No";
                        }
                    }

                    obj.put("isphysicallychallenged", finalValue);
                    obj.put("premadd1", rs.getString("premadd1"));
                    obj.put("premadd2", rs.getString("premadd2"));
                    obj.put("premadd3", rs.getString("premadd3"));
                    obj.put("prem_distid", rs.getString("prem_distid"));
                    obj.put("pincode", rs.getString("pincode"));
                    obj.put("parentmobile", rs.getString("parentmobile"));
                    obj.put("parentemail", rs.getString("parentemail"));
                    obj.put("officename", rs.getString("officename"));
                    //obj.put("studentphoto", rs.getString("studentphoto"));
                    //obj.put("isapplicationgenerate", rs.getString("isapplicationgenerate"));
                    Timestamp updated = rs.getTimestamp("updated_on");

                    obj.put("updated_on", updated != null ? dateTimeFormat.format(updated) : "");
                    obj.put("permstate", rs.getString("permstate"));
                    obj.put("maxmark", rs.getString("maxmark"));
                    obj.put("bloodgroupid", rs.getString("bloodgroupid"));

                    // GUARDIAN TABLE
                    obj.put("guardianrelation", rs.getString("guardianrelation"));
                    obj.put("guardline1", rs.getString("guardline1"));
                    obj.put("guardline2", rs.getString("guardline2"));
                    obj.put("guardline3", rs.getString("guardline3"));
                    obj.put("guardianmobile", rs.getString("guardianmobile"));
                    obj.put("guardianemail", rs.getString("guardianemail"));
                    obj.put("guardstate", rs.getString("guardstate"));
                    obj.put("guarddist", rs.getString("guarddist"));
                    obj.put("filename", rs.getString("filename"));

                    arr.add(obj);
                }
            }

        } catch (Exception e) {

            System.out.println("\n\n\nCatch in HostelApplicantDAO.getApplicants\n\n\n");
            e.printStackTrace();
        }

        return arr;
    }

public static JSONArray getNonSelectedApplicants(String fromDate, String toDate, String institution, String academicyear, String office) {

        JSONArray arr = new JSONArray();

        SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy");
        SimpleDateFormat dateTimeFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

        // ── Uses ONLY hostel tables (no lccerp joins) for testing ──
        String sql = "SELECT "
                + "h.registerno, h.applicationno, h.institutionname, h.studentname, "
                + "h.college, h.studentprogram, h.bloodgroup, h.dateofbirth, h.gender, "
                + "h.studentmobilenumber, h.studentemailid, h.state, h.distid, "
                + "h.village, h.town, h.mothertongue, h.religion, h.category, h.casteid, "
                + "h.fathername, h.fathereducation, h.fatheroccupation, h.fatherannualincome, "
                + "h.mothername, h.mothereducation, h.motheroccupation, h.motherannualincome, "
                + "h.nameofschool, h.marksplustwo, h.maxmark, h.isphysicallychallenged, "
                + "h.premadd1, h.premadd2, h.premadd3, h.prem_distid, h.pincode, "
                + "h.parentmobile, h.parentemail, h.officename, h.permstate, "
                + "h.bloodgroupid, h.filename, h.updated_on, "
                + "g.guardianrelation, g.guardline1, g.guardline2, g.guardline3, "
                + "g.guardianmobile, g.guardianemail, g.guardstate, g.guarddist "
                + "FROM hostel.hostelpersonaldetails h "
                + "LEFT JOIN hostel.guardiandetails g ON h.registerno = g.registerno "
                + "INNER JOIN hostel.mens_hostelregistration m "
                + "  ON h.registerno = m.registerno "
                + " AND m.isselected = 'N' "
                + " AND m.isappfeespaid = 'Y' "
                + "WHERE 1=1 ";

        System.out.println("\n\n Debug the institution " + institution + "\n\n");

        if (institution != null && !institution.trim().isEmpty() && !institution.equals("All")) {
            sql += " AND h.institutionname = ?";
        }

        if (academicyear != null && !academicyear.trim().isEmpty() && !academicyear.equals("All")) {
            sql += " AND m.academicyearid = ?";
        }

        // office filter removed: lccerp.student_studentmaster not available
        // if (office != null && !office.trim().isEmpty() && !office.equals("All")) {
        //     sql += " AND s.officeid = ?";
        // }

        if (fromDate != null && !fromDate.isEmpty()) {
            sql += " AND h.updated_on >= ?";
        }

        if (toDate != null && !toDate.isEmpty()) {
            sql += " AND h.updated_on <= ?";
        }

        sql += " ORDER BY h.updated_on DESC";

        try (Connection con = new CyberCon().ErpConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            int index = 1;
            System.out.println("SQL: " + sql);

            if (institution != null && !institution.trim().isEmpty() && !institution.equals("All")) {
                ps.setString(index++, institution);
            }

            if (academicyear != null && !academicyear.trim().isEmpty() && !academicyear.equals("All")) {
                ps.setInt(index++, Integer.parseInt(academicyear));
            }

            // office param removed: no lccerp.student_studentmaster
            // if (office != null && !office.trim().isEmpty() && !office.equals("All")) {
            //     ps.setInt(index++, Integer.parseInt(office));
            // }

            if (fromDate != null && !fromDate.isEmpty()) {
                ps.setTimestamp(index++, Timestamp.valueOf(fromDate + " 00:00:00"));
            }

            if (toDate != null && !toDate.isEmpty()) {
                ps.setTimestamp(index++, Timestamp.valueOf(toDate + " 23:59:59"));
            }

            System.out.println("\n\nDEBUG SQL:\n" + ps.toString());

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    JSONObject obj = new JSONObject();

                    // ── Core fields from hostelpersonaldetails ──
                    obj.put("registerno",          rs.getString("registerno"));
                    obj.put("applicationno",        rs.getString("applicationno"));
                    obj.put("filename",             rs.getString("filename"));
                    obj.put("institutionname",      rs.getString("institutionname"));
                    obj.put("studentname",          rs.getString("studentname"));
                    obj.put("college",              rs.getString("college"));
                    obj.put("studentprogram",       rs.getString("studentprogram"));
                    obj.put("bloodgroup",           rs.getString("bloodgroup"));

                    java.sql.Date dob = rs.getDate("dateofbirth");
                    obj.put("dateofbirth",          dob != null ? dateFormat.format(dob) : "");

                    obj.put("gender",               rs.getString("gender"));
                    obj.put("studentmobilenumber",  rs.getString("studentmobilenumber"));
                    obj.put("studentemailid",       rs.getString("studentemailid"));
                    obj.put("state",                rs.getString("state"));

                    // distname not available without lccerp.distlist —
                    // fall back to raw distid so the column is never null
                    obj.put("distname",             rs.getString("distid"));

                    obj.put("village",              rs.getString("village"));
                    obj.put("town",                 rs.getString("town"));
                    obj.put("mothertongue",         rs.getString("mothertongue"));
                    obj.put("religion",             rs.getString("religion"));
                    obj.put("category",             rs.getString("category"));
                    obj.put("casteid",              rs.getString("casteid"));
                    obj.put("fathername",           rs.getString("fathername"));
                    obj.put("fathereducation",      rs.getString("fathereducation"));
                    obj.put("fatheroccupation",     rs.getString("fatheroccupation"));
                    obj.put("fatherannualincome",   rs.getString("fatherannualincome"));
                    obj.put("mothername",           rs.getString("mothername"));
                    obj.put("mothereducation",      rs.getString("mothereducation"));
                    obj.put("motheroccupation",     rs.getString("motheroccupation"));
                    obj.put("motherannualincome",   rs.getString("motherannualincome"));
                    obj.put("nameofschool",         rs.getString("nameofschool"));
                    obj.put("marksplustwo",         rs.getString("marksplustwo"));

                    // ── Differently abled ──
                    // differentlyabledtypeid lives in lccerp.student_studentmasterdetails
                    // which is not available; fall back directly to hostel column
                    String hostelValue = rs.getString("isphysicallychallenged");
                    System.out.println("Diff Y/N " + hostelValue);

                    String finalValue = "Y".equalsIgnoreCase(hostelValue) ? "Yes" : "No";
                    obj.put("isphysicallychallenged", finalValue);

                    obj.put("premadd1",     rs.getString("premadd1"));
                    obj.put("premadd2",     rs.getString("premadd2"));
                    obj.put("premadd3",     rs.getString("premadd3"));
                    obj.put("prem_distid",  rs.getString("prem_distid"));
                    obj.put("pincode",      rs.getString("pincode"));
                    obj.put("parentmobile", rs.getString("parentmobile"));
                    obj.put("parentemail",  rs.getString("parentemail"));
                    obj.put("officename",   rs.getString("officename"));

                    Timestamp updated = rs.getTimestamp("updated_on");
                    obj.put("updated_on",   updated != null ? dateTimeFormat.format(updated) : "");

                    obj.put("permstate",    rs.getString("permstate"));
                    obj.put("maxmark",      rs.getString("maxmark"));
                    obj.put("bloodgroupid", rs.getString("bloodgroupid"));

                    // ── Guardian table (still joined — hostel.guardiandetails is available) ──
                    obj.put("guardianrelation", rs.getString("guardianrelation"));
                    obj.put("guardline1",       rs.getString("guardline1"));
                    obj.put("guardline2",       rs.getString("guardline2"));
                    obj.put("guardline3",       rs.getString("guardline3"));
                    obj.put("guardianmobile",   rs.getString("guardianmobile"));
                    obj.put("guardianemail",    rs.getString("guardianemail"));
                    obj.put("guardstate",       rs.getString("guardstate"));
                    obj.put("guarddist",        rs.getString("guarddist"));

                    arr.add(obj);
                }
            }

        } catch (Exception e) {
            System.out.println("\n\n\nCatch in HostelApplicantDAO.getNonSelectedApplicants\n\n\n");
            e.printStackTrace();
        }

        return arr;
    }

    public static String SelectApplicant(String appnos, String userId, String ip) {

        JSONObject response = new JSONObject();
        Connection con = null;

        try {
            con = new CyberCon().ErpConnection();
            con.setAutoCommit(false); // ✅ START TRANSACTION

            String[] appArray = appnos.split(",");

            String sql1 = "UPDATE hostel.mens_hostelregistration SET isselected = 'Y' WHERE applicationno = ?";
            String sql2 = "UPDATE hostel.hostelpersonaldetails SET selectedbyuserid = ?, selecteddatetime = NOW(), selectedbyip = ? WHERE applicationno = ?";

            try (
                    PreparedStatement ps1 = con.prepareStatement(sql1); PreparedStatement ps2 = con.prepareStatement(sql2)) {

                for (String app : appArray) {

                    String applicationNo = app.trim();

                    ps1.setString(1, applicationNo);
                    ps1.addBatch();
                    System.out.println("\n\nPrint Query"+ ps1);

                    ps2.setString(1, userId);
                    ps2.setString(2, ip);
                    ps2.setString(3, applicationNo);
                    ps2.addBatch();
                    System.out.println("\n\nPrint Query"+ ps2);
                }

                int[] r1 = ps1.executeBatch();
                int[] r2 = ps2.executeBatch();

                con.commit();

                response.put("success", true);
                response.put("updatedSelectionCount", r1.length);
                response.put("updatedAuditCount", r2.length);
            }

        } catch (Exception e) {

            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }

            System.out.println("Catch in SelectApplicant method in DAO");
            e.printStackTrace();

            response.put("success", false);
            response.put("error", e.getMessage());

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

   public static JSONArray getSelectedApplicants(
        String fromDate,
        String toDate,
        String institution,
        String academicyear,
        String office) {

    JSONArray arr = new JSONArray();

    SimpleDateFormat dateFormat =
            new SimpleDateFormat("dd-MM-yyyy");

    SimpleDateFormat dateTimeFormat =
            new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

    String sql =
            "SELECT "
            + "    h.*, "
            + "    g.*, "
            + "    m.*, "
            + "    s.*, "
            + "    sd.*, "
            + "    d.distname "

            + "FROM hostel.hostelpersonaldetails h "

            + "LEFT JOIN hostel.guardiandetails g "
            + "    ON h.registerno = g.registerno "

            + "INNER JOIN hostel.mens_hostelregistration m "
            + "    ON h.registerno = m.registerno "
            + "   AND m.isselected = 'Y' "

            + "LEFT JOIN lccerp.student_studentmaster s "
            + "    ON h.registerno = s.registerno "

            + "LEFT JOIN lccerp.student_studentmasterdetails sd "
            + "    ON s.studentid = sd.studentid "

            + "LEFT JOIN lccerp.distlist d "
            + "    ON h.distid = d.distid "

            + "WHERE 1 = 1 ";

    System.out.println(
            "\n\nDebug Institution : "
            + institution + "\n\n");

    // =========================================
    // INSTITUTION FILTER
    // =========================================

    if (institution != null
            && !institution.trim().isEmpty()
            && !institution.equalsIgnoreCase("All")) {

        sql += " AND h.institutionname = ? ";
    }

    // =========================================
    // ACADEMIC YEAR FILTER
    // =========================================

    if (academicyear != null
            && !academicyear.trim().isEmpty()
            && !academicyear.equalsIgnoreCase("All")) {

        sql += " AND m.academicyearid = ? ";
    }

    // =========================================
    // OFFICE FILTER
    // =========================================

    if (office != null
            && !office.trim().isEmpty()
            && !office.equalsIgnoreCase("All")) {

        sql += " AND s.officeid = ? ";
    }

    // =========================================
    // FROM DATE FILTER
    // =========================================

    if (fromDate != null
            && !fromDate.trim().isEmpty()) {

        sql += " AND h.updated_on >= ? ";
    }

    // =========================================
    // TO DATE FILTER
    // =========================================

    if (toDate != null
            && !toDate.trim().isEmpty()) {

        sql += " AND h.updated_on <= ? ";
    }

    // =========================================
    // ORDER BY
    // =========================================

    sql += " ORDER BY h.updated_on DESC ";

    try (Connection con = new CyberCon().ErpConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        int index = 1;

        System.out.println("\nSQL : \n" + sql);

        // =========================================
        // SET INSTITUTION
        // =========================================

        if (institution != null
                && !institution.trim().isEmpty()
                && !institution.equalsIgnoreCase("All")) {

            ps.setString(index++, institution);
        }

        // =========================================
        // SET ACADEMIC YEAR
        // =========================================

        if (academicyear != null
                && !academicyear.trim().isEmpty()
                && !academicyear.equalsIgnoreCase("All")) {

            ps.setInt(index++,
                    Integer.parseInt(academicyear));
        }

        // =========================================
        // SET OFFICE
        // =========================================

        if (office != null
                && !office.trim().isEmpty()
                && !office.equalsIgnoreCase("All")) {

            ps.setInt(index++,
                    Integer.parseInt(office));
        }

        // =========================================
        // SET FROM DATE
        // =========================================

        if (fromDate != null
                && !fromDate.trim().isEmpty()) {

            ps.setTimestamp(
                    index++,
                    Timestamp.valueOf(
                            fromDate + " 00:00:00"));
        }

        // =========================================
        // SET TO DATE
        // =========================================

        if (toDate != null
                && !toDate.trim().isEmpty()) {

            ps.setTimestamp(
                    index++,
                    Timestamp.valueOf(
                            toDate + " 23:59:59"));
        }

        System.out.println(
                "\n\nDEBUG SQL : \n" + ps.toString());

        try (ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                JSONObject obj = new JSONObject();

                // =========================================
                // PERSONAL DETAILS
                // =========================================

                obj.put("registerno",
                        rs.getString("registerno"));

                obj.put("applicationno",
                        rs.getString("applicationno"));

                obj.put("institutionname",
                        rs.getString("institutionname"));

                obj.put("filename",
                        rs.getString("filename"));

                obj.put("studentname",
                        rs.getString("studentname"));

                obj.put("college",
                        rs.getString("college"));

                obj.put("studentprogram",
                        rs.getString("studentprogram"));

                obj.put("bloodgroup",
                        rs.getString("bloodgroup"));

                java.sql.Date dob =
                        rs.getDate("dateofbirth");

                obj.put("dateofbirth",
                        dob != null
                        ? dateFormat.format(dob)
                        : "");

                obj.put("gender",
                        rs.getString("gender"));

                obj.put("studentmobilenumber",
                        rs.getString("studentmobilenumber"));

                obj.put("studentemailid",
                        rs.getString("studentemailid"));

                obj.put("state",
                        rs.getString("state"));

                obj.put("distname",
                        rs.getString("distname"));

                obj.put("village",
                        rs.getString("village"));

                obj.put("town",
                        rs.getString("town"));

                obj.put("mothertongue",
                        rs.getString("mothertongue"));

                obj.put("religion",
                        rs.getString("religion"));

                obj.put("category",
                        rs.getString("category"));

                obj.put("casteid",
                        rs.getString("casteid"));

                obj.put("fathername",
                        rs.getString("fathername"));

                obj.put("fathereducation",
                        rs.getString("fathereducation"));

                obj.put("fatheroccupation",
                        rs.getString("fatheroccupation"));

                obj.put("fatherannualincome",
                        rs.getString("fatherannualincome"));

                obj.put("mothername",
                        rs.getString("mothername"));

                obj.put("mothereducation",
                        rs.getString("mothereducation"));

                obj.put("motheroccupation",
                        rs.getString("motheroccupation"));

                obj.put("motherannualincome",
                        rs.getString("motherannualincome"));

                obj.put("nameofschool",
                        rs.getString("nameofschool"));

                obj.put("marksplustwo",
                        rs.getString("marksplustwo"));

                // =========================================
                // DIFFERENTLY ABLED
                // =========================================

                String differentlyabledid =
                        rs.getString("differentlyabledtypeid");

                String hostelValue =
                        rs.getString("isphysicallychallenged");

                String finalValue = "No";

                if (differentlyabledid != null) {

                    if ("8".equals(differentlyabledid)) {

                        finalValue = "No";

                    } else {

                        finalValue = "Yes";
                    }

                } else {

                    if ("Y".equalsIgnoreCase(hostelValue)) {

                        finalValue = "Yes";

                    } else {

                        finalValue = "No";
                    }
                }

                obj.put("isphysicallychallenged",
                        finalValue);

                // =========================================
                // ADDRESS DETAILS
                // =========================================

                obj.put("premadd1",
                        rs.getString("premadd1"));

                obj.put("premadd2",
                        rs.getString("premadd2"));

                obj.put("premadd3",
                        rs.getString("premadd3"));

                obj.put("prem_distid",
                        rs.getString("prem_distid"));

                obj.put("pincode",
                        rs.getString("pincode"));

                obj.put("parentmobile",
                        rs.getString("parentmobile"));

                obj.put("parentemail",
                        rs.getString("parentemail"));

                obj.put("officename",
                        rs.getString("officename"));

                // =========================================
                // UPDATED DATE
                // =========================================

                Timestamp updated =
                        rs.getTimestamp("updated_on");

                obj.put("updated_on",
                        updated != null
                        ? dateTimeFormat.format(updated)
                        : "");

                obj.put("permstate",
                        rs.getString("permstate"));

                obj.put("maxmark",
                        rs.getString("maxmark"));

                obj.put("bloodgroupid",
                        rs.getString("bloodgroupid"));

                // =========================================
                // GUARDIAN DETAILS
                // =========================================

                obj.put("guardianrelation",
                        rs.getString("guardianrelation"));

                obj.put("guardline1",
                        rs.getString("guardline1"));

                obj.put("guardline2",
                        rs.getString("guardline2"));

                obj.put("guardline3",
                        rs.getString("guardline3"));

                obj.put("guardianmobile",
                        rs.getString("guardianmobile"));

                obj.put("guardianemail",
                        rs.getString("guardianemail"));

                obj.put("guardstate",
                        rs.getString("guardstate"));

                obj.put("guarddist",
                        rs.getString("guarddist"));

                arr.add(obj);
            }
        }

    } catch (Exception e) {

        System.out.println(
                "\n\nCatch in HostelApplicantDAO.getSelectedApplicants\n\n");

        e.printStackTrace();
    }

    return arr;
}

    public static JSONObject getStudentByRegNo(String regno) {

        JSONObject obj = new JSONObject();

        String sql = "SELECT * FROM hostel.hostelpersonaldetails h "
                + "LEFT JOIN hostel.guardiandetails g ON h.registerno = g.registerno "
                + "LEFT JOIN hostel.mens_hostelregistration m ON h.registerno = m.registerno "
                + "LEFT JOIN lccerp.distlist d ON h.distid = d.distid "
                + "WHERE h.registerno = ?";

        try (Connection con = new CyberCon().ErpConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, regno);

            System.out.println("\n\ngetStudentByRegNo:\n" + ps.toString());

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    obj.put("registerno", rs.getString("registerno"));
                    obj.put("studentname", rs.getString("studentname"));
                    obj.put("institutionname", rs.getString("institutionname"));
                    obj.put("studentprogram", rs.getString("studentprogram"));
                    obj.put("gender", rs.getString("gender"));
                    obj.put("studentmobilenumber", rs.getString("studentmobilenumber"));
                    obj.put("studentemailid", rs.getString("studentemailid"));
                    obj.put("fathername", rs.getString("fathername"));
                    obj.put("dateofbirth", rs.getString("dateofbirth"));
                    obj.put("distid", rs.getString("distid"));
                    obj.put("state", rs.getString("state"));
                    obj.put("category", rs.getString("category"));
                    obj.put("caste", rs.getString("casteid"));
                    obj.put("religion", rs.getString("religion"));
                    obj.put("premadd1", rs.getString("premadd1"));
                    obj.put("premadd2", rs.getString("premadd2"));
                    obj.put("premadd3", rs.getString("premadd3"));
                    obj.put("parentmobile", rs.getString("parentmobile"));
                }
            }

        } catch (Exception e) {
            System.out.println("ERROR in getStudentByRegNo");
            e.printStackTrace();
        }

        return obj;
    }

    public static JSONArray getSelectedRegisterNos() {

        JSONArray arr = new JSONArray();

        String sql = "SELECT registerno FROM hostel.mens_hostelregistration WHERE isselected = 'Y' ORDER BY registerno";

        try (Connection con = new CyberCon().ErpConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            System.out.println("\n\ngetSelectedRegisterNos:\n" + ps.toString());

            while (rs.next()) {

                JSONObject obj = new JSONObject();

                obj.put("registerno", rs.getString("registerno"));

                arr.add(obj);
            }

        } catch (Exception e) {

            System.out.println("\n\nCatch in getSelectedRegisterNos\n\n");
            e.printStackTrace();
        }

        return arr;
    }

public static JSONArray getInstitutions() {

    JSONArray arr = new JSONArray();

    String sql =
            "SELECT "
            + "    institutionid, "
            + "    institutename "
            + "FROM lccerp.institution "
            + "ORDER BY institutename ASC";

    try (Connection con = new CyberCon().ErpConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()) {

        System.out.println("\n\ngetInstitutions Query : " + ps);

        while (rs.next()) {

            JSONObject obj = new JSONObject();

            obj.put("institutionid",
        rs.getString("institutionid"));

            obj.put("institutename",
                    rs.getString("institutename"));

            arr.add(obj);
        }

    } catch (Exception e) {

        System.out.println("\n\nCatch in getInstitutions\n\n");
        e.printStackTrace();
    }

    return arr;
}

    public static JSONArray getAcademicYears() {

        JSONArray arr = new JSONArray();

        String sql = "SELECT academicyearid, academicyear FROM lccerp.academicyears ORDER BY academicyear DESC";

        try (Connection con = new CyberCon().ErpConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                JSONObject obj = new JSONObject();

                obj.put("academicyearid", rs.getString("academicyearid"));
                obj.put("academicyear", rs.getString("academicyear"));

                arr.add(obj);
            }

        } catch (Exception e) {

            System.out.println("\n\n\nCatch in getAcademicYears\n\n\n");
            e.printStackTrace();
        }

        return arr;
    }

    public static JSONArray getOffices() {

        JSONArray arr = new JSONArray();

        String sql = "SELECT officeid, officename FROM lccerp.officemaster ORDER BY officename";

        try (Connection con = new CyberCon().ErpConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                JSONObject obj = new JSONObject();

                obj.put("officeid", rs.getString("officeid"));
                obj.put("officename", rs.getString("officename"));

                arr.add(obj);
            }

        } catch (Exception e) {

            System.out.println("\n\n\nCatch in getOffices\n\n\n");
            e.printStackTrace();
        }

        return arr;
    }

    public static JSONArray getReligions() {

        JSONArray arr = new JSONArray();

        String sql = "SELECT religionid, religion FROM lccerp.religion ORDER BY sortnumber";

        try (Connection con = new CyberCon().ErpConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            System.out.println("\n\ngetReligions:\n" + ps.toString());

            while (rs.next()) {

                JSONObject obj = new JSONObject();

                obj.put("religionid", rs.getLong("religionid"));
                obj.put("religion", rs.getString("religion"));

                arr.add(obj);
            }

        } catch (Exception e) {

            System.out.println("\n\nCatch in getReligions\n\n");
            e.printStackTrace();
        }

        return arr;
    }

    public static JSONArray getCategories() {

        JSONArray arr = new JSONArray();

        String sql = "SELECT categoryid, category FROM lccerp.category ORDER BY category";

        try (Connection con = new CyberCon().ErpConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            System.out.println("\n\ngetCategories:\n" + ps.toString());

            while (rs.next()) {

                JSONObject obj = new JSONObject();

                obj.put("categoryid", rs.getLong("categoryid"));
                obj.put("category", rs.getString("category"));

                arr.add(obj);
            }

        } catch (Exception e) {

            System.out.println("\n\nCatch in getCategories\n\n");
            e.printStackTrace();
        }

        return arr;
    }

    public static JSONArray getStates() {

        JSONArray arr = new JSONArray();

        String sql = "SELECT stateid, statename FROM lccerp.state ORDER BY statename";

        try (Connection con = new CyberCon().ErpConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            System.out.println("\n\ngetStates:\n" + ps.toString());

            while (rs.next()) {

                JSONObject obj = new JSONObject();

                obj.put("stateid", rs.getLong("stateid"));
                obj.put("statename", rs.getString("statename"));

                arr.add(obj);
            }

        } catch (Exception e) {

            System.out.println("\n\nCatch in getStates\n\n");
            e.printStackTrace();
        }

        return arr;
    }

    public static JSONArray getDistricts() {

        JSONArray arr = new JSONArray();

        String sql = "SELECT distid, distname FROM lccerp.distlist ORDER BY distname";

        try (Connection con = new CyberCon().ErpConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            System.out.println("\n\ngetDistricts:\n" + ps.toString());

            while (rs.next()) {

                JSONObject obj = new JSONObject();

                obj.put("distid", rs.getLong("distid"));
                obj.put("distname", rs.getString("distname"));

                arr.add(obj);
            }

        } catch (Exception e) {

            System.out.println("\n\nERROR in getDistricts\n\n");
            e.printStackTrace();
        }

        return arr;
    }

    public static String getFullHostelStudentProfile(String userid) {
        System.out.println("Register NO: " + userid);
        JSONObject result = new JSONObject();
//        if (userid == null || userid.trim().isEmpty()) {
//            result.put("error", "Invalid session");
//            return result.toJSONString();
//        }

//        String sql = """
//SELECT
//    hr.applicationno,
//    hr.registerno,
//    hr.institutionid,
//    hp.village,
//    hp.town,
//    hp.maxmark,
//    hp.fatheroccupationid,
//    hp.motheroccupationid,
//    hp.prem_distid,
//    hp.filename,
//    sm.differentlyabledtypeid,
//
//    -- NAME
//    COALESCE(sm.studentname, hp.studentname) AS studentname,
//
//    -- DOB
//    COALESCE(sm.dob, hp.dateofbirth) AS dob,
//
//    -- GENDER
//    COALESCE(g.gender, hp.gender, '') AS gender_name,
//
//    -- MOBILE ( keep alias consistent with DAO)
//    COALESCE(sd.studentmobilenumber, hp.studentmobilenumber) AS studentmobilenumber,
//
//    -- EMAIL
//    COALESCE(sd.studentemail, hp.studentemailid) AS studentemail,
//
//    -- COLLEGE
//    COALESCE(o.officename, hp.college) AS office_name,
//
//    -- OFFICE ID
//    sm.officeid AS officeid,
//
//    -- COURSE
//    COALESCE(c.description, hp.studentprogram) AS course_description,
//    
//    hp.permstate,
//                                     
//    -- DISTRICT
//    COALESCE(dl.distname, dl2.distname) AS district_name,
//    dl3.distname AS prem_district,
//
//    -- DISTRICT ID
//    COALESCE(sd.distid, hp.distid) AS distid,
//
//    -- STATE
//    COALESCE(st.statename, hp.state) AS state_name,
//    COALESCE(st.stateid, st2.stateid) AS stateid,
//    
//    COALESCE(sd.mothertongueid, lang2.langid) AS mothertongueid,
//    COALESCE(sd.religionid, r2.religionid) AS religionid,
//    COALESCE(r1.religion, r2.religion, hp.religion) AS religion,
//              
//    COALESCE(sd.categoryid, cat2.categoryid) AS categoryid,
//    COALESCE(cat1.category, cat2.category, hp.category) AS category,              
//                     
//    COALESCE(sd.casteid::text, hp.casteid) AS casteid,
//
//    -- ✅ BLOOD GROUP
//    COALESCE(bg.bloodgroup, hp.bloodgroup) AS bloodgroup,
//    COALESCE(sd.bloodgroupid, hp.bloodgroupid) AS bloodgroupid,
//
//    -- ✅ MOTHER TONGUE
//    COALESCE(lang1.lang, lang2.lang, hp.mothertongue) AS mothertongue,
//
//    -- ✅ PARENTS
//    COALESCE(sd.fathername, hp.fathername) AS fathername,
//    COALESCE(sd.mothername, hp.mothername) AS mothername,
//
//    COALESCE(sd.fathereducation, hp.fathereducation) AS fathereducation,
//    COALESCE(sd.mothereducation, hp.mothereducation) AS mothereducation,
//
//    COALESCE(sd.occupation, hp.fatheroccupation) AS father_occupation,
//    COALESCE(sd.motheroccupation, hp.motheroccupation) AS motheroccupation,
//
//    COALESCE(sd.annualincome, hp.fatherannualincome) AS father_income,
//    COALESCE(sd.motherannualincome, hp.motherannualincome) AS motherannualincome,
//
//    -- ✅ ACADEMIC
//    COALESCE(sd.school_name_12, hp.nameofschool) AS school_name_12,
//    COALESCE(sd.overall_obtain, hp.marksplustwo) AS overall_obtain,
//
//    -- ✅ ADDRESS
//    COALESCE(
//        sd.address,
//        CONCAT_WS(',', hp.premadd1, hp.premadd2, hp.premadd3)
//    ) AS address,
//
//    COALESCE(sd.pincode, hp.pincode) AS pincode,
//    COALESCE(hp.studentphoto, '') AS studentphoto,
//
//    -- ✅ CONTACT
//    COALESCE(sd.parentmobilenumber, hp.parentmobile) AS parentmobilenumber,
//    COALESCE(sd.parentemail, hp.parentemail) AS parentemail,
//
//    -- ✅ GUARDIAN
//    gd.guardianrelation AS guardianname,
//    gd.guardline1,
//    gd.guardline2,
//    gd.guardline3,
//    gd.distid AS guard_distid,
//    gd.pincode AS guard_pincode,
//    gd.guardianmobile,
//    gd.guardianemail,
//    gd.guardstate,
//    gd.guarddist,
//
//    -- ✅ INSTITUTION
//    ins.institutename
//
//FROM hostel.mens_hostelregistration hr
//
//-- STUDENT MASTER
//LEFT JOIN lccerp.student_studentmaster sm
//    ON sm.registerno = hr.registerno 
//    AND sm.activestatus = 1
//
//LEFT JOIN lccerp.student_studentmasterdetails sd
//    ON sd.studentid = sm.studentid
//
//-- PERSONAL DETAILS
//LEFT JOIN hostel.hostelpersonaldetails hp
//    ON hp.registerno = hr.registerno
//                     
//LEFT JOIN lccerp.state st2 ON st2.statename = hp.state
//                     
//-- ✅ LOOKUPS
//LEFT JOIN lccerp.gender g 
//    ON g.genderid = sm.sex
//
//LEFT JOIN lccerp.religion r1 
//    ON r1.religionid = sd.religionid
//
//LEFT JOIN lccerp.religion r2 
//    ON LOWER(TRIM(r2.religion)) = LOWER(TRIM(hp.religion))
//
//LEFT JOIN lccerp.category cat1 
//    ON cat1.categoryid = sd.categoryid
//
//LEFT JOIN lccerp.category cat2 
//    ON LOWER(TRIM(cat2.category)) = LOWER(TRIM(hp.category))
//
//LEFT JOIN lccerp.bloodgroup bg 
//    ON bg.bloodgroupid = sd.bloodgroupid 
//
//LEFT JOIN lccerp.languages lang1 
//    ON lang1.langid = sd.mothertongueid
//
//LEFT JOIN lccerp.languages lang2 
//    ON LOWER(TRIM(lang2.lang)) = LOWER(TRIM(hp.mothertongue))
//
//-- ✅ DISTRICT
//LEFT JOIN lccerp.distlist dl 
//    ON dl.distid = sd.distid
//
//LEFT JOIN lccerp.distlist dl2 
//    ON dl2.distid = hp.distid
//                     
//LEFT JOIN lccerp.distlist dl3 
//    ON dl3.distid = hp.prem_distid
//
//-- ✅ STATE
//LEFT JOIN lccerp.state st 
//    ON st.stateid = dl.stateid
//
//-- ✅ COURSE / OFFICE
//LEFT JOIN lccerp.courses c 
//    ON c.courseid = sm.courseid
//
//LEFT JOIN lccerp.officemaster o 
//    ON o.officeid = sm.officeid
//
//-- ✅ GUARDIAN
//LEFT JOIN hostel.guardiandetails gd 
//    ON gd.registerno = hr.registerno
//
//-- ✅ INSTITUTION
//LEFT JOIN lccerp.institution ins 
//    ON ins.institutionid = hr.institutionid
//
//WHERE hr.registerno = ?
//""";
       String sql =
    "SELECT "
    + "h.applicationno, "
    + "h.registerno, "
    + "h.studentname, "
    + "h.institutionname, "
    + "h.studentmobilenumber, "
    + "h.studentemailid, "
    + "h.gender, "
    + "h.bloodgroup, "
    + "h.category, "
    + "h.religion, "
    + "h.state, "
    + "h.village, "
    + "h.town, "
    + "h.parentmobile, "
    + "h.parentemail, "
    + "h.studentphoto, "
    + "h.updated_on "
    + "FROM hostel.hostelpersonaldetails h "
    + "INNER JOIN hostel.mens_hostelregistration m "
    + "ON h.registerno = m.registerno "
    + "AND m.isselected = 'N' "
    + "AND m.isappfeespaid = 'Y' "
    + "ORDER BY h.updated_on DESC";
        try (Connection conn = new CyberCon().ErpConnection();
     PreparedStatement ps = conn.prepareStatement(sql)) {

    System.out.println("Fetch details DAO " + userid);

    ps.setString(1, userid);

    try (ResultSet rs = ps.executeQuery()) {

        System.out.println("\n\n" + rs);

        if (!rs.next()) {
            result.put("error", "No hostel registration found.");
            return result.toJSONString();
        }

        // === BASIC INFO ===
        result.put("filename", nullToEmpty(rs.getString("filename")));
        result.put("studentphoto", nullToEmpty(rs.getString("studentphoto")));

        result.put("applicationno", nullToEmpty(rs.getString("applicationno")));
        result.put("regno", nullToEmpty(rs.getString("registerno")));
        result.put("name", nullToEmpty(rs.getString("studentname")));
        result.put("institution", nullToEmpty(rs.getString("institutename")));

        result.put("officeid", "");
        result.put("stateid", "");

        result.put("dob", formatDate(rs.getDate("dob")));
        result.put("gender", nullToEmpty(rs.getString("gender_name")));

        result.put("mobile",
                nullToEmpty(rs.getString("studentmobilenumber")));

        result.put("email",
                nullToEmpty(rs.getString("studentemail")));

        // === COURSE & COLLEGE ===
        result.put("course_description",
                nullToEmpty(rs.getString("course_description")));

        result.put("office_name",
                nullToEmpty(rs.getString("office_name")));

        // === STATE & DISTRICT ===
        result.put("statename",
                nullToEmpty(rs.getString("state_name")));

        result.put("district", "");
        result.put("districtid", "");

        result.put("village",
                nullToEmpty(rs.getString("village")));

        result.put("town",
                nullToEmpty(rs.getString("town")));

        // === DIFFERENTLY ABLED ===
        result.put("differentlyabled",
                nullToEmpty(rs.getString("isphysicallychallenged")));

        // === PARENTS & FAMILY ===
        result.put("fathername",
                nullToEmpty(rs.getString("fathername")));

        result.put("mothername",
                nullToEmpty(rs.getString("mothername")));

        result.put("guardianname",
                nullToEmpty(rs.getString("guardianname")));

        result.put("father_occupation",
                nullToEmpty(rs.getString("father_occupation")));

        result.put("mother_occupation",
                nullToEmpty(rs.getString("motheroccupation")));

        result.put("fatheroccupationid", "");
        result.put("motheroccupationid", "");

        result.put("father_income",
                rs.getObject("father_income") != null
                ? rs.getString("father_income") : "0");

        result.put("mother_income",
                rs.getObject("motherannualincome") != null
                ? rs.getString("motherannualincome") : "0");

        result.put("father_education",
                nullToEmpty(rs.getString("fathereducation")));

        result.put("mother_education",
                nullToEmpty(rs.getString("mothereducation")));

        // === ACADEMIC ===
        result.put("school",
                nullToEmpty(rs.getString("school_name_12")));

        result.put("mark_200",
                nullToEmpty(rs.getString("overall_obtain")));

        result.put("mark_100",
                nullToEmpty(rs.getString("maxmark")));

        // === CONTACT ===
        result.put("parent_mobile",
                nullToEmpty(rs.getString("parentmobilenumber")));

        result.put("parent_email",
                nullToEmpty(rs.getString("parentemail")));

        // === LOOKUP VALUES ===
        result.put("bloodgroup",
                nullToEmpty(rs.getString("bloodgroup")));

        result.put("bloodgroupid", "");

        result.put("mothertongueid", "");

        result.put("mothertongue",
                nullToEmpty(rs.getString("mothertongue")));

        result.put("religion",
                nullToEmpty(rs.getString("religion")));

        result.put("community",
                nullToEmpty(rs.getString("category")));

        result.put("caste",
                nullToEmpty(rs.getString("casteid")));

        result.put("religionid", "");
        result.put("communityid", "");

        // === ADDRESS SPLIT ===
        String fullAddr =
                nullToEmpty(rs.getString("premadd1")) + "," +
                nullToEmpty(rs.getString("premadd2")) + "," +
                nullToEmpty(rs.getString("premadd3"));

        String[] lines =
                fullAddr.isEmpty() ? new String[0] : fullAddr.split(",", 4);

        result.put("address_line1",
                lines.length > 0 ? lines[0].trim() : "");

        result.put("address_line2",
                lines.length > 1 ? lines[1].trim() : "");

        result.put("address_line3",
                lines.length > 2 ? lines[2].trim() : "");

        result.put("permState",
                nullToEmpty(rs.getString("permstate")));

        result.put("prem_distid", "");
        result.put("prem_district", "");

        result.put("pincode",
                nullToEmpty(rs.getString("pincode")));

        // === GUARDIAN ===
        result.put("guardianName",
                nullToEmpty(rs.getString("guardianname")));

        result.put("guard_address_line1",
                nullToEmpty(rs.getString("guardline1")));

        result.put("guard_address_line2",
                nullToEmpty(rs.getString("guardline2")));

        result.put("guard_address_line3",
                nullToEmpty(rs.getString("guardline3")));

        result.put("guardState",
                nullToEmpty(rs.getString("guardstate")));

        result.put("guarddistrict",
                nullToEmpty(rs.getString("guarddist")));

        result.put("guarddistid", "");

        result.put("guard_pincode",
                nullToEmpty(rs.getString("guard_pincode")));

        result.put("guardian_mobile",
                nullToEmpty(rs.getString("guardianmobile")));

        result.put("guardian_email",
                nullToEmpty(rs.getString("guardianemail")));

        // === AGE CALCULATION ===
        String dobStr = result.get("dob").toString();

        if (dobStr.matches("^\\d{2}-\\d{2}-\\d{4}$")) {

            String[] p = dobStr.split("-");

            int day = Integer.parseInt(p[0]);
            int month = Integer.parseInt(p[1]);
            int year = Integer.parseInt(p[2]);

            java.util.Calendar dobCal =
                    java.util.Calendar.getInstance();

            dobCal.set(year, month - 1, day);

            java.util.Calendar todayCal =
                    java.util.Calendar.getInstance();

            int years =
                    todayCal.get(java.util.Calendar.YEAR)
                    - dobCal.get(java.util.Calendar.YEAR);

            int months =
                    todayCal.get(java.util.Calendar.MONTH)
                    - dobCal.get(java.util.Calendar.MONTH);

            int daysDiff =
                    todayCal.get(java.util.Calendar.DAY_OF_MONTH)
                    - dobCal.get(java.util.Calendar.DAY_OF_MONTH);

            if (daysDiff < 0) {

                months--;

                java.util.Calendar lastMonth =
                        (java.util.Calendar) todayCal.clone();

                lastMonth.add(java.util.Calendar.MONTH, -1);

                daysDiff +=
                        lastMonth.getActualMaximum(
                                java.util.Calendar.DAY_OF_MONTH);
            }

            if (months < 0) {
                years--;
                months += 12;
            }

            result.put("age",
                    years + " Years " + months + " Months");

        } else {

            result.put("age", "");
        }
    }

} catch (Exception e) {

    result.put("error",
            "Database Connection not established: "
            + e.getMessage());

    e.printStackTrace();
}

return result.toJSONString();
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
    
public JSONObject getSingleApplicationPdf(String userid)
        throws Exception {

    JSONObject obj = new JSONObject();

    String sql =
        "SELECT "
      + "h.registerno, h.applicationno, h.institutionname, h.studentname, "
      + "h.college, h.studentprogram, h.bloodgroup, h.dateofbirth, h.gender, "
      + "h.studentmobilenumber, h.studentemailid, h.state, h.distid, "
      + "h.village, h.town, h.mothertongue, h.religion, h.category, h.casteid, "
      + "h.fathername, h.fathereducation, h.fatheroccupation, h.fatherannualincome, "
      + "h.mothername, h.mothereducation, h.motheroccupation, h.motherannualincome, "
      + "h.nameofschool, h.marksplustwo, h.maxmark, h.isphysicallychallenged, "
      + "h.premadd1, h.premadd2, h.premadd3, h.prem_distid, h.pincode, "
      + "h.parentmobile, h.parentemail, h.officename, h.permstate, "
      + "h.bloodgroupid, h.filename, h.studentphoto, h.updated_on, "
      + "g.guardianrelation, g.guardline1, g.guardline2, g.guardline3, "
      + "g.guardianmobile, g.guardianemail, g.guardstate, g.guarddist "
      + "FROM hostel.hostelpersonaldetails h "
      + "LEFT JOIN hostel.guardiandetails g "
      + "ON g.registerno = h.registerno "
      + "LEFT JOIN hostel.mens_hostelregistration m "
      + "ON m.registerno = h.registerno "
      + "WHERE h.registerno = ?";

    SimpleDateFormat dfDate =
            new SimpleDateFormat("dd-MM-yyyy");

    SimpleDateFormat dfDT =
            new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

    try (Connection con = new CyberCon().ErpConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, userid);

        try (ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {

    obj.put("registerno",
            rs.getString("registerno"));

    obj.put("applicationno",
            rs.getString("applicationno"));

    obj.put("institutionname",
            rs.getString("institutionname"));

    obj.put("studentname",
            rs.getString("studentname"));

    obj.put("college",
            rs.getString("college"));

    obj.put("studentprogram",
            rs.getString("studentprogram"));

    obj.put("bloodgroup",
            rs.getString("bloodgroup"));

    java.sql.Date dob =
            rs.getDate("dateofbirth");

    obj.put("dateofbirth",
            dob != null
            ? dfDate.format(dob) : "");

    obj.put("gender",
            rs.getString("gender"));

    obj.put("studentmobilenumber",
            rs.getString("studentmobilenumber"));

    obj.put("studentemailid",
            rs.getString("studentemailid"));

    obj.put("state",
            rs.getString("state"));

    obj.put("distid",
            rs.getString("distid"));

    obj.put("village",
            rs.getString("village"));

    obj.put("town",
            rs.getString("town"));

    obj.put("mothertongue",
            rs.getString("mothertongue"));

    obj.put("religion",
            rs.getString("religion"));

    obj.put("category",
            rs.getString("category"));

    obj.put("casteid",
            rs.getString("casteid"));

    obj.put("fathername",
            rs.getString("fathername"));

    obj.put("fathereducation",
            rs.getString("fathereducation"));

    obj.put("fatheroccupation",
            rs.getString("fatheroccupation"));

    obj.put("fatherannualincome",
            rs.getString("fatherannualincome"));

    obj.put("mothername",
            rs.getString("mothername"));

    obj.put("mothereducation",
            rs.getString("mothereducation"));

    obj.put("motheroccupation",
            rs.getString("motheroccupation"));

    obj.put("motherannualincome",
            rs.getString("motherannualincome"));

    obj.put("nameofschool",
            rs.getString("nameofschool"));

    obj.put("marksplustwo",
            rs.getString("marksplustwo"));

    obj.put("maxmark",
            rs.getString("maxmark"));

    obj.put("isphysicallychallenged",
            rs.getString("isphysicallychallenged"));

    obj.put("premadd1",
            rs.getString("premadd1"));

    obj.put("premadd2",
            rs.getString("premadd2"));

    obj.put("premadd3",
            rs.getString("premadd3"));

    obj.put("prem_distid",
            rs.getString("prem_distid"));

    obj.put("pincode",
            rs.getString("pincode"));

    obj.put("parentmobile",
            rs.getString("parentmobile"));

    obj.put("parentemail",
            rs.getString("parentemail"));

    obj.put("officename",
            rs.getString("officename"));

    obj.put("permstate",
            rs.getString("permstate"));

    obj.put("bloodgroupid",
            rs.getString("bloodgroupid"));

    obj.put("filename",
            rs.getString("filename"));

    obj.put("studentphoto",
            rs.getString("studentphoto"));

    Timestamp upd =
            rs.getTimestamp("updated_on");

    obj.put("updated_on",
            upd != null
            ? dfDT.format(upd) : "");

    obj.put("guardianrelation",
            rs.getString("guardianrelation"));

    obj.put("guardline1",
            rs.getString("guardline1"));

    obj.put("guardline2",
            rs.getString("guardline2"));

    obj.put("guardline3",
            rs.getString("guardline3"));

    obj.put("guardianmobile",
            rs.getString("guardianmobile"));

    obj.put("guardianemail",
            rs.getString("guardianemail"));

    obj.put("guardstate",
            rs.getString("guardstate"));

    obj.put("guarddist",
            rs.getString("guarddist"));
}
        }
    }

    return obj;
}

public List<JSONObject> getApplicationsForPdf(
        String fromAppNo,
        String toAppNo) throws Exception {

    List<JSONObject> list = new ArrayList<>();

    String sql =
        "SELECT "
      + "h.registerno, h.applicationno, h.institutionname, h.studentname, "
      + "h.college, h.studentprogram, h.bloodgroup, h.dateofbirth, h.gender, "
      + "h.studentmobilenumber, h.studentemailid, h.state, h.village, h.town, "
      + "h.mothertongue, h.religion, h.category, h.casteid, "
      + "h.fathername, h.fathereducation, h.fatheroccupation, h.fatherannualincome, "
      + "h.mothername, h.mothereducation, h.motheroccupation, h.motherannualincome, "
      + "h.nameofschool, h.marksplustwo, h.maxmark, h.isphysicallychallenged, "
      + "h.premadd1, h.premadd2, h.premadd3, h.prem_distid, h.pincode, "
      + "h.parentmobile, h.parentemail, h.officename, h.permstate, "
      + "h.filename, h.updated_on, "

      + "g.guardianrelation, "
      + "g.guardline1, "
      + "g.guardline2, "
      + "g.guardline3, "
      + "g.distid, "
      + "g.pincode AS guard_pincode, "
      + "g.guardianmobile, "
      + "g.guardianemail, "
      + "g.guardstate, "
      + "g.guarddist, "
      + "g.guardstateid "

      + "FROM hostel.hostelpersonaldetails h "

      + "LEFT JOIN hostel.guardiandetails g "
      + "ON g.registerno = h.registerno "

      + "LEFT JOIN hostel.mens_hostelregistration m "
      + "ON m.registerno = h.registerno "

      + "WHERE m.isappfeespaid = 'Y' "
      + "AND h.applicationno >= ? "
      + "AND h.applicationno <= ? "

      + "ORDER BY h.applicationno";

    SimpleDateFormat dfDate =
            new SimpleDateFormat("dd-MM-yyyy");

    SimpleDateFormat dfDT =
            new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

    try (Connection con = new CyberCon().ErpConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, fromAppNo);
        ps.setString(2, toAppNo);

        try (ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                JSONObject o = new JSONObject();

                o.put("registerno",
                        rs.getString("registerno"));

                o.put("applicationno",
                        rs.getString("applicationno"));

                o.put("institutionname",
                        rs.getString("institutionname"));

                o.put("studentname",
                        rs.getString("studentname"));

                o.put("college",
                        rs.getString("college"));

                o.put("studentprogram",
                        rs.getString("studentprogram"));

                o.put("bloodgroup",
                        rs.getString("bloodgroup"));

                java.sql.Date dob =
                        rs.getDate("dateofbirth");

                o.put("dateofbirth",
                        dob != null
                        ? dfDate.format(dob) : "");

                o.put("gender",
                        rs.getString("gender"));

                o.put("studentmobilenumber",
                        rs.getString("studentmobilenumber"));

                o.put("studentemailid",
                        rs.getString("studentemailid"));

                o.put("state",
                        rs.getString("state"));

                o.put("village",
                        rs.getString("village"));

                o.put("town",
                        rs.getString("town"));

                o.put("mothertongue",
                        rs.getString("mothertongue"));

                o.put("religion",
                        rs.getString("religion"));

                o.put("category",
                        rs.getString("category"));

                o.put("casteid",
                        rs.getString("casteid"));

                o.put("fathername",
                        rs.getString("fathername"));

                o.put("fathereducation",
                        rs.getString("fathereducation"));

                o.put("fatheroccupation",
                        rs.getString("fatheroccupation"));

                o.put("fatherannualincome",
                        rs.getString("fatherannualincome"));

                o.put("mothername",
                        rs.getString("mothername"));

                o.put("mothereducation",
                        rs.getString("mothereducation"));

                o.put("motheroccupation",
                        rs.getString("motheroccupation"));

                o.put("motherannualincome",
                        rs.getString("motherannualincome"));

                o.put("nameofschool",
                        rs.getString("nameofschool"));

                o.put("marksplustwo",
                        rs.getString("marksplustwo"));

                o.put("maxmark",
                        rs.getString("maxmark"));

                String pc =
                        rs.getString("isphysicallychallenged");

                o.put("isphysicallychallenged",
                        "Y".equalsIgnoreCase(pc)
                        ? "Yes" : "No");

                o.put("premadd1",
                        rs.getString("premadd1"));

                o.put("premadd2",
                        rs.getString("premadd2"));

                o.put("premadd3",
                        rs.getString("premadd3"));

                o.put("pincode",
                        rs.getString("pincode"));

                o.put("parentmobile",
                        rs.getString("parentmobile"));

                o.put("parentemail",
                        rs.getString("parentemail"));

                o.put("officename",
                        rs.getString("officename"));

                o.put("permstate",
                        rs.getString("permstate"));

                o.put("filename",
                        rs.getString("filename"));

                Timestamp upd =
                        rs.getTimestamp("updated_on");

                o.put("updated_on",
                        upd != null
                        ? dfDT.format(upd) : "");

                /* GUARDIAN DETAILS */

                o.put("guardianrelation",
                        rs.getString("guardianrelation"));

                o.put("guardline1",
                        rs.getString("guardline1"));

                o.put("guardline2",
                        rs.getString("guardline2"));

                o.put("guardline3",
                        rs.getString("guardline3"));

                o.put("distid",
                        rs.getString("distid"));

                o.put("guard_pincode",
                        rs.getString("guard_pincode"));

                o.put("guardianmobile",
                        rs.getString("guardianmobile"));

                o.put("guardianemail",
                        rs.getString("guardianemail"));

                o.put("guardstate",
                        rs.getString("guardstate"));

                o.put("guarddist",
                        rs.getString("guarddist"));

                o.put("guardstateid",
                        rs.getString("guardstateid"));

                list.add(o);
            }
        }
    }

    return list;
}
    public boolean updateHostelStudent(JSONObject o) throws Exception {
        String sql1 =
            "UPDATE hostel.hostelpersonaldetails SET "
          + "studentname=?, "
          + "studentmobilenumber=?, "
          + "studentemailid=?, "
          + "fathername=?, "
          + "mothername=?, "
          + "fathereducation=?, "
          + "mothereducation=?, "
          + "fatheroccupation=?, "
          + "motheroccupation=?, "
          + "fatherannualincome=?, "
          + "motherannualincome=?, "
          + "premadd1=?, "
          + "premadd2=?, "
          + "premadd3=?, "
          + "pincode=?, "
          + "parentmobile=?, "
          + "parentemail=?, "
          + "village=?, "
          + "town=?, "
          + "state=?, "
          + "religion=?, "
          + "category=?, "
          + "bloodgroup=? "
          + "WHERE registerno=?";

         String sql2 =
            "UPDATE hostel.guardiandetails SET "
          + "guardianrelation=?, "
          + "guardline1=?, "
          + "guardline2=?, "
          + "guardline3=?, "
          + "guardianmobile=?, "
          + "guardianemail=?, "
          + "guardstate=?, "
          + "guarddist=?, "
          + "pincode=? "
          + "WHERE registerno=?";

        try (Connection con = new CyberCon().ErpConnection()) {

            con.setAutoCommit(false);

            try (PreparedStatement ps1 = con.prepareStatement(sql1);
                 PreparedStatement ps2 = con.prepareStatement(sql2)) {

                // ── Bind sql1 parameters ──────────────────────────
                ps1.setString(1,  (String) o.get("studentname"));
                ps1.setString(2,  (String) o.get("studentmobilenumber"));
                ps1.setString(3,  (String) o.get("studentemailid"));
                ps1.setString(4,  (String) o.get("fathername"));
                ps1.setString(5,  (String) o.get("mothername"));
                ps1.setString(6,  (String) o.get("fathereducation"));
                ps1.setString(7,  (String) o.get("mothereducation"));
                ps1.setString(8,  (String) o.get("fatheroccupation"));
                ps1.setString(9,  (String) o.get("motheroccupation"));
                ps1.setBigDecimal(
        10,
        new java.math.BigDecimal(
            o.get("fatherannualincome").toString()
        )
);

ps1.setBigDecimal(
        11,
        new java.math.BigDecimal(
            o.get("motherannualincome").toString()
        )
);
                ps1.setString(12, (String) o.get("premadd1"));
                ps1.setString(13, (String) o.get("premadd2"));
                ps1.setString(14, (String) o.get("premadd3"));
                ps1.setString(15, (String) o.get("pincode"));
                ps1.setString(16, (String) o.get("parentmobile"));
                ps1.setString(17, (String) o.get("parentemail"));
                ps1.setString(18, (String) o.get("village"));
                ps1.setString(19, (String) o.get("town"));
                ps1.setString(20, (String) o.get("state"));
                ps1.setString(21, (String) o.get("religion"));
                ps1.setString(22, (String) o.get("category"));
                ps1.setString(23, (String) o.get("bloodgroup"));
                ps1.setString(24, (String) o.get("registerno"));

                int rows1 = ps1.executeUpdate();
                System.out.println("updateHostelStudent sql1 rows updated: " + rows1);

                // ── Bind sql2 parameters ──────────────────────────
                ps2.setString(1,  (String) o.get("guardianrelation"));
                ps2.setString(2,  (String) o.get("guardline1"));
                ps2.setString(3,  (String) o.get("guardline2"));
                ps2.setString(4,  (String) o.get("guardline3"));
                ps2.setString(5,  (String) o.get("guardianmobile"));
                ps2.setString(6,  (String) o.get("guardianemail"));
                ps2.setString(7,  (String) o.get("guardstate"));
                ps2.setString(8,  (String) o.get("guarddist"));
                ps2.setString(9,  (String) o.get("guard_pincode"));
                ps2.setString(10, (String) o.get("registerno"));

                int rows2 = ps2.executeUpdate();
                System.out.println("updateHostelStudent sql2 rows updated: " + rows2);

                con.commit();
                System.out.println("updateHostelStudent committed OK for " + o.get("registerno"));
                return true;

            } catch (Exception e) {
                con.rollback();
                System.out.println("updateHostelStudent ROLLED BACK for " + o.get("registerno"));
                e.printStackTrace();
                throw e;   // re-throw so the JSP catch block gets it
            }
        }
    }
/*
 * ============================================================
 * ADD THESE TWO METHODS TO  ERPHostelRoomDAO.java
 * (paste inside the class body, after the existing methods)
 * ============================================================
 */

// ============================================================
// METHOD 1: getAllocatedStudent
// Search an already-allocated student by register no,
// application no, or student name (case-insensitive LIKE).
// Returns the student's current room / block / floor details
// plus shift info from online application tables.
// ============================================================
public static JSONObject getAllocatedStudent(String query) {

    JSONObject result = new JSONObject();

    String sql =
            "SELECT "
            + "    sra.registerno, "
            + "    sra.applicationno, "
            + "    sra.studentname, "
            + "    sra.shifttype, "
            + "    sra.roomid, "
            + "    sra.roomno, "
            + "    sra.floorid, "
            + "    sra.floorname, "
            + "    sra.blockid, "
            + "    sra.blockname, "

            + "    rm.totaloccupancy, "
            + "    rm.currentoccupancy "

            + "FROM hostel.student_room_allocation sra "

            + "LEFT JOIN hostel.room_master rm "
            + "    ON rm.roomid = sra.roomid "

            + "WHERE sra.isactive = 'Y' "

            + "AND ( "
            + "    LOWER(sra.registerno) LIKE LOWER(?) "
            + " OR LOWER(sra.applicationno) LIKE LOWER(?) "
            + " OR LOWER(sra.studentname) LIKE LOWER(?) "
            + ") "

            + "LIMIT 1";

    String likeQuery = "%" + query + "%";

    try (Connection con =
            new CyberCon().ErpConnection();

         PreparedStatement ps =
                 con.prepareStatement(sql)) {

        ps.setString(1, likeQuery);
        ps.setString(2, likeQuery);
        ps.setString(3, likeQuery);

        System.out.println(
                "\n\ngetAllocatedStudent SQL:\n"
                + ps);

        try (ResultSet rs = ps.executeQuery()) {

            if (!rs.next()) {

                result.put("success", false);

                result.put(
                        "message",
                        "No allocated student found");

                return result;
            }

            result.put("success", true);

            // =====================================
            // STUDENT DETAILS
            // =====================================

            result.put(
                    "registerno",
                    nullSafe(
                            rs.getString("registerno")));

            result.put(
                    "applicationno",
                    nullSafe(
                            rs.getString("applicationno")));

            result.put(
                    "studentname",
                    nullSafe(
                            rs.getString("studentname")));

            result.put(
                    "shifttype",
                    nullSafe(
                            rs.getString("shifttype")));

            // =====================================
            // ROOM DETAILS
            // =====================================

            result.put(
                    "roomid",
                    rs.getObject("roomid"));

            result.put(
                    "roomname",
                    nullSafe(
                            rs.getString("roomno")));

            result.put(
                    "max_noofoccupants",
                    rs.getInt("totaloccupancy"));

            result.put(
                    "no_of_occupants",
                    rs.getInt("currentoccupancy"));

            // =====================================
            // BLOCK / FLOOR
            // =====================================

            result.put(
                    "blockid",
                    rs.getObject("blockid"));

            result.put(
                    "blockname",
                    nullSafe(
                            rs.getString("blockname")));

            result.put(
                    "floorid",
                    rs.getObject("floorid"));

            result.put(
                    "floorname",
                    nullSafe(
                            rs.getString("floorname")));
        }

    } catch (Exception e) {

        System.out.println(
                "\n\nERROR in getAllocatedStudent\n\n");

        e.printStackTrace();

        result.put("success", false);

        result.put(
                "message",
                "Database error : "
                + e.getMessage());
    }

    return result;
}

// ============================================================
// METHOD 2: changeRoom
// Transfers a student from their current room to a new room.
// Uses a single transaction:
//   1. Decrement old room occupancy
//   2. Increment new room occupancy
//   3. Update student record with new roomid
// Rolls back completely on any failure.
// ============================================================
public static String changeRoom(
        String registerno,
        int oldRoomId,
        int newRoomId,
        String updatedBy,
        String updatedIp) {

    JSONObject result = new JSONObject();

    Connection con = null;

    try {

        con = new CyberCon().ErpConnection();

        con.setAutoCommit(false);

        System.out.println(
                "\n=================================");
        System.out.println("changeRoom START");
        System.out.println("=================================");

        System.out.println("REGISTER NO : " + registerno);
        System.out.println("OLD ROOM ID : " + oldRoomId);
        System.out.println("NEW ROOM ID : " + newRoomId);

        // =====================================================
        // STEP 1 : VERIFY CURRENT ACTIVE ROOM
        // =====================================================

        String verifySql =
                "SELECT roomid "
                + "FROM hostel.student_room_allocation "
                + "WHERE registerno = ? "
                + "AND isactive = 'Y' "
                + "ORDER BY allocationid DESC "
                + "LIMIT 1";

        try (PreparedStatement ps =
                con.prepareStatement(verifySql)) {

            ps.setString(1, registerno);

            try (ResultSet rs =
                    ps.executeQuery()) {

                if (!rs.next()) {

                    con.rollback();

                    result.put("success", false);

                    result.put(
                            "error",
                            "Student allocation not found");

                    return result.toJSONString();
                }

                int dbRoomId =
                        rs.getInt("roomid");

                System.out.println(
                        "DB ROOM ID : " + dbRoomId);

                if (dbRoomId != oldRoomId) {

                    con.rollback();

                    result.put("success", false);

                    result.put(
                            "error",
                            "Room mismatch — student is in room "
                            + dbRoomId
                            + ", not "
                            + oldRoomId
                            + ". Please refresh and retry.");

                    return result.toJSONString();
                }
            }
        }

        // =====================================================
        // STEP 2 : CHECK NEW ROOM CAPACITY
        // =====================================================

        String capacitySql =
                "SELECT totaloccupancy, "
                + "currentoccupancy "
                + "FROM hostel.room_master "
                + "WHERE roomid = ?";

        try (PreparedStatement ps =
                con.prepareStatement(capacitySql)) {

            ps.setInt(1, newRoomId);

            try (ResultSet rs =
                    ps.executeQuery()) {

                if (!rs.next()) {

                    con.rollback();

                    result.put("success", false);

                    result.put(
                            "error",
                            "New room not found");

                    return result.toJSONString();
                }

                int total =
                        rs.getInt("totaloccupancy");

                int current =
                        rs.getInt("currentoccupancy");

                if (current >= total) {

                    con.rollback();

                    result.put("success", false);

                    result.put(
                            "error",
                            "Selected room is already full");

                    return result.toJSONString();
                }
            }
        }

        // =====================================================
        // STEP 3 : DECREMENT OLD ROOM
        // =====================================================

        String decrementSql =
                "UPDATE hostel.room_master "
                + "SET currentoccupancy = "
                + "GREATEST(currentoccupancy - 1, 0), "
                + "availablebeds = availablebeds + 1 "
                + "WHERE roomid = ?";

        try (PreparedStatement ps =
                con.prepareStatement(decrementSql)) {

            ps.setInt(1, oldRoomId);

            int rows = ps.executeUpdate();

            System.out.println(
                    "OLD ROOM UPDATED : " + rows);

            if (rows == 0) {

                throw new Exception(
                        "Failed to update old room");
            }
        }

        // =====================================================
        // STEP 4 : INCREMENT NEW ROOM
        // =====================================================

        String incrementSql =
                "UPDATE hostel.room_master "
                + "SET currentoccupancy = currentoccupancy + 1, "
                + "availablebeds = availablebeds - 1 "
                + "WHERE roomid = ?";

        try (PreparedStatement ps =
                con.prepareStatement(incrementSql)) {

            ps.setInt(1, newRoomId);

            int rows = ps.executeUpdate();

            System.out.println(
                    "NEW ROOM UPDATED : " + rows);

            if (rows == 0) {

                throw new Exception(
                        "Failed to update new room");
            }
        }

        // =====================================================
        // STEP 5 : DEACTIVATE OLD ALLOCATION
        // =====================================================

        String deactivateSql =
                "UPDATE hostel.student_room_allocation "
                + "SET isactive = 'N', "
                + "vacateddate = CURRENT_TIMESTAMP "
                + "WHERE registerno = ? "
                + "AND isactive = 'Y'";

        try (PreparedStatement ps =
                con.prepareStatement(deactivateSql)) {

            ps.setString(1, registerno);

            ps.executeUpdate();
        }

        // =====================================================
        // STEP 6 : INSERT NEW ALLOCATION
        // =====================================================

        String insertSql =
                "INSERT INTO hostel.student_room_allocation ( "
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
                + "allocateddate, "
                + "allocatedby, "
                + "isactive "
                + ") "

                + "SELECT "
                + "sra.applicationno, "
                + "sra.registerno, "
                + "sra.studentname, "
                + "sra.shifttype, "
                + "rm.roomid, "
                + "rm.roomno, "
                + "sra.floorid, "
                + "rm.floorname, "
                + "sra.blockid, "
                + "rm.blockname, "
                + "CURRENT_TIMESTAMP, "
                + "?, "
                + "'Y' "

                + "FROM hostel.student_room_allocation sra "

                + "JOIN hostel.room_master rm "
                + "ON rm.roomid = ? "

                + "WHERE sra.registerno = ? "

                + "ORDER BY sra.allocationid DESC "

                + "LIMIT 1";

        try (PreparedStatement ps =
                con.prepareStatement(insertSql)) {

            ps.setString(1, updatedBy);

            ps.setInt(2, newRoomId);

            ps.setString(3, registerno);

            int rows = ps.executeUpdate();

            System.out.println(
                    "NEW ALLOCATION INSERTED : "
                    + rows);

            if (rows == 0) {

                throw new Exception(
                        "Failed to insert new allocation");
            }
        }

        // =====================================================
        // STEP 7 : UPDATE PERSONAL DETAILS
        // =====================================================

        String updateStudentSql =
                "UPDATE hostel.hostelpersonaldetails "
                + "SET roomid = ? "
                + "WHERE registerno = ?";

        try (PreparedStatement ps =
                con.prepareStatement(updateStudentSql)) {

            ps.setInt(1, newRoomId);

            ps.setString(2, registerno);

            ps.executeUpdate();
        }

        // =====================================================
        // COMMIT
        // =====================================================

        con.commit();

        System.out.println(
                "\nROOM CHANGE SUCCESS");

        result.put("success", true);

        result.put(
                "message",
                "Room changed successfully");

    } catch (Exception e) {

        System.out.println(
                "\nERROR IN changeRoom");

        e.printStackTrace();

        try {

            if (con != null) {

                con.rollback();
            }

        } catch (Exception ex) {

            ex.printStackTrace();
        }

        result.put("success", false);

        result.put(
                "error",
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
/*
 * Private helper — already present in HostelDashboardDAO, add here only if
 * not already defined in ERPHostelRoomDAO.
 */
private static String nullSafe(String s) {
    return s != null ? s.trim() : "";
}


}


