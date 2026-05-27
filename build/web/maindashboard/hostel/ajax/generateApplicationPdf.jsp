<%--
    generateApplicationPdf.jsp
    Generates a single-student hostel application PDF.
    Called from selectHostelApplicants.jsp via:
        <a href="ajax/generateApplicationPdf.jsp?userid=REGISTERNUMBER">PDF</a>

    Uses ONLY:
        hostel.hostelpersonaldetails   (alias h)
        hostel.mens_hostelregistration (alias m)
        hostel.guardiandetails         (alias g)
--%>
<%@page contentType="application/pdf" pageEncoding="UTF-8"
        import="
            com.itextpdf.text.*,
            com.itextpdf.text.pdf.*,
            java.io.ByteArrayOutputStream,
            java.io.OutputStream,
            java.sql.Connection,
            java.sql.PreparedStatement,
            java.sql.ResultSet,
            java.sql.Timestamp,
            java.text.SimpleDateFormat,
            java.util.stream.Collectors,
            java.util.stream.Stream,
            Dbs.Connect.CyberCon
        "%>
<%@page import="Dao.ERPHostel.ERPHostelDAO"%>
<%@page import="org.json.simple.JSONObject"%>

<%!
    /* ══════════════════════════════════════════════════════════
       FONTS  (same as downloadAllApplications.jsp)
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
       COLORS  (same as downloadAllApplications.jsp)
    ══════════════════════════════════════════════════════════ */
    private static final BaseColor COL_HEADER  = new BaseColor(15,  50, 100);
    private static final BaseColor COL_SECTION = new BaseColor(30,  80, 160);
    private static final BaseColor COL_LABEL   = new BaseColor(235, 240, 250);
    private static final BaseColor COL_BORDER  = new BaseColor(180, 195, 220);

    /* ══════════════════════════════════════════════════════════
       CELL HELPERS  (same style as downloadAllApplications.jsp)
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

    /* ── Section title bar (same as downloadAllApplications.jsp) ── */
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
    private String sv(String val) {
        return (val == null || val.trim().isEmpty() || val.trim().equalsIgnoreCase("null"))
               ? "" : val.trim();
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
       BUILD PDF  — portrait A4, label/value 2-column grid layout
    ══════════════════════════════════════════════════════════ */
  private byte[] buildIndividualPdf(
        String userid,
        javax.servlet.ServletContext ctx) throws Exception {

    SimpleDateFormat dfDate =
            new SimpleDateFormat("dd-MM-yyyy");

    /* ── Field holders ── */
    String registerno = "", applicationno = "", institutionname = "",
           studentname = "", studentprogram = "", bloodgroup = "", dateofbirth = "",
           gender = "", mobile = "", email = "", state = "", village = "", town = "",
           mothertongue = "", religion = "", category = "", casteid = "",
           fathername = "", fathereducation = "", fatheroccupation = "", fatherincome = "",
           mothername = "", mothereducation = "", motheroccupation = "", motherincome = "",
           nameofschool = "", marksplustwo = "", maxmark = "", physically = "",
           premadd1 = "", premadd2 = "", premadd3 = "", pincode = "",
           parentmobile = "", parentemail = "", officename = "", permstate = "",
           studentphoto = "", updatedOn = "",
           guardrelation = "", guardline1 = "", guardline2 = "", guardline3 = "",
           guardmobile = "", guardemail = "", guardstate = "", guarddist = "";

    /* ─────────────────────────────────────────────
       DAO METHOD CALL
    ───────────────────────────────────────────── */

    try {

        ERPHostelDAO dao = new ERPHostelDAO();

        JSONObject data =
                dao.getSingleApplicationPdf(userid);

        if (data == null || data.isEmpty()) {
            return null;
        }

        registerno      = sv((String)data.get("registerno"));
        applicationno   = sv((String)data.get("applicationno"));
        institutionname = sv((String)data.get("institutionname"));
        studentname     = sv((String)data.get("studentname"));
        studentprogram  = sv((String)data.get("studentprogram"));
        bloodgroup      = sv((String)data.get("bloodgroup"));
        dateofbirth     = sv((String)data.get("dateofbirth"));

        gender          = sv((String)data.get("gender"));

        mobile          = sv((String)data.get("studentmobilenumber"));

        email           = sv((String)data.get("studentemailid"));

        state           = sv((String)data.get("state"));
        village         = sv((String)data.get("village"));
        town            = sv((String)data.get("town"));

        mothertongue    = sv((String)data.get("mothertongue"));

        religion        = sv((String)data.get("religion"));

        category        = sv((String)data.get("category"));

        casteid         = sv((String)data.get("casteid"));

        fathername      = sv((String)data.get("fathername"));

        fathereducation =
                sv((String)data.get("fathereducation"));

        fatheroccupation =
                sv((String)data.get("fatheroccupation"));

        fatherincome =
                sv((String)data.get("fatherannualincome"));

        mothername      = sv((String)data.get("mothername"));

        mothereducation =
                sv((String)data.get("mothereducation"));

        motheroccupation =
                sv((String)data.get("motheroccupation"));

        motherincome =
                sv((String)data.get("motherannualincome"));

        nameofschool =
                sv((String)data.get("nameofschool"));

        marksplustwo =
                sv((String)data.get("marksplustwo"));

        maxmark =
                sv((String)data.get("maxmark"));

        physically =
                "Y".equalsIgnoreCase(
                        sv((String)data.get("isphysicallychallenged")))
                ? "Yes" : "No";

        premadd1 = sv((String)data.get("premadd1"));
        premadd2 = sv((String)data.get("premadd2"));
        premadd3 = sv((String)data.get("premadd3"));

        pincode =
                sv((String)data.get("pincode"));

        parentmobile =
                sv((String)data.get("parentmobile"));

        parentemail =
                sv((String)data.get("parentemail"));

        officename =
                sv((String)data.get("officename"));

        permstate =
                sv((String)data.get("permstate"));

        studentphoto =
                sv((String)data.get("studentphoto"));

        updatedOn =
                sv((String)data.get("updated_on"));

        guardrelation =
                sv((String)data.get("guardianrelation"));

        guardline1 =
                sv((String)data.get("guardline1"));

        guardline2 =
                sv((String)data.get("guardline2"));

        guardline3 =
                sv((String)data.get("guardline3"));

        guardmobile =
                sv((String)data.get("guardianmobile"));

        guardemail =
                sv((String)data.get("guardianemail"));

        guardstate =
                sv((String)data.get("guardstate"));

        guarddist =
                sv((String)data.get("guarddist"));

    } catch (Exception e) {

        e.printStackTrace();
        throw e;
    }

    /* ── Compose permanent address ── */
    String permAddr = Stream.of(premadd1, premadd2, premadd3)
        .filter(x -> !x.isEmpty())
        .collect(Collectors.joining(", "));

    /* ── Compose guardian address ── */
    String guardAddr = Stream.of(guardline1, guardline2, guardline3)
        .filter(x -> !x.isEmpty())
        .collect(Collectors.joining(", "));

    /* Remaining PDF generation code continues SAME */
        /* ════════════════════════════════════════════════════
           BUILD PDF DOCUMENT  — Portrait A4
        ════════════════════════════════════════════════════ */
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        Document doc = new Document(PageSize.A4, 36, 36, 40, 40);
        PdfWriter writer = PdfWriter.getInstance(doc, baos);
        doc.open();

        /* ── Header block ── */
        Paragraph title = new Paragraph(
            "LOYOLA MEN'S HOSTEL", FONT_TITLE);
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

        // 4-column label/value table (label | value | label | value)
        PdfPTable tPersonal = new PdfPTable(4);
        tPersonal.setWidthPercentage(100);
        tPersonal.setWidths(new float[]{2.5f, 3.5f, 2.5f, 3.5f});
        tPersonal.setSpacingBefore(0f);
        tPersonal.setSpacingAfter(6f);

        // Row 1
        tPersonal.addCell(labelCell("Student Name"));
        tPersonal.addCell(valueCellSpan(studentname, 3));

        // Row 2
        tPersonal.addCell(labelCell("Institution"));
        tPersonal.addCell(valueCellSpan(institutionname, 3));

        // Row 3
        tPersonal.addCell(labelCell("Program / Course"));
        tPersonal.addCell(valueCellSpan(studentprogram, 3));

        // Row 4
        tPersonal.addCell(labelCell("College / Office"));
        tPersonal.addCell(valueCellSpan(officename, 3));

        // Row 5
        tPersonal.addCell(labelCell("Gender"));
        tPersonal.addCell(valueCell(gender));
        tPersonal.addCell(labelCell("Blood Group"));
        tPersonal.addCell(valueCell(bloodgroup));

        // Row 6
        tPersonal.addCell(labelCell("Date of Birth"));
        tPersonal.addCell(valueCell(dateofbirth));
        tPersonal.addCell(labelCell("Mobile Number"));
        tPersonal.addCell(valueCell(mobile));

        // Row 7
        tPersonal.addCell(labelCell("Email ID"));
        tPersonal.addCell(valueCellSpan(email, 3));

        // Row 8
        tPersonal.addCell(labelCell("Religion"));
        tPersonal.addCell(valueCell(religion));
        tPersonal.addCell(labelCell("Community"));
        tPersonal.addCell(valueCell(category));

        // Row 9
        tPersonal.addCell(labelCell("Caste"));
        tPersonal.addCell(valueCell(casteid));
        tPersonal.addCell(labelCell("Mother Tongue"));
        tPersonal.addCell(valueCell(mothertongue));

        // Row 10
        tPersonal.addCell(labelCell("State"));
        tPersonal.addCell(valueCell(state));
        tPersonal.addCell(labelCell("Town / Village"));
        tPersonal.addCell(valueCell(
            Stream.of(town, village).filter(x -> !x.isEmpty())
                  .collect(Collectors.joining(" / "))));

        // Row 11
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

        // Father
        tFamily.addCell(labelCell("Father's Name"));
        tFamily.addCell(valueCellSpan(fathername, 3));

        tFamily.addCell(labelCell("Father's Education"));
        tFamily.addCell(valueCell(fathereducation));
        tFamily.addCell(labelCell("Father's Occupation"));
        tFamily.addCell(valueCell(fatheroccupation));

        tFamily.addCell(labelCell("Father's Annual Income"));
        tFamily.addCell(valueCellSpan(incomeStr(fatherincome), 3));

        // Mother
        tFamily.addCell(labelCell("Mother's Name"));
        tFamily.addCell(valueCellSpan(mothername, 3));

        tFamily.addCell(labelCell("Mother's Education"));
        tFamily.addCell(valueCell(mothereducation));
        tFamily.addCell(labelCell("Mother's Occupation"));
        tFamily.addCell(valueCell(motheroccupation));

        tFamily.addCell(labelCell("Mother's Annual Income"));
        tFamily.addCell(valueCellSpan(incomeStr(motherincome), 3));

        // Parent contact
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

        doc.add(tGuard);

        /* ── Footer ── */
        Paragraph footer = new Paragraph(
            "Generated by Loyola ERP  |  Application No: " + applicationno
            + "  |  Register No: " + registerno,
            FONT_SMALL);
        footer.setAlignment(Element.ALIGN_RIGHT);
        footer.setSpacingBefore(10f);
        doc.add(footer);

        doc.close();
        return baos.toByteArray();
    }
%>
<%
    /* ── 1. Read parameter ── */
    String userid = request.getParameter("userid");

    if (userid == null || userid.trim().isEmpty()) {
        response.setContentType("text/html");
        out.println("<h3 style='color:red;'>Error: userid (register number) is required.</h3>");
        out.println("<p>Example: ?userid=REG001</p>");
        return;
    }

    userid = userid.trim();

    /* ── 2. Build PDF ── */
    byte[] pdfBytes = null;
    try {
        pdfBytes = buildIndividualPdf(userid, application);
    } catch (Exception ex) {
        response.setContentType("text/html");
        out.println("<h3 style='color:red;'>Error generating PDF: " + ex.getMessage() + "</h3>");
        ex.printStackTrace();
        return;
    }

    if (pdfBytes == null || pdfBytes.length == 0) {
        response.setContentType("text/html");
        out.println("<h3 style='color:orange;'>No record found for register number: <b>" + userid + "</b></h3>");
        return;
    }

    /* ── 3. Stream PDF to browser ── */
    String filename = "Application_" + userid + ".pdf";

    response.reset();
    response.setContentType("application/pdf");
    response.setContentLength(pdfBytes.length);
    response.setHeader("Content-Disposition",
                       "inline; filename=\"" + filename + "\"");
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");

    OutputStream os = response.getOutputStream();
    os.write(pdfBytes);
    os.flush();
    os.close();
%>
