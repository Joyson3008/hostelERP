<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
<head>

    <title>Hostel Fee Structure Management</title>

    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <!-- Bootstrap -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">

    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <style>

        body{
            background:#f4f6f9;
            font-family:Segoe UI;
        }

        .page-header{
            background:#0d6efd;
            color:white;
            padding:14px 20px;
            font-size:24px;
            font-weight:600;
            border-radius:8px;
            margin-bottom:20px;
        }

        .card-box{
            background:white;
            border-radius:10px;
            padding:20px;
            box-shadow:0 2px 10px rgba(0,0,0,0.08);
            margin-bottom:20px;
        }

        .section-title{
            font-size:18px;
            font-weight:600;
            margin-bottom:15px;
            color:#0d6efd;
        }

        .table thead{
            background:#0d6efd;
            color:white;
        }

        .table td{
            vertical-align:middle;
        }

        .fee-input{
            min-width:180px;
        }

        .amount-input{
            width:150px;
            text-align:right;
        }

        .total-box{
            font-size:22px;
            font-weight:bold;
            color:#198754;
        }

        .note-row{
            display:flex;
            gap:10px;
            margin-bottom:10px;
        }

        .btn-add{
            border-radius:50px;
        }

        .preview-box{
            background:#eef5ff;
            border-left:5px solid #0d6efd;
            padding:15px;
            border-radius:6px;
        }

    </style>

</head>

<body>

<div class="container-fluid p-4">

    <!-- PAGE HEADER -->

    <div class="page-header">
        <i class="fa-solid fa-money-bill-wave"></i>
        Hostel Fee Structure Management
    </div>

    <!-- FILTER SECTION -->

    <div class="card-box">

        <div class="section-title">
            Fee Structure Information
        </div>

        <div class="row g-3">

            <!-- Academic Year -->

            <div class="col-md-2">

                <label class="form-label">
                    Academic Year
                </label>

                <select class="form-select"
                        id="academicyear">

                    <option value="">
                        Select
                    </option>

                    <option value="2026">
                        2026 - 2027
                    </option>

                </select>

            </div>

            <!-- Hostel Type -->

            <div class="col-md-2">

                <label class="form-label">
                    Hostel Type
                </label>

                <select class="form-select"
                        id="hosteltype">

                    <option value="">
                        Select
                    </option>

                    <option value="Mens">
                        Men's Hostel
                    </option>

                    <option value="Womens">
                        Women's Hostel
                    </option>

                </select>

            </div>

            <!-- Block -->

            <div class="col-md-2">

                <label class="form-label">
                    Block
                </label>

                <select class="form-select"
                        id="blockno">

                    <option value="">
                        Select Block
                    </option>

                </select>

            </div>

            <!-- Room Type -->

            <!-- Room No From -->

<div class="col-md-2">

    <label class="form-label">
        Room No From
    </label>

    <input type="text"
           class="form-control"
           id="roomnofrom"
           placeholder="e.g. 101">
<input type="hidden"
       id="feestructureid">
</div>

<!-- Room No To -->

<div class="col-md-2">

    <label class="form-label">
        Room No To
    </label>

    <input type="text"
           class="form-control"
           id="roomnoto"
           placeholder="e.g. 120">

</div>

<!-- Room Type -->

<div class="col-md-2">

    <label class="form-label">
        Room Type
    </label>

    <input type="text"
           class="form-control"
           id="roomtype"
           placeholder="Enter Room Type">

