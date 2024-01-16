<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="allkeyboard.vo.BuyItem" %>
<%@ page import="allkeyboard.vo.Member" %>
<%@ page import="allkeyboard.util.CertHelper" %>
<%@ page import="ateam.db.DBManager" %>

<%
	request.setCharacterEncoding("UTF-8");
	
	String method = request.getMethod();
	// 요청이 GET이거나, pno, quantity 둘중 한개라도 없으면 fail
	/* if(method.equals("GET"))
	{
		out.print("FAIL");
	}
	else { */


		// 회원인경우, 비회원인경우 넘어오는 파라메터가 다름.
	
		boolean isMember = false; 
		//1. 로그인 정보 확인
		Member member = (Member)session.getAttribute("login");
		if(member != null && !CertHelper.isExpired(member.getMno(), member.getToken()))
		{ 
			isMember = true;
		}
		
		// 일단 가능한모든 데이터 수집
		String agree_chk_1 = request.getParameter("agree_chk_1"); // 회원인경우 null
		String agree_chk_2 = request.getParameter("agree_chk_2"); // 회원인경우 null
		String order_name = request.getParameter("order_name");
		String order_tell = request.getParameter("order_tell");
		String order_phone = request.getParameter("order_phone");
		String order_email = request.getParameter("order_email");
		String shiping_radio_chk = request.getParameter("shiping_radio_chk");
		String shiping_name = request.getParameter("shiping_name");
		String delivery_loc = request.getParameter("delivery_loc");
		String shiping_tell = request.getParameter("shiping_tell");
		String shiping_phone = request.getParameter("shiping_phone");
		String shiping_memo = request.getParameter("shiping_memo");
		String payment_method_type = request.getParameter("payment_method_type");
		String payment_type1_name = request.getParameter("payment_type1_name");
		String payment_type1_bank = request.getParameter("payment_type1_bank");
		String payment_agree_chk_1 = request.getParameter("payment_agree_chk_1");
		
		System.out.println(agree_chk_1);
		System.out.println(agree_chk_2);
		System.out.println(order_name);
		System.out.println(order_tell);
		System.out.println(order_phone);
		System.out.println(order_email);
		System.out.println(shiping_radio_chk);
		System.out.println(shiping_name);
		System.out.println(delivery_loc);
		System.out.println(shiping_tell);
		System.out.println(shiping_phone);
		System.out.println(shiping_memo);
		System.out.println(payment_method_type);
		System.out.println(payment_type1_name);
		System.out.println(payment_type1_bank);
		System.out.println(payment_agree_chk_1);
		
		
		
		
		if(isMember){ // 회원
			
		} else { // 비회원
			
		}
	
	//}
	
%>