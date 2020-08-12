
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    
   String fid = request.getParameter("form_id");
   Connection conn = (Connection)application.getAttribute("conn");
   PreparedStatement ps = conn.prepareStatement("select * from form_data where form_id =  ?");
   ps.setString(1,fid);
   ResultSet rs = ps.executeQuery();
   rs.next();
   pageContext.setAttribute("title",rs.getString(3));
   pageContext.setAttribute("background",rs.getString(4));
   pageContext.setAttribute("border",rs.getString(5));
   pageContext.setAttribute("font",rs.getString(6));
   pageContext.setAttribute("fid",fid); 
    
%>
<!DOCTYPE html>
<html lang="en"> 
 <head>
   <title>Edit Quizze</title>
   <meta charset="utf-8">
   <link rel="icon" href="icon.png"   type="image/png">
   <meta name="viewport" content="width=device-width, initial-scale=1">
   <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
   <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
   <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
   <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>
   <link href="https://fonts.googleapis.com/css2?family=Berkshire+Swash&family=Cinzel+Decorative:wght@700&family=Trocchi&display=swap" rel="stylesheet">
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
   <link href="https://fonts.googleapis.com/css2?family=Galada&family=Grenze+Gotisch:wght@200&family=Roboto+Slab:wght@300&family=Satisfy&display=swap" rel="stylesheet">
   <style>
       
  *{
   margin:0px;
   padding:0px;
   box-sizing:border-box;
  }
  .modal { font-family:Trocchi;}
  .form-header {  font-size:18px !important;  }
  .logo{ font:20px Trocchi;letter-spacing:2px;color:#30949d;  }
  .text-teal{ color:#30949d; }
  .bg-teal{ background:#30949d;  }	
  .border-top{ border-top:5px solid #30949d  !important; }
  #title{    box-shadow : 0 !important; border : 0px !important; }
  #form-container{ border-top:8px solid ${border};font-family:Trocchi; }
  .font-Trocchi{ font-family:Trocchi; }
  #right-column{ background:${background};}
  .bottom{ position:fixed; bottom:0%; left:0%;}
  #main-container{width:97%;}
 .loader-wrapper{  position:absolute;height:100%;width:100%;top:0;left:0;z-index : 1000;background:rgba(255,255,255,0.7);display:none; }     
 .loader{    height:50px;  width:50px;border:5px solid white;border-top:5px solid teal;border-radius:50%; animation:spin 0.8s linear infinite;}
 .logo:hover{
      text-decoration: none;  
     }             
    @keyframes spin{
            0%{  transform : rotate(0deg);  }
           100%{ transform : rotate(360deg); } 
        }   
  @media only screen and (min-width:720px){
      #main-container{ width:75%;  }
      .form-header {  font-size:28px !important;  }
  } 
  </style>
 </head>
<body>
       <nav class="navbar p-2 p-md-3  shadow ">
           <a class="logo" href="index.html">SURVEY.COM</a>
           <div class="ml-auto">
               <a href="home.jsp" class="float-right btn p-0 pr-2 pl-2" title="user-profile"><i class="fa fa-user-circle-o"  style="font-size:20px;"></i></a> 
                <button class="btn p-0 pr-2 pl-2" onclick="sendData()" title="save"><i class="fa fa-save"  style="font-size:20px;"></i></button>
                <button class="btn p-0 pr-2 pl-2" data-toggle="modal" data-target="#modalSetting"  title="color and font"><i class="fa fa-paint-brush"  style="font-size:20px;"></i></button>
           </div>
       </nav>
       <br>
       <p class="p-2  border-danger text-center text-danger"><i class="fa fa-warning"></i> If you change the structure of the quizze than your previous responses will be deleted.</p>
      <br>
     <div class=" mx-auto" id="main-container">
         <p class="p-2 text-danger" id="error" style="display:none"></p>
      <div class="form-group">
         <input type="text" class="form-control font-Trocchi"  value="${title}"  name="title" id="title"  placeholder="Enter Title" onkeyup="fillHeader(this)">
     </div>
      <div class="mb-2 sticky-top bg-light pt-1 pb-1 d-none d-md-block"> 
       <div class="input-group">
            <select class="form-control font-Trocchi" id="large_screen_input_options">
             <option value="InputBox">Input Box</option>
             <option value = "List">Selection List</option>
             <option value = "Radio">Radio</option>
             <option value="CheckBox">Checkbox</option>
              </select>
              <div class="input-group-append">
                        <button type="button" class="btn float-right bg-teal text-white"  onclick="addOfLarge()">Add</button>
               </div>      
        </div> 
     </div>
       <div class="bodrer p-md-4 p-2  mx-auto"  id="right-column">
            <div class="p-2 p-md-3  rounded-lg   mx-auto d-block"  id="form-container" style="background:white;">
                <h3 class="form-header p-2">${title}</h3><br>
            </div> 
        </div>
    </div>
        
  <button type="button" data-toggle="modal" data-target="#modalCheckBox"  id="modalCheckBoxShow" class="d-none"></button>        
  <button type="button"  class="d-none"  data-toggle="modal" data-target="#modalRadio "  id="modalRadioShow"></button>
  <button  data-toggle="modal" data-target="#modalList"  class="d-none"  id="modalListShow"></button>
  <button type="button" class="d-none" data-toggle="modal" data-target="#modalInputBox" id="modalInputBoxShow"></button>
                                         
 <div class="modal" id="modalCheckBox">
   <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-top rounded-lg">
         <div class="modal-header">
           <h4 class="modal-title">CheckBox</h4>
        <button type="button" class="close" data-dismiss="modal" id="closeaddcheck">&times;</button>
      </div>
      <div class="modal-body">
          <div class="form-group">
              <label>Label :</label>
              <input type="text" class="form-control" name="c_label" placeholder="Enter label" >
          </div>
          <div class="form-group">
              <label>Data :</label>
              <textarea class="form-control" name="c_data"  ></textarea>
          </div>
          
          <div class="form-group">
              <label>answer :</label>
              <textarea class="form-control" name="c_answer"  ></textarea>
          </div>
          <div class="form-group">
              <input type="radio"  name="c_optimality" id="c_optimality_1" value="optional" checked>
              <label for="c_optimality_1">optional</label>
              <input type="radio"  name="c_optimality" value='required' id="c_optimality_2">
              <label for="c_optimality_2">required</label>
          </div>
      </div>
        
      <div class="modal-footer">
        <button type="button" class="btn bg-teal"  id="addCheckBoxButton"  >Add</button>
      </div>
     </div>
  </div>
</div>
        
 
<div class="modal" id="modalRadio">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-top rounded-lg">
         <div class="modal-header">
           <h4 class="modal-title font-Trocchi">Radio Button</h4>
        <button type="button" class="close" data-dismiss="modal" id="closeaddradio">&times;</button>
      </div>
      <div class="modal-body">
          <div class="form-group">
              <label>Label :</label>
              <input type="text" class="form-control" name="r_label" placeholder="Enter label" >
          </div>
          <div class="form-group">
              <label>Data :</label>
              <textarea class="form-control" name="r_data"  ></textarea>
          </div>
          <div class="form-group">
              <label>answer :</label>
              <input type="text" class="form-control" name="r_answer" placeholder="Enter answer" >
          </div>
          <div class="form-group">
              <input type="radio"  name="r_optimality"  id="r_optimality_1" value="optional"  checked>
              <label for="r_optimality_1">optional</label>
              <input type="radio"  name="r_optimality" value='required'  id="r_optimality_2">
              <label for = "r_optimality_2">required</label>
          </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn bg-teal font-Trocchi" id="addRadioButton" >Add</button>
      </div>
     </div>
  </div>
</div>       
        
  
<div class="modal" id="modalList">
  <div class="modal-dialog   modal-dialog-centered">
    <div class="modal-content border-top  rounded-lg">
         <div class="modal-header">
           <h4 class="modal-title font-Trocchi">List</h4>
        <button type="button" class="close" data-dismiss="modal" id="closeaddlist">&times;</button>
      </div>
      <div class="modal-body">
          <div class="form-group">
              <label>Label :</label>
              <input type="text" class="form-control" name="l_label" placeholder="Enter label" >
          </div>
          <div class="form-group">
              <label>Data :</label>
              <textarea class="form-control" name="l_data"  ></textarea>
          </div>
          <div class="form-group">
              <input type="radio"  name="l_optimality" value="optional"  id="l_optimality_1" checked>
              <label for="l_optimality_1">optional</label>
              <input type="radio"  name="l_optimality" value='required' id="l_optimality_2">
              <label for="l_optimality_2">required</label>
          </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn bg-teal font-Trocchi"  id="addListButton" >Add</button>
      </div>
     </div>
  </div>
</div>       
               
        
     
<div class="modal" id="modalInputBox">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-top rounded-lg">
         <div class="modal-header">
           <h4 class="modal-title font-Trocchi">Input Box</h4>
        <button type="button" class="close" data-dismiss="modal" id="closeaddinput">&times;</button>
      </div>
      <div class="modal-body">
          <div class="form-group">
              <label class="font-Tricch">Label :</label>
              <input type="text" class="form-control" name="i_label" placeholder="Enter label" >
          </div>
          <div class="form-group">
              <label class="font-Tricch">Type :</label>
              <select class="form-control" name="i_data"  >
                   <option value="date">Date</option>
                   <option value="email">Email</option>
                   <option value="text">Text</option>
                   <option value="number">Number</option>
                   <option value="range">Range</option>
                   <option value="tel">Telephone Number</option>
                   <option value="time">time</option>
                   <option value="file">file</option>    
              </select>
          </div>
          <div class="form-group">
              <input type="radio"  name="i_optimality" value="optional" id="i_optimality_o"   checked>
              <label class="font-Tricch" for="i_optimality_o">optional</label>
              <input type="radio"  name="i_optimality" value='required' id="i_optimality_r">
              <label class="font-Tricchi" for="i_optimality_r">required</label>
          </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn bg-teal font-Trocchi" id="addInputBoxButton" >Add</button>
      </div>
     </div>
   </div>
 </div>          
      
   
<div class="modal" id="modalSetting">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-top rounded-lg">
         <div class="modal-header">
           <h4 class="modal-title font-Trocchi">Set color and fonts</h4>
        <button type="button" class="close" data-dismiss="modal" >&times;</button>
      </div>
      <div class="modal-body">
          
          <div class="row">
              <div class="col-6 p-3">Background</div>
              <div class="col-6 p-3">
                    <div class="form-group p-0">
                        <input type="color"  class="form-contol"  value="${background}"  onchange="changeBgColor(this)" ><br>
                    </div>
                </div>
          </div>
          <div class="row">
              <div class="col-6 p-3">Border</div>
              <div class="col-6 p-3">
                    <div class="form-group p-0">
                        <input type="color" class="form-cotrol"  value="${border}"  onchange="changeBorderColor(this)" ><br>
                     </div>
                </div>
          </div>
          <div class="row">
              <div class="col-6 p-3">Font</div>
              <div class="col-6 p-3">
                    <div class="form-group p-0">
                        <select class="form-control"  onchange="changeFontFamily(this)" value="${font}">
                            <option   value="Galada" style="font-family:Galada">Live Happy 1</option>
                            <option   value="Grenze" style="font-family:Grenze">Live Happy 2</option>
                            <option   value="Roboto" style="font-family:Roboto">Live Happy 3</option>
                            <option   value="Satisfy" style="font-family:Satisfy">Live Happy 4</option>
                            <option   value="Trocchi" style="font-family:Trocchi">Live Happy 5</option>
                            <option   value="Berkshire Swash" style="font-family:Berkshire Swash ">Live Happy 6</option>
                            <option value="times new roman"  style="font-family:times new roman ">Live Happy 7</option>
                        </select>
                    </div>
                </div>
          </div>
        </div>
       <div class="modal-footer">
              <button type="button" class="btn btn-success" data-dismiss="modal" >Save</button>
       </div>
     </div>
   </div>
 </div>      
                       
  <div class="modal" id="responseModal">
      <div class="modal-dialog modal-dialog-centered">
          <div class="modal-content">
              <div class="modal-header">
                  <button class="close"  data-dismiss="modal">&times;</button>
              </div> 
              <div class="modal-body" id="response_container">
               
              </div>
              <div class="modal-footer">
                  <a class = "btn bg-teal text-white float-right" href="home.jsp" >ok</a>
              </div>
           </div>
      </div>
  </div>                   
 <button class="d-none"  data-toggle="modal" data-target="#responseModal" id="responseModalShowButton">hey</button>                      
                       
  <div class="bottom d-block d-sm-none w-100">
     <div class="input-group">
            <select class="form-control" id="small_screen_input_options">
             <option value="InputBox">Input Box</option>
             <option value = "List">Selection List</option>
             <option value = "Radio">Radio</option>
             <option value="CheckBox">Checkbox</option>
              </select>
              <div class="input-group-append">
                        <button type="button" class="btn  bg-teal text-white"  onclick="addOfSmall()">Add</button>
               </div>      
        </div> 
     </div> 
   
    <div class="loader-wrapper  justify-content-center">
            <div class="align-self-center loader"> </div>
    </div>
        
    <script>
        
     var change_tracker;   
     function loadData(){
            var xhttp = new XMLHttpRequest();
            xhttp.onreadystatechange = function() {
                if (this.readyState === 4 && this.status === 200) {

              var recieveObjs = JSON.parse(this.responseText);     
              for (var  x  in recieveObjs){
                  
                    if(recieveObjs[x].type == "checkbox"){
                       document.getElementsByName("c_label")[0].value = recieveObjs[x].label;
                       document.getElementsByName("c_data")[0].value = recieveObjs[x].value;
                       document.getElementsByName("c_answer")[0].value = recieveObjs[x].answer;
                       var optimility = document.getElementsByName("c_optimality");
                       optimility[1].checked = recieveObjs[x].optimility == "*" ? "true" : "false";
                       addCheckBox(-1);
                    }
                   else if(recieveObjs[x].type == "list"){
                       document.getElementsByName("l_label")[0].value = recieveObjs[x].label;
                       document.getElementsByName("l_data")[0].value = recieveObjs[x].value;
                       var optimility = document.getElementsByName("l_optimality");
                       optimility[1].checked = recieveObjs[x].optimility == "*" ? "true" : "false";
                       addList(-1);
                 }
                else if(recieveObjs[x].type == "radio"){
                       document.getElementsByName("r_label")[0].value = recieveObjs[x].label;
                       document.getElementsByName("r_data")[0].value = recieveObjs[x].value;
                        document.getElementsByName("r_answer")[0].value = recieveObjs[x].answer;
                       var optimility = document.getElementsByName("r_optimality");
                       optimility[1].checked = recieveObjs[x].optimility == "*" ? "true" : "false";
                       addRadio(-1);
                   }
                 else{
                        document.getElementsByName("i_label")[0].value = recieveObjs[x].label;
                        document.getElementsByName("i_data")[0].value = recieveObjs[x].type;
                        var optimility = document.getElementsByName("i_optimality");
                        optimility[1].checked = recieveObjs[x].optimility == "*" ? "true" : "false";
                        addInputBox(-1);
                      }  
                }
                change_tracker = false;
            }
        };
      
      xhttp.open("POST", "LoadData", true);
      xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
      xhttp.send("fid=${fid}&type=quizze");
      
  }
    
    loadData();
    
        var error = document.getElementById("error");   
        var form_meta_data = [];
        var form_container  =   document.getElementById("form-container");
        var count = 0 ;
        var numbering = 1;
        var font_family="${font}",border_color="${border}",background_color="${background}",title_text="${title}";
        function changeBgColor(i){
            document.getElementById("right-column").style.backgroundColor = i.value ;
            background_color = i.value;
        }
        function changeBorderColor(i){
            document.getElementById("form-container").style.borderTop = "8px solid  " +  i.value; 
            border_color = i.value;
         } 
        function changeFontFamily(i){
            document.getElementById("form-container").style.fontFamily = i.value;
            font_family = i.value; 
            i.style.fontFamily = i.value;
        }
        
        function addOfLarge(){
            show(document.getElementById("large_screen_input_options").value);
        }
        
        function addOfSmall(){
            show(document.getElementById("small_screen_input_options").value);
        }
        
        
        function show(id){
            
            if(id=="InputBox"){
                document.getElementById("add" + id +"Button").onclick = function(){ addInputBox(-1); } ;
                 }
            else if(id=="Radio"){
                document.getElementById("add" + id +"Button").onclick = function(){ addRadio(-1); } ;
              }
            else if(id=="List"){
                document.getElementById("add" + id +"Button").onclick = function(){ addList(-1); } ;
            }
            else{ 
                document.getElementById("add" + id +"Button").onclick = function(){ addCheckBox(-1); } ;
             }
            
               document.getElementById("modal"+id+"Show").click();
         }
         
        function fillHeader(v){
           document.getElementsByClassName("form-header")[0].innerHTML = v.value;
           title_text = v.value;
        }
        
       function addCheckBox(index){
          
          var  label            =       document.getElementsByName("c_label")[0];
          var  data             =      document.getElementsByName("c_data")[0];
          var  answer          =      document.getElementsByName("c_answer")[0];
          var  optimality    =      document.getElementsByName("c_optimality");
          var  isrequired      =      optimality[1].checked === true?"*":"";
          var  answer_v      =      answer.value;
          var  label_v         =       label.value;
          var  data_v          =      data.value;
          var  obj              =      {type:"checkbox",label:label_v,value:data_v,optimality:isrequired,answer:answer_v};
          var  values          =       data_v.split(",");
        
       
        if(index===-1){
            
          var  container  = "<div class='border '><span class='text-white pr-2 pl-2 pt-1 pb-1 bg-success numbering_label'>"+numbering+"</span> <div class='btn-group float-right'><button type='button' class='btn p-1' onclick='editCheckBox("+count +")'><i class='fa fa-edit'></i></button><button type='button' class='btn p-1' onclick='remove("+count+")'><i class='fa fa-trash'></i></button></div>";
                 container  +=  "<div class='mt-2 pl-2 pr-2 pl-md-4 pr-md-4 form-group fg'><label>"+ label_v+"&nbsp;<span class='text-danger'>"+isrequired+"</span></label><br> ";
          
          for(var x in values){
               container += "<input type='checkbox'  >&nbsp;<label>"+ values[x] +"</label><br>";
             }
              container  += "</div></div>";
          
             form_meta_data.push(obj);
             form_container.innerHTML += container;
             count++;
             numbering++;
         }
         else{
             
             var fg  = document.getElementsByClassName("fg")[index];
            
             fg.innerHTML = "<label>"+ label_v+"&nbsp;<span class='text-danger'>"+isrequired+"</span></label><br> ";
             
             for(var x in values){
                 fg.innerHTML += "<input type='checkbox'  >&nbsp;<label>"+ values[x] +"</label><br>";
             }
             form_meta_data[index] = obj;
         }
         
              
              label.value = "";
              data.value  = "";
              answer.value="";
              optimality[0].checked = true; 
              document.getElementById("closeaddcheck").click();
              change_tracker = true;
     }   
     
     function addRadio(index){
          
          var  label           =      document.getElementsByName("r_label")[0];
          var  data            =     document.getElementsByName("r_data")[0];
          var  optimality    =      document.getElementsByName("r_optimality");
          var  answer          =      document.getElementsByName("c_answer")[0];
          var  isrequired     =      optimality[1].checked === true?"*":"";
          var  label_v = label.value;
          var  data_v  = data.value;
          var answer_v = answer.value;
          var obj  = {type:"radio",label:label_v,value:data_v,optimality:isrequired,answer:answer_v};
          var  values = data_v.split(",");
        
        if(index===-1){
           
             var  container  = "<div class='border '><span class='text-white pr-2 pl-2 pt-1 pb-1 bg-success numbering_label'>"+numbering+"</span> <div class='btn-group float-right'><button type='button' class='btn p-1' onclick='editRadio("+count +")'><i class='fa fa-edit'></i></button><button type='button' class='btn p-1' onclick='remove("+count+")'><i class='fa fa-trash'></i></button></div>";
                   container  +=  "<div class='mt-2 pl-2 pr-2 pl-md-4 pr-md-4 form-group fg'><label>"+ label_v+"&nbsp;<span class='text-danger'>"+isrequired+"</span></label><br> ";
          
            for (var x in values){
                     container += "<input type='radio'  >&nbsp;<label>"+ values[x] +"</label><br>";
               }
                 container  += "</div></div>";
              
              form_container.innerHTML += container;
              count++;
              form_meta_data.push(obj);
              numbering++;
        }    
        else{
          
            var fg  = document.getElementsByClassName("fg")[index];
             fg.innerHTML = "<label>"+ label_v+"&nbsp;<span class='text-danger'>"+isrequired+"</span></label><br> ";
             
             for(var x in values){
                 fg.innerHTML += "<input type='radio'  >&nbsp;<label>"+ values[x] +"</label><br>";
             }
             form_meta_data[index] = obj;
           }
        
              label.value = "";
              data.value  = "";
              answer.value = "";
              optimality[0].checked = true;
              document.getElementById("closeaddradio").click();
              change_tracker = true;
     }  
    
     function addList(index){
          
          var  label    =  document.getElementsByName("l_label")[0];
          var  data     =  document.getElementsByName("l_data")[0];
          var  optimality    =      document.getElementsByName("l_optimality");
          var  isrequired     =      optimality[1].checked === true?"*":"";
          var  label_v = label.value;
          var  data_v  = data.value;
          var obj  = {type:"list",label:label_v,value:data_v,optimality:isrequired,answer:""};
           var  values = data_v.split(",");
          
        if(index===-1){ 
            
            var  container  = "<div class='border '><span class='text-white pr-2 pl-2 pt-1 pb-1 bg-success numbering_label'>"+numbering+"</span> <div class='btn-group float-right'><button type='button' class='btn p-1' onclick='editList("+count +")'><i class='fa fa-edit'></i></button><button type='button' class='btn p-1' onclick='remove("+count+")'><i class='fa fa-trash'></i></button></div>";
                   container  +=  "<div class='mt-2 form-group fg pl-2 pr-2 pl-md-4 pr-md-4'><label>"+ label_v+"&nbsp;<span class='text-danger'>"+isrequired+"</span></label><br><select class='form-control'>";
                 
               for (var x in values){
                      container += "<option>"+ values[x] +"</option>";
               }
              container  += "</select></div></div>";
              form_meta_data.push(obj);
              form_container.innerHTML += container;
              numbering++;
              count++;
        }
       else{
          
             var fg  = document.getElementsByClassName("fg")[index];
             var content  = "<label>"+ label_v+"&nbsp;<span class='text-danger'>"+isrequired+"</span></label><br> <select class='form-control'>";
             
             for(var x in values){
                  content +=  "<option>"+ values[x] +"</option>";;
             }
                   content +="</select>";
                   fg.innerHTML = content;
             form_meta_data[index] = obj;
          }   
              label.value = "";
              data.value  = "";
              optimality[0].checked = true;
              document.getElementById("closeaddlist").click();
              change_tracker = true;
     }  
    
    function addInputBox(index){
          
          var  label    =  document.getElementsByName("i_label")[0];
          var  data     =  document.getElementsByName("i_data")[0];
          var  optimality    =  document.getElementsByName("i_optimality");
          var  isrequired     =      optimality[1].checked === true?"*":"";
          var  label_v = label.value;
          var  data_v  = data.value;
          var obj  = {type:data_v,label:label_v,value:"",optimality:isrequired,answer:""};
          
          if(index===-1){
          
          form_meta_data.push(obj);
          var   container  = "<div class='border '><span class='text-white pr-2 pl-2 pt-1 pb-1 bg-success numbering_label'>"+numbering+"</span> <div class='btn-group float-right'><button type='button' class='btn p-1' onclick='editInputBox("+count +")'><i class='fa fa-edit'></i></button><button type='button' class='btn p-1' onclick='remove("+count+")'><i class='fa fa-trash'></i></button></div>";
                 container  +=  "<div class='mt-2  pl-2 pr-2 pl-md-4 pr-md-4 form-group fg'><label >"+ label_v+"&nbsp;<span class='text-danger'>"+isrequired+"</span></label>";
                 container  += "<input type='"+data_v+"' class='form-control'  placeholder='Enter "+label_v+"' >";
                 container  += "</div></div>";
           form_container.innerHTML += container;
           numbering++;
           count++;
       }
       else{
         
            document.getElementsByClassName("fg")[index].innerHTML = "<label>"+ label_v+"&nbsp;<span class='text-danger'>"+isrequired+"</span></label><br><input type='"+data_v+"' class='form-control' placeholder='Enter "+label_v+"' >";  
            form_meta_data[index] = obj;  
        }
                label.value = "";
              
               optimality[0].checked = true;
               document.getElementById("closeaddinput").click();
               change_tracker = true;
     }  
    
    function editCheckBox(index){
        
          var  label            =      document.getElementsByName("c_label")[0];
          var  data             =      document.getElementsByName("c_data")[0];
          var  optimality    =      document.getElementsByName("c_optimality");
          var answer           =     document.getElementsByName("c_answer")[0];
          answer.value       =      form_meta_data[index].answer;      
          label.value           =      form_meta_data[index].label;
          data.value           =      form_meta_data[index].value;
          form_meta_data[index].optimality==="*"?optimality[1].checked=true:optimality[0].checked=true;
          document.getElementById("addCheckBoxButton").onclick = function(){ addCheckBox(index); } ;
          document.getElementById("modalCheckBoxShow").click();
    }
    function editRadio(index){
        
          var  label            =    document.getElementsByName("r_label")[0];
          var  data             =    document.getElementsByName("r_data")[0];
          var  optimality    =    document.getElementsByName("r_optimality");
          var answer           =     document.getElementsByName("r_answer")[0];
          answer.value       =      form_meta_data[index].answer;      
          label.value           =    form_meta_data[index].label;
          data.value            =     form_meta_data[index].value;
          form_meta_data[index].optimality==="*"?optimality[1].checked=true:optimality[0].checked=true;
          document.getElementById("addRadioButton").onclick = function(){ addRadio(index); } ; 
          document.getElementById("modalRadioShow").click();
        
    }
    
    function editInputBox(index){
        
          var  label            =    document.getElementsByName("i_label")[0];
          var  data             =    document.getElementsByName("i_data")[0];
          var  optimality    =    document.getElementsByName("i_optimality");
          label.value           =    form_meta_data[index].label;
          data.value            =     form_meta_data[index].type;
          form_meta_data[index].optimality==="*"?optimality[1].checked=true:optimality[0].checked=true;
          document.getElementById("addInputBoxButton").onclick = function(){ addInputBox(index); } ;
          document.getElementById("modalInputBoxShow").click();
    }
    
    function  editList(index){
        
          var  label            =    document.getElementsByName("l_label")[0];
          var  data             =    document.getElementsByName("l_data")[0];
          var  optimality    =    document.getElementsByName("l_optimality");
          label.value           =    form_meta_data[index].label;
          data.value            =     form_meta_data[index].value;
          form_meta_data[index].optimality==="*"?optimality[1].checked=true:optimality[0].checked=true;
          document.getElementById("addListButton").onclick = function(){ addList(index); } ;
          document.getElementById("modalListShow").click();
    }
    
    function remove(index){
        
        var fg = document.getElementsByClassName("fg")[index];
        fg.parentNode.style.display =  "none";
        form_meta_data[index] = null;
        numbering--;
        var num_labels = document.getElementsByClassName("numbering_label");
        var i=1;
        for(x in form_meta_data){
          if ( form_meta_data[x] !== null){  
               num_labels[x].innerHTML=i;
               i++;
           }
         }
         change_tracker = true;
    }
    
    function sendData(){

       var loader = document.querySelector(".loader-wrapper");
       
        
      if (numbering!==1){
          if (title_text != " "  &&  title_text != ""){
         
                loader.style.display = "flex";  
               var obj = {title:title_text,background:background_color,border:border_color,font:font_family};
               var settings = JSON.stringify(obj);
               var xhttp = new XMLHttpRequest();
        
                 xhttp.onreadystatechange = function() {
                if (this.readyState === 4 && this.status === 200) {
                   loader.style.display = "none";
                   document.getElementById("response_container").innerHTML = this.responseText;
                   document.getElementById("responseModalShowButton").click();
               }
        };
    
    var form_meta_data_json = "";
    
    for (x in form_meta_data)
        if (form_meta_data[x]!==null)
           form_meta_data_json +=  JSON.stringify(form_meta_data[x]) + ";";
    
      xhttp.open("POST", "quizze_metadata_store.jsp", true);
      xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
      xhttp.send("data="+form_meta_data_json+"&setting="+settings+"&fid=${fid}&change_tracker="+change_tracker);
    }
    else{
             error.style.display = "block";
             error.innerHTML = "!Please give a title to the form."
             document.querySelector("#title").focus();
         }
    }
     else{
     
        error.style.display = "block";
         error.innerHTML = "!Form is Empty first make form and then save."
     }
   } 
    
    </script>
    </body>
</html>
