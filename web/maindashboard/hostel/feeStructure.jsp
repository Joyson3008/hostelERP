<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Fee Structure Management</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

    <style>

        body{
            background:#f4f6f9;
            font-family:Segoe UI;
        }

        .page-header{
            background:#0d2d62;
            color:white;
            padding:14px 20px;
            font-size:20px;
            font-weight:600;
            letter-spacing:0.5px;
        }

        .main-container{
            padding:20px;
        }

        .card-box{
            background:white;
            border-radius:10px;
            box-shadow:0px 2px 10px rgba(0,0,0,0.08);
            padding:20px;
            margin-bottom:20px;
        }

        .section-title{
            font-size:18px;
            font-weight:600;
            color:#0d2d62;
            margin-bottom:18px;
        }

        .fee-table thead{
            background:#0d2d62;
            color:white;
        }

        .fee-table th{
            vertical-align:middle;
            font-size:14px;
        }

        .fee-table td{
            vertical-align:middle;
        }

        .fee-head-input{
            width:100%;
            border:1px solid #ced4da;
            border-radius:6px;
            padding:8px;
        }

        .fee-amount-input{
            width:100%;
            border:1px solid #ced4da;
            border-radius:6px;
            padding:8px;
            text-align:right;
        }

        .btn-add{
            background:#198754;
            color:white;
            border:none;
        }

        .btn-add:hover{
            background:#157347;
            color:white;
        }

        .btn-delete{
            background:#dc3545;
            color:white;
            border:none;
        }

        .btn-delete:hover{
            background:#bb2d3b;
            color:white;
        }

        .summary-card{
            background:#0d2d62;
            color:white;
            border-radius:10px;
            padding:20px;
        }

        .summary-label{
            font-size:14px;
            opacity:0.8;
        }

        .summary-value{
            font-size:18px;
            font-weight:bold;
        }

        .total-amount{
            font-size:28px;
            color:#ffc107;
            font-weight:bold;
        }

        .note-box{
            border:1px solid #dee2e6;
            border-radius:8px;
            padding:10px;
            margin-bottom:10px;
            background:#fafafa;
        }

        .note-input{
            width:100%;
            border:none;
            outline:none;
            background:transparent;
        }

        .sticky-total{
            position:sticky;
            bottom:0;
            background:#0d2d62;
            color:white;
            padding:15px;
            border-radius:10px 10px 0px 0px;
            display:flex;
            justify-content:space-between;
            align-items:center;
            z-index:999;
        }

    </style>
</head>

<body>

<div class="page-header">
    <i class="bi bi-cash-stack"></i>
    Hostel Fee Structure Management
</div>

<div class="main-container">

    <div class="row">

        <!-- LEFT SECTION -->
        <div class="col-lg-3">

            <div class="card-box">

                <div class="section-title">
                    Filters
                </div>

                <div class="mb-3">
                    <label class="form-label">Academic Year</label>
                    <select class="form-select" id="academicyear">
                        <option value="">Select</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label">Hostel Type</label>
                    <select class="form-select" id="hosteltype">
                        <option value="">Select</option>
                        <option value="MENS">Mens Hostel</option>
                        <option value="WOMENS">Womens Hostel</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label">Block</label>
                    <select class="form-select" id="blockno">
                        <option value="">Select Block</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label">Room Type</label>
                    <select class="form-select" id="roomtype">
                        <option value="">Select</option>
                        <option value="COMMON">Common</option>
                        <option value="DOUBLE">Double</option>
                        <option value="TRIPLE">Triple</option>
                        <option value="AC">AC</option>
                        <option value="NON AC">Non AC</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label">Structure Name</label>
                    <input type="text"
                           class="form-control"
                           id="structurename"
                           placeholder="Enter Structure Name">
                </div>

                <div class="mb-3">
                    <label class="form-label">Effective Date</label>
                    <input type="date"
                           class="form-control"
                           id="effectivedate">
                </div>

                <hr>

                <div class="d-grid gap-2">

                    <button class="btn btn-primary"
                            onclick="saveFeeStructure()">
                        <i class="bi bi-save"></i>
                        Save Fee Structure
                    </button>

                    <button class="btn btn-success"
                            onclick="assignToStudents()">
                        <i class="bi bi-people"></i>
                        Assign To Students
                    </button>

                    <button class="btn btn-warning"
                            onclick="loadExistingStructure()">
                        <i class="bi bi-folder2-open"></i>
                        Load Existing
                    </button>

                    <button class="btn btn-secondary"
                            onclick="resetPage()">
                        <i class="bi bi-arrow-clockwise"></i>
                        Reset
                    </button>

                </div>

            </div>

        </div>

        <!-- CENTER SECTION -->
        <div class="col-lg-6">

            <div class="card-box">

                <div class="d-flex justify-content-between align-items-center mb-3">

                    <div class="section-title mb-0">
                        Fee Heads
                    </div>

                    <button class="btn btn-add"
                            onclick="addFeeRow()">
                        <i class="bi bi-plus-circle"></i>
                        Add Fee Head
                    </button>

                </div>

                <div class="table-responsive">

                    <table class="table table-bordered fee-table">

                        <thead>
                        <tr>
                            <th width="60">S.No</th>
                            <th>Fee Head</th>
                            <th width="180">Amount</th>
                            <th width="100">Action</th>
                        </tr>
                        </thead>

                        <tbody id="feeTableBody">

                        </tbody>

                        <tfoot>

                        <tr>

                            <th colspan="2"
                                class="text-end">
                                Total
                            </th>

                            <th class="text-end"
                                id="grandTotal">
                                ₹ 0.00
                            </th>

                            <th></th>

                        </tr>

                        </tfoot>

                    </table>

                </div>

            </div>

            <!-- NOTES -->

            <div class="card-box">

                <div class="d-flex justify-content-between align-items-center mb-3">

                    <div class="section-title mb-0">
                        Notes
                    </div>

                    <button class="btn btn-add"
                            onclick="addNote()">
                        <i class="bi bi-plus-circle"></i>
                        Add Note
                    </button>

                </div>

                <div id="notesContainer">

                </div>

            </div>

        </div>

        <!-- RIGHT SECTION -->
        <div class="col-lg-3">

            <div class="summary-card">

                <div class="mb-4">

                    <div class="summary-label">
                        Selected Block
                    </div>

                    <div class="summary-value"
                         id="summaryBlock">
                        -
                    </div>

                </div>

                <div class="mb-4">

                    <div class="summary-label">
                        Room Type
                    </div>

                    <div class="summary-value"
                         id="summaryRoomType">
                        -
                    </div>

                </div>

                <div class="mb-4">

                    <div class="summary-label">
                        Fee Heads Count
                    </div>

                    <div class="summary-value"
                         id="summaryHeads">
                        0
                    </div>

                </div>

                <div class="mb-4">

                    <div class="summary-label">
                        Total Fee
                    </div>

                    <div class="total-amount"
                         id="summaryTotal">
                        ₹ 0.00
                    </div>

                </div>

            </div>

        </div>

    </div>

