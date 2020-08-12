
<%@page import="java.sql.ResultSetMetaData"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Scanner"%>
<%@page import="java.io.File"%>
<%@page import="java.util.List"%>
<%@page import="com.opencsv.CSVReader"%>
<%@page import="java.io.FileReader"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%> 

<c:catch var="e">
    
<%
    
    String fid   = request.getParameter("id").trim();
    String title  = request.getParameter("title").trim();
    String type = request.getParameter("type").trim();
    String word;
    List< List<String>> content = new ArrayList<List<String>>();
    List<String> header = new ArrayList<String>();
    Connection conn = (Connection)application.getAttribute("conn");
    
    if(type.equals("survey")){
   
             ResultSet rs = conn.createStatement().executeQuery("select * from form_data_"+fid);
             ResultSetMetaData rsmd = rs.getMetaData();
            for (int i=1;i<=rsmd.getColumnCount();i++)
                    header.add(rsmd.getColumnName(i));
             while (rs.next()){
                     List<String> temp = new ArrayList<String>();
                     for (int i=1;i<=rsmd.getColumnCount();i++)
                            temp.add(rs.getString(i));   
                     content.add(temp);
              }
         }
    else{
             ResultSet rs = conn.createStatement().executeQuery("select * from quizze_data_"+fid);
             ResultSetMetaData rsmd = rs.getMetaData();
             for (int i=1;i<=rsmd.getColumnCount();i++)
                    header.add(rsmd.getColumnName(i));
              while (rs.next()){
                     List<String> temp = new ArrayList<String>();
                     for (int i=1;i<=rsmd.getColumnCount();i++)
                            temp.add(rs.getString(i));   
                     content.add(temp);
              }
       }
   pageContext.setAttribute("table_header",header);
   pageContext.setAttribute("content",content);
   pageContext.setAttribute("title",title);
   
%>

</c:catch>
<c:out value="${e}" />
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Table view</title>
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
   font-family:Trocchi;
  }
  header{
      font-size:25px;
  }
  .bg-teal{
      background:#30949d;
  }
  
   </style>
    </head>
    <body>
        <div class="container">
            <header class="text-center bg-teal text-white p-3">${title}</header>
        <table class="table table-borderd table-stripped">
            <tr>
                <c:forEach var="v"  items="${table_header}">
                     <td>${v}</td>
                </c:forEach>
            </tr>    
            <c:forEach var="row"  items="${content}">
                <tr>
                    <c:forEach var="v" items="${row}">
                         <td>${v}</td>
                    </c:forEach>
                 </tr>
             </c:forEach>
           </table>
        </div> 
     </body>
</html>
