

<script>



    function loadPage(id, menuurl, menuname) {
    console.log("....---", id + "-------------------" + menuurl);

    var subForm = document.getElementById("pagecont");
    subForm.rePage.value = menuurl;

    // Store in sessionStorage (client-side)
    sessionStorage.setItem("activeMenu", menuurl);
    sessionStorage.setItem("activeMenuid", id);

    // Debug
    console.log("Setting session for menu:", id, menuname);
    //alert(menuname);

    // ? Wait for fetch to finish before submitting form
    fetch('<%=request.getContextPath()%>/setactivemenu.jsp', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'activeMenu=' + encodeURIComponent(id) + '&activeMenuname=' + encodeURIComponent(menuname)
    })
    .then(response => response.text())
    .then(data => {
        console.log("? Session set:", data);
        // Submit AFTER fetch completes
        subForm.submit();
    })
    .catch(error => {
        console.error("? Error setting session:", error);
        // Still submit the form even if fetch fails
        subForm.submit();
    });
}

</script>
<script>
window.addEventListener('DOMContentLoaded', () => {
    const savedUrl = sessionStorage.getItem('activeMenu');
    if (savedUrl) {
        document.querySelectorAll('.menu-link').forEach(link => {
            if (link.getAttribute('onclick').includes(savedUrl)) {
                link.parentElement.classList.add('active');
            }
        });
    }
});
</script>
<script>
    function updateDateTime() {
        const now = new Date();

        // Format date (e.g., 15-Oct-2025)
        const options = { day: '2-digit', month: 'short', year: 'numeric' };
        const dateString = now.toLocaleDateString('en-GB', options).replace(/ /g, '-');

        // Format time (HH:MM:SS)
        const timeString = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' });

       // document.getElementById("currentDate").textContent = dateString +" "+timeString;
        //document.getElementById("currentTime").textContent = timeString;
    }

    // Run immediately, then every second
    updateDateTime();
    setInterval(updateDateTime, 1000);
</script>
<script>
    $("#currmemarkoffices").on("change", function () {
        var officeVal = $(this).val();

        $.ajax({
            url: "<%=request.getContextPath()%>/ChangeOfficeServlet",
            type: "POST",
            data: {offices: officeVal},
            success: function (response) {
                console.log(response);
                // Show popup message
                $("#popupMsg").text(response).fadeIn();

                // Auto-hide after 3 seconds
                setTimeout(function () {
                    $("#popupMsg").fadeOut();
                }, 3000);
            },
            error: function () {
                $("#popupMsg").text("Error changing office!").css("background", "#dc3545").fadeIn();
                setTimeout(function () {
                    $("#popupMsg").fadeOut();
                }, 3000);
            }
        });
    });
</script>

<script type="text/javascript" src="<%=request.getContextPath()%>/maindashboard/assets/js/jquery/jquery.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/maindashboard/assets/js/jquery-ui/jquery-ui.min.js "></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/maindashboard/assets/js/popper.js/popper.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/maindashboard/assets/js/bootstrap/js/bootstrap.min.js "></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/maindashboard/assets/pages/widget/excanvas.js "></script>
<!-- waves js -->
<script src="<%=request.getContextPath()%>/maindashboard/assets/pages/waves/js/waves.min.js"></script>
<!-- jquery slimscroll js -->
<script type="text/javascript" src="<%=request.getContextPath()%>/maindashboard/assets/js/jquery-slimscroll/jquery.slimscroll.js "></script>
<!-- modernizr js -->
<script type="text/javascript" src="<%=request.getContextPath()%>/maindashboard/assets/js/modernizr/modernizr.js "></script>
<!-- slimscroll js -->
<script type="text/javascript" src="<%=request.getContextPath()%>/maindashboard/assets/js/SmoothScroll.js"></script>
<script src="<%=request.getContextPath()%>/maindashboard/assets/js/jquery.mCustomScrollbar.concat.min.js "></script>

<script type="text/javascript" src="assets/js/chart.js/Chart.js"></script>
<!-- amchart js -->
<script src="https://www.amcharts.com/lib/3/amcharts.js"></script>
<script src="<%=request.getContextPath()%>/maindashboard/assets/pages/widget/amchart/gauge.js"></script>
<script src="<%=request.getContextPath()%>/maindashboard/assets/pages/widget/amchart/serial.js"></script>
<script src="<%=request.getContextPath()%>/maindashboard/assets/pages/widget/amchart/light.js"></script>
<script src="<%=request.getContextPath()%>/maindashboard/assets/pages/widget/amchart/pie.min.js"></script>
<script src="https://www.amcharts.com/lib/3/plugins/export/export.min.js"></script>

<script src="<%=request.getContextPath()%>/maindashboard/assets/js/pcoded.min.js"></script>
<script src="<%=request.getContextPath()%>/maindashboard/assets/js/vertical-layout.min.js "></script>
<!-- custom js -->
<script type="text/javascript" src="<%=request.getContextPath()%>/maindashboard/assets/pages/dashboard/custom-dashboard.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/maindashboard/assets/js/script.js "></script>

<!-- jQuery -->

<!-- DataTables CSS & JS -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>

<!-- Buttons Extension CSS & JS -->
<link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.4.1/css/buttons.dataTables.min.css">
<script src="https://cdn.datatables.net/buttons/2.4.1/js/dataTables.buttons.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.html5.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.4.1/js/buttons.print.min.js"></script>

<!-- JSZip for Excel export -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>

<!-- pdfmake for PDF export -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>

</body>

</html>