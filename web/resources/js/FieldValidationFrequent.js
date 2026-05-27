//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%////
//% call   : To trim the left and right blank spaces in a component (i.e. TextBox,TextArea)
//% Date   : 26-April-2003
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%////

function trim(str){
    lTrim(str);
    rTrim(str);
}
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%////
//% call   : To trim the left trailing blank spaces in a component
//% Date   : 26-April-2003
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%////

function lTrim(str){
    var val=document.getElementById(str).value;
    var len=val.length;
    var temp='';
    for (i=0;i< len;i++){
        var chr=val.charAt(i);
        if (chr != ' ')	{temp=temp+val.substring(i);i=len;}
    }
    document.getElementById(str).value=temp;
    return true;
}

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%////
//% call   : To trim the right trailing blank spaces in a component
//% Date   : 26-April-2003
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%////

function rTrim(str){
    var val=document.getElementById(str).value;
    var len=val.length;
    var temp='';
    for (i=len-1;i>=0;i--){
        chr=val.charAt(i);
        if (chr != ' ')	{temp=temp+val.substring(0,i+1);i=-1;}
    }
    document.getElementById(str).value=temp;
}

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%////
//% call   : To check whether the given field is empty or not
//% By     : Muralidharan G
//% Date   : 26-April-2003
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%////

function checkEmpty(str,msg){
    if (document.getElementById(str).value==""){
        alert('Field Empty, Value Required for '+msg+ '!');
        document.getElementById(str).focus();
        return false;
    }
    return true;
}

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%////
//% call   : To check Numeric 
//% Date   : 26-April-2003
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%////

function checkNumeric(str,msg){
    var list ="0123456789.";
    val = strTrim(document.getElementById(str).value);
    for(var i=0;i<val.length;i++){
        if(list.indexOf(val.charAt(i))== -1){
            if (msg == null){
                alert('Not A Valid Data!');
            }else{
                alert('Not a Valid Data in ' + msg + '!');
            } 			
            document.getElementById(str).value="";
            document.getElementById(str).focus();
            return false;
        }
    }
    return true;	
	
}//checkNumeric

function checkNumericAlone(str,msg){
    var list ="0123456789";
    val = strTrim(document.getElementById(str).value);
    for(var i=0;i<val.length;i++){
        if(list.indexOf(val.charAt(i))== -1){
            if (msg == null){
                alert('Not A Valid Data!');
            }else{
                alert('Not a Valid Data in ' + msg + '!');
            }
            document.getElementById(str).value="";
            document.getElementById(str).focus();
            return false;
        }
    }
    return true;

}//checkNumeric

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%////
//% call   : To trim the left and right blank spaces of a string
//% Date   : 26-April-2003
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%////

function strTrim(str){
    var str1=strLTrim(str);
    var str2=strRTrim(str1);
    return str2;
}

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%////
//% call   : To trim the left trailing blank spaces of a string
//% Date   : 26-April-2003
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%////

function strLTrim(str){
    var len=str.length;
    var temp='';
    for (i=0;i< len;i++){
        var chr=str.charAt(i);
        if (chr != ' ')	{temp=temp+str.substring(i);i=len;}
    }
    return temp;
}

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%////
//% call   : To trim the right trailing blank spaces of a String
//% Date   : 26-April-2003
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%////

function strRTrim(str){
    var len=str.length;
    var temp='';
    for (i=len-1;i>=0;i--){
        chr=str.charAt(i);
        if (chr != ' ')	{temp=temp+str.substring(0,i+1);i=-1;}
    }
    return temp;
}

//this function accepts numbers only from 0 to 9 and not even . and allow back space.
//use this function in the keypress event like onkeypress= "return NumbersOnly(event)"
//arun.v
function NumbersOnly(e){
    var unicode=e.charCode? e.charCode : e.keyCode
    if (unicode!=8 && unicode!=9 && unicode!=46){ //if the key isn't the backspace key (which we should allow)
        if (unicode<48||unicode>57 ) //if not a number
            return false //disable key press
    }
    return true;
}


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%////
//% call   : To find the Difference Between two dates
//% By     : Muralidharan G
//% Date   : 28-July-2003
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%////

