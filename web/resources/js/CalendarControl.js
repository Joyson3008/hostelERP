var isCurrentDateAllow=true;
var minYear=1950;
var maxYear=2010;
var futureAllowed=0,pastAllowed=0;
var currentdate;
var defCurrentYear=0,defCurrentMonth=0,defCurrentDay=0;
var lcurrentMonth=0,lcurrentYear=0;
var minAllowedDate=new Date();
var maxAllowedDate=new Date();

function positionInfo(object) { 
  
    var p_elm = object;

    this.getElementLeft = getElementLeft;
    function getElementLeft() {
        var x = 0;
        var elm;
        if(typeof(p_elm) == "object"){
            elm = p_elm;
        } else {
            elm = document.getElementById(p_elm);
        }
        while (elm != null) {
            x+= elm.offsetLeft;
            elm = elm.offsetParent;
        }
        return parseInt(x);
    }

    this.getElementWidth = getElementWidth;
    function getElementWidth(){
        var elm;
        if(typeof(p_elm) == "object"){
            elm = p_elm;
        } else {
            elm = document.getElementById(p_elm);
        }
        return parseInt(elm.offsetWidth);
    }

    this.getElementRight = getElementRight;
    function getElementRight(){
        return getElementLeft(p_elm) + getElementWidth(p_elm);
    }

    this.getElementTop = getElementTop;
    function getElementTop() {
        var y = 0;
        var elm;
        if(typeof(p_elm) == "object"){
            elm = p_elm;
        } else {
            elm = document.getElementById(p_elm);
        }
        while (elm != null) {
            y+= elm.offsetTop;
            elm = elm.offsetParent;
        }
        return parseInt(y);
    }

    this.getElementHeight = getElementHeight;
    function getElementHeight(){
        var elm;
        if(typeof(p_elm) == "object"){
            elm = p_elm;
        } else {
            elm = document.getElementById(p_elm);
        }
        return parseInt(elm.offsetHeight);
    }

    this.getElementBottom = getElementBottom;
    function getElementBottom(){
        return getElementTop(p_elm) + getElementHeight(p_elm);
    }
}

function getPreviousDateDifference(argCurrentDate,argPreviousDateValue){
    var re=/-/g;
    argCurrentDate=argCurrentDate.replace(re,'/');
    argPreviousDateValue=argPreviousDateValue.replace(re,'/');
    var datediff=CalendarDateDiff(argPreviousDateValue,argCurrentDate);
    return datediff;
}

