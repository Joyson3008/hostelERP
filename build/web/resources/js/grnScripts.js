function funCheckNegative(argTaxid){
    var txt=document.getElementById('txtTaxPercentage_'+argTaxid).value;       
    var strArray=txt.split(".");
    if ( ( (strArray.length) - 1) > 1){
        alert("ERROR! \n\nYou have entered more than one decimal point!\nPlease enter only one!");
        document.getElementById('txtTaxPercentage_'+argTaxid).value="";
        return false;
    }        
    var ind=txt.indexOf('-');
    if (ind == 0){
        document.getElementById('txtTaxPercentage_'+argTaxid).value=txt.substring(1);
    }
    if ( parseFloat(txt) > 100 ){
        alert("Tax should be less than 100");
        document.getElementById('chkTax_'+argTaxid).checked=false;
        document.getElementById('txtTaxPercentage_'+argTaxid).disabled=true;
        document.getElementById('txtTaxPercentage_'+argTaxid).value="";            
        return false;
    }
    try{
        txt=parseFloat(txt).toFixed(2);
    }catch(e){}
    document.getElementById('txtTaxPercentage_'+argTaxid).value=txt;
    return true;
}
    
function funCheckNegativevalue(argRow){        
    var txt=document.getElementById('txtDiscount_'+argRow).value;       
    var strArray=txt.split(".");
    if ( ( (strArray.length) - 1) > 1){
        alert("ERROR! \n\nYou have entered more than one decimal point!\nPlease enter only one!");
        document.getElementById('txtDiscount_'+argRow).value=document.getElementById('txtDiscount_'+argRow).title;
        return false;
    }                
    var ind=txt.indexOf('-');
    if (ind == 0){
        document.getElementById('txtDiscount_'+argRow).value=txt.substring(1);
    }
    funAmountCheck(argRow);
    return true;
}
    
function funCheckDecimal(arg){
    trim(arg);  
    val=document.getElementById(arg).value;
    ind=val.indexOf(".");
    if (ind > 0) {
        alert("Should not accept value in Decimal");
        document.getElementById(arg).value=document.getElementById(arg).title;            
        return false;
    }
    document.getElementById(arg).focus();
    return true;
}

function funCheckLength(argField,argDiv,argLength){
    len=checkTextAreaLen(argField,argLength);
    document.getElementById(argDiv).innerHTML="Entered " + len + " of "+argLength+" characters."
}

function funShowTaxForm(argRow){
    xmlHttp=GetXmlHttpObject();
    if (xmlHttp==null){
        alert("Browser does not support");
        return;
    }        
    if (document.getElementById('chk_'+argRow).checked){
        document.getElementById('cmdSave').disabled=true;
        var url="GrnDetailsAdvancedInner.jsp?RowVal="+argRow+"&iden=10";            
        divSelect="divTaxAdd_"+argRow;            
        xmlHttp.onreadystatechange=stateChanged;
        xmlHttp.open("GET",url,true);
        xmlHttp.send(null);        
    }
}
    
function funShowAdditionalForm(argRow){
    xmlHttp=GetXmlHttpObject();
    if (xmlHttp==null){
        alert("Browser does not support");
        return;
    }   
    if (document.getElementById('chk_'+argRow).checked){            
        //document.getElementById("divAdditionalAdd"+argRow).style.left=document.getElementById("hrfAddAdditional"+argRow).style.left;
        document.getElementById('cmdSave').disabled=true;
        var Additionalvalues = document.getElementById('hdnAdditionalValue_'+argRow).value;
        var url="GrnDetailsAdvancedInner.jsp?RowVal="+argRow+"&iden=15&Additionalvalues="+Additionalvalues;
        divSelect="divAdditionalAdd_"+argRow;
        xmlHttp.onreadystatechange=stateChanged;
        xmlHttp.open("GET",url,true);
        xmlHttp.send(null);        
    }else{
        alert('Select product before View/Edit !')
    }
}
        
function funAjaxmethod(arg){
    xmlHttp=GetXmlHttpObject();
    if (xmlHttp==null){
        alert("Browser does not support");
        return;
    }
    if (arg==2){
        document.getElementById('txtDivision').value="";
        arg=1;
    }
    if (arg==1){
        division=document.getElementById('txtDivision').value;
        var url="GrnDetailsAdvancedInner.jsp?Division="+division+"&iden=11";
        divSelect="divDivision";
    }
    xmlHttp.onreadystatechange=stateChanged;
    xmlHttp.open("GET",url,true);
    xmlHttp.send(null);
}
    