function DateDiff(date1,date2){
    //alert("Paased  "+date1 + " " + date2);
    var d1=new Date(date1);
    var d2=new Date(date2);
    //alert("Convert "+d1 + " " + d2);
    var d3=(d2-d1)/86400000;
    //alert("d3"+d3);
    return d3;

}

function checkEmail(str,arg){
    var list="abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ.@1234567890_";
    val=document.getElementById(str).value;
    for(var i=0;i<val.length;i++){
        if(list.indexOf(val.charAt(i))== -1){
            alert("Not a valid Email Id... "+arg);
            //document.getElementById(str).value="";
            document.getElementById(str).focus();
            return false;
        }
    }
    /// Email Valid
    check=0;
    for(var i=0;i<val.length;i++){
        if(list.indexOf(val.charAt(i))== 54){
            check=1;
            break;
        }
    }
    if (check==1) {
        check=0;
        for(var i=0;i<val.length;i++){
            if(list.indexOf(val.charAt(i))== 53){
                check=1;
                break;
            }
        }
    }
    if (check==1)
        return true;
    else {
        alert("Not a valid Email Id... "+arg);
        return false;
    }
    //// End
    //return true;
}

// By C.R.Senthil 

function checkAlphaNumeric(str, msg){
    var list="abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\n";
    val=document.getElementById(str).value;
    for(var i=0;i< val.length;i++){
        if(list.indexOf(val.charAt(i))== -1){
            if (msg == null){
                alert('Not A Valid Data!');
            }else{
                alert('Not a Valid Data in ' + msg + '!');
            }
            //document.getElementById(str).value="";
            document.getElementById(str).focus();
            return false;
        }
    }
    return true;
}//checkAlphaNumeric

function IsEmpty(str){
    trim(str);
    a=document.getElementById(str).value;
    if ((a.charAt(0)==" ") || (a.length==0))
        {
        alert("Please Enter Valid String Data");
           return true;
        }
    else
        return false;  
}// IsEmpty


function isCheckFromToDate(frmYear,frmMonth,frmDay,toYear,toMonth,toDay){

    frmYear=parseFloat(frmYear);
    frmMonth=parseFloat(frmMonth);
    frmDay=parseFloat(frmDay);
    toYear=parseFloat(toYear);
    toMonth=parseFloat(toMonth);
    toDay=parseFloat(toDay);
    if (frmYear > toYear){            
            return false;
    }
    if (frmYear == toYear){
            if (frmMonth > toMonth){
                return false;
            }
            if (frmMonth == toMonth){
                if (frmDay>toDay){
                        return false;
                }
            }
    }
    return true;
}// isCheckFromToDate

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%////
//% call   : Check for Maximum Length of a Text Area
//% Date   : 21-Jul-2003
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%////

function checkTextAreaLen(str1,str2){
	txt=document.getElementById(str1).value;
	len=txt.length;
    lenCnt=0,nxtLineChar=0;
    for(i=0;i<len;i++){       
        if(txt.charCodeAt(i)==10){
            lenCnt+=2;
            nxtLineChar++;
        }else{
            lenCnt++;
        }
    }
	if (lenCnt>str2) {
		alert('Length exceeds than the limit');
		document.getElementById(str1).value=txt.substring(0,str2-nxtLineChar);
	}//end of if
    return lenCnt;
}//checkTextAreaLen


function checkEnterKey(str,msg){    
    a=document.getElementById(str).value;
    if ((a.charCodeAt(0)==10) || (a.charCodeAt(0)==13) || (a.charCodeAt(0)==32))
        {
            if (msg==null) {
                alert("Please Enter Valid String Data");
            }
            else{
                alert("Please Enter Valid String Data "+msg);
            }
            document.getElementById(str).focus();
            return false;
        }

    else
        return true;  
}


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%////
//% call   : To check Decimal values with 2 precision
//% Date   : 26-April-2003
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%////