function CalendarControl() {

    var calendarId = 'CalendarControl';
    var currentYear = 0;
    var currentMonth = 0;
    var currentDay = 0;

    var selectedYear = 0;
    var selectedMonth = 0;
    var selectedDay = 0;

    var months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
    var shortmonths = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    var dateField = null;
    var hiddenDateField=null;

    function getProperty(p_property){
        var p_elm = calendarId;
        var elm = null;

        if(typeof(p_elm) == "object"){
            elm = p_elm;
        } else {
            elm = document.getElementById(p_elm);
        }
        if (elm != null){
            if(elm.style){
                elm = elm.style;
                if(elm[p_property]){
                    return elm[p_property];
                } else {
                    return null;
                }
            } else {
                return null;
            }
        }
    }

    function setElementProperty(p_property, p_value, p_elmId){
        var p_elm = p_elmId;
        var elm = null;

        if(typeof(p_elm) == "object"){
            elm = p_elm;
        } else {
            elm = document.getElementById(p_elm);
        }
        if((elm != null) && (elm.style != null)){
            elm = elm.style;
            elm[ p_property ] = p_value;
        }
    }

    function setProperty(p_property, p_value) {
        setElementProperty(p_property, p_value, calendarId);
    }

    function getDaysInMonth(year, month) {
        return [31,((!(year % 4 ) && ( (year % 100 ) || !( year % 400 ) ))?29:28),31,30,31,30,31,31,30,31,30,31][month-1];
    }

    function getDayOfWeek(year, month, day) {
        var date = new Date(year,month-1,day)
        return date.getDay();
    }

    this.clearDate = clearDate;
    function clearDate() {
        dateField.value = '';
        hiddenDateField.value='';
        hide();
    }

    this.setDate = setDate;
    function setDate(day, month, year) {
        if (dateField) {
            if (month < 10) {
                month = "0" + month;
            }
            if (day < 10) {
                day = "0" + day;
            }
            var dateString = day+"-"+month+"-"+year;
            dateField.value = dateString;
            var dateString1 = year+"-"+month+"-"+day;
            hiddenDateField.value=dateString1;
            dateField.focus();
            hide();
        }
        return;
    }

    this.changeMonth = changeMonth;
    function changeMonth(change) {
        currentMonth += change;
        currentDay = 0;
        if(currentMonth > 12) {
            currentMonth = 1;
            currentYear++;
        } else if(currentMonth < 1) {
            currentMonth = 12;
            currentYear--;
        }
        lcurrentMonth=currentMonth,
        lcurrentYear=currentYear;
        calendar = document.getElementById(calendarId);
        calendar.innerHTML = calendarDrawTable();
    }


    this.changeMonthFromCombo = changeMonthFromCombo;
    function changeMonthFromCombo(change) {
        currentMonth = parseInt(change,10);
        currentDay = 0;
        currentYear=currentYear;
        lcurrentMonth=currentMonth,
        lcurrentYear=currentYear;
        calendar = document.getElementById(calendarId);
        calendar.innerHTML = calendarDrawTable();
    }

    this.changeYear = changeYear;
    function changeYear(change) {
        if (currentYear>minYear && currentYear<maxYear)
            currentYear += change;

        if ((currentYear==minYear && change>0) || (currentYear==maxYear && change<0))
            currentYear += change;

        currentDay = 0;
        calendar = document.getElementById(calendarId);
        calendar.innerHTML = calendarDrawTable();
    }

    this.changeYearFromCombo = changeYearFromCombo;
    function changeYearFromCombo(change) {
        currentYear = change;
        lcurrentYear=currentYear;
        currentDay = 0;
        calendar = document.getElementById(calendarId);
        calendar.innerHTML = calendarDrawTable();
    }

    function getCurrentYear() {
        return defCurrentYear;
    }

    function getCurrentMonth() {
        return defCurrentMonth;
    } 

    function getCurrentDay() {
        return defCurrentDay;
    }

    function calendarDrawTable() {

        var dayOfMonth = 1;
        var validDay = 0;
        var startDayOfWeek = getDayOfWeek(currentYear, currentMonth, dayOfMonth);
        var daysInMonth = getDaysInMonth(currentYear, currentMonth);
        var css_class = null; //CSS class for each day
        var alertmessage="";
        var table = "<table cellspacing='0' cellpadding='0' border='0'>";
        table = table + "<tr class='header'>";
        //table = table + "  <td colspan='1' class='previous' nowrap><a href='javascript:changeCalendarControlMonth(-1);'>&lt;</a> <a href='javascript:changeCalendarControlYear(-1);'>&laquo;</a></td>";
        table = table + "  <td colspan='1' class='previous' nowrap><a href='javascript:changeCalendarControlMonth(-1);'>&lt;</a> </td>";
        //table = table + "  <td colspan='3' class='title'>" + months[currentMonth-1] + "<br>" + currentYear + "</td>";
        table = table + "  <td colspan='5' class='title' nowrap>" + drawMonths() + "&nbsp;" + drawYear() + "</td>";
        //table = table + "  <td colspan='1' class='next' nowrap><a href='javascript:changeCalendarControlYear(1);'>&raquo;</a> <a href='javascript:changeCalendarControlMonth(1);'>&gt;</a></td>";
        table = table + "  <td colspan='1' class='next' nowrap><a href='javascript:changeCalendarControlMonth(1);'>&gt;</a></td>";
        table = table + "</tr>";
        table = table + "<tr><th>S</th><th>M</th><th>T</th><th>W</th><th>T</th><th>F</th><th>S</th></tr>";
        for(var week=0; week < 6; week++) {
            table = table + "<tr>";
            for(var dayOfWeek=0; dayOfWeek < 7; dayOfWeek++) {
                if(week == 0 && startDayOfWeek == dayOfWeek) {
                    validDay = 1;
                } else if (validDay == 1 && dayOfMonth > daysInMonth) {
                    validDay = 0;
                }

                if(validDay) {
                    if (dayOfMonth == selectedDay && currentYear == selectedYear && currentMonth == selectedMonth) {
                        css_class = 'current';
                    } else if (dayOfWeek == 0 || dayOfWeek == 6) {
                        css_class = 'weekend';
                    } else {
                        css_class = 'weekday';
                    }

                    alertmessage=getCssClass(dayOfMonth,currentMonth,currentYear);

                    if (alertmessage=="empty"){
                        //table = table + "<td><a class='"+css_class+"' href=\"javascript:setCalendarControlDate("+dayOfMonth+","+currentMonth+","+currentYear+")\">"+dayOfMonth+"</a></td>";
                        table = table + "<td><a class='"+css_class+"' href=\"javascript:setCalendarControlDate("+dayOfMonth+","+currentMonth+","+currentYear+")\">"+dayOfMonth+"</a></td>";
                    }else{
                        table = table + "<td class='empty' onclick=\"javascript:alert('"+alertmessage+"')\">"+dayOfMonth+"</td>";
                    }
                    dayOfMonth++;
                } else {
                    table = table + "<td class='empty'>&nbsp;</td>";
                }
            }
            table = table + "</tr>";
        }

        /* table = table + "<tr class='header'><th colspan='7' style='padding: 3px;'><a href='javascript:clearCalendarControl();'>Clear</a> | <a href='javascript:hideCalendarControl();'>Close</a></td></tr>"; */
        table = table + "<tr class='header'><th colspan='7' style='padding: 3px;'><a href='javascript:hideCalendarControl();'>Close</a></td></tr>"; 
        table = table + "</table>";
        return table;
    }

    this.show = show;
    function show(field,field1) {
        currentdate=getCurrentYear()+"/"+getCurrentMonth()+"/"+getCurrentDay();
        can_hide = 0;
  
        // If the calendar is visible and associated with
        // this field do not do anything.
        if (dateField == field) {
            return;
        } else {
            dateField = field;
            hiddenDateField=field1;
        }

        if(dateField) {
            try {
                var dateString = new String(dateField.value);
                var dateParts = dateString.split("-");
        
                selectedMonth = parseInt(dateParts[1],10);
                selectedDay = parseInt(dateParts[0],10);
                selectedYear = parseInt(dateParts[2],10);
            } catch(e) {}
        }

        if (!(selectedYear && selectedMonth && selectedDay)) {
            selectedMonth = getCurrentMonth();
            selectedDay = getCurrentDay();
            selectedYear = getCurrentYear();
        }

        currentMonth = selectedMonth;
        currentDay = selectedDay;
        currentYear = selectedYear;
    
        lcurrentMonth=currentMonth,
        lcurrentYear=currentYear;

        if(document.getElementById){

            calendar = document.getElementById(calendarId);
            calendar.innerHTML = calendarDrawTable(currentYear, currentMonth);

            setProperty('display', 'block');

            var fieldPos = new positionInfo(dateField);
            var calendarPos = new positionInfo(calendarId);

            var x = fieldPos.getElementLeft();
            var y = fieldPos.getElementBottom();

            setProperty('left', x + "px");
            setProperty('top', y + "px");
 
            if (document.all) {
                setElementProperty('display', 'block', 'CalendarControlIFrame');
                setElementProperty('left', x + "px", 'CalendarControlIFrame');
                setElementProperty('top', y + "px", 'CalendarControlIFrame');
                setElementProperty('width', calendarPos.getElementWidth() + "px", 'CalendarControlIFrame');
                setElementProperty('height', calendarPos.getElementHeight() + "px", 'CalendarControlIFrame');
            }
        }
        dateField.focus();
    }

    this.hide = hide;
    function hide() {
        if(dateField) {
            setProperty('display', 'none');
            setElementProperty('display', 'none', 'CalendarControlIFrame');
            dateField = null;
            hiddenDateField=null;

        }
    }

    this.visible = visible;
    function visible() {
        return dateField
    }

    this.can_hide = can_hide;
    var can_hide = 0;

    function drawMonths(){
        var dmonths="<SELECT id='months' style='width:60px;height:18px;' onchange='changeCalendarControlMonthFromCombo(this.value)'>";
        for(lo=1;lo<=12;lo++){
            if (currentMonth==lo)
                dmonths = dmonths+ "<option  selected value="+lo+">"+shortmonths[lo-1];
            else
                dmonths = dmonths+ "<option  value="+lo+">"+shortmonths[lo-1];
        }
        dmonths=dmonths+"</SELECT>"
        return dmonths
    }

    function drawYear(){
        var dyears="<SELECT id='years' style='width:60px;height:18px;' onchange='changeCalendarControlYearFromCombo(this.value)'>";
        for(lo=minYear;lo<=maxYear;lo++){
            if (lo==currentYear)
                dyears = dyears+ "<option  selected value="+lo+">"+lo;
            else
                dyears = dyears+ "<option  value="+lo+">"+lo;
        }
        dyears=dyears+"</SELECT>"
        return dyears
    }

}