function GetXmlHttpObject(){ 
    var objXMLHttp=null;        
    if (window.XMLHttpRequest){
        objXMLHttp=new XMLHttpRequest()
    }
    else if (window.ActiveXObject){
        objXMLHttp=new ActiveXObject("Microsoft.XMLHTTP")
    }
    return objXMLHttp
}
function stateChanged(){
    if (xmlHttp.readyState==4 || xmlHttp.readyState=="complete"){
        document.getElementById(divSelect).style.display="block";          
        document.getElementById(divSelect).innerHTML=xmlHttp.responseText;

        if (divSelect.indexOf("divAdditionalAdd")>=0){
            stripeTables('tblExtra','dynaColorTR1','dynaColorTR2');
        }else if (divSelect.indexOf("divTaxAdd")>=0){
            stripeTables('tblTax','dynaColorTR1','dynaColorTR2');
        }else if(divSelect=="divDivision"){
            stripeTables('tblDivision','dynaColorTR1','dynaColorTR2');
        }
            
        if (divSelect.substring("divTaxAdd") != -1 ){
            try{
                var rowval=document.getElementById('hdnRowVal').value; //Product Row value
                var count=document.getElementById('hdnTaxCount').value; // Tax row value
                hidtaxvalues=document.getElementById('hdnTaxValue_'+rowval).value; // hidden tax value
                if (hidtaxvalues == "") return false;
                var arrvalue=hidtaxvalues; //+"&&";
                for (var i=1; i <= count;i++){
                    var arr=arrvalue.split("|~|");
                    for (var j=0; j < arr.length; j++){
                        var innerarr=arr[j].split("!`!");
                        if (document.getElementById('chkTax_'+i).value == innerarr[1]){
                            document.getElementById('chkTax_'+i).checked=true;
                            document.getElementById('txtTaxPercentage_'+i).value=innerarr[2];
                            document.getElementById('txtTaxPercentage_'+i).disabled=false;
                            document.getElementById('txtTaxPriority_'+i).value=innerarr[3];
                            document.getElementById('txtTaxPriority_'+i).disabled=false;  
                        }// end of if
                    }// end of inner for
                }// end of outer for
            }// end of try
            catch (e){}
        } //end of if (divSelect.substring("divTaxAdd") != -1         
        if(divSelect=="divOverAllDeductions"){
            document.getElementById(divSelect).innerHTML=xmlHttp.responseText;
            document.getElementById(divSelect).style.display="block";
            return true;
        }
        if(divSelect=="divOverAllAdditionsB4Tax"){
            document.getElementById(divSelect).innerHTML=xmlHttp.responseText;
            document.getElementById(divSelect).style.display="block";
            return true;
        }                
        if(divSelect=="divAdditionalAdd"){
            document.getElementById(divSelect).innerHTML=xmlHttp.responseText;
            document.getElementById(divSelect).style.display="block";
            return true;
        }                        
    }//endif
    return true;
}
    
function funShowDivision(argDivision,argDivisionId){
    document.getElementById('txtDivision').value=argDivision;
    document.getElementById('hdnDivisionId').value=argDivisionId;
    document.getElementById('divDivision').innerHTML="";
    document.getElementById('divDivision').style.display="none";        
}
    
function funCheck(argRow){
    if (document.getElementById('chk_'+argRow).checked){
        document.getElementById('txtRecQty_'+argRow).disabled=false;
        document.getElementById('txtPrice_'+argRow).disabled=false;
        document.getElementById('txtDiscount_'+argRow).disabled=false;
        document.getElementById('txtWarrantymonths_'+argRow).disabled=false;            
    }
    else{
        document.getElementById('txtRecQty_'+argRow).disabled=true;
        document.getElementById('txtRecQty_'+argRow).value=document.getElementById('txtRecQty_'+argRow).title;
        document.getElementById('txtPrice_'+argRow).disabled=true;
        document.getElementById('txtPrice_'+argRow).value=document.getElementById('txtPrice_'+argRow).title;
        document.getElementById('txtDiscount_'+argRow).disabled=true;
        document.getElementById('txtDiscount_'+argRow).value=document.getElementById('txtDiscount_'+argRow).title;
        document.getElementById('txtWarrantymonths_'+argRow).disabled=true;
        document.getElementById('txtWarrantymonths_'+argRow).value=document.getElementById('txtWarrantymonths_'+argRow).title;
    }
    funCalculateTotalCost(argRow);        
}
    
function funCheckTax(argTaxCount){
    if (document.getElementById('chkTax_'+argTaxCount).checked){
        document.getElementById('txtTaxPercentage_'+argTaxCount).disabled=false;
        document.getElementById('txtTaxPriority_'+argTaxCount).disabled=false;
    }
    else{
        document.getElementById('txtTaxPercentage_'+argTaxCount).disabled=true;
        document.getElementById('txtTaxPriority_'+argTaxCount).disabled=true;
        document.getElementById('txtTaxPercentage_'+argTaxCount).value="";
    }
}
    
function funCheckAdditional(argAdditionalCount){
    if (document.getElementById('chkAdditional_'+argAdditionalCount).checked){
        document.getElementById('txtAdditionalDesc_'+argAdditionalCount).disabled=false;
        document.getElementById('txtAdditionalAmt_'+argAdditionalCount).disabled=false;
    }
    else{
        document.getElementById('txtAdditionalDesc_'+argAdditionalCount).disabled=true;
        document.getElementById('txtAdditionalDesc_'+argAdditionalCount).value="";
        document.getElementById('txtAdditionalAmt_'+argAdditionalCount).disabled=true;
        document.getElementById('txtAdditionalAmt_'+argAdditionalCount).value="";
    }
}
    
function funClose(){
    document.getElementById(divSelect).innerHTML="";
    document.getElementById(divSelect).style.display="none";
    document.getElementById(divAdditionalSelect).innerHTML="";
    document.getElementById(divAdditionalSelect).style.display="none";
}
    
