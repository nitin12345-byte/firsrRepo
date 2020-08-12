<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page  import="com.survey.FormInput" %>

<c:catch var="error" >

    <%
     
         String font,bg,border,title;
         boolean activate,shuffle;
         String fid = request.getParameter("id");
         Connection conn = (Connection)application.getAttribute("conn");
         session.setAttribute("fid",fid);
         Statement stm = conn.createStatement();
         ResultSet rs  =  stm.executeQuery( "select * from form_data where form_id ='"+fid+"'");
         rs.next();
         title =  rs.getString(3);
         bg = rs.getString(4);
         border = rs.getString(5);
         font = rs.getString(6);
         activate = Boolean.valueOf(rs.getString(8));
         shuffle = rs.getBoolean(9);
        
         if( activate == true ){
         
         rs = stm.executeQuery("select * from  quizze_metadata_"+fid.toLowerCase());
         List<FormInput> coll = new ArrayList<FormInput>();
         int counter=0;
         FormInput fm;
         
         while (rs.next()) {
                 fm = new FormInput();
                 fm.setType(rs.getString(1));
                 fm.setLabel(rs.getString(2));
                 fm.setOptimality(rs.getString(4));
                 fm.setValue(rs.getString(3));
                 fm.setName("input"+counter);
                 coll.add(fm);
                 counter++;
          }
         
         if(shuffle == true){
             
             int size = coll.size();
             
             for(int i=0;i<size;i++){
                  
                    int j = (int)(Math.random()*size);
                    fm = coll.get(i); 
                    coll.set(i, coll.get(j));
                    coll.set(j, fm);
             }
         }
         
         pageContext.setAttribute("metadata" , coll);
      }  
         pageContext.setAttribute("activate",activate);
         pageContext.setAttribute("title",title);
         pageContext.setAttribute("border",border);
         pageContext.setAttribute("background",bg);
         pageContext.setAttribute("font_family",font);
    %>
 