var calendarControl = new CalendarControl();

function showCalendarControl(textField) {
    // textField.onblur = hideCalendarControl;
    calendarControl.show(textField);
}

function hideCalendarControl() {
    // textField.onblur = hideCalendarControl;
    calendarControl.hide();
}

/* 
*    showCalendarControl(<br>
*           objTextField  : (String)  Text Field Object (Not NAME or ID), returns date in format dd-mm-yyyy<br>
*           argPastDay    : (Integer) 0 - Previous Date Not allowed, Any Positive Integer - No. of Previous days to allow<br>
*           argCurrentDay : (boolean) true - allow Current date , false - current date is not allowed<br>
*           argFutureDay  : (Integer) 0 - Future Date Not allowed, Any Positive Integer - No. of Future days to allow<br>
*           argCurrentDate: (String)  Current Date from Database server with format yyyy-mm-dd<br>
*           objHidden     : (String)  Hidden Field Object (Not NAME or ID), returns date in format yyyy-mm-dd<br>
*     )
* */

function showCalendarControl(objTextField,argPastDay,argCurrentDay,argFutureDay,argCurrentDate,objHidden){
    // textField.onblur = hideCalendarControl;
    futureAllowed=argFutureDay;
    pastAllowed=argPastDay;
    isCurrentDateAllow=argCurrentDay;
    tmp=argCurrentDate.split("-");
    defCurrentYear=parseInt(tmp[0],10);
    defCurrentMonth=parseInt(tmp[1],10);
    defCurrentDay=parseInt(tmp[2],10);
    var todaydate=new Date();
    var mindate=new Date();
    var maxdate=new Date();
    todaydate.setFullYear(defCurrentYear,defCurrentMonth-1,defCurrentDay);
    mindate.setDate(todaydate.getDate()-pastAllowed);
    minYear=mindate.getFullYear();
    minAllowedDate=mindate;
    minAllowedDate.setHours(1, 0, 0,0);
    maxdate.setDate(todaydate.getDate()+futureAllowed);
    maxAllowedDate=maxdate;
    maxAllowedDate.setHours(23, 59, 59, 59);
    maxYear=maxdate.getFullYear();
    calendarControl.show(objTextField,objHidden);
}

