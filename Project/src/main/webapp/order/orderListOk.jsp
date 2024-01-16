<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.*"%>
<%@ page import="org.json.simple.parser.*"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="allkeyboard.vo.BuyItem" %>
<%@ page import="allkeyboard.vo.Member" %>
<%@ page import="allkeyboard.util.CertHelper" %>
<%@ page import="ateam.db.DBManager" %>

<%
	request.setCharacterEncoding("UTF-8");
	boolean isError = false;
	boolean isLogin = false; // 로그인 또는 비회원구매 확인
	
	//1. 로그인 정보 확인
	Member member = (Member)session.getAttribute("login");
	String nonMemberPurchase = (String)session.getAttribute("NMP"); // none member purchase
	if((member != null && !CertHelper.isExpired(member.getMno(), member.getToken())) // 로그인했거나. 
		|| (nonMemberPurchase != null && nonMemberPurchase.equals("y")))  // 비회원 구매 확인한경우.
	{ 
		isLogin = true;
	}
	
	String json = request.getParameter("paramList").toString();
	//System.out.println(json);
	
	// 2. 넘어온 데이터 파싱해서 목록만들기.
	ArrayList<BuyItem> parameterList =new ArrayList<BuyItem>();
	JSONParser parser = new JSONParser();
	try{
    	JSONArray jsonArray = (JSONArray)parser.parse(json);
    	
    	for(Object obj : jsonArray){
    		JSONObject jsonObj = (JSONObject)obj;
    		//System.out.println("pno : " + jsonObj.get("pno"));
    		//System.out.println("quantity : " + jsonObj.get("quantity"));
    		
    		int pno = Integer.parseInt(jsonObj.get("pno").toString());
    		int quantity = Integer.parseInt(jsonObj.get("quantity").toString());
    		parameterList.add(new BuyItem(pno, quantity));
    	}
        
	} catch (Exception e){
		e.printStackTrace();
		isError = true;
		
	}
	
	if(!isError)
	{
		// 3. Price 정보 기록하기 
	    // 목록을 순회하면서 price 설정. (DB 엑세스) 
		DBManager db = new DBManager();
		if(db.connect()){
			
			String sql = "SELECT price FROM product WHERE pno=?";
			for(BuyItem item : parameterList){
				if(db.prepare(sql).setInt(item.getPno()).read()){
					if(db.getNext()){
						item.setPrice(db.getInt("price"));		
					}
					else{
						// 디비에 내용이 없으면 오류임.
						isError= true;
						break;
					}
				}
			}
			
			db.disconnect();
		}
	}
	
	if(!isError)
	{
		// 4. 세션에 저장하기
		//구매 목록도 기본적으로 세션에 담겨있음. (회원인경우에도 orderList 정보는 저정하지 않고 주문완료후 주문정보만 저장함.)
		ArrayList<BuyItem> orderItemList = (ArrayList<BuyItem>)session.getAttribute("orderList");
		// 기존 데이터가 있었어도 덮어씌움.
		orderItemList = parameterList; 
		// 세션에 저장.	
		session.setAttribute("orderList", orderItemList);
	}
	
	
	
	// 5. 결과 반환.
	if(isError){ // 에러인경우.
		out.print("FAIL");
	} else {
		if(isLogin){ //에러 X, 로그인상태
			out.print("SUCCESS");
		}
		else { // 에러 X, 비로그인 상태(비회원구매 동의도 X)
			out.print("SUCCESS_LOGIN"); // 세션에 비회원 구매 확인, 로그인시 해당 플래그 제거.
		}
	}
	
%>