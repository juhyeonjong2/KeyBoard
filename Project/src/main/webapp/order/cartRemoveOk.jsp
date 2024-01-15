<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="allkeyboard.vo.Member" %>
<%@ page import="allkeyboard.vo.BuyItem" %>
<%@ page import="allkeyboard.util.CertHelper" %>
<%@ page import="ateam.db.DBManager" %>

<%

	request.setCharacterEncoding("UTF-8");
	
	String pnoParam = request.getParameter("pno");
	String method = request.getMethod();
	// 요청이 GET이거나, pno, quantity 둘중 한개라도 없으면 fail
	if(method.equals("GET") || pnoParam == null || pnoParam.equals(""))
	{
		out.print("FAIL");
	}
	else 
	{
		int pno=0;
		if(pnoParam != null  && !pnoParam.equals("")){
			pno = Integer.parseInt(pnoParam);
		}
		
		Member member = (Member)session.getAttribute("login");
		if(member != null && !CertHelper.isExpired(member.getMno(), member.getToken()))
		{ // 회원 갱신 (디비)
			DBManager db = new DBManager();
			if(db.connect()){
				
				String sql = "DELETE FROM cart WHERE mmo=? AND pno=?";
				
				db.prepare(sql)
				  .setInt(member.getMno())
				  .setInt(pno)
				  .update();
				
				db.disconnect();
			}
		} 
		// 회원 비회원 공통 갱신 (세션)
		ArrayList<BuyItem> cartItemList = (ArrayList<BuyItem>)session.getAttribute("cartList");
		// 세션
		int size = cartItemList.size();
		System.out.println("---------------- before ---------------- ");
		for(int i=0;i<size;i++){
			BuyItem item = cartItemList.get(i);
			System.out.println("item[" + i +"] pno:" + item.getPno() + " quantity:" + item.getQuantity() + " price:" + item.getPrice());
		}
		
		//세션 장바구니 데이터를 순회하며 pno를 찾아서 index 저장
		int removeTarget = -1;
		for(int i=0;i<size;i++){
			BuyItem item = cartItemList.get(i);
			if(item.getPno() == pno){
				removeTarget = i;
			}
		}
		// 저장된 인덱스를 통해 아이템 삭제
		if(removeTarget != -1){
			cartItemList.remove(removeTarget);
		}
		
		System.out.println("---------------- After ---------------- ");
		size = cartItemList.size();
		for(int i=0;i<size;i++){
			BuyItem item = cartItemList.get(i);
			System.out.println("item[" + i +"] pno:" + item.getPno() + " quantity:" + item.getQuantity() + " price:" + item.getPrice());
		}
		
		// 변경된 리스트 세션에 덮어쓰기
		session.setAttribute("cartList", cartItemList);
		
		out.print("SUCCESS");
	}
%>