</div>
            <!-- Effective Date -->

            <div class="col-md-2">

                <label class="form-label">
                    Effective Date
                </label>

                <input type="date"
                       class="form-control"
                       id="effectivedate">

            </div>

            <!-- Structure Name -->

            <div class="col-md-2">

                <label class="form-label">
                    Structure Name
                </label>

                <input type="text"
                       class="form-control"
                       id="structurename"
                       placeholder="Fee Structure Name">

            </div>

        </div>

        <!-- BUTTONS -->

        <div class="mt-4 d-flex gap-2 flex-wrap">

            <button class="btn btn-success"
                    id="saveBtn">

                <i class="fa-solid fa-floppy-disk"></i>
                Save Structure

            </button>

            <button class="btn btn-primary"
                    id="updateBtn">

                <i class="fa-solid fa-pen"></i>
                Update Structure

            </button>

            <button class="btn btn-warning"
                    id="loadBtn">

                <i class="fa-solid fa-folder-open"></i>
                Load Structure

            </button>
    <button class="btn btn-info"
            id="previewBtn">

        <i class="fa fa-eye"></i>
        Preview Students

    </button>
            <button class="btn btn-danger"
                    id="assignBtn">

                <i class="fa-solid fa-users"></i>
                Assign To Students

            </button>

            <button class="btn btn-secondary"
                    id="resetBtn">

                <i class="fa-solid fa-rotate"></i>
                Reset

            </button>

            <button class="btn btn-dark"
                    id="copyBtn">

                <i class="fa-solid fa-copy"></i>
                Copy Previous Structure

            </button>

        </div>

    </div>

    <!-- FEE STRUCTURE TABLE -->

    <div class="card-box">

        <div class="d-flex justify-content-between align-items-center mb-3">

            <div class="section-title mb-0">
                Fee Structure Details
            </div>

            <button class="btn btn-primary btn-add"
                    id="addFeeHeadBtn">

                <i class="fa-solid fa-plus"></i>
                Add Fee Head

            </button>

        </div>

        <div class="table-responsive">

            <table class="table table-bordered"
                   id="feeTable">

                <thead>

                <tr>

                    <th width="80">
                        S.No
                    </th>

                    <th>
                        Fee Head
                    </th>

                    <th width="220">
                        Amount
                    </th>

                    <th width="120">
                        Action
                    </th>

                </tr>

                </thead>

                <tbody>

                </tbody>

                <tfoot>

                <tr>

                    <th colspan="2"
                        class="text-end">

                        Total Amount

                    </th>

                    <th class="total-box"
                        id="totalAmount">

                        ₹ 0.00

                    </th>

                    <th></th>

                </tr>

                </tfoot>

            </table>

        </div>

    </div>

    <!-- NOTES SECTION -->

    <div class="card-box">

        <div class="d-flex justify-content-between align-items-center mb-3">

            <div class="section-title mb-0">
                Notes / Instructions
            </div>

            <button class="btn btn-primary btn-add"
                    id="addNoteBtn">

                <i class="fa-solid fa-plus"></i>
                Add Note

            </button>

        </div>

        <div id="notesContainer">

        </div>

    </div>

    <!-- PREVIEW SECTION -->

    <div class="card-box">

        <div class="section-title">
            Fee Assignment Preview
        </div>

        <div class="preview-box">

            <div class="row">

                <div class="col-md-4">

                    <h6>Total Students</h6>

                    <h3 id="previewStudents">
                        0
                    </h3>

                </div>

                <div class="col-md-4">

                    <h6>Total Fee Collection</h6>

                    <h3 id="previewCollection">
                        ₹ 0.00
                    </h3>

                </div>

                <div class="col-md-4">

                    <h6>Selected Block</h6>

                    <h3 id="previewBlock">
                        -
                    </h3>

                </div>

            </div>

        </div>

    </div>

</div>

<script>

    // =========================================
    // DEFAULT FEE HEADS
    // =========================================

    let defaultFeeHeads = [

        "Mess Fee",
        "Electricity",
        "Maintenance",
        "Room Rent",
        "Establishment",
        "Staff Salary",
        "Forms & Registration"

    ];

    // =========================================
    // DOCUMENT READY
    // =========================================

    $(document).ready(function () {

        loadDefaultFeeHeads();

        loadBlocks();

    });

    // =========================================
    // LOAD DEFAULT FEE HEADS
    // =========================================

    function loadDefaultFeeHeads() {

        $("#feeTable tbody").empty();

        defaultFeeHeads.forEach(function (head) {

            addFeeRow(head, 0);

        });
    }

    // =========================================
    // ADD FEE ROW
    // =========================================

