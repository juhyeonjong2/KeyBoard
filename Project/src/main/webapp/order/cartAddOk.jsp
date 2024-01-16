<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.ArrayList" %>
<%@ page import="allkeyboard.vo.Member" %>
<%@ page import="allkeyboard.vo.BuyItem" %>
<%@ page import="allkeyboard.util.CertHelper" %>
<%@ page import="ateam.db.DBManager" %>

<%

	request.setCharacterEncoding("UTF-8");
	
	String pnoParam = request.getParameter("pno");
	String quantityParam = request.getParameter("quantity");
	String method = request.getMethod();


	// 요청이 GET이거나, pno, quantity 둘중 한개라도 없으면 fail
	if(method.equals("GET") || pnoParam == null || pnoParam.equals("") ||  quantityParam == null || quantityParam.equals(""))
	{
		out.print("FAIL");
	}
	else 
	{
		int pno=0;
		if(pnoParam != null  && !pnoParam.equals("")){
			pno = Integer.parseInt(pnoParam);
		}
		
		int quantity = 0;
		if(quantityParam != null  && !quantityParam.equals("")){
			quantity = Integer.parseInt(quantityParam);
		}
		
		// DB에 연결해서 상품의 가격을 가져온다.
		int price = 0;
		DBManager db = new DBManager();
		if(db.connect()){
			
			// 1. 상품의 가격 가져오기.
			String sql = "SELECT price FROM product WHERE pno=?";
			if(db.prepare(sql).setInt(pno).read())
			{
				if(db.getNext()){
					price = db.getInt("price");
				}
			}
			
			db.disconnect();
		}
		
		// 상품의 가격이 0이라면 없는 상품.
		if(price == 0)
		{
			out.print("FAIL");
		}
		else 
		{

			Member member = (Member)session.getAttribute("login");
			if(member != null && !CertHelper.isExpired(member.getMno(), member.getToken()))
			{ // 회원 갱신 (디비)
				//DBManager db = new DBManager();
				if(db.connect()){ // db reconnect
					
					// 이미 들고있는지 확인
					String sql = "SELECT mno, pno, quantity FROM cart WHERE mno=? AND pno=?";
					
					int alreadyQuantity = 0; //이미 있다
					if(db.prepare(sql).setInt(member.getMno()).setInt(pno).read())
					{
						if(db.getNext()){
							alreadyQuantity = db.getInt("quantity");
						}
					}
					
					
					if(alreadyQuantity == 0){ // Insert
						sql = "INSERT INTO cart(mno, pno, quantity) VALUES (?, ?, ?)";
						db.prepare(sql).setInt(member.getMno()).setInt(pno).setInt(quantity).update();
					}
					else { // Update
						sql = "UDPATE cart SET quantity=? WHERE mno=? AND pno=?";
						db.prepare(sql).setInt(alreadyQuantity+quantity).setInt(member.getMno()).setInt(pno).update();
					}
					
					db.disconnect();
				}
			} 
			
			// 회원 비회원 공통 갱신 (세션)
			ArrayList<BuyItem> cartItemList = (ArrayList<BuyItem>)session.getAttribute("cartList");
			
			// 데이터가 있을수 있으므로 세션에서 검색해봄. (세션에 데이터가 없음. - ws comment 회원인경우 로그인시에 세션에 채워야한다.)
			if(cartItemList == null)
			{ // 데이터 없음. 생성필요
				cartItemList = new ArrayList<BuyItem>();
				
				BuyItem newItem = new BuyItem(pno,quantity);
				newItem.setPrice(price);
				
				cartItemList.add(newItem);
			}
			else {
				// 데이터 있음 검색해서 수정하거나 추가.
				// 세션
				int size = cartItemList.size();
				/* System.out.println("---------------- before ---------------- ");
				for(int i=0;i<size;i++){
					BuyItem item = cartItemList.get(i);
					System.out.println("item[" + i +"] pno:" + item.getPno() + " quantity:" + item.getQuantity() + " price:" + item.getPrice());
				} */
				
				//세션 장바구니 데이터를 순회하며 pno를 찾음
				for(int i=0;i<size;i++){
					BuyItem item = cartItemList.get(i);
					if(item.getPno() == pno){
						// 찾았으면 갯수 증가.
						item.setQuantity(item.getQuantity()+quantity);
						item.setPrice(price); // 가격 갱신
					}
				}
				
			/* 	System.out.println("---------------- After ---------------- ");
				size = cartItemList.size();
				for(int i=0;i<size;i++){
					BuyItem item = cartItemList.get(i);
					System.out.println("item[" + i +"] pno:" + item.getPno() + " quantity:" + item.getQuantity() + " price:" + item.getPrice());
				} */
			}
			// 변경된 리스트 세션에 덮어쓰기
			session.setAttribute("cartList", cartItemList);
			out.print("SUCCESS");	
		}
	}
%>