function clearCalendarControl() {
//calendarControl.clearDate();
}

function hideCalendarControl() {
    if (calendarControl.visible()) {
        calendarControl.hide();
    }
}

function setCalendarControlDate(day, month, year) {
    calendarControl.setDate(day, month, year);
//dateField.focus();
}

function changeCalendarControlYear(change) {

    if (futureAllowed==0 && change>0){
        alert("Future date is not allowed");
    }else if (pastAllowed==0 && change<0){
        alert("Previous date is not allowed");
    }else{
        calendarControl.changeYear(change);
    }
}

function changeCalendarControlMonth(change) {
    var res=0;
    if (change>0){
        if ((futureAllowed==0 && getDateChangeAllowed(lcurrentMonth,lcurrentYear,change,1,1)) ||  getDateChangeAllowed(lcurrentMonth,lcurrentYear,change,1,1)){
            alert("Future date is not allowed beyond "+futureAllowed +" days");
            res=1;
        }
    }else if (change<0){
        if ((pastAllowed==0  && getDateChangeAllowed(lcurrentMonth,lcurrentYear,change,1,1)) || getDateChangeAllowed(lcurrentMonth,lcurrentYear,change,1,1)){
            alert("Previous date is not allowed beyond "+pastAllowed +" days");
            res=1;
        }
    }

    if (res<1) calendarControl.changeMonth(change);

}