// =========================================
// ADD FEE ROW
// =========================================

// =========================================
// ADD FEE ROW
// =========================================

function addFeeRow(
        feehead = "",
        amount = "") {

    let rowCount =
            $("#feeTable tbody tr").length + 1;

    let row = `

        <tr>

            <td class="text-center fw-bold serialNo">

                ${rowCount}

            </td>

            <td>

                <input type="text"
                       class="form-control fee-head">

            </td>

            <td>

                <input type="number"
                       class="form-control amount">

            </td>

            <td class="text-center">

                <button type="button"
                        class="btn btn-danger deleteRow">

                    <i class="fa fa-trash"></i>

                </button>

            </td>

        </tr>

    `;

    $("#feeTable tbody").append(row);

    let lastRow =
            $("#feeTable tbody tr:last");

    lastRow.find(".fee-head").val(feehead);

    lastRow.find(".amount").val(amount);

    refreshSerialNumbers();

    calculateTotal();
}

    // =========================================
    // ADD NEW FEE HEAD
    // =========================================

    $("#addFeeHeadBtn").click(function () {

        addFeeRow();

    });

    // =========================================
    // DELETE FEE ROW
    // =========================================

    $(document).on("click", ".deleteRow", function () {

        $(this).closest("tr").remove();

        refreshSerialNumbers();

        calculateTotal();

    });

    // =========================================
    // REFRESH SERIAL NUMBERS
    // =========================================

  function refreshSerialNumbers() {

    $("#feeTable tbody tr").each(function (index) {

        $(this)
            .find(".serialNo")
            .html(index + 1);

    });
}

    // =========================================
    // CALCULATE TOTAL
    // =========================================

    $(document).on("keyup change", ".amount", function () {

        calculateTotal();

    });

    function calculateTotal() {

        let total = 0;

        $(".amount").each(function () {

            total +=
                    parseFloat($(this).val()) || 0;

        });

        $("#totalAmount").text(
                "₹ "
                + total.toLocaleString()
                + ".00");

        $("#previewCollection").text(
                "₹ "
                + total.toLocaleString()
                + ".00");
    }

    // =========================================
    // ADD NOTE
    // =========================================

    $("#addNoteBtn").click(function () {

        let noteRow = `

            <div class="note-row">

                <input type="text"
                       class="form-control noteText"
                       placeholder="Enter note">

                <button class="btn btn-danger deleteNote">

                    <i class="fa-solid fa-trash"></i>

                </button>

            </div>

        `;

        $("#notesContainer").append(noteRow);

    });

    // =========================================
    // DELETE NOTE
    // =========================================

    $(document).on("click", ".deleteNote", function () {

        $(this).closest(".note-row").remove();

    });

    // =========================================
    // LOAD BLOCKS
    // =========================================

    function loadBlocks() {

    $.ajax({

        url: "ajax/getBlocksDetails.jsp",

        type: "GET",

        dataType: "json",

        success: function (response) {

            console.log("BLOCK RESPONSE :", response);

            let blockDropdown =
                    $("#blockno");

            blockDropdown.empty();

            blockDropdown.append(
                    '<option value="">Select Block</option>'
            );

            $.each(response, function (i, obj) {

                console.log(obj);

                blockDropdown.append(

                        '<option value="' + obj.blockno + '">' +

                        obj.blockname +

                        '</option>'
                );

            });

        },

        error: function (xhr) {

            console.log(xhr.responseText);

            alert("Failed to load blocks");

        }

    });

}
    // =========================================
    // BLOCK CHANGE PREVIEW
    // =========================================

    $("#blockno").change(function () {

        let blockName =
                $("#blockno option:selected").text();

        $("#previewBlock").text(blockName);

    });

    // =========================================
    // SAVE FEE STRUCTURE
    // =========================================

    $("#saveBtn").click(function () {

        let feeDetails = [];

        $("#feeTable tbody tr").each(function () {

            let feehead =
                    $(this)
                    .find(".fee-head")
                    .val()
                    .trim();

            let amount =
                    $(this)
                    .find(".amount")
                    .val();

            if (feehead !== "") {

                feeDetails.push({

                    feehead : feehead,
                    amount  : amount

                });
            }

        });

        let notes = [];

        $(".noteText").each(function () {

            let note =
                    $(this).val().trim();

            if (note !== "") {

                notes.push(note);
            }

        });

        let total = 0;

        $(".amount").each(function () {

            total +=
                    parseFloat($(this).val()) || 0;

        });

        let payload = {

            academicyearid :
                    $("#academicyear").val(),

            hosteltype :
                    $("#hosteltype").val(),

            blockno :
                    $("#blockno").val(),

            blockname :
                    $("#blockno option:selected").text(),

            roomtype :
                    $("#roomtype").val(),
            roomnofrom :
        $("#roomnofrom").val(),

roomnoto :
        $("#roomnoto").val(),

            structurename :
                    $("#structurename").val(),

            effectivedate :
                    $("#effectivedate").val(),

            totalamount :
                    total,

            feeDetails :
                    feeDetails,

            notes :
                    notes
        };

        console.log(payload);

        $.ajax({

            url  : "ajax/saveFeeStructure.jsp",

            type : "POST",

            dataType : "json",

            data : {

                jsonData :
                        JSON.stringify(payload)

            },

            success : function (response) {
               

                console.log(response);

                if (response.success) {

                    alert(
                        "Fee Structure Saved Successfully");

                } else {

                    alert(
                        "Save Failed : "
                        + response.message);
                }
            },

            error : function (xhr) {

                console.log(xhr.responseText);

                alert("Server Error");
            }

        });

    });
    
    // =========================================
