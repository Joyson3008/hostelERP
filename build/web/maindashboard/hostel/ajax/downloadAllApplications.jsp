<%--
    downloadAllApplications.jsp
    Downloads a range of hostel applications as a multi-page PDF.
    Each student gets their own portrait A4 page — same layout as
    generateApplicationPdf.jsp.

    Uses ONLY: hostel.hostelpersonaldetails + hostel.mens_hostelregistration

    URL:
      hostel/ajax/downloadAllApplications.jsp
          ?fromApplicationNo=26LMH-001
          &toApplicationNo=26LMH-100
--%>
<%@page contentType="application/pdf" pageEncoding="UTF-8"%>

<%@page import="com.itextpdf.text.*"%>
<%@page import="com.itextpdf.text.pdf.*"%>

<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.OutputStream"%>

<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Timestamp"%>

<%@page import="java.text.SimpleDateFormat"%>

<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>

<%@page import="java.util.stream.Collectors"%>
<%@page import="java.util.stream.Stream"%>

<%@page import="org.json.simple.JSONObject"%>

<%@page import="Dbs.Connect.CyberCon"%>
<%@page import="Dao.ERPHostel.ERPHostelDAO"%>
<%!
    /* ══════════════════════════════════════════════════════════
       FONTS  (same as generateApplicationPdf.jsp)
    ══════════════════════════════════════════════════════════ */
    private static final Font FONT_TITLE =
        new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD,   new BaseColor(15, 50, 100));
    private static final Font FONT_SUB =
        new Font(Font.FontFamily.HELVETICA, 11, Font.BOLD,   new BaseColor(15, 50, 100));
    private static final Font FONT_SEC =
        new Font(Font.FontFamily.HELVETICA,  9, Font.BOLD,   BaseColor.WHITE);
    private static final Font FONT_LABEL =
        new Font(Font.FontFamily.HELVETICA,  8, Font.BOLD,   new BaseColor(30, 30, 30));
    private static final Font FONT_VALUE =
        new Font(Font.FontFamily.HELVETICA,  8, Font.NORMAL, new BaseColor(30, 30, 30));
    private static final Font FONT_SMALL =
        new Font(Font.FontFamily.HELVETICA,  7, Font.NORMAL, new BaseColor(80, 80, 80));

    /* ══════════════════════════════════════════════════════════
       COLORS  (same as generateApplicationPdf.jsp)
    ══════════════════════════════════════════════════════════ */
    private static final BaseColor COL_HEADER  = new BaseColor(15,  50, 100);
    private static final BaseColor COL_SECTION = new BaseColor(30,  80, 160);
    private static final BaseColor COL_LABEL   = new BaseColor(235, 240, 250);
    private static final BaseColor COL_BORDER  = new BaseColor(180, 195, 220);

    /* ══════════════════════════════════════════════════════════
       CELL HELPERS  (same as generateApplicationPdf.jsp)
    ══════════════════════════════════════════════════════════ */
    private PdfPCell labelCell(String text) {
        PdfPCell c = new PdfPCell(new Phrase(text, FONT_LABEL));
        c.setBackgroundColor(COL_LABEL);
        c.setPadding(5f);
        c.setBorderColor(COL_BORDER);
        return c;
    }

    private PdfPCell valueCell(String text) {
        PdfPCell c = new PdfPCell(
            new Phrase((text == null || text.trim().isEmpty()) ? " " : text, FONT_VALUE));
        c.setPadding(5f);
        c.setBorderColor(COL_BORDER);
        return c;
    }

    private PdfPCell valueCellSpan(String text, int span) {
        PdfPCell c = valueCell(text);
        c.setColspan(span);
        return c;
    }

    /* ── Section title bar (same as generateApplicationPdf.jsp) ── */
    private PdfPTable sectionTitle(String text) {
        PdfPTable t = new PdfPTable(1);
        t.setWidthPercentage(100);
        t.setSpacingBefore(10f);
        t.setSpacingAfter(4f);
        PdfPCell c = new PdfPCell(new Phrase(text, FONT_SEC));
        c.setBackgroundColor(COL_SECTION);
        c.setBorderColor(COL_BORDER);
        c.setPadding(6f);
        t.addCell(c);
        return t;
    }

    /* ── Null-safe helpers ── */
    private String sv(Object val) {
        if (val == null) return "";
        String s = val.toString().trim();
        return s.equals("null") ? "" : s;
    }

    private String incomeStr(String val) {
        if (val == null || val.trim().isEmpty()
                || val.equals("null") || val.equals("0") || val.equals("0.0"))
            return "-";
        try { return String.format("%.2f", Double.parseDouble(val)); }
        catch (NumberFormatException e) { return val; }
    }

    private String marksStr(String val) {
        if (val == null || val.trim().isEmpty() || val.equals("null")) return "-";
        try {
            double d = Double.parseDouble(val);
            return (d % 1 == 0) ? String.valueOf((int) d) : String.format("%.2f", d);
        } catch (NumberFormatException e) { return val; }
    }

    /* ══════════════════════════════════════════════════════════
       addStudentPage — writes one student's content into the
       open Document. Called once per student inside the loop.
       Mirrors buildIndividualPdf() from generateApplicationPdf.jsp
       but writes directly into the shared Document instead of
       returning a byte[].
    ══════════════════════════════════════════════════════════ */
    private void addStudentPage(Document doc,
                                JSONObject data,
                                javax.servlet.ServletContext ctx)
            throws Exception {

        /* ── Extract fields (same names as generateApplicationPdf.jsp) ── */
        String registerno       = sv(data.get("registerno"));
        String applicationno    = sv(data.get("applicationno"));
        String institutionname  = sv(data.get("institutionname"));
        String studentname      = sv(data.get("studentname"));
        String studentprogram   = sv(data.get("studentprogram"));
        String bloodgroup       = sv(data.get("bloodgroup"));
        String dateofbirth      = sv(data.get("dateofbirth"));
        String gender           = sv(data.get("gender"));
        String mobile           = sv(data.get("studentmobilenumber"));
        String email            = sv(data.get("studentemailid"));
        String state            = sv(data.get("state"));
        String village          = sv(data.get("village"));
        String town             = sv(data.get("town"));
        String mothertongue     = sv(data.get("mothertongue"));
        String religion         = sv(data.get("religion"));
        String category         = sv(data.get("category"));
        String casteid          = sv(data.get("casteid"));
        String fathername       = sv(data.get("fathername"));
        String fathereducation  = sv(data.get("fathereducation"));
        String fatheroccupation = sv(data.get("fatheroccupation"));
        String fatherincome     = sv(data.get("fatherannualincome"));
        String mothername       = sv(data.get("mothername"));
        String mothereducation  = sv(data.get("mothereducation"));
        String motheroccupation = sv(data.get("motheroccupation"));
        String motherincome     = sv(data.get("motherannualincome"));
        String nameofschool     = sv(data.get("nameofschool"));
        String marksplustwo     = sv(data.get("marksplustwo"));
        String maxmark          = sv(data.get("maxmark"));
        String physically       = "Y".equalsIgnoreCase(sv(data.get("isphysicallychallenged")))
                                  ? "Yes" : "No";
        String premadd1         = sv(data.get("premadd1"));
        String premadd2         = sv(data.get("premadd2"));
        String premadd3         = sv(data.get("premadd3"));
        String pincode          = sv(data.get("pincode"));
        String parentmobile     = sv(data.get("parentmobile"));
        String parentemail      = sv(data.get("parentemail"));
        String officename       = sv(data.get("officename"));
        String permstate        = sv(data.get("permstate"));
        String studentphoto     = sv(data.get("studentphoto"));
        String updatedOn        = sv(data.get("updated_on"));
        String guardrelation    = sv(data.get("guardianrelation"));
        String guardline1       = sv(data.get("guardline1"));
        String guardline2       = sv(data.get("guardline2"));
        String guardline3       = sv(data.get("guardline3"));
        String guardmobile      = sv(data.get("guardianmobile"));
        String guardemail       = sv(data.get("guardianemail"));
        String guardstate       = sv(data.get("guardstate"));
        String guarddist        = sv(data.get("guarddist"));
        String guardpincode     = sv(data.get("guard_pincode"));

        /* ── Compose addresses ── */
        String permAddr = Stream.of(premadd1, premadd2, premadd3)
            .filter(x -> !x.isEmpty())
            .collect(Collectors.joining(", "));

        String guardAddr = Stream.of(guardline1, guardline2, guardline3)
            .filter(x -> !x.isEmpty())
            .collect(Collectors.joining(", "));

        /* ════════════════════════════════════════════════════
           HEADER BLOCK  (same as generateApplicationPdf.jsp)
        ════════════════════════════════════════════════════ */
        Paragraph title = new Paragraph("LOYOLA MEN'S HOSTEL", FONT_TITLE);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(2f);
        doc.add(title);

        Paragraph subTitle = new Paragraph(
            "Hostel Application Form  –  2026-2027", FONT_SUB);
        subTitle.setAlignment(Element.ALIGN_CENTER);
        subTitle.setSpacingAfter(2f);
        doc.add(subTitle);

        Paragraph appLine = new Paragraph(
            "Application No: " + applicationno
            + "    |    Register No: " + registerno
            + "    |    Applied On: " + updatedOn,
            FONT_SMALL);
        appLine.setAlignment(Element.ALIGN_CENTER);
        appLine.setSpacingAfter(10f);
        doc.add(appLine);

        /* ── Photo block (right-aligned, if photo exists) ── */
        if (!studentphoto.isEmpty() && ctx != null) {
            try {
                String photoPath = ctx.getRealPath(
                    "/hostelERP/hostelprofile_uploads/" + studentphoto);
                if (photoPath != null) {
                    java.io.File photoFile = new java.io.File(photoPath);
                    if (photoFile.exists()) {
                        Image photo = Image.getInstance(photoPath);
                        photo.scaleToFit(90, 110);
                        photo.setAlignment(Image.RIGHT);
                        photo.setBorderWidth(1f);
                        photo.setBorder(Image.BOX);
                        doc.add(photo);
                    }
                }
            } catch (Exception photoEx) {
                System.out.println("Photo load skipped: " + photoEx.getMessage());
            }
        }

        /* ══════════════════════════════════
           SECTION 1 — PERSONAL DETAILS
        ══════════════════════════════════ */
        doc.add(sectionTitle("1.  PERSONAL DETAILS"));

        PdfPTable tPersonal = new PdfPTable(4);
        tPersonal.setWidthPercentage(100);
        tPersonal.setWidths(new float[]{2.5f, 3.5f, 2.5f, 3.5f});
        tPersonal.setSpacingBefore(0f);
        tPersonal.setSpacingAfter(6f);

        tPersonal.addCell(labelCell("Student Name"));
        tPersonal.addCell(valueCellSpan(studentname, 3));

        tPersonal.addCell(labelCell("Institution"));
        tPersonal.addCell(valueCellSpan(institutionname, 3));

        tPersonal.addCell(labelCell("Program / Course"));
        tPersonal.addCell(valueCellSpan(studentprogram, 3));

        tPersonal.addCell(labelCell("College / Office"));
        tPersonal.addCell(valueCellSpan(officename, 3));

        tPersonal.addCell(labelCell("Gender"));
        tPersonal.addCell(valueCell(gender));
        tPersonal.addCell(labelCell("Blood Group"));
        tPersonal.addCell(valueCell(bloodgroup));

        tPersonal.addCell(labelCell("Date of Birth"));
        tPersonal.addCell(valueCell(dateofbirth));
        tPersonal.addCell(labelCell("Mobile Number"));
        tPersonal.addCell(valueCell(mobile));

        tPersonal.addCell(labelCell("Email ID"));
        tPersonal.addCell(valueCellSpan(email, 3));

        tPersonal.addCell(labelCell("Religion"));
        tPersonal.addCell(valueCell(religion));
        tPersonal.addCell(labelCell("Community"));
        tPersonal.addCell(valueCell(category));

        tPersonal.addCell(labelCell("Caste"));
        tPersonal.addCell(valueCell(casteid));
        tPersonal.addCell(labelCell("Mother Tongue"));
        tPersonal.addCell(valueCell(mothertongue));

        tPersonal.addCell(labelCell("State"));
        tPersonal.addCell(valueCell(state));
        tPersonal.addCell(labelCell("Town / Village"));
        tPersonal.addCell(valueCell(
            Stream.of(town, village).filter(x -> !x.isEmpty())
                  .collect(Collectors.joining(" / "))));

        tPersonal.addCell(labelCell("Differently Abled"));
        tPersonal.addCell(valueCell(physically));
        tPersonal.addCell(labelCell("Applied On"));
        tPersonal.addCell(valueCell(updatedOn));

        doc.add(tPersonal);

        /* ══════════════════════════════════
           SECTION 2 — FAMILY DETAILS
        ══════════════════════════════════ */
        doc.add(sectionTitle("2.  FAMILY DETAILS"));

        PdfPTable tFamily = new PdfPTable(4);
        tFamily.setWidthPercentage(100);
        tFamily.setWidths(new float[]{2.5f, 3.5f, 2.5f, 3.5f});
        tFamily.setSpacingBefore(0f);
        tFamily.setSpacingAfter(6f);

        tFamily.addCell(labelCell("Father's Name"));
        tFamily.addCell(valueCellSpan(fathername, 3));

        tFamily.addCell(labelCell("Father's Education"));
        tFamily.addCell(valueCell(fathereducation));
        tFamily.addCell(labelCell("Father's Occupation"));
        tFamily.addCell(valueCell(fatheroccupation));

        tFamily.addCell(labelCell("Father's Annual Income"));
        tFamily.addCell(valueCellSpan(incomeStr(fatherincome), 3));

        tFamily.addCell(labelCell("Mother's Name"));
        tFamily.addCell(valueCellSpan(mothername, 3));

        tFamily.addCell(labelCell("Mother's Education"));
        tFamily.addCell(valueCell(mothereducation));
        tFamily.addCell(labelCell("Mother's Occupation"));
        tFamily.addCell(valueCell(motheroccupation));

        tFamily.addCell(labelCell("Mother's Annual Income"));
        tFamily.addCell(valueCellSpan(incomeStr(motherincome), 3));

        tFamily.addCell(labelCell("Parent Mobile"));
        tFamily.addCell(valueCell(parentmobile));
        tFamily.addCell(labelCell("Parent Email"));
        tFamily.addCell(valueCell(parentemail));

        doc.add(tFamily);

        /* ══════════════════════════════════
           SECTION 3 — ACADEMIC DETAILS
        ══════════════════════════════════ */
        doc.add(sectionTitle("3.  ACADEMIC DETAILS"));

        PdfPTable tAcademic = new PdfPTable(4);
        tAcademic.setWidthPercentage(100);
        tAcademic.setWidths(new float[]{2.5f, 3.5f, 2.5f, 3.5f});
        tAcademic.setSpacingBefore(0f);
        tAcademic.setSpacingAfter(6f);

        tAcademic.addCell(labelCell("School Name"));
        tAcademic.addCell(valueCellSpan(nameofschool, 3));

        tAcademic.addCell(labelCell("Plus Two Marks"));
        tAcademic.addCell(valueCell(marksStr(marksplustwo)));
        tAcademic.addCell(labelCell("Max Mark"));
        tAcademic.addCell(valueCell(marksStr(maxmark)));

        doc.add(tAcademic);

        /* ══════════════════════════════════
           SECTION 4 — PERMANENT ADDRESS
        ══════════════════════════════════ */
        doc.add(sectionTitle("4.  PERMANENT ADDRESS"));

        PdfPTable tAddr = new PdfPTable(4);
        tAddr.setWidthPercentage(100);
        tAddr.setWidths(new float[]{2.5f, 3.5f, 2.5f, 3.5f});
        tAddr.setSpacingBefore(0f);
        tAddr.setSpacingAfter(6f);

        tAddr.addCell(labelCell("Address"));
        tAddr.addCell(valueCellSpan(permAddr, 3));

        tAddr.addCell(labelCell("State"));
        tAddr.addCell(valueCell(permstate));
        tAddr.addCell(labelCell("Pincode"));
        tAddr.addCell(valueCell(pincode));

        doc.add(tAddr);

        /* ══════════════════════════════════
           SECTION 5 — LOCAL GUARDIAN DETAILS
        ══════════════════════════════════ */
        doc.add(sectionTitle("5.  LOCAL GUARDIAN DETAILS"));

        PdfPTable tGuard = new PdfPTable(4);
        tGuard.setWidthPercentage(100);
        tGuard.setWidths(new float[]{2.5f, 3.5f, 2.5f, 3.5f});
        tGuard.setSpacingBefore(0f);
        tGuard.setSpacingAfter(6f);

        tGuard.addCell(labelCell("Name / Relation"));
        tGuard.addCell(valueCellSpan(guardrelation, 3));

        tGuard.addCell(labelCell("Address"));
        tGuard.addCell(valueCellSpan(guardAddr, 3));

        tGuard.addCell(labelCell("State"));
        tGuard.addCell(valueCell(guardstate));
        tGuard.addCell(labelCell("District"));
        tGuard.addCell(valueCell(guarddist));

        tGuard.addCell(labelCell("Mobile"));
        tGuard.addCell(valueCell(guardmobile));
        tGuard.addCell(labelCell("Email"));
        tGuard.addCell(valueCell(guardemail));

        tGuard.addCell(labelCell("Pincode"));
        tGuard.addCell(valueCellSpan(guardpincode, 3));

        doc.add(tGuard);
    }

    /* ══════════════════════════════════════════════════════════
       BUILD PDF — Portrait A4, one student per page
    ══════════════════════════════════════════════════════════ */
    private byte[] buildPdf(List<JSONObject> students,
                            String fromAppNo,
                            String toAppNo,
                            javax.servlet.ServletContext ctx) throws Exception {

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        // Portrait A4 — same margins as generateApplicationPdf.jsp
        Document doc = new Document(PageSize.A4, 36, 36, 40, 40);
        PdfWriter.getInstance(doc, baos);
        doc.open();

        for (int i = 0; i < students.size(); i++) {
            if (i > 0) {
                // New page for every student after the first
                doc.newPage();
            }
            addStudentPage(doc, students.get(i), ctx);
        }

        doc.close();
        return baos.toByteArray();
    }
