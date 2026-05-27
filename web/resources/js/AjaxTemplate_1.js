var xmlHttp;
var divName;
function GetXmlHttpObject(){ 
    var objXMLHttp=null;
    if (window.XMLHttpRequest)
        objXMLHttp=new XMLHttpRequest()
    else if (window.ActiveXObject)
        objXMLHttp=new ActiveXObject("Microsoft.XMLHTTP")
    return objXMLHttp
}
            
function getAjax(argDivName,argUrl){
       divName=argDivName;
       xmlHttp=GetXmlHttpObject();
        if(xmlHttp==null){
            alert("Browser doesnot support");
            return;
        }
        document.getElementById(divName).style.display="block";
        xmlHttp.onreadystatechange=stateChanged;
        xmlHttp.open("POST",argUrl,true);
        xmlHttp.send(null);
 }

function getAjaxWithObject(argDivName,argUrl,argObject){
       divName=argDivName;
       document.getElementById(divName).innerHTML="";
       xmlHttp=GetXmlHttpObject();
        if(xmlHttp==null){
            alert("Browser doesnot support");
            return;
        }
        document.getElementById(divName).style.display="block";
        document.getElementById(divName).innerHTML="<table width='100%'><tr><td align=center><img src='../../resources/Image/loading.gif'></td></tr></table>";
        //document.getElementById(divName).style.left=argObject.style.left;
        xmlHttp.onreadystatechange=stateChanged;
        xmlHttp.open("POST",argUrl,true);
        xmlHttp.send(null);
 }

function getAjaxAppendContentToDiv(argDivName,argUrl){       
       divName=argDivName;
       xmlHttp=GetXmlHttpObject();
        if(xmlHttp==null){
            alert("Browser doesnot support");
            return;
        }
        document.getElementById(divName).style.display="block";
        xmlHttp.onreadystatechange=stateChangedAppend;
        xmlHttp.open("POST",argUrl,true);
        xmlHttp.send(null);
 }
            
function stateChanged(){
    if(xmlHttp.readyState==4 || xmlHttp.readyState=="complete"){
        document.getElementById(divName).innerHTML=xmlHttp.responseText;	
        try{
	    if(divName=="divPayStructure"){
		stripeTables('tblPayStructure','dynaColorTR1','dynaColorTR2');
	    }else if(divName=="divView"){
		stripeTables('tblView','dynaColorTR1','dynaColorTR2');
	    }else if (divName=="divPayPeriod"){
		stripeTables('tblPayPeriod','dynaColorTR1','dynaColorTR2');
	    }else if (divName=="divDivision"){
		stripeTables('tblDivision','dynaColorTR1','dynaColorTR2');
	    }else if (divName=="divCategory"){
		stripeTables('tblCategory','dynaColorTR1','dynaColorTR2');
	    }else if (divName=="divEmployees"){
		stripeTables('tblEmployees','dynaColorTR1','dynaColorTR2');
	    }else if(divName=="divPayComponent"){
		stripeTables('tblPayComponent','dynaColorTR1','dynaColorTR2');
	    }
        }catch(e){}
     }
}

function stateChangedAppend(){
    if(xmlHttp.readyState==4 || xmlHttp.readyState=="complete"){        
        document.getElementById(divName).innerHTML=document.getElementById(divName).innerHTML+xmlHttp.responseText;
     }
}

  // this function is needed to work around 
  // a bug in IE related to element attributes
  function hasClass(obj) {
     var result = false;
     if (obj.getAttributeNode("class") != null) {
         result = obj.getAttributeNode("class").value;
     }
     return result;
  }   

 function stripeTables(id) {
    // the flag we'll use to keep track of 
    // whether the current row is odd or even
    var even = false;
  
    // Set the alternate color in the method call arguments
    var evenColor; 
	
    // hard coded here and applies to all tables.
    /*
    *********
    *********
    */
    // Set the alternate color in the method call arguments
    var oddColor;
	
    /*
    *********
    *********
    */ 
    // hard coded here and applies to all tables.
	
    // Populate 2 arrays with the arguments,
    // separating the colors from the ID's.
    var colorArray = new Array();
    var cArrayCount = 0;
    
    var colorArrayOdd = new Array();
    var cArrayCountOdd = 0;
	 
    var IdArray = new Array();
    var IdArrayCount = 0;
	 
    // This script assumes that the arguements always
    // come in pairs: ID / evenColor. So the first
    // argument will always be the ID.
    for (i_id = 0; i_id < arguments.length; i_id++) {
	 	
        // Since the function arguments are formatted in ID/color pairs,
        // and the first argument is an ID, when %2 == 0 
        // it will be a element ID and not a color.
        if (i_id == 0) {
            IdArray[IdArrayCount] = arguments[i_id];
            IdArrayCount++;
        } else if (i_id == 1) {
            colorArray[cArrayCount] = arguments[i_id];
            cArrayCount++;
        } else if (i_id == 2) {
            colorArrayOdd[cArrayCountOdd] = arguments[i_id];
            cArrayCountOdd++
        }
    }
    // Populate 2 arrays with arguments
	 
    /*
        // Testing code for the arrays
        alert("Color Array has: "+ colorArray.length);
        alert("ID Array has: "+IdArray.length);

        for (a = 0; a < colorArray.length; a++) {
            alert(colorArray[a]);	 	
        }
        for (a = 0; a < IdArray.length; a++) {
            alert(IdArray[a]);	 	
        }
        // Testing code for the arrays
    */
	 
    // color the rows for each table as defined in the function arguments
    for (a = 0; a < IdArray.length; a++) {
        evenColor = colorArray[a]; 	
        oddColor = colorArrayOdd[a];

        // obtain a reference to the desired table
        // if no such table exists, abort
        var table = document.getElementById(IdArray[a]);
        if (! table) { return; }		 


        // by definition, tables can have more than one tbody
        // element, so we'll have to get the list of child
        // &lt;tbody&gt;s 

        var tbodies = table.getElementsByTagName("tbody");
			
        // and iterate through them...
        for (var h = 0; h < tbodies.length; h++) {
				
            // find all the &lt;tr&gt; elements... 
            var trs = tbodies[h].getElementsByTagName("tr");
				  
            // ... and iterate through them
            for (var i = 0; i < trs.length; i++) {

                // avoid rows that have a class attribute
                // or backgroundColor style
                if (! hasClass(trs[i]) &&
                    ! trs[i].style.backgroundColor) {
					  
                    // get all the cells in this row...
                    var tds = trs[i].getElementsByTagName("td");
					
                    // and iterate through them...
                    for (var j = 0; j < tds.length; j++) {
                        var mytd = tds[j];
			
                        // avoid cells that have a class attribute
                        // or backgroundColor style
                        if (! hasClass(mytd) &&
                            ! mytd.style.backgroundColor) {
					
                                mytd.className =
                                    even ? evenColor : oddColor;
                        }
                    }
                }
                // flip from odd to even, or vice-versa
                even =  ! even;
            }
        }
    } // for loop		
  }