// LOAD FEE STRUCTURE
// =========================================

$("#loadBtn").click(function () {

    let academicyearid =
            $("#academicyear").val();

    let blockno =
            $("#blockno").val();

    let roomnofrom =
            $("#roomnofrom").val();

    let roomnoto =
            $("#roomnoto").val();

    // =====================================
    // VALIDATION
    // =====================================

    if (academicyearid === "") {

        alert("Select Academic Year");

        return;
    }

    if (blockno === "") {

        alert("Select Block");

        return;
    }

    // =====================================
    // AJAX
    // =====================================

    $.ajax({

        url  : "ajax/loadFeeStructure.jsp",

        type : "GET",

        dataType : "json",

        data : {

            academicyearid : academicyearid,

            blockno : blockno,

            roomnofrom : roomnofrom,

            roomnoto : roomnoto

        },

        success : function (response) {

            console.log(response);

            if (!response.success) {

                alert(response.message);

                return;
            }

            // =============================
            // MASTER
            // =============================
 $("#feestructureid").val(response.master.feestructureid);
            $("#hosteltype")
                    .val(response.master.hosteltype);

            $("#roomtype")
                    .val(response.master.roomtype);

            $("#structurename")
                    .val(response.master.structurename);

            $("#effectivedate")
                    .val(response.master.effectivedate);

            $("#roomnofrom")
                    .val(response.master.roomnofrom);

            $("#roomnoto")
                    .val(response.master.roomnoto);

            // =============================
            // CLEAR TABLE
            // =============================

            $("#feeTable tbody").empty();

            // =============================
            // LOAD DETAILS
            // =============================

            $.each(response.details,
                function (i, obj) {

                addFeeRow(
                    obj.feehead,
                    obj.amount
                );

            });

            // =============================
            // NOTES
            // =============================

            $("#notesContainer").empty();

            $.each(response.notes,
                function (i, note) {

                let noteRow = `

                    <div class="note-row">

                        <input type="text"
                               class="form-control noteText"
                               value="${note.notes}">

                        <button class="btn btn-danger deleteNote">

                            <i class="fa-solid fa-trash"></i>

                        </button>

                    </div>

                `;

                $("#notesContainer")
                        .append(noteRow);

            });

            // =============================
            // TOTAL
            // =============================

            calculateTotal();

            alert(
                "Fee Structure Loaded Successfully");

        },

        error : function (xhr) {

            console.log(xhr.responseText);

            alert("Failed To Load Structure");

        }

    });

});