</c:catch> 
<!DOCTYPE html>
<html>
   <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta charset="utf-8">
        <title>view Form page</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="icon" href="icon.png"   type="image/png">
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
        .main-container{
           font-family:${font_family}; 
            width:100%;
         }
         .form-container{
            width: 95%;
         }
         .error {
            display:none;
         }
         .title { font-size : 20px;}
         @media only screen and (min-width:720px){
            .form-container{
                width:75%;
            }
            .title { font-size : 30px;}
         }
         
       </style>
  </head>
  <body  style="background:${background}">
  <c:if test = "${error == null }" >
    <c:set var  = "counter" value = "0" />
     <form action="quizze_data_store.jsp" method="post"   onsubmit="check(event)">
       <div class="main-container pt-2 pt-sm-5">
          <div class="form-container mx-auto">
              <div class="title-section p-3 rounded-lg mb-3" style="border-top:8px solid ${border};background:white">
                  <header class="title "><c:out value="${title}" /></header>
              </div>
             <div class="input-container rounded-lg" style="background:white">
                <c:if test="${activate == true}" > 
                  <c:forEach var="input"  items="${metadata}" >
                           <c:set var="required" value="false" />
                           <c:if test="${fn:contains(input.optimality,'*')}">
                               <c:set var="required" value="true" />
                            </c:if>
                           <c:choose>
                              <c:when test="${fn:contains(input.type,'radio')}">
                                  <div class="input-box p-3 border" style="background:white"    data-required="${required}"  data-stillrequired="true">
                                        <label>
                                         <c:out value="${input.label}" />
                                         <span class="text-danger"><c:out value="${input.optimality}" /></span>
                                        </label>
                                         <c:forEach var="radio_label"  items="${fn:split(input.value,',')}">
                                              <div class="" >
                                                   <input type="radio"   value="${radio_label}"  id="${radio_label}"  name="${input.name}"  onchange=setRadioRequired(${counter}) />
                                                     &nbsp;<label for="${radio_label}"> <c:out value="${radio_label}" /></label>
                                              </div>
                                         </c:forEach>
                                        <spna class="error text-danger"><i class="fa fa-warning"></i>&nbsp; it is required to fill</span>
                                    </div> 
                               </c:when>
                               <c:when test="${fn:contains(input.type,'checkbox')}">
                                    <div class="input-box p-3 border" style="background:white"    data-required="${required}"  data-stillrequired="true">
                                        <label>
                                           <c:out value="${input.label}" />
                                            <span class="text-danger"><c:out value="${input.optimality}" /></span>
                                       </label>
                                       <c:forEach var="checkbox_label"  items="${fn:split(input.value,',')}">
                                           <div class="" >
                                               <input type = "checkbox"   name="${input.name}[]"  value="${checkbox_label}"   id="${checkbox_label}"   onchange = 'setCheckboxRequired(${counter},"${input.name}" )' />
                                                &nbsp;<label for="${checkbox_label}"> <c:out value="${checkbox_label}" /></label>
                                           </div>
                                       </c:forEach> 
                                        <span class="error text-danger"><i class="fa fa-warning"></i>&nbsp; it is required to fill</span>
                                   </div> 
                                </c:when>
                                <c:when test="${fn:contains(input.type,'list')}">
                                    <div class="input-box p-3 border" style="background:white">
                                        <div class="form-group" >
                                           <label><c:out value="${input.label}" /> <span class="text-danger"><c:out value="${input.optimality}" /></span></label>
                                            <select name="${input.name}" class="form-control">
                                                <c:forEach var="list_option"  items="${fn:split(input.value,',')}">
                                                     <option value="${list_option}"><c:out value="${list_option}" /></option>
                                                </c:forEach>
                                            </select>
                                       </div>
                                      <span class="error text-danger"><i class="fa fa-warning"></i>&nbsp; it is required to fill</span>   
                                 </div> 
                             </c:when>
                             <c:otherwise>
                              <div class="input-box p-3 border" style="background:white;"   data-required="${required}"  data-stillrequired="true">
                                 <div class="form-group">
                                     <label><c:out value="${input.label}" /> <span class="text-danger"><c:out value="${input.optimality}" /></span></label>
                                     <input type="${input.type}" class="form-control" name="${input.name}"    onchange=setOtherInputsStillrequired(this,${counter})  />
                                 </div>
                                 <span class="error text-danger"><i class="fa fa-warning"></i>&nbsp; it is required to fill</span>
                              </div>
                           </c:otherwise>
                       </c:choose>
                           <c:set var="counter"  value="${counter+1}" />
                    </c:forEach>
                    <div class="p-3 text-right" style="background:white;">
                        <div class="form-group">
                           <button type="submit" class="btn bg-success">Save</button>
                       </div>
                    </div>
                    <div class="footer mt-4  bg-dark p-3 text-white text-center d-block w-100" >
                         Powered By Survey.com
                    </div>
                </c:if>
                <c:if test="${activate==false}">
                       Currently the form can not take response.
                </c:if> 
             </div>
           </div>
         </div>
      </form>
  </c:if>
  <c:if test = "${error != null}" >
      <div class="p-5 text-center  text-danger "><i class="fa fa-warning" style="font-size:40px"></i><br>Link is invalid contact to concern body<br>{<c:out value="${error}" />}</div>
  </c:if>   
 <script>
                  
    function setRadioRequired(index){
        
         document.getElementsByClassName('input-box')[index].setAttribute("data-stillrequired","false");
    
    }                  

    function setOtherInputsStillrequired(i,index){
       
        if(i.value=="")
            document.getElementsByClassName('input-box')[index].setAttribute("data-stillrequired","true");
        else
            document.getElementsByClassName('input-box')[index].setAttribute("data-stillrequired","false");
    }
    
    function setCheckboxRequired(index,name){
        
        var checkinputvalue = document.getElementsByName(name+"[]")[0].value;
         
        if (checkinputvalue == "")
            document.getElementsByClassName('input-box')[index].setAttribute("data-stillrequired","true");
        else
            document.getElementsByClassName('input-box')[index].setAttribute("data-stillrequired","false");
     
    }
    
    
    function check(event){
        
        var allinputbox =   document.getElementsByClassName('input-box');
        var allerrors     =  document.getElementsByClassName('error');
        var v  =  null;
        
        for (var x=0;  x<allinputbox.length; x++){
             if (allinputbox[x].getAttribute("data-required") == "true"){
                if (allinputbox[x].getAttribute("data-stillrequired") == "true"){
                     allinputbox[x].style.border = "1px solid #DC3545";
                     allerrors[x].style.display = "inline";
                   if (v == null)
                         v = x;
                 }
                 else
                 {
                    allinputbox[x].style.border = "0px solid #DC3545";
                    allerrors[x].style.display = "none"; 
                 }
             }
         }
        
        if(v!=null){
            allinputbox[v].focus();
            event.preventDefault();
           return false;
      }
      else
          return true;
      }
      
    </script>            
  </body>
</html>