function checkDecimal(str){
    val=document.getElementById(str).value;

    if (val=="")  {
        return false;
    }
    if (isNaN(val))
    {
        alert('Not a Valid Data');
        //document.getElementById(str).value="";
        document.getElementById(str).focus();
        return false;
    }
    else{
        ind=val.indexOf(".");
        if(ind != -1){
            len=val.length;
            temp=val.substring(0,ind+3);
            if (temp.length < ind+3){	temp=temp+'0';	}
            document.getElementById(str).value=temp;
        }
        else{
            //document.getElementById(str).value=val+'0.00';
            document.getElementById(str).value=val+'.00';
        }
   } 
    var chk=val.indexOf('0',0);
    while (chk == 0 && val.length>1){
            val=val.substring(1);
            chk=val.indexOf('0',0);
            document.getElementById(str).value=val;
    }
    return true;
}//end of function checkDecimal

function isDate(d, m, y,arg) {    
    if (!checkNumericText(d)){
        alert("Please give valid input to day field!");        
        document.getElementById(d).focus();
        return false;
    }
    if (!checkNumericText(y)){
        alert("Please give valid input to year field!");
        document.getElementById(y).focus();
        return false;
    }

	var yy,mm,dd; 
	var im,id,iy;
	var present_date = new Date();
	yy = 1900 + present_date.getYear();
	if (yy > 3000)
	{
		yy = yy - 1900;
	}
	mm = present_date.getMonth();
	dd = present_date.getDate();
	var entered_month = eval(m)-parseInt(1);
	var invalid_month = eval(m)-parseInt(1);
	var entered_day = d; 
	var entered_year = y; 
        var msg = arg;
        if (msg == null){
            msg=""; 
        }

	if ( (d == 0) || (m == 0) || (y == 0) )
	{
		alert("Please enter correct date "+ msg);
		return false;
	}
	if ( is_greater_date(entered_year,entered_month,entered_day,yy,mm,dd,msg) && is_valid_day(invalid_month,entered_day,entered_year,msg) )
	{
		return true; 
	}
	return false;
}

function checkNumericText(str){
    str=str+"";
    if (str.length > 0){
        var list ="0123456789";
        val = str;
        for(var i=0;i<val.length;i++){
            if(list.indexOf(val.charAt(i))== -1){
                return false;
            }
        }            
        return true;	
    }else{
        return false;
    }
}//checkNumericNew

function checkNumericOnly(str,arg){
    var list="0123456789";
    var val=document.getElementById(str).value;
    for(var i=0;i<val.length;i++){
    if(list.indexOf(val.charAt(i))== -1){
        alert("Not Valid Number .. "+arg);
 //       document.getElementById(str).value="";
        document.getElementById(str).focus();
        return false;
    }
}
return true;
}

function is_greater_date(entered_year,entered_month,entered_day,yy,mm,dd,arg)
{       
       var msg = arg;
        if (msg == null){
            msg=""; 
        }  
	if (eval(entered_year) > eval(yy))
	{
		alert("The Year field is entered incorrectly."+msg);
		return false;
	}
	if (eval(entered_year) == eval(yy))
	{
		if (eval(entered_month) > eval(mm))
		{
			alert("The Month field is entered incorrectly."+msg);
			return false;
		}
		if (eval(entered_month) == eval(mm))
		{
			if (eval(entered_day) > eval(dd))
			{
				alert("The Date field is entered incorrectly."+msg);
				return false;
			}
		}
	}
	return true;
}

