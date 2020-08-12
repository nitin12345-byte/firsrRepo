
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.survey.FormData" %>
<%@page import="com.survey.User" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%> 
<c:catch var="error" >
<%
    
   String email =  (String)session.getAttribute("email");
   String display_error_container = "none" , display_main_container="none";
    
   if (email != null){
    
    display_main_container = "block";
    Connection conn = (Connection)application.getAttribute("conn");
    ResultSet rs  = conn.createStatement().executeQuery("select * from form_data where email = '" + email +"'");
    List<FormData> list_fd = new ArrayList<FormData>(); 
    
    while(rs.next()){
     
        FormData fd = new FormData(); 
        fd.setForm_id(rs.getString(1)); 
        fd.setTitle(rs.getString(3));
        fd.setDate(rs.getString(7));
        fd.setBorder(rs.getString(5));
        fd.setActivate(rs.getString(8));
        fd.setShuffle(rs.getBoolean(9));
        fd.setType(rs.getString(10));
        list_fd.add(fd);  
      }
     pageContext.setAttribute("list",list_fd);
    
   }
   else
    {
       display_error_container = "block";
     }
   
   pageContext.setAttribute("display_main_container",display_main_container);
   pageContext.setAttribute("display_error_container",display_error_container);
   
  %>
</c:catch>
<c:out value="${error}" />

