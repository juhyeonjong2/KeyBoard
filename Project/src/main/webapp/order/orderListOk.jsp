<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.*"%>
<%@ page import="org.json.simple.parser.*"%>


<%

	request.setCharacterEncoding("UTF-8");
	
	
	String json = request.getParameter("paramList").toString();
	System.out.println(json);
	
	/* // json 파싱
	 ArrayList<Integer> checkedFruitList = new ArrayList<>();
        JSONParser parser = new JSONParser();
        JSONArray arr =  (JSONArray) parser.parse(param);
        checkedFruitList = arr;
        this.checkedFruitList = checkedFruitList; */
	
	JSONParser parser = new JSONParser();
	try{
    	JSONArray jsonArray = (JSONArray)parser.parse(json);
    	
    	for(Object obj : jsonArray){
    		JSONObject jsonObj = (JSONObject)obj;
    		System.out.println("pno : " + jsonObj.get("pno"));
    		System.out.println("quantity : " + jsonObj.get("quantity"));
    		
    		// ws comment - 여기 처리 작업중
    	}
        
	} catch (Exception e){
		e.printStackTrace();
	}
        
	
	
%>