%>
<%
    /* ── 1. Parameters ── */
    String fromApplicationNo = request.getParameter("fromApplicationNo");
    String toApplicationNo   = request.getParameter("toApplicationNo");

    if (fromApplicationNo == null || fromApplicationNo.trim().isEmpty() ||
        toApplicationNo   == null || toApplicationNo.trim().isEmpty()) {

        response.setContentType("text/html");
        out.println("<h3 style='color:red;'>Error: fromApplicationNo and toApplicationNo are required.</h3>");
        out.println("<p>Example: ?fromApplicationNo=26LMH-001&amp;toApplicationNo=26LMH-100</p>");
        return;
    }

    fromApplicationNo = fromApplicationNo.trim();
    toApplicationNo   = toApplicationNo.trim();

    /* ── 2. Fetch records ── */
    List<JSONObject> students = null;

    try {
        ERPHostelDAO dao = new ERPHostelDAO();
        students = dao.getApplicationsForPdf(fromApplicationNo, toApplicationNo);
    } catch (Exception dbEx) {
        response.setContentType("text/html");
        out.println("<h3 style='color:red;'>Database error: " + dbEx.getMessage() + "</h3>");
        dbEx.printStackTrace();
        return;
    }

    if (students == null || students.isEmpty()) {
        response.setContentType("text/html");
        out.println("<h3 style='color:orange;'>No fee-paid applications found between <b>"
                  + fromApplicationNo + "</b> and <b>" + toApplicationNo + "</b>.</h3>");
        return;
    }

    /* ── 3. Build PDF — one page per student ── */
    byte[] pdfBytes = null;
    try {
        pdfBytes = buildPdf(students, fromApplicationNo, toApplicationNo, application);
    } catch (Exception ex) {
        response.setContentType("text/html");
        out.println("<h3 style='color:red;'>Error generating PDF: " + ex.getMessage() + "</h3>");
        ex.printStackTrace();
        return;
    }

    /* ── 4. Stream PDF to browser ── */
    String filename = "Applications_" + fromApplicationNo
                    + "_to_" + toApplicationNo + ".pdf";

    response.reset();
    response.setContentType("application/pdf");
    response.setContentLength(pdfBytes.length);
    response.setHeader("Content-Disposition",
                       "attachment; filename=\"" + filename + "\"");
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");

    OutputStream os = response.getOutputStream();
    os.write(pdfBytes);
    os.flush();
    os.close();
%>
