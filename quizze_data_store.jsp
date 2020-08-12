
<%@page import="java.util.Arrays"%>
<%@page import="java.lang.String"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.io.FileWriter"%>
<%@page import="com.opencsv.CSVWriter"%>
<%@page import="java.io.File"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 

<c:catch var="e">
    
    <%
        
        String fid =  (String)session.getAttribute("fid");
        String type,answer , userinput="";
        Connection conn = (Connection)application.getAttribute("conn");
        Statement stm =  conn.createStatement();
        ResultSet rs = stm.executeQuery("select * from quizze_metadata_"+fid);
        int counter = 0 ;
        int gain_marks  = 0,total_marks  = 0;
        String sql = "insert into  quizze_data_"+fid +" values(";
        while (rs.next()){
           
            type = rs.getString(1);
            answer = rs.getString(5);
            
            if (type.equals("checkbox")){
                List<String> v  =  Arrays.asList(request.getParameterValues("input"+counter+"[]"));
                String answer_arr[] = answer.split(",");
                if (v.size()==answer_arr.length){
                     for (int i=0;i<answer_arr.length;i++)
                         v.remove(answer_arr[i]);
                }
                if(v.size()==0)
                    gain_marks++;
                total_marks++;
              }
             else if (type.equals("radio")){
                 userinput =  request.getParameter("input"+counter);
                if (userinput.equals(answer))
                    gain_marks++;
                total_marks++;
              }
            else{
                    userinput =  request.getParameter("input"+counter);
              }
            sql += "'"+ userinput + "' ,";
            counter++;  
          }
      
        sql += "'"+gain_marks+"')";
      // sql = sql.substring(0,sql.length()-1);    
      // sql+=")";
       stm.execute(sql);
       pageContext.setAttribute("gain_marks", gain_marks);
       pageContext.setAttribute("total_marks", total_marks);
     %>
     
</c:catch>

<c:out value="${e}" />

<c:if test="${error==null}">
    
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>survey.com form response page</title>
        <link rel="icon" href="icon.png"   type="image/png">
         <meta charset="utf-8">
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
            
            .mid{
                width:100%;
                height:500px;
              }
              .response{
                  font-size:20px;
              }
              @media only screen and (min-width:720px){
                  response{
                      font-size:35px;
                  }
                  .mid{
                      height:700px;
                  }
              }    
              
        </style>
    </head>
    <body>
        <div class="mid  d-flex justify-content-center bg-light" >
            <div class="align-self-center p-3 p-sm-5 response text-center border border-success text-success">
                <i class="fa fa-check-circle" style="font-size:35px"></i><br>
                <span>Your response has been recorded</span><br>
                <h5>marks : ${gain_marks}/${total_marks}</h5><br>
           </div>
        </div> 
      </body>
</html>
</c:if>