</div>

<!-- STICKY TOTAL -->

<div class="sticky-total">

    <div>
        Grand Total
    </div>

    <div id="stickyGrandTotal"
         class="fw-bold fs-4 text-warning">
        ₹ 0.00
    </div>

</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<script>

    let rowIndex = 0;

    $(document).ready(function () {

        addDefaultRows();

        $("#blockno").change(function () {

            let blockText = $("#blockno option:selected").text();

            $("#summaryBlock").text(blockText);

        });

        $("#roomtype").change(function () {

            $("#summaryRoomType").text($(this).val());

        });

    });

    function addDefaultRows() {

        addFeeRow("Mess Fee", 0);
        addFeeRow("Electricity", 0);
        addFeeRow("Maintenance", 0);
        addFeeRow("Room Rent", 0);
        addFeeRow("Establishment", 0);

    }

    function addFeeRow(head = "", amount = 0) {

        rowIndex++;

        let row = `
            <tr>

                <td class="text-center row-no">
                    ${rowIndex}
                </td>

                <td>
                    <input type="text"
                           class="fee-head-input"
                           value="${head}">
                </td>

                <td>
                    <input type="number"
                           class="fee-amount-input amount-field"
                           value="${amount}"
                           oninput="calculateTotal()">
                </td>

                <td class="text-center">

                    <button class="btn btn-delete btn-sm"
                            onclick="deleteRow(this)">
                        <i class="bi bi-trash"></i>
                    </button>

                </td>

            </tr>
        `;

        $("#feeTableBody").append(row);

        updateHeadCount();

        calculateTotal();

    }

    function deleteRow(button) {

        $(button).closest("tr").remove();

        refreshSerialNumbers();

        updateHeadCount();

        calculateTotal();

    }

    function refreshSerialNumbers() {

        $("#feeTableBody tr").each(function (index) {

            $(this).find(".row-no").text(index + 1);

        });

    }

    function calculateTotal() {

        let total = 0;

        $(".amount-field").each(function () {

            total += parseFloat($(this).val()) || 0;

        });

        let formatted = "₹ " + total.toLocaleString('en-IN', {
            minimumFractionDigits: 2
        });

        $("#grandTotal").text(formatted);

        $("#summaryTotal").text(formatted);

        $("#stickyGrandTotal").text(formatted);

    }

    function updateHeadCount() {

        $("#summaryHeads").text($("#feeTableBody tr").length);

    }

    function addNote(text = "") {

        let note = `
            <div class="note-box">

                <div class="d-flex align-items-start gap-2">

                    <textarea class="note-input"
                              rows="2"
                              placeholder="Enter note">${text}</textarea>

                    <button class="btn btn-danger btn-sm"
                            onclick="$(this).closest('.note-box').remove()">
                        <i class="bi bi-x"></i>
                    </button>

                </div>

            </div>
        `;

        $("#notesContainer").append(note);

    }

    function saveFeeStructure() {

        alert("Save Fee Structure AJAX will be added next.");

    }

    function assignToStudents() {

        alert("Assign To Students AJAX will be added next.");

    }

    function loadExistingStructure() {

        alert("Load Existing AJAX will be added next.");

    }

    function resetPage() {

        location.reload();

    }

</script>

</body>
</html>