function is_valid_day(entered_month,entered_day,entered_year,arg){
        var days_in_month="";
        var msg = arg;
        if (msg == null){
            msg=""; 
        }
        if ((entered_year % 4) == 0) { 
            days_in_month = "312931303130313130313031";
 	    }else{
		    days_in_month = "312831303130313130313031";
 	    }
	    //var months = new Array("January","February","March","April","May","June","July","August","September","October","November","December");
	    if (eval(entered_month) != -1){
		   //if (eval(entered_day) > eval(days_in_month.substring(2*entered_month,2*entered_month+2)))
           if (eval(entered_day) > days_in_month.substring(2*(eval(entered_month)-1),2*(eval(entered_month)-1)+2)){
                alert ("The Date field is entered wrongly (the day field value exceeds the number of days for the month entered)."+msg);
                return false;
            }
        }
	return true;
}

  function checkSpecialChars(ctrl){
        var str="`~!@#$%^&*()-_=+,<.>/?;:'[{]}|\"\\";
        val=document.getElementById(ctrl).value;
        for(i=0; i < val.length; i++)
        {
            if(str.indexOf(val.charAt(i))>=0){
              alert("Special Characters not allowed!");
              document.getElementById(ctrl).focus();
              return false;
             }    
          } 
          return true;
    }


function loadCurrentDate(day,month,year){

   var Present_Date=new Date();

   var Present_Day=Present_Date.getDate();

   var Present_Month=Present_Date.getMonth();

   Present_Month=parseInt(Present_Month)+parseInt(1);

   var Present_Year=1900+Present_Date.getYear();

   if(parseInt(Present_Year)>3000)  {

	    Present_Year=Present_Year-1900;
	}

   if(parseInt(Present_Month)<10)  {

	     Present_Month="0"+Present_Month;

	}

   if (parseInt(Present_Day)<10)

        Present_Day="0"+Present_Day;

    document.getElementById(day).value=Present_Day;

    document.getElementById(month).value=Present_Month;

    document.getElementById(year).value=Present_Year;

}

function funNameCap(str) {
    trim(str);
    var name=document.getElementById(str).value;
    var temp="";
    var i=0;
    while(i < name.length) {
        if (i==0) 
            temp=name.charAt(0).toUpperCase();
        else if (name.charAt(i)==" ") {
            temp+=name.charAt(i).toUpperCase();
            temp+=name.charAt(++i).toUpperCase();
        }
        else
            temp+=name.charAt(i)
        i++;
    }
    document.getElementById(str).value=temp;
}

function checkNameString(str,msg){
	var list="abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ .-";
	var val=document.getElementById(str).value;
	for(var i=0;i<val.length;i++){
		if(list.indexOf(val.charAt(i))== -1){
                        if (msg == null){
                             alert('Not A Valid Data!');
                         }else{
                              alert('Not a Valid Data in ' + msg + '!');
                         }
			//document.getElementById(str).value="";
			document.getElementById(str).focus();
			return false;
		}
	}
    return true;
}


function checkNameStringNew(str,msg){
	var list="abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ  .()0123456789[]-";
	var val=document.getElementById(str).value;
	for(var i=0;i<val.length;i++){
		if(list.indexOf(val.charAt(i))== -1){
                        if (msg == null){
                             alert('Not A Valid Data!');
                         }else{
                              alert('Not a Valid Data in ' + msg + '!');
                         }
			//document.getElementById(str).value="";
			document.getElementById(str).focus();
			return false;
		}
	}
    return true;
}

