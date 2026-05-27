function DatesOnly(e){
    var unicode=e.charCode? e.charCode : e.keyCode
    if (unicode!=8 && unicode!=9 && unicode!=45 && unicode!=46 && unicode!=47 && unicode!=37 && unicode!=39 && unicode!=32){ //if the key isn't the backspace key (which we should allow)
        if (unicode<48||unicode>57 ) //if not a number
            return false //disable key press
    }
}
function getDate(argString,argCurrentYear){
    var splitLibText="./- ";
    var splitText="-1";
    var temp="",dd="",mm="",yy="";
    var countCheck=0;
    
    if (strTrim(argString)==""){ return ""; }
    
    argString=strTrim(argString);
    for(var i=0;i<argString.length;i++){
            if(splitLibText.indexOf(argString.charAt(i))>=0){
                    splitText=argString.charAt(i);
                    break;
            }
    }
    for(var i=0;i<argString.length;i++){
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
        for(var i=0;i<argString.length;i++){
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
                    temp=dd+"/"+mm+"/"+yy;
            }else{
                temp=dd+"/"+mm+"/"+argCurrentYear;
            }
        }else{
            temp="";
        }
    }else{
        temp="";
    }
    if(temp==""){
        if (argString != ""){
            alert("Invalid Date..");
        }
    }
    return temp;
}