
<%@page import="com.opencsv.CSVWriter"%>
<%@page import="java.io.FileWriter"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.sql.Date"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="org.json.simple.JSONValue"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 


<%!

// function to generateg formId randomly;

public String getFormId(){
    
    String str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    String id="";
   
    
    for(int i=0;i<12; i++){
       int index = (int)(Math.random()*30+5);
        id += str.substring(index, index+1);
    }
        return id ;
}

%>

<c:catch var="e">

<%
   
    String objects[] = request.getParameter("data").split(";");
    JSONObject settings = (JSONObject)JSONValue.parse(request.getParameter("setting"));
    String fid = request.getParameter("fid");
    boolean change_tracker = Boolean.valueOf(request.getParameter("change_tracker"));
    String message = "";
    
   List<JSONObject> json_object_list = new ArrayList();
    for(String obj : objects){
          Object   java_obj  = (Object)JSONValue.parse(obj);
          json_object_list.add((JSONObject)java_obj);
    }
    List<String> header  = new ArrayList<String>();
    Connection conn =  (Connection)application.getAttribute("conn");
    PreparedStatement ps;
    
    if (fid==null){
        
         fid = getFormId();
         String href_val = "viewform.jsp?id="+fid;
         message = "Your form is created successfully and you can use this using following link : <a href="+href_val+">"+href_val+"</a>";
    
          ps = (PreparedStatement)conn.prepareStatement("insert into form_data values(?,?,?,?,?,?,?,?,?,?)");
         Calendar sc = Calendar.getInstance();
         ps.setString(1,fid);
         ps.setString(2,(String)session.getAttribute("email"));
         ps.setString(3,(String)settings.get("title"));
         ps.setString(4,(String)settings.get("background"));
         ps.setString(5,(String)settings.get("border"));
         ps.setString(6,(String)settings.get("font"));
         ps.setString(7,sc.getTime().toString());
         ps.setString(8,"true");
         ps.setBoolean(9,false);
         ps.setString(10,"survey");
         int success = ps.executeUpdate();
         if(success==0)
            out.print("error in form_data table");
         
           Statement st = conn.createStatement();
           String sql = "create table form_metadata_"+fid+"(type varchar(20),label varchar(90),value varchar(90),optimality varchar(5))";
           st.executeUpdate(sql);
           ps = conn.prepareStatement("insert into form_metadata_"+fid+"  values(?,?,?,?)");
           sql = "create table form_data_" + fid+"(";
          for (int i=0;i<json_object_list.size();i++)
           {
               JSONObject json_obj = json_object_list.get(i);
               ps.setString(1,(String)json_obj.get("type"));
               ps.setString(2,(String)json_obj.get("label"));
               sql +="`" + (String)json_obj.get("label") + "` varchar(100) ,";
               ps.setString(3,(String)json_obj.get("value"));
               ps.setString(4,(String)json_obj.get("optimality"));
               header.add((String)json_obj.get("label"));
               ps.addBatch();
          }
    
           sql = sql.substring(0,sql.length()-1);
           sql += ")";
           int result[] = ps.executeBatch();
           st.executeUpdate(sql); 
    }
    else
    {
         ps = conn.prepareStatement("update form_data set title = ?,background=?,font_style = ?,border = ? where form_id = ? ");
         ps.setString(1, (String)settings.get("title"));
         ps.setString(2,(String)settings.get("background"));
         ps.setString(3,(String)settings.get("font"));
         ps.setString(4,(String)settings.get("border"));
         ps.setString(5,fid);
         ps.executeUpdate();
         
         if (change_tracker == true){
               ps = conn.prepareStatement("drop table form_metadata_"+fid.toLowerCase());
               ps.executeUpdate();
               ps = conn.prepareStatement("drop table form_data_"+fid.toLowerCase());
               ps.executeUpdate();
  
              Statement st = conn.createStatement();
              String sql = "create table form_metadata_"+fid+"(type varchar(20),label varchar(90),value varchar(90),optimality varchar(5))";
              st.executeUpdate(sql);
              ps = conn.prepareStatement("insert into form_metadata_"+fid+"  values(?,?,?,?)");
             sql = "create table form_data_" + fid+"(";
             for (int i=0;i<json_object_list.size();i++)
              {
                 JSONObject json_obj = json_object_list.get(i);
                 ps.setString(1,(String)json_obj.get("type"));
                 ps.setString(2,(String)json_obj.get("label"));
                sql +="`" + (String)json_obj.get("label") + "` varchar(100) ,";
                ps.setString(3,(String)json_obj.get("value"));
                ps.setString(4,(String)json_obj.get("optimality"));
                header.add((String)json_obj.get("label"));
                ps.addBatch();
           }
    
           sql = sql.substring(0,sql.length()-1);
           sql += ")";
           int result[] = ps.executeBatch();
           st.executeUpdate(sql);
         }   
           message = "! your form is edited successfully ";
    }
   
       
   
    //returning link for form view
    
    out.print(message+"->"+change_tracker);
    
  %>
</c:catch>
<c:out value="${e}" />