// =========================================
// UPDATE FEE STRUCTURE
// =========================================

$("#updateBtn").click(function () {

    let feestructureid =
            $("#feestructureid").val();

    if (!feestructureid) {

        alert("Please Load Structure First");
        return;
    }

    let feeDetails = [];

    $("#feeTable tbody tr").each(function (index) {

        let feehead =
                $(this)
                .find(".fee-head")
                .val()
                .trim();

        let amount =
                $(this)
                .find(".amount")
                .val();

        if (feehead !== "") {

            feeDetails.push({

                feehead : feehead,
                amount  : amount,
                orderno : index + 1

            });
        }

    });

    let notes = [];

    $(".noteText").each(function () {

        let note =
                $(this).val().trim();

        if (note !== "") {

            notes.push(note);
        }

    });

    let total = 0;

    $(".amount").each(function () {

        total +=
                parseFloat($(this).val()) || 0;

    });

    let payload = {

        feestructureid :
                feestructureid,

        academicyearid :
                $("#academicyear").val(),

        hosteltype :
                $("#hosteltype").val(),

        blockno :
                $("#blockno").val(),

        blockname :
                $("#blockno option:selected").text(),

        roomnofrom :
                $("#roomnofrom").val(),

        roomnoto :
                $("#roomnoto").val(),

        roomtype :
                $("#roomtype").val(),

        structurename :
                $("#structurename").val(),

        effectivedate :
                $("#effectivedate").val(),

        totalamount :
                total,

        feeDetails :
                feeDetails,

        notes :
                notes
    };

    console.log(payload);

    $.ajax({

        url  : "ajax/updateFeeStructure.jsp",

        type : "POST",

        dataType : "json",

        data : {

            jsonData :
                    JSON.stringify(payload)

        },

        success : function (response) {

            console.log(response);

            if (response.success) {

                alert(
                    "Fee Structure Updated Successfully");

            } else {

                alert(
                    "Update Failed : "
                    + response.message);
            }

        },

        error : function (xhr) {

            console.log(xhr.responseText);

            alert("Server Error");

        }

    });

});


// =========================================
// ASSIGN FEE TO STUDENTS
// =========================================

$("#assignBtn").click(function () {

    let feestructureid =
            $("#feestructureid").val();

    if (!feestructureid) {

        alert("Please Load Structure First");

        return;
    }

    let payload = {

    feestructureid :
            feestructureid,

    blockno :
            $("#blockno").val(),

    blockname :
            $("#blockno option:selected").text(),

    roomnofrom :
            $("#roomnofrom").val(),

    roomnoto :
            $("#roomnoto").val()

};

    console.log(payload);

    if (!confirm(
            "Assign this fee structure to students ?")) {

        return;
    }

    $.ajax({

        url : "ajax/assignFeeToStudents.jsp",

        type : "POST",

        dataType : "json",

        data : {

            jsonData :
                    JSON.stringify(payload)

        },

        success : function (response) {

            console.log(response);

            if (response.success) {

                alert(
                    response.count
                    + " Students Assigned Successfully");

            } else {

                alert(
                    "Assignment Failed : "
                    + response.message);
            }

        },

        error : function (xhr) {

            console.log(xhr.responseText);

            alert("Server Error");

        }

    });

});


// =========================================
// COPY PREVIOUS STRUCTURE
// =========================================