function isDateNew(day, month, year,msg) {
    var entered_day="",entered_month="",entered_year="";
    try{
        entered_day=document.getElementById(day).value;
        entered_month=document.getElementById(month).value;
        entered_year=document.getElementById(year).value;
    }
    catch(e)
    {
        alert(e.toString());
        return false;
    }

    if (!checkNumericText(entered_day))
    {
        alert("Please give valid input to day field!");
        document.getElementById(day).focus();
        return false;
    }
    if (entered_month==0)
    {
        alert("Please give valid input to month field!");
        document.getElementById(month).focus();
        return false;
    }
    if (!checkNumericText(entered_year) || entered_year.length!=4 ){
        alert("Please give valid input to year field!");
        document.getElementById(year).focus();
        return false;
    }
	if(is_valid_day(entered_month,entered_day,entered_year,msg))
	{
		return true;
	}
	return false;
}

 function WithComma(argValue,argLowerLimit,argInterLevel){
        var strOmitted="00",lowerLimit=0,interLevel=0;
        var strNumber="",checkNumber=0,newStr="",sst="";
        var k="",len=0,res="",i=0,z=0;
        var strOmitted="00";

        strNumber=argValue;
    lowerLimit=argLowerLimit;
    interLevel=argInterLevel;

    checkNumber=parseFloat(strNumber);
    //check the number is it have minus sighn,if it has remove that sign..
    if(checkNumber<0){
        k="-";
        strNumber=String(checkNumber*-1);
    }
    else{
        k="";
    }
    //check the number , is it have decimal values, if it has separate it..
    sst=String(strNumber);
    z=sst.indexOf(".");
    if(z>0){
        strOmitted=sst.substring(z+1,sst.length);
        sst=sst.substring(0,z);
    }
    if(parseInt(strOmitted)<10 && strOmitted.length==1 && strOmitted!="00")
        strOmitted=strOmitted+"0";

    strNumber=sst; //this is the decimal value removed, sign removed value

    len=strNumber.length;
    newStr=new String(strNumber);
    var firstQtr="",secondQtr="";

    //this loops add the , in the value..
    for(i=len-lowerLimit;i>0;i-=interLevel){
        firstQtr=newStr.substring(0,i);
        secondQtr=newStr.substring(i,len);
        newStr=(firstQtr+","+secondQtr);
        len=newStr.length;
    }
    //add minus sign, decimal value with the comma included value..
    res=k+(newStr+"."+strOmitted);
    //alert("With Comma "+res);
    //alert("With out Comma "+replaceComma(res));
    return res;
}


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%////

//% call   : To check whether given field contains Postive Integer or Not

//% Date   : 21-July-2003

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%////

function checkPositiveInt(str){

	if (!checkInt(str)) return false;

	var txt=document.getElementById(str).value;

	var ind=txt.indexOf('-');

	if (ind == 0){

            document.getElementById(str).value=txt.substring(1);

            return true;

        }else if (ind > 0) {

            alert ('Please enter a positive value');

            document.getElementById(str).value="";

            return false;

        }
    return true;
}

function is_Less_date(entered_year,entered_month,entered_day,yy,mm,dd,arg)

{

       var msg = arg;

        if (msg == null){

            msg="";

        }

	if (entered_year < yy)

	{

		alert("The Year field is entered incorrectly. "+msg);

		return false;

	}

	if (entered_year == yy)

	{

		if (entered_month < mm)
		{
			alert("The Month field is entered incorrectly."+msg);

			return false;

		}

		if (entered_month == mm)

		{

			if (entered_day < dd)

			{

				alert("The Date field is entered incorrectly."+msg);

				return false;

			}

		}

	}

	return true;

}

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%////

//% call   : To check whether given field contains Integer or Not

//% Date   : 26-April-2003

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%////



function checkInt(str){

		var val=document.getElementById(str).value;

		if (isNaN(val)){

 		   alert('Invalid Character');

  		   document.getElementById(str).value='';

		   document.getElementById(str).focus();

		   return false;

		  }

		if ((val >2147483647)||(val<-2147483648)){

				alert ('Length Exist than the limit');

  				document.getElementById(str).value='2147483647';

				document.getElementById(str).focus();

				return false;

		}

  		if (val.indexOf('.') != -1){

  			alert ('Invalid Character');

  			//document.getElementById(str).value='';

			document.getElementById(str).focus();

			return false;

  		}

  		var chk=val.indexOf('0',0);

  		while (chk == 0){

  			val=val.substring(1);

  			chk=val.indexOf('0',0);

  			document.getElementById(str).value=val;

  		}

return true;

}

function replaceComma(argValue){

    var data=argValue.split(",");

    var i=0;

    var len=data.length;

    var newVal="";

    for(i=0;i<len;i++){

        newVal=newVal+data[i];

    }
    
    return newVal;
}


function funReplaceSingleQout(arg) {
    var a = document.getElementById(arg).value;
    var aa = "";
    var i = 0;
    while(a.length>i) {
        if (a.charAt(i)=="'")
            aa+="`";
        else if (a.charAt(i)=='"')
            aa+="`";
        else
            aa+=a.charAt(i);
        i++;
    }
    document.getElementById(arg).value=aa;
}