function funCloseTaxDiv(argRowVal){
    var taxcount=document.getElementById('hdnTaxCount').value;
    document.getElementById('hdnTaxValue_'+argRowVal).value="";
    document.getElementById('hdnTotalTax_'+argRowVal).value="0.00";
    document.getElementById('cmdSave').disabled=false;
    funAddTax(taxcount,argRowVal);
    document.getElementById('divTaxAdd_'+argRowVal).style.display="none";
    document.getElementById('divTaxAdd_'+argRowVal).innerHTML="";    
    document.getElementById('divTaxAdd_'+argRowVal).style.display="none";
    document.getElementById('divTaxAdd_'+argRowVal).innerHTML="";
}
    
function funCloseAdditionalDiv(argRowVal){
    //var Additionalcount=document.getElementById('hdnAdditionalCount').value;
    //document.getElementById('hdnAdditionalValue'+argRowVal).value="";
    document.getElementById('cmdSave').disabled=false;
    //funAddAdditional(Additionalcount,argRowVal);
    document.getElementById('divAdditionalAdd_'+argRowVal).style.display="none";
    document.getElementById('divAdditionalAdd_'+argRowVal).innerHTML="";    
}
    
    
function funQtyCheck(argRowVal){
    document.getElementById('hdnTotalAmount_'+argRowVal).value="";
    trim("txtRecQty_"+argRowVal);
    if (! checkEmpty("txtRecQty_"+argRowVal,"Ordering Quantity")) return false;
    if ( parseFloat(document.getElementById('txtRecQty_'+argRowVal).value) <= 0){        
        alert("Not a valid entry");
        document.getElementById('txtRecQty_'+argRowVal).value=document.getElementById('txtRecQty_'+argRowVal).title;
        document.getElementById('txtRecQty_'+argRowVal).focus();
        return false;
    }
    if ( parseFloat(document.getElementById('txtRecQty_'+argRowVal).value) > parseFloat(document.getElementById('txtRecQty_'+argRowVal).title) ){
        alert("Ordering Quantity value should be less than or equal to Quantity Ordered value");
        document.getElementById('txtRecQty_'+argRowVal).value=document.getElementById('txtRecQty_'+argRowVal).title;
        document.getElementById('txtRecQty_'+argRowVal).focus();
        return false;
    }
    funCalculateTotalCost(argRowVal);
    return true;
}    
function funAddTax(argTaxCount,argRowVal){
    var taxvalues="";
    var totaltax="0";
    var cnt="0";
    var discount;
    var productid=document.getElementById('chk_'+argRowVal).value;   
    var taxPriorityLength=document.getElementById('txtTaxPriority_1').length;
    for(var j=1;j<=taxPriorityLength;j++){    
        for (var i=1; i<= argTaxCount; i++){
            taxPriorityObj=document.getElementById('txtTaxPriority_'+i);
            taxPriority=parseFloat(taxPriorityObj.options[taxPriorityObj.selectedIndex].value);
            if ( taxPriority == j){        
                if (document.getElementById('chkTax_'+i).checked){
                        trim("txtTaxPercentage_"+i);
                        if (! checkEmpty("txtTaxPercentage_"+i,"Tax value")) return false;
                        cnt++;
                        totaltax=parseFloat(totaltax)+parseFloat(document.getElementById('txtTaxPercentage_'+i).value);
                        if (taxvalues == ""){
                            taxvalues=productid+"!`!"+document.getElementById('chkTax_'+i).value+"!`!"+parseFloat(document.getElementById('txtTaxPercentage_'+i).value).toFixed(2)+"!`!"+taxPriority;
                        }
                        else{
                            taxvalues=taxvalues+"|~|"+productid+"!`!"+document.getElementById('chkTax_'+i).value+"!`!"+parseFloat(document.getElementById('txtTaxPercentage_'+i).value)+"!`!"+taxPriority;
                        }
                }//end of if (document.getElementById('chkTax_'+i).checked...
            }//end of if (taxPriority....
        }//end of for ...i
    }//end of for ...j        
    if (taxvalues == ""){
        alert("No tax selected");
    //document.getElementById('lblAddTax_'+argRowVal).innerHTML="("+cnt+")";
    }
    document.getElementById('hdnTotalTax_'+argRowVal).value=totaltax;
    document.getElementById('lblAddTax_'+argRowVal).innerHTML="("+cnt+")";        
    document.getElementById('hdnTaxValue_'+argRowVal).value=taxvalues;
    document.getElementById('cmdSave').disabled=false;
    document.getElementById('divTaxAdd_'+argRowVal).style.display="none";
    document.getElementById('divTaxAdd_'+argRowVal).innerHTML="";
    funCalculateTotalCost(argRowVal);
    return true;
}
    
