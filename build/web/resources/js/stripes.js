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

 var currentrow=0,previousrow=0,maxrows=0,previousstyle="",funtobecall="";
 var objTables,ltbodies,ltrs,objText;
 function KeyNavigations(charCode,tableids,argObjText){
      objText=argObjText;
      if (charCode==40){
            currentrow=currentrow+1;
      }else if (charCode==38){
          currentrow=currentrow-1;
          if (currentrow<0){
              currentrow=0;
              previousrow=0;
              return;
          }
      }else if (charCode==13){
          direction=0;
          //eval(funtobecall);
          ltrs[currentrow].onclick();
          funtobecall="";
          objTables=null;
          currentrow=0;
          previousrow=0;
          return;
      }



     objTables=document.getElementById(tableids);
     if (objTables==null|| (!objTables)) return;
      //alert(" obj Tables "+objTables);
      //if (! objTables) {return;}
      ltbodies = objTables.getElementsByTagName("tbody");
      ltrs = ltbodies[0].getElementsByTagName("tr");
      maxrows=ltrs.length;
      if (currentrow>=maxrows || currentrow==0) {
          currentrow=0;
          objText.focus();
          ltds = ltrs[previousrow].getElementsByTagName("td");
          ApplyClass(ltds,previousstyle);
          previousrow=0;
          return;
      }
      //alert(ltrs[currentrow].innerHTML);
      var ltds = ltrs[currentrow].getElementsByTagName("td");
      previousstyle=ltds[0].getAttributeNode("class").value;
      //alert("previousstyle"+previousstyle);
      funtobecall=ltrs[currentrow].getAttributeNode("onclick").value;
      ApplyClass(ltds,'keyNavigation',1);
      scrollToRow(ltrs[currentrow]);

      if (previousrow>0){
        ltds = ltrs[previousrow].getElementsByTagName("td");
        ApplyClass(ltds,previousstyle,0);
      }
      previousrow=currentrow;

 }

//argType 1 currentrow 0 previous row
 function ApplyClass(argTdObject,argStyle,argType){
     var lmytd1;
     for (var j1 = 0; j1 < argTdObject.length; j1++) {
            lmytd1 = argTdObject[j1];
            lmytd1.className =argStyle;
     }
     if (argType==1){
         objText.value=argTdObject[0].innerHTML;

     }
 }

 function callKeyNavigation(evt,argTblName,objText){
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode==38||charCode==40||charCode==13){
            KeyNavigations(charCode,argTblName,objText);
            return false;
    }
    currentrow=0;
    previousrow=0;
    return true;
 }

 function scrollToRow(argRow){
        argRow.scrollIntoView(false);
 }