function changeCalendarControlMonthFromCombo(change){
    calendarControl.changeMonthFromCombo(change);
/*if (getDateChangeAllowed(change,lcurrentYear,change,2,1)){
      alert("Previous date not allowed beyond "+pastAllowed +" days \n Future date is not allowed beyond "+futureAllowed +" days  ");
      document.getElementById('months').value=lcurrentMonth;
      calendarControl.changeMonthFromCombo(change);
  }else{
        calendarControl.changeMonthFromCombo(change);
    }*/
}

function changeCalendarControlYearFromCombo(change) {
    calendarControl.changeYearFromCombo(change);
/*if (getDateChangeAllowed(lcurrentMonth,change,change,2,2)){
      alert("Previous date not allowed beyond "+pastAllowed +" days \n Future date is not allowed beyond "+futureAllowed +" days  ");
      document.getElementById('years').value=lcurrentYear;
  }else{
        calendarControl.changeYearFromCombo(change);
    }*/
}

function CalendarDateDiff(date1,date2){
    var d1=new Date(date1);
    var d2=new Date(date2);
    var d3=(d2-d1)/86400000;
    return d3;
}

function getCssClass(day, month, year){
    var tmp=year+"/"+month+"/"+day;
    var daydiff=CalendarDateDiff(currentdate,tmp);
    var alertmsg="empty";

    if (daydiff<0 && Math.abs(daydiff)>pastAllowed){
        if (pastAllowed == 0 )
            alertmsg="Previous date not allowed";
        else
            alertmsg="Previous date not allowed beyond "+pastAllowed +" days";
    }

    if (daydiff>0 && Math.abs(daydiff)>futureAllowed){
        if (futureAllowed == 0 )
            alertmsg="Future date is not allowed";
        else
            alertmsg="Future date is not allowed beyond "+futureAllowed +" days";
    }

    if(isCurrentDateAllow==false && daydiff==0){
        alertmsg="Current date not allowed";
    }

    return alertmsg;
}

function getLastDayOfMonth(month,year){
    var day;
    switch(month)	{
        case 1 :
        case 3 :
        case 5 :
        case 7 :
        case 8 :
        case 10:
        case 12:
            day = 31;
            break;
        case 4 :
        case 6 :
        case 9 :
        case 11:
            day = 30;
            break;
        case 2 :
            if(year % 4 == 0)
                day = 29;
            else
                day = 28;
            break;
    }
    return day;
}

function getDateChangeAllowed(month,year,chage,mode,type){
    //mode 1 from arrow 2 from combo   //type 1 Month  default year
    var startdate=new Date();
    var enddate=new Date();
    var locMon=0,locYear=0;
    var returnvalue;
    locYear=parseInt(year,10);

    if (type==1){
        if (mode==1)
            locMon=parseInt(month,10)+chage;
        else
            locMon=parseInt(chage,10);

        if (locMon>12){
            locMon=1;
            locYear=parseInt(year,10)+1;
        }else if (locMon<1){
            locMon=12;
            locYear=parseInt(year,10)-1;
        }
    }else{
        locMon=month;
    }

    startdate.setFullYear(parseInt(locYear,10),parseInt(locMon,10)-1,1);
    enddate.setFullYear(parseInt(locYear,10),parseInt(locMon,10)-1,getLastDayOfMonth(locMon,locYear));

    //alert(" MinAll "+minAllowedDate+"\n Max All D"+maxAllowedDate+"\n st da"+startdate+"\n end date"+enddate);
    //alert("C1" +(startdate>=minAllowedDate && startdate<=maxAllowedDate));
    //alert("C2" +(enddate>=minAllowedDate && enddate<=maxAllowedDate))
    if ((startdate>=minAllowedDate && startdate<=maxAllowedDate)  || (enddate>=minAllowedDate && enddate<=maxAllowedDate))
        returnvalue=false;
    else
        returnvalue=true;

    return returnvalue;
}