<c:if test="${error==null}"> 
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta charset="utf-8">
        <title>Home page</title>
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
           font-family:Trocchi;
        }
  	
     .logo{
          font:20px Trocchi;
          letter-spacing:2px;
          color:#30949d;     
     }
  
    .text-teal{
        color:#30949d;
     }
    .bg-teal{
      background:#30949d;
    }
    .main{
       width:95%;
       min-height:500px;
    }
    .form-container{
       border-top:8px solid green;
   }
   .error_container,main-container{
       display:none;
   }
   .logo:hover{
      text-decoration: none;  
     }
     .date{
         font-size:12px;
     } 
   .link { font-size: 12px;}
   
   .loader-wrapper{  position:absolute;height:100%;width:100%;top:0;left:0;z-index : 1000;background:rgba(255,255,255,0.7);display:none; }     
   .loader{    height:50px;  width:50px;border:5px solid white;border-top:5px solid teal;border-radius:50%; animation:spin 0.8s linear infinite;}
   .logo:hover{
        text-decoration: none;  
      }             
      .bg-gradient{
                     background-color: #0093E9;
                     background-image: linear-gradient(160deg, #0093E9 0%, #80D0C7 100%);
                    border-radius: 20px;
         } 
         
    @keyframes spin{
            0%{  transform : rotate(0deg);  }
           100%{ transform : rotate(360deg); } 
        }   
   @media only screen and (min-width:720px){
      .main{
          width:75%;
      }
      .link { font-size: 15px;}   
   }
  </style>
  </head>
    <body>
         <div class="error_container mt-5 text-center" style="display: ${display_error_container}">
             <h4>first  Login or signin to get access this page</h4> 
        </div>     
       <div class = "main_container" style="display:${display_main_container}">   
            <nav class="navbar p-2 p-md-3  shadow">
               <a class="logo" href="index.html">SURVEY.COM</a>
                <div class="ml-auto">
                      <a href="createQuizze.jsp" class="btn pt-2 pb-2 pr-4 pl-4 d-none text-white  d-sm-inline mr-2 bg-gradient" title="click to start new quizze">Start new quizze + </a>
                      <a href="CreateForm.jsp" class="btn pt-2 pb-2 pr-4 pl-4 d-none text-white  d-sm-inline bg-gradient" title="click to create a new form">Compose + </a>
                     <button  data-toggle="modal" data-target="#userprofileModal" class="btn pt-2 pb-2 pr-4 pl-4" title="user-profile"><i class="fa fa-user-circle-o"  style="font-size:20px;"></i></button>
                </div>
           </nav>
    <br>
     <h5 class="text-center p-2">Welcome ,  ${name}</h5>
    <div class="form-group d-block d-sm-none p-2 mt-3">
        <a href="CreateForm.jsp" class="btn btn-block pt-2 pb-2 pr-4 pl-4  text-white mb-2 bg-gradient" title="click to start new quizze">Start new quizze + </a>
        <a class="btn btn-block bg-gradient   text-white" href="CreateForm.jsp">Compose</a>
    </div>
   
    <div class="main bg-light mx-auto border">
        <header class="bg-info text-white p-2 text-center">Form-list</header>
        <div class="p-3 p-sm-5">
            <c:if test="${list.size()==0}">
                <center>There is   no any form</center> 
            </c:if>
            <c:set var="counter" value="0" />    
            <c:forEach var="form" items="${list}" >
               <c:if test='${form.type.equals("survey")}'>
                  <div class="form-details row mt-3 rounded-lg border-left border-right border-bottom"  id="${form.form_id}"  style="background:white;border-top:6px solid ${form.border}">
                    <div class="col-md-8 p-3 border-bottom">
                        <h6>${form.title}</h6> 
                        <a href="viewform.jsp?id=${form.form_id}" class=" link">localhost:8080/survey.com/viewform.jsp?id = ${form.form_id}</a>
                        <br><span class="text-dark date">${form.date}</span>
                    </div>
                     <div class="col-md-4 p-2 text-center text-md-right">
                         <a class="btn p-1" title="view csv" href="tableview.jsp?title=${form.title}&id=${form.form_id}&type=survey"><i class="fa fa-eye" style="font-size:20px"></i></a>
                         <a class="btn p-1" title="download csv" style="font-size:20px"  href="C:\Users\shri\AppData\Roaming\NetBeans\8.0\config\GF_4.0\domain1\config\form_${form.form_id}.csv" download ><i class="fa fa-download"> </i> </a>
                         <button class="btn p-1" title= "delete form" style="font-size:20px" onclick = sendDeleteRequest("${form.type}","${form.form_id}")><i class="fa fa-trash"></i></button>
                     
                        <c:if test="${form.activate=='true'}" >
                              <input type="checkbox" class="btn  activate_status" style="height:18px;width:18px"  title="click to deactivate the form after deactivate it will not take respone"  onchange = change_status(this,"${form.form_id}")  checked> 
                        </c:if>
                        <c:if test="${form.activate!='true'}" >
                              <input type="checkbox" class="btn  activate_status" style="height:18px;width:18px" title="click to activate the form after activate it will not take respone"  onchange = change_status(this,"${form.form_id}")> 
                        </c:if>
                          <!--  <button  class="btn p-1 shuffle" title="click to shuffle the questions"   onclick = shuffle_unshuffle(true,${counter},"${form.form_id}")  style="font-size:20px;display:${ form.isShuffle()==true?'none':'inline'}"><i class="fa fa-random" aria-hidden="true"></i></button>      
                            <button  class="btn p-1 unshuffle" title="click to unshuffle the questions"   onclick = shuffle_unshuffle(false,${counter},"${form.form_id}") style="font-size:20px;display:${ form.isShuffle()==true?'inline':'none'}"><i class="fa fa-repeat" aria-hidden="true"></i></button>         
                          -->  
                          <a  class="btn p-1" title="click to edit" href="editForm.jsp?form_id=${form.form_id}" style="font-size:20px"><i class="fa fa-edit"></i></a>   
                     </div>
                 </div>
                </c:if>
               <c:if test='${form.type.equals("quizze")}'>
                  <div class="form-details row mt-3 rounded-lg border-left border-right border-bottom"  id="${form.form_id}"  style="background:white;border-top:6px solid ${form.border}">
                    <div class="col-md-8 p-3 border-bottom">
                        <h6>${form.title}</h6> 
                        <a href="quizze.jsp?id=${form.form_id}" class=" link">localhost:8080/survey.com/quizze.jsp?id = ${form.form_id}</a>
                        <br><span class="text-dark date">${form.date}</span>
                    </div>
                     <div class="col-md-4 p-2 text-center text-md-right">
                         <a class="btn p-1" title="view csv" href="tableview.jsp?title=${form.title}&id=${form.form_id}&type=quizze"><i class="fa fa-eye" style="font-size:20px"></i></a>
                         <a class="btn p-1" title="download csv" style="font-size:20px"  href="C:\Users\shri\AppData\Roaming\NetBeans\8.0\config\GF_4.0\domain1\config\form_${form.form_id}.csv" download ><i class="fa fa-download"> </i> </a>
                         <button class="btn p-1" title= "delete form" style="font-size:20px" onclick = sendDeleteRequest("${form.type}","${form.form_id}")><i class="fa fa-trash"></i></button>
                     
                        <c:if test="${form.activate=='true'}" >
                              <input type="checkbox" class="btn  activate_status" style="height:18px;width:18px"  title="click to deactivate the form after deactivate it will not take respone"  onchange = change_status(this,"${form.form_id}")  checked> 
                        </c:if>
                        <c:if test="${form.activate!='true'}" >
                              <input type="checkbox" class="btn  activate_status" style="height:18px;width:18px" title="click to activate the form after activate it will not take respone"  onchange = change_status(this,"${form.form_id}")> 
                        </c:if>
                          <!--  
                                <button  class="btn p-1 shuffle" title="click to shuffle the questions"   onclick = shuffle_unshuffle(true,${counter},"${form.form_id}")  style="font-size:20px;display:${ form.isShuffle()==true?'none':'inline'}"><i class="fa fa-random" aria-hidden="true"></i></button>      
                                <button  class="btn p-1 unshuffle" title="click to unshuffle the questions"   onclick = shuffle_unshuffle(false,${counter},"${form.form_id}") style="font-size:20px;display:${ form.isShuffle()==true?'inline':'none'}"><i class="fa fa-repeat" aria-hidden="true"></i></button>         
                            -->
                           <a  class="btn p-1" title="click to edit" href="editQuizze.jsp?form_id=${form.form_id}" style="font-size:20px"><i class="fa fa-edit"></i></a>   
                     </div>
                 </div>
                </c:if>
               <c:set var="counter" value="${counter+1}"/>      
            </c:forEach>   
         </div>
      </div>
    </div>
     <div class="loader-wrapper  justify-content-center">
        <div class="align-self-center loader"> </div>
    </div>
    
     <div class="modal" id="userprofileModal">
      <div class="modal-dialog modal-dialog-centered">
          <form action="ChangeCredentials" method="post">
          <div class="modal-content">
              <div class="modal-header">
                  <h4>Profile</h4>
                  <button class="close border-0"  data-dismiss="modal">&times;</button>
              </div> 
              <div class="modal-body p-3">
                  <div class="card">
                       <img class="card-img-top image-fluid" src="avatar.jpg" alt="Card image" height="180"/>
                      
                       <div class="card-body">
                         <div class="form-group">
                             <label>name</label>
                             <input type="text" class="form-control" value="${name}" name="name"  required disabled>
                         </div>
                          <div class="form-group">
                             <label>Email</label>
                             <input type="text" class="form-control" value="${email}" name="email"  required disabled>
                         </div>
                      </div>
                </div>
              </div>
              <div class="modal-footer">
                       <button type="button" class = "btn bg-teal text-white" onclick="edit()">edit</button>
                       <button type="submit" class = "btn bg-teal text-white float-right" onclick="saveData()" id="savebtn" disabled>save</button>
              </div>
           </div>
          </form>               
      </div>
  </div>                   
                     
   <script>
        
      var loader = document.querySelector(".loader-wrapper");
     
    function sendDeleteRequest(type,id){
        loader.style.display = "flex";      
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
        if  ( this.readyState === 4 && this.status === 200) {
           
            if (this.responseText == "success"){
                 loader.style.display= "none";
                 var removedDiv = document.getElementById(id);
                 var parent = removedDiv.parentElement;
                  removedDiv.remove();
                  if (document.querySelectorAll(".form-details").length==0){
                      parent.innerHTML = "<center>There is no form<center>";
                  }
             }
            else{
                document.write(this.responseText);
            }
       }
   }
      xhttp.open("POST", "DeleteForm", true);
      xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
      xhttp.send("form_id="+id+"&type="+type);  
    }    
     
    function change_status(checkbox,id){
        var activate;
        
        if (checkbox.checked == true){
            activate = "true";
            checkbox.setAttribute("title","click to deactivate the form after deactivate it will not take respone");
        }
        else{ 
            activate = "false";
            checkbox.setAttribute("title","click to activate the form after activate it will  take respone");
        }
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
        if  ( this.readyState === 4 && this.status === 200) {
           
              console.log(this.responseText);
           }
   }
      xhttp.open("POST", "ChangeFormStatus", true);
      xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
      xhttp.send("form_id="+id+"&active="+activate);  
   }
    
    
   function shuffle_unshuffle(status,index,fid){
       
       var shuffle  =  document.querySelectorAll(".shuffle")[index];
       var unshuffle  =  document.querySelectorAll(".unshuffle")[index];
        
        
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
        if  ( this.readyState === 4 && this.status === 200) {
       
            console.log(this.responseText);
       
             if (status == true){
                 unshuffle.style.display = "inline";
                 shuffle.style.display = "none";
             }
          else{
                  unshuffle.style.display = "none";
                  shuffle.style.display = "inline";
               }
         }
         
   }
      xhttp.open("POST", "ChangeShuffleStatus", true);
      xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
      xhttp.send("status="+status+"&fid="+fid);  
   
    } 
   
   function edit(){
       
       var name = document.getElementsByName("name")[0];
       var email = document.getElementsByName("email")[0];
       name.disabled = false;
       email.disabled = false;
       var btn =  document.getElementById("savebtn");
       btn.disabled=false;
   }
   
   
    </script>
   </body>
</html>
</c:if>