function funAddAdditional(argAdditionalCount,argRowVal){
    var additionalvalues="";
    var totaladditional="0";
    var cnt="0";
    var discount;
    var productid=document.getElementById('chk_'+argRowVal).value;        
    for (var i=1; i<= argAdditionalCount; i++){
        if (document.getElementById('chkAdditional_'+i).checked){
            trim("txtAdditionalDesc_"+i);
            trim("txtAdditionalAmt_"+i);
            if (! checkEmpty("txtAdditionalDesc_"+i,"Additional Desc value")) return false;
            if (! checkEmpty("txtAdditionalAmt_"+i,"Additional Amount value")) return false;
            if(!checkDecimal("txtAdditionalAmt_"+i)) return false;
                
            var txt=document.getElementById('txtAdditionalDesc_'+i).value;
            var ind=txt.indexOf("|~|");
            var ind1=txt.indexOf("'");
            var ind2=txt.indexOf("&");
            if (ind > 1 || ind1 > 1  || ind2 > 1){
                alert("In Extra Description @@ and & and ' symbol not allowed");
                return false;
            }
                
            cnt++;
            totaladditional=parseFloat(totaladditional)+parseFloat(document.getElementById('txtAdditionalAmt_'+i).value);
            if (additionalvalues == ""){
                additionalvalues=productid+"!`!"+document.getElementById('txtAdditionalDesc_'+i).value+"!`!"+parseFloat(document.getElementById('txtAdditionalAmt_'+i).value).toFixed(2);
            }
            else{
                additionalvalues=additionalvalues+"|~|"+productid+"!`!"+document.getElementById('txtAdditionalDesc_'+i).value+"!`!"+parseFloat(document.getElementById('txtAdditionalAmt_'+i).value).toFixed(2);
            }
        }
    }
    if (additionalvalues == ""){
        alert("No additional selected");
        document.getElementById('lblAddAdditional_'+argRowVal).innerHTML="";
    //return false;
    }
    document.getElementById('hdnTotalAdditional_'+argRowVal).value=totaladditional;
    document.getElementById('lblAddAdditional_'+argRowVal).innerHTML=parseFloat(totaladditional).toFixed(2);        
    document.getElementById('hdnAdditionalValue_'+argRowVal).value=additionalvalues;
    document.getElementById('cmdSave').disabled=false;
    document.getElementById('divAdditionalAdd_'+argRowVal).style.display="none";
    document.getElementById('divAdditionalAdd_'+argRowVal).innerHTML="";
    funCalculateTotalCost(argRowVal);
    return true;
}
    
function funAmountCheck(argRow){
    var val=document.getElementById('txtPrice_'+argRow).value;
    var strArray=val.split(".");
    if ( ( (strArray.length) - 1) > 1){
        alert("ERROR! \n\nYou have entered more then one decimal point!\nPlease only enter one!");
        document.getElementById('txtPrice_'+argRow).value=document.getElementById('txtPrice_'+argRow).title;
        return false;
    }    
    trim("txtPrice_"+argRow);
    if (! checkEmpty("txtPrice_"+argRow,"Amount Quoted")){
        document.getElementById('txtPrice_'+argRow).value="";
        document.getElementById('txtPrice_'+argRow).focus();
        return false;
    }
    if ( parseFloat(document.getElementById('txtPrice_'+argRow).value) <= 0){        
        alert("Not a valid price");
        document.getElementById('txtPrice_'+argRow).value=document.getElementById('txtPrice_'+argRow).title;
        document.getElementById('txtPrice_'+argRow).focus();
        return false;
    }
    val=parseFloat(val).toFixed(2);
    document.getElementById('txtPrice_'+argRow).value=val;        
    funCalculateTotalCost(argRow);
    return true;
}    
function getRowTotal(arg){
    var total=0.0;
    $("#productListTable input[id^='"+arg+"']").each(function(){
        var strChk='#chk_'+(this.id).replace(arg,'');
        if ($(strChk).is(":checked")){
            total += parseFloat(this.value);
        }
    });
    return total;
}  
function funShowTotal(){
    var totqty=getRowTotal('txtRecQty_');
    var totamt=getRowTotal('hdnTotalAmount_');

    if(!checkDecimal("txtOverallAdditionalCharges")) return false;
    if(!checkDecimal("txtRoundOff")) return false;       

    document.getElementById('tdTotqty').innerHTML=parseFloat(totqty).toFixed(2);
    document.getElementById('tdGross1').innerHTML=getRowTotal('hdnGrossAmt_').toFixed(2);
    document.getElementById('tdGrossDiscount').innerHTML=getRowTotal('txtDiscountAmount_').toFixed(2);
    document.getElementById('tdGrossBill').innerHTML=getRowTotal('hdnGrossValue_').toFixed(2);
    document.getElementById('tdOverAllDeductions').innerHTML=getRowTotal('hdnDeduction_').toFixed(2);
    document.getElementById('tdOverAllAdditionsB4Tax').innerHTML=getRowTotal('hdnAdditionB4Tax_').toFixed(2);
    document.getElementById('tdGrossTaxable').innerHTML=getRowTotal('hdnGrossTaxable_').toFixed(2);
    document.getElementById('tdTotalTax').innerHTML=getRowTotal('hdnTaxVal_').toFixed(2);
    document.getElementById('tdTotalExtra').innerHTML=getRowTotal('hdnTotalAdditional_').toFixed(2);
                    
    document.getElementById('txtTotamt').innerHTML=parseFloat(totamt).toFixed(2);
    document.getElementById('tdGrandTotal').innerHTML=parseFloat(totamt)+parseFloat(document.getElementById('txtOverallAdditionalCharges').value)+parseFloat(document.getElementById('txtRoundOff').value);
    document.getElementById('tdGrandTotal').innerHTML="<font size=2><b>"+parseFloat(document.getElementById('tdGrandTotal').innerHTML).toFixed(2)+"</b></font>";
    return true;
}    