function showCalendarControlText(argTextObject,argPastDay,argCurrentDay,argFutureDay,argCurrentDate,argHiddenObject){
    var result="";
    var arrayCurrentDate;
    arrayCurrentDate=argCurrentDate.split("-");
    if (!argTextObject.disabled){
        result=getDateNew(argTextObject.value,arrayCurrentDate[0],"-");
        if (result != ""){
            argTextObject.value=result;
            showCalendarControl(argTextObject,argPastDay,argCurrentDay,argFutureDay,argCurrentDate,argHiddenObject);
            tmparray=(argTextObject.value).split("-");
            result=getCssClass(tmparray[0],tmparray[1],tmparray[2]);
            argHiddenObject.value=tmparray[2]+"-"+tmparray[1]+"-"+tmparray[0];
            hideCalendarControl();
        }else{
            result="Invalid date ";
        }

        if (result != "empty"){
            alert(result);
            argTextObject.value=arrayCurrentDate[2]+"-"+arrayCurrentDate[1]+"-"+arrayCurrentDate[0];
            argHiddenObject.value=arrayCurrentDate[0]+"-"+arrayCurrentDate[1]+"-"+arrayCurrentDate[2];
            setTimeout(function(){
                argTextObject.focus();
            },1);
        }
    }
}

function getDateNew(argString,argCurrentYear,argSeperator){
    var splitLibText="./- ";
    var splitText="-1";
    var temp="",dd="",mm="",yy="";
    var countCheck=0;
    argString=strTrim(argString);
    for(var i=0;i<argString.length;i++){
        if(splitLibText.indexOf(argString.charAt(i))>=0){
            splitText=argString.charAt(i);
            break;
        }
    }
    for(i=0;i<argString.length;i++){
        if(splitLibText.indexOf(argString.substr(i,1))>=0){
            countCheck++;
            if(countCheck==1){
                if(!isNaN(parseFloat(temp))){
                    dd=parseFloat(temp);
                    temp="";
                }
            }else if(countCheck==2){
                if(!isNaN(parseFloat(temp))){
                    mm=parseFloat(temp);
                    temp="";
                }
            }
        }
        else
            temp=temp+argString.substr(i,1);
    }
    if(countCheck==1){
        countCheck=0;
        temp="";
        argString=strTrim(argString+splitText);
        for(i=0;i<argString.length;i++){
            if(splitLibText.indexOf(argString.substr(i,1))>=0){
                countCheck++;
                if(countCheck==1){
                    if(!isNaN(parseFloat(temp))){
                        dd=parseFloat(temp);
                        temp="";
                    }
                }else if(countCheck==2){
                    if(!isNaN(parseFloat(temp))){
                        mm=parseFloat(temp);
                        temp="";
                    }
                }
            }
            else
                temp=temp+argString.substr(i,1);
        }
    }
    yy=parseFloat(temp);
    if(yy>=1 && yy<1000 )
        yy=2000+yy;
    if(splitText==-1 || countCheck<2 || countCheck>2){
        if(dd<1 || dd>31 || isNaN(parseFloat(dd))){
            dd="";
            temp="";
        }else if(mm<1 || mm>12 || isNaN(parseFloat(mm))){
            mm="";
            temp="";
        }
    }else{
        if(dd>=1 && dd<=9){
            dd="0"+dd;
        }else if(dd>31){
            dd="0";
        }
        if(mm>=1 && mm<=9){
            mm="0"+mm;
        }else if(mm>12){
            mm=0;
        }
    }
    if(dd!="" && parseFloat(dd)>0){
        if(mm!=" " && parseFloat(mm)>0){
            if(yy!="" && parseFloat(yy)>0){
                temp=dd+argSeperator+mm+argSeperator+yy;
            }else{
                temp=dd+argSeperator+mm+argSeperator+argCurrentYear;
            }
        }else{
            temp="";
        }
    }else{
        temp="";
    }
    return temp;
}

function DatesOnly(e){
    var unicode=e.charCode? e.charCode : e.keyCode
    if (unicode!=8 && unicode!=9 && unicode!=45 && unicode!=46 && unicode!=47 && unicode!=39 && unicode!=32  && unicode!=36){ //if the key isn't the backspace key (which we should allow)
        if (unicode<48||unicode>57 ) //if not a number
            return false //disable key press
    }
    return true;
}

document.write("<iframe id='CalendarControlIFrame' src='' frameBorder='0' scrolling='no'></iframe>");
document.write("<div id='CalendarControl'></div>");