function checkStringHypen(str,msg){
	var list="abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ -";
	var val=document.getElementById(str).value;
	for(var i=0;i<val.length;i++){
		if(list.indexOf(val.charAt(i))== -1){
                        if (msg == null){
                             alert('Not A Valid Data!');
                         }else{
                              alert('Not a Valid Data in ' + msg + '!');
                         }
			//document.getElementById(str).value="";
			document.getElementById(str).focus();
			return false;
		}
	}
return true;
}

function isAlphaNumberKey(evt){
            var charCode = (evt.which) ? evt.which : evt.keyCode;

            if ((charCode==8) || (charCode==9) || (charCode==32))   //backspace and tap key
                return true;

            if ((charCode > 64 && charCode < 91) || (charCode > 96 && charCode < 123) || (charCode > 47 && charCode < 58))
                return true;

           return false;
}


function isNumberKeyWithDecimal(evt){
             var charCode = (evt.which) ? evt.which : evt.keyCode;

             if ((charCode==8) || (charCode==9))   //backspace and tap key
                return true;

             if (charCode!=46){
                    if (charCode > 31 && (charCode < 48 || charCode > 57))
                        return false;
             }
             return true;
}


function isNumberKey(evt){
    var charCode = (evt.which) ? evt.which : evt.keyCode;

    if ((charCode==8) || (charCode==9))   //backspace and tap key
        return true;

    if (charCode > 31 && (charCode < 48 || charCode > 57))
        return false;

    return true;
}

function toFixDecimalPlaces(myNumber, NumberDec){
    var cordec = Math.pow(10,NumberDec);
    myNumber = Math.round(myNumber * cordec) / cordec;
    return myNumber;
}

function checkAlpha(str, msg){
    var list="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    val=document.getElementById(str).value;
    for(var i=0;i< val.length;i++){
	if(list.indexOf(val.charAt(i))== -1){
	    if (msg == null){
		alert('Not a Valid Data!');
	    }else{
		alert('Not a Valid Data in ' + msg + '!');
	    }
	    document.getElementById(str).focus();
	    return false;
	}
    }
    return true;
}

function checkEmptySpace(str,msg){
    var list=" ";
    var val=document.getElementById(str).value;
    for(var i=0;i<val.length;i++){
	if(list.indexOf(val.charAt(i))>=0){
	    if (msg == null){
		alert('Empty space not allowed');
            } else {
		alert('Empty space not allowed in ' + msg);
            }
	    document.getElementById(str).focus();
	    return false;
	}
    }
    return true;
}
function checkAddressString(str, msg){
    var list="abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\ / .,#-\n ";
    val=document.getElementById(str).value;
    for(var i=0;i< val.length;i++){
        if(list.indexOf(val.charAt(i))== -1){
            if (msg == null){
                alert('Invalid data');
            }else{
                alert('Invalid data in ' + msg);
            }
            document.getElementById(str).focus();
            return false;
        }
    }
    return true;
}//checkAddressString

function replaceEnterKey(textarea,replaceWith){
    textarea.value=escape(textarea.value)
    for(i=0; i<textarea.value.length; i++){
            if(textarea.value.indexOf("%0D%0A") > -1){
            textarea.value=textarea.value.replace("%0D%0A",replaceWith)
            }
            else if(textarea.value.indexOf("%0A") > -1){
            textarea.value=textarea.value.replace("%0A",replaceWith)
            }
            else if(textarea.value.indexOf("%0D") > -1){
            textarea.value=textarea.value.replace("%0D",replaceWith)
            }
    }
    textarea.value=unescape(textarea.value)
}