function funCalculateTotalCost(argRowVal){
    trim('txtPrice_'+argRowVal);
    if (document.getElementById('txtPrice_'+argRowVal).value=="") return false;
    var amtquoted=parseFloat(document.getElementById('txtPrice_'+argRowVal).value);
    var qty=parseFloat(document.getElementById('txtRecQty_'+argRowVal).value);
    var grossAmt=parseFloat(amtquoted*qty);
    document.getElementById('hdnGrossAmt_'+argRowVal).value=grossAmt;
    var dpunit=parseFloat(document.getElementById('txtDiscount_'+argRowVal).value);
    if (dpunit > 100 ){
        alert("Discount should be less than 100");
        document.getElementById('txtDiscount_'+argRowVal).value="0";            
        return false;
    }
    var discountAmt=0;
    if (dpunit>0){
        discountAmt= parseFloat((grossAmt*dpunit)/100); 
    }
    document.getElementById('txtDiscountAmount_'+argRowVal).value=discountAmt;
    var grossValue=parseFloat(grossAmt-discountAmt);
    document.getElementById('hdnGrossValue_'+argRowVal).value=grossValue;
    var totalProductsCount=document.getElementById('hdnPOCount').value;
    if (document.getElementById('hdnTotalDeductionDetails').value != "")
        funCalculateOverAllDeduction(totalProductsCount,argRowVal);
    if (document.getElementById('hdnTotalAdditionB4TaxDetails').value != "")
        funCalculateOverAllAdditionB4Tax(totalProductsCount,argRowVal);
    try{
        if ($("#productListTable input[id='hdnTaxVal"+productId+"']").val() !=""){
            funCalculateOverAllTax(productId);
        }
    }catch(e){}
                    
    deduction=parseFloat(document.getElementById('hdnDeduction_'+argRowVal).value);
    additionB4Tax=parseFloat(document.getElementById('hdnAdditionB4Tax_'+argRowVal).value);
    var grossTaxable=parseFloat(grossValue-deduction+additionB4Tax);
    document.getElementById('hdnGrossTaxable_'+argRowVal).value=grossTaxable;
                    
    trim("hdnTaxValue_"+argRowVal);
    var totTaxAmount=0;
    if (document.getElementById('hdnTaxValue_'+argRowVal).value!=""){
        var taxvalue=document.getElementById('hdnTaxValue_'+argRowVal).value;
        var arr=taxvalue.split("|~|");
        for (var i=0; i < arr.length; i++){
            var innerarr=arr[i].split("!`!");
            var taxpercentage=parseFloat(innerarr[2]);
            var taxpriority=parseFloat(innerarr[3]);
            if (taxpriority==1){
                totTaxAmount=parseFloat(totTaxAmount) + (( parseFloat(grossTaxable) * taxpercentage)/100);
            }else{
                totTaxAmount=parseFloat(totTaxAmount) + (( (parseFloat(grossTaxable)+parseFloat(totTaxAmount)) * taxpercentage)/100);
            }
        }//end for...
    }//end if..
    document.getElementById('hdnTaxVal_'+argRowVal).value=totTaxAmount;
    var extraCharges=parseFloat(document.getElementById('hdnTotalAdditional_'+argRowVal).value);
    document.getElementById('hdnTotalCost').value= parseFloat(grossTaxable+totTaxAmount+extraCharges);
    document.getElementById('hdnTotalAmount_'+argRowVal).value=parseFloat(document.getElementById('hdnTotalCost').value).toFixed(2);
    funShowTotal();
    return true;
}    
        
        
        
function funShowTotalDeductions(){
    if(eval(document.getElementById('hdnPOCount').value)==0 || document.getElementById('hdnPOCount').value==""){
        alert("No product added in product details list");
        return false;
    }
    xmlHttp=GetXmlHttpObject();
    if (xmlHttp==null){
        alert("Browser does not support");
        return true;
    }
    totDedDetails=document.getElementById("hdnTotalDeductionDetails").value;
    totDedDetails=URLEncode(totDedDetails);
    var url="GrnDetailsAdvancedInner.jsp?iden=16&totDedDetails="+totDedDetails;
    divSelect="divOverAllDeductions";
    xmlHttp.onreadystatechange=stateChanged;
    xmlHttp.open("GET",url,true);
    xmlHttp.send(null);
    return true;
}// end of funShowTaxForm()

function funCloseDivOverAllDeductions(){
    document.getElementById("divOverAllDeductions").style.display="none";
}
        
function funShowTotalAdditionsB4Tax(){
    if(eval(document.getElementById('hdnPOCount').value)==0 || document.getElementById('hdnPOCount').value==""){
        alert("No product added in product details list");
        return false;
    }
    xmlHttp=GetXmlHttpObject();
    if (xmlHttp==null){
        alert("Browser does not support");
        return true;
    }
    totDedDetails=document.getElementById("hdnTotalAdditionB4TaxDetails").value;
    totDedDetails=URLEncode(totDedDetails);
    var url="GrnDetailsAdvancedInner.jsp?iden=17&totAdditionB4TaxDetails="+totDedDetails;
    divSelect="divOverAllAdditionsB4Tax";
    xmlHttp.onreadystatechange=stateChanged;
    xmlHttp.open("GET",url,true);
    xmlHttp.send(null);
    return true;
}// end of funShowTaxForm()