$("#copyBtn").click(function () {

    let academicyearid =
            $("#academicyear").val();

    let hosteltype =
            $("#hosteltype").val();

    let blockno =
            $("#blockno").val();

    if (blockno === "") {

        alert("Please Select Block");

        return;
    }

    $.ajax({

        url  : "ajax/copyPreviousFeeStructure.jsp",

        type : "GET",

        dataType : "json",

        data : {

            academicyearid :
                    academicyearid,

            hosteltype :
                    hosteltype,

            blockno :
                    blockno

        },

        success : function (response) {

            console.log(response);

            if (response.success) {

                // =====================================
                // SET MASTER VALUES
                // =====================================

                $("#structurename").val(
                        response.master.structurename);

                $("#roomtype").val(
                        response.master.roomtype);

                // =====================================
                // CLEAR EXISTING ROWS
                // =====================================

                $("#feeTable tbody").empty();

                // =====================================
                // LOAD DETAILS
                // =====================================

                $.each(
                    response.details,
                    function (i, item) {

                        addFeeRow(
                                item.feehead,
                                item.amount);
                    });

                // =====================================
                // CLEAR NOTES
                // =====================================

                $("#notesContainer").empty();

                // =====================================
                // LOAD NOTES
                // =====================================

                $.each(
                    response.notes,
                    function (i, item) {

                        addNoteRow(
                                item.notes);
                    });

                calculateTotal();

                alert(
                    "Previous Structure Loaded");

            } else {

                alert(
                    response.message);
            }
        },

        error : function (xhr) {

            console.log(
                xhr.responseText);

            alert("Server Error");
        }
    });

});
// =========================================
// PREVIEW STUDENTS
// =========================================

$("#previewBtn").click(function () {

    let blockno =
            $("#blockno").val();

    let roomnofrom =
            $("#roomnofrom").val();

    let roomnoto =
            $("#roomnoto").val();

    if (roomnofrom === ""
            || roomnoto === "") {

        alert("Enter Room Range");

        return;
    }

    $.ajax({

        url :
            "ajax/getFeeAssignmentPreview.jsp",

        type : "GET",

        dataType : "json",

        data : {

            blockno :
                    blockno,

            roomnofrom :
                    roomnofrom,

            roomnoto :
                    roomnoto
        },

        success : function (response) {

            console.log(response);

            if (!response.success) {

                alert(response.message);

                return;
            }

let rows = "";

response.students.forEach(function(student, index) {

    rows +=
        "<tr>" +

            "<td>" +
                (index + 1) +
            "</td>" +

            "<td>" +
                student.registerno +
            "</td>" +

            "<td>" +
                student.applicationno +
            "</td>" +

            "<td>" +
                student.studentname +
            "</td>" +

            "<td>" +
                student.roomno +
            "</td>" +

            "<td>" +
                student.floorname +
            "</td>" +

            "<td>" +
                student.blockname +
            "</td>" +

        "</tr>";
});

$("#previewTableBody").html(rows);
$("#previewStudents").text(response.count);
            $("#previewModal")
                    .modal("show");
        },

        error : function (xhr) {

            console.log(xhr.responseText);

            alert("Server Error");
        }
    });

});
    // =========================================
    // RESET BUTTON
    // =========================================

    $("#resetBtn").click(function () {

        location.reload();

    });

</script>
<!-- PREVIEW MODAL -->

<div class="modal fade"
     id="previewModal"
     tabindex="-1">

    <div class="modal-dialog modal-xl">

        <div class="modal-content">

            <div class="modal-header bg-primary text-white">

                <h5 class="modal-title">

                    Students Preview

                </h5>

                <button type="button"
                        class="btn-close btn-close-white"
                        data-bs-dismiss="modal">

                </button>

            </div>

            <div class="modal-body">

<table class="table table-bordered table-striped">

    <thead>

        <tr>

            <th>S.No</th>
            <th>Register No</th>
            <th>Application No</th>
            <th>Student Name</th>
            <th>Room No</th>
            <th>Floor</th>
            <th>Block</th>

        </tr>

    </thead>

    <tbody id="previewTableBody">

    </tbody>

</table>

            </div>

        </div>

    </div>

</div>
</body>
</html>