function PositiveDecimalNumbersOnly(e){
            var unicode=e.charCode? e.charCode : e.keyCode;
            if (e.charCode == "0" ){ // allowing all non-characters
              return true;
            }else{
                if(unicode!=46){// dot (.) // minus (-)
                    if (unicode<48||unicode>57 ) //if not a number
                        return false; //disable key press
                }
                if ((unicode ==46) && (!funCheckDotDuplication(e.target.id))) return false;
            }
            return true;
    }

    function NumbersOnly(e){
        var unicode=e.charCode? e.charCode : e.keyCode
            if (unicode!=8 && unicode!=9 && unicode!=46){ //if the key isn't the backspace key (which we should allow)
                if (unicode<48||unicode>57 ) //if not a number
                    return false //disable key press
            }
}


function CoolNumbersOnly(e){
        var unicode=e.charCode? e.charCode : e.keyCode
        if (unicode != 8 && unicode!=9 && unicode!=46 ){ //if the key isn't the backspace key (which we should allow)
            if (unicode<48||unicode>57 ) //if not a number
                return false //disable key press
        }
}

function URLEncode(argString)
{
	// The Javascript escape and unescape functions do not correspond
	// with what browsers actually do...
	var SAFECHARS = "0123456789" +					// Numeric
					"ABCDEFGHIJKLMNOPQRSTUVWXYZ" +	// Alphabetic
					"abcdefghijklmnopqrstuvwxyz" +
					"-_.!~*'()";					// RFC2396 Mark characters
	var HEX = "0123456789ABCDEF";

	var plaintext = argString;
	var encoded = "";
	for (var i = 0; i < plaintext.length; i++ ) {
		var ch = plaintext.charAt(i);
	    if (ch == " ") {
		    encoded += "+";				// x-www-urlencoded, rather than %20
		} else if (SAFECHARS.indexOf(ch) != -1) {
		    encoded += ch;
		} else {
		    var charCode = ch.charCodeAt(0);
			if (charCode > 255) {
			    alert( "Unicode Character '"
                        + ch
                        + "' cannot be encoded using standard URL encoding.\n" +
				          "(URL encoding only supports 8-bit characters.)\n" +
						  "A space (+) will be substituted." );
				encoded += "+";
			} else {
				encoded += "%";
				encoded += HEX.charAt((charCode >> 4) & 0xF);
				encoded += HEX.charAt(charCode & 0xF);
			}
		}
	} // for

	return encoded;
	//return false;
}

function URLDecode(argString)
{
   // Replace + with ' '
   // Replace %xx with equivalent character
   // Put [ERROR] in output if %xx is invalid.
   var HEXCHARS = "0123456789ABCDEFabcdef";
   //var encoded = document.URLForm.F2.value;
   var encoded = argString;
   var plaintext = "";
   var i = 0;
   while (i < encoded.length) {
       var ch = encoded.charAt(i);
	   if (ch == "+") {
	       plaintext += " ";
		   i++;
	   } else if (ch == "%") {
			if (i < (encoded.length-2)
					&& HEXCHARS.indexOf(encoded.charAt(i+1)) != -1
					&& HEXCHARS.indexOf(encoded.charAt(i+2)) != -1 ) {
				plaintext += unescape( encoded.substr(i,3) );
				i += 3;
			} else {
				alert( 'Bad escape combination near ...' + encoded.substr(i) );
				plaintext += "%[ERROR]";
				i++;
			}
		} else {
		   plaintext += ch;
		   i++;
		}
	} // while
   //document.URLForm.F1.value = plaintext;
   //return false;
   return plaintext;
}

function checkAllCheckBoxes(checkboxname, tocheckas, callonclick){
        chkBox=document.getElementsByName(checkboxname);
        for (i=0;i<chkBox.length;i++){
            chkBox[i].checked=tocheckas;
            if (callonclick){
                chkBox[i].onclick();
            }
        }
}

function createCookie(name, value, days) {
    if (days) {
        var date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        var expires = "; expires=" + date.toGMTString();
    } else var expires = "";
    document.cookie = escape(name) + "=" + escape(value) + expires + "; path=/";
}

function readCookie(name) {
    var nameEQ = escape(name) + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') c = c.substring(1, c.length);
        if (c.indexOf(nameEQ) == 0) return unescape(c.substring(nameEQ.length, c.length));
    }
    return null;
}

function eraseCookie(name) {
    createCookie(name, "", -1);
}