function funCloseDivOverAllAdditionsB4Tax(){
    document.getElementById("divOverAllAdditionsB4Tax").style.display="none";
}                
        
function funOnBlurDeduction(cnt,elementId){
    var percent=0;
    if (elementId=="txtPercentage"){
        percent=document.getElementById("txtPercentage"+cnt).value;
        if (parseFloat(percent)>0){
            document.getElementById("txtTotalAmount"+cnt).value=0;
            document.getElementById("deductionSave").focus();
        }
    }

    if (elementId=="txtTotalAmount"){
        percent=document.getElementById("txtTotalAmount"+cnt).value;
        if (parseFloat(percent)>0){
            document.getElementById("txtPercentage"+cnt).value=0;
            document.getElementById("deductionSave").focus();
        }
    }
}

function funOnBlurAdditionB4Tax(cnt,elementId){
    var percent=0;
    if (elementId=="txtAdditionB4TaxPercentage"){
        percent=document.getElementById("txtAdditionB4TaxPercentage"+cnt).value;
        if (parseFloat(percent)>0){
            document.getElementById("txtAdditionB4TaxTotalAmount"+cnt).value=0;
            document.getElementById("additionSave").focus();
        }
    }

    if (elementId=="txtAdditionB4TaxTotalAmount"){
        percent=document.getElementById("txtAdditionB4TaxTotalAmount"+cnt).value;
        if (parseFloat(percent)>0){
            document.getElementById("txtAdditionB4TaxPercentage"+cnt).value=0;
            document.getElementById("additionSave").focus();
        }
    }

}

function funOverAllDeductionsSave(cnt){
    funCloseDivOverAllDeductions();
    var totDed=document.getElementById("hdnTotalDeductionDetails").value;
    var desc=document.getElementById("txtDesc"+cnt).value;
    if (!checkEmpty("txtDesc"+cnt, "Deduction Description")) return false;
    var percent=document.getElementById("txtPercentage"+cnt).value;
    if (!checkEmpty("txtPercentage"+cnt, "Percentage")) return false;
    var totAmount=document.getElementById("txtTotalAmount"+cnt).value;
    if (!checkEmpty("txtTotalAmount"+cnt, "Percentage")) return false;
    var currDetails=desc+"~"+percent+"~"+totAmount+"@@";
    document.getElementById("hdnTotalDeductionDetails").value=totDed+currDetails;
    if (document.getElementById("hdnTotalDeductionDetails").title != document.getElementById("hdnTotalDeductionDetails").value){
        document.getElementById("hdnTotalDeductionDetails").title=document.getElementById("hdnTotalDeductionDetails").value;
        checkOAAvailableDetail();
        return true;
    }
    alert('No changes made');
    return true;
}

function funOverAllAdditionsB4TaxSave(cnt){
    funCloseDivOverAllAdditionsB4Tax();
    var totDed=document.getElementById("hdnTotalAdditionB4TaxDetails").value;
    var desc=document.getElementById("txtAdditionB4TaxDesc"+cnt).value;
    if (!checkEmpty("txtAdditionB4TaxDesc"+cnt, "Addition before tax Description")) return false;
    var percent=document.getElementById("txtAdditionB4TaxPercentage"+cnt).value;
    if (!checkEmpty("txtAdditionB4TaxPercentage"+cnt, "Percentage")) return false;
    var totAmount=document.getElementById("txtAdditionB4TaxTotalAmount"+cnt).value;
    if (!checkEmpty("txtAdditionB4TaxTotalAmount"+cnt, "Amount")) return false;
    var currDetails=desc+"~"+percent+"~"+totAmount+"@@";
    document.getElementById("hdnTotalAdditionB4TaxDetails").value=totDed+currDetails;
    if (document.getElementById("hdnTotalAdditionB4TaxDetails").title != document.getElementById("hdnTotalAdditionB4TaxDetails").value){
        document.getElementById("hdnTotalAdditionB4TaxDetails").title=document.getElementById("hdnTotalAdditionB4TaxDetails").value;
        checkOAAvailableDetailForAdditionB4Tax();
        return true;
    }
    alert('No changes made');
    return true;
}
        
function checkOAAvailableDetail(){
    trim("hdnTotalDeductionDetails");
    var deductionvalue=document.getElementById('hdnTotalDeductionDetails').value;
    document.getElementById('hdnOADeductionPercent').value="0";
    document.getElementById('hdnOADeductionAmount').value="0";
    var arr=deductionvalue.split("@@");
    var flag=false;
    for (var i=0; i < arr.length-1; i++){
        var innerarr=arr[i].split("~");
        var deductionPercent=parseFloat(innerarr[1]);
        var deductionTotalAmount=parseFloat(innerarr[2]);
        if (parseFloat(deductionPercent) > 0) {
            document.getElementById('hdnOADeductionPercent').value =
            parseInt(document.getElementById('hdnOADeductionPercent').value) +1;
            flag=true;
        }
        if (deductionTotalAmount > 0) {
            document.getElementById('hdnOADeductionAmount').value =
            parseInt(document.getElementById('hdnOADeductionAmount').value) +1
            flag=true;
        }
    }//end of for
    if (flag && (document.getElementById("cmdCalculate").style.visibility=='hidden')){
        alert('Deduction Details found, Press Recalculate before save');
        document.getElementById("cmdCalculate").style.visibility='visible';
        document.getElementById("cmdSave").style.visibility='hidden';
    }else{
        return false;
    }
    return true;
}

function checkOAAvailableDetailForAdditionB4Tax(){
    trim("hdnTotalAdditionB4TaxDetails");
    var deductionvalue=document.getElementById('hdnTotalAdditionB4TaxDetails').value;
    document.getElementById('hdnOAAdditionB4TaxPercent').value="0";
    document.getElementById('hdnOAAdditionB4TaxAmount').value="0";
    var arr=deductionvalue.split("@@");
    var flag=false;
    for (var i=0; i < arr.length-1; i++){
        var innerarr=arr[i].split("~");
        var deductionPercent=parseFloat(innerarr[1]);
        var deductionTotalAmount=parseFloat(innerarr[2]);
        if (parseFloat(deductionPercent) > 0) {
            document.getElementById('hdnOAAdditionB4TaxPercent').value =
            parseInt(document.getElementById('hdnOAAdditionB4TaxPercent').value) +1;
            flag=true;
        }
        if (deductionTotalAmount > 0) {
            document.getElementById('hdnOAAdditionB4TaxAmount').value =
            parseInt(document.getElementById('hdnOAAdditionB4TaxAmount').value) +1
            flag=true;
        }
    }//end of for
    if (flag && (document.getElementById("cmdCalculate").style.visibility=='hidden')){
        alert('Addition Details found, Press Recalculate before save');
        document.getElementById("cmdCalculate").style.visibility='visible';
        document.getElementById("cmdSave").style.visibility='hidden';
    }else{
        return false;
    }
    return true;
}


function funSumWithExistingValueForFieldNamesLike(argFieldName,objValue){
    var currValue=0;
    $("input[id^='"+argFieldName+"']").each(function(){
        currValue=parseFloat(this.value);
        this.value = parseFloat(parseFloat(currValue)+parseFloat(objValue));
    });
}

function funOverAllDeductionsRemove(cnt){
    var yn=confirm("Do you wish to remove this?");
    if (!yn) return false;
    var totDed=document.getElementById("hdnTotalDeductionDetails").value;
    var desc=document.getElementById("txtDesc"+cnt).value;
    if (!checkEmpty("txtDesc"+cnt, "Deduction Description")) return false;
    var percent=document.getElementById("txtPercentage"+cnt).value;
    if (!checkEmpty("txtPercentage"+cnt, "Percentage")) return false;
    var totAmount=document.getElementById("txtTotalAmount"+cnt).value;
    if (!checkEmpty("txtTotalAmount"+cnt, "Percentage")) return false;
    if (percent > 0 ){
        document.getElementById('hdnOADeductionPercent').value =
        parseInt(document.getElementById('hdnOADeductionPercent').value)-1;
    }else {
        document.getElementById('hdnOADeductionAmount').value =
        parseInt(document.getElementById('hdnOADeductionAmount').value)-1;
    }
    currDetails=desc+"~"+percent+"~"+totAmount+"@@";
    totDed=totDed.replace(currDetails,'');
    document.getElementById("hdnTotalDeductionDetails").value=totDed;
    document.getElementById("hdnTotalDeductionDetails").title=totDed;
    //funCloseDivOverAllDeductions();
    funCalculateOverAllTotal();
    if (!checkOAAvailableDetail()){
        document.getElementById("cmdCalculate").style.visibility='visible';
        document.getElementById("cmdSave").style.visibility='hidden';
        alert('Deduction removed Successfully. Press Recalculate before save.');
    }else{
        alert('Deduction removed Successfully!');
    }
    funShowTotalDeductions();
    return true;
}

function funOverAllAdditionsB4TaxRemove(cnt){
    var yn=confirm("Do you wish to remove this?");
    if (!yn) return false;
    var totDed=document.getElementById("hdnTotalAdditionB4TaxDetails").value;
    var desc=document.getElementById("txtAdditionB4TaxDesc"+cnt).value;
    if (!checkEmpty("txtAdditionB4TaxDesc"+cnt, "Additions Before tax Description")) return false;
    var percent=document.getElementById("txtAdditionB4TaxPercentage"+cnt).value;
    if (!checkEmpty("txtAdditionB4TaxPercentage"+cnt, "Percentage")) return false;
    var totAmount=document.getElementById("txtAdditionB4TaxTotalAmount"+cnt).value;
    if (!checkEmpty("txtAdditionB4TaxTotalAmount"+cnt, "Percentage")) return false;
    if (percent > 0 ){
        document.getElementById('hdnOAAdditionB4TaxPercent').value =
        parseInt(document.getElementById('hdnOAAdditionB4TaxPercent').value)-1;
    }else {
        document.getElementById('hdnOAAdditionB4TaxAmount').value =
        parseInt(document.getElementById('hdnOAAdditionB4TaxAmount').value)-1;
    }
    currDetails=desc+"~"+percent+"~"+totAmount+"@@";
    totDed=totDed.replace(currDetails,'');
    document.getElementById("hdnTotalAdditionB4TaxDetails").value=totDed;
    document.getElementById("hdnTotalAdditionB4TaxDetails").title=totDed;
    //funCloseDivOverAllDeductions();
    funCalculateOverAllTotal();
    if (!checkOAAvailableDetailForAdditionB4Tax()){
        document.getElementById("cmdCalculate").style.visibility='visible';
        document.getElementById("cmdSave").style.visibility='hidden';
        alert('Addition removed Successfully. Press Recalculate before save.');
    }else{
        alert('Addition removed Successfully!');
    }
    funShowTotalAdditionsB4Tax();
    return true;
}
function funRecalculate(){
    if (!funCalculateOverall()) return false;
    document.getElementById("cmdCalculate").style.visibility='hidden';
    document.getElementById("cmdSave").style.visibility='visible';
    return true;
}       

function funCalculateOverall(){
    $("input[id^='chk_']").each(function(){
        if (this.checked){
            var rowId=(this.id).replace('chk_','');
            if (!funCalculateTotalCost(rowId)) return false;
        }
    });
    return true;
}            

function funCalculateOverAllDeduction(totalProductsCount,productId){
    var totprodamount=document.getElementById('tdGrossBill').innerHTML;
    var deductionvalue=document.getElementById('hdnTotalDeductionDetails').value;            
    var arr=deductionvalue.split("@@");
    var OAGROSSTAXABLE=parseFloat(document.getElementById('hdnGrossValue_'+productId).value);
    var OADEDUCTION=0;
    for (var i=0; i < arr.length-1; i++){
        var innerarr=arr[i].split("~");
        var deductionPercent=parseFloat(innerarr[1]);
        var deductionTotalAmount=parseFloat(innerarr[2]);
        var tempVal=0.00;
        if (parseFloat(deductionPercent) > 0){
            //funCalcDeductionPercent(deductionPercent,productId);
            tempVal=parseFloat(OAGROSSTAXABLE*deductionPercent/100);
        }
        if (deductionTotalAmount > 0){
            //funCalcDeductionTotalAmount(deductionTotalAmount,totalProductsCount,productId);
            //tempVal=parseFloat(deductionTotalAmount/totalProductsCount);
            tempVal=parseFloat(deductionTotalAmount * (OAGROSSTAXABLE * 100/totprodamount)/100);   
        }
        OADEDUCTION += parseFloat(tempVal);
        OAGROSSTAXABLE -= parseFloat(tempVal);
    }//end of for
    funSetValueAttribute('hdnGrossTaxable_'+productId,OAGROSSTAXABLE);
    //document.getElementById('hdnGrossTaxable'+productId).value=OAGROSSTAXABLE;
    funSetValueAttribute('hdnDeduction_'+productId,parseFloat(OADEDUCTION));
//document.getElementById('hdnDeduction'+productId).value=OADEDUCTION;
}

function funCalculateOverAllAdditionB4Tax(totalProductsCount,productId){
    var totprodamount=document.getElementById('tdGrossBill').innerHTML;
    var additionvalue=document.getElementById('hdnTotalAdditionB4TaxDetails').value;            
    var arr=additionvalue.split("@@");
    var OADeduction = parseFloat(document.getElementById('hdnDeduction_'+productId).value);
    var OAGROSSVALUE=parseFloat(document.getElementById('hdnGrossValue_'+productId).value);
    var OAGROSSTAXABLE=parseFloat(document.getElementById('hdnGrossValue_'+productId).value);
    var OAADDITION=0;
    for (var i=0; i < arr.length-1; i++){
        var innerarr=arr[i].split("~");
        var additionPercent=parseFloat(innerarr[1]);
        var additionTotalAmount=parseFloat(innerarr[2]);
        var tempVal=0.00;
        if (parseFloat(additionPercent) > 0){
            tempVal=parseFloat(OAGROSSTAXABLE*additionPercent/100);
        }
        if (additionTotalAmount > 0){
            //funCalcDeductionTotalAmount(additionTotalAmount,totalProductsCount,productId);
            tempVal=parseFloat(additionTotalAmount * (OAGROSSVALUE * 100/totprodamount)/100);     //Total Discount Amount * (product price*100/sum product price)/100
        //tempVal=parseFloat(additionTotalAmount/totalProductsCount);
        }
        OAADDITION += parseFloat(tempVal);
    }//end of for
    OAGROSSTAXABLE = OAGROSSVALUE;
    OAGROSSTAXABLE += parseFloat(OAADDITION);
    OAGROSSTAXABLE -= parseFloat(OADeduction);
    funSetValueAttribute('hdnGrossTaxable_'+productId,OAGROSSTAXABLE);
    funSetValueAttribute('hdnAdditionB4Tax_'+productId,parseFloat(OAADDITION));
}        
        
function funSetValueAttribute(objName,objValue){
    $("input[id='"+objName+"']").attr('value',objValue);
}
function checkEmptyReturnZero(str){
    if (document.getElementById(str).value==""){
        document.getElementById(str).value="0"
    }
}