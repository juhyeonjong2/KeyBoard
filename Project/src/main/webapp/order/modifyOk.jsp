<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="allkeyboard.vo.OrderResultItem" %>
<%@ page import="allkeyboard.vo.Order" %>
<%@ page import="allkeyboard.vo.Member" %>
<%@ page import="allkeyboard.util.CertHelper" %>
<%@ page import="ateam.db.DBManager" %>

<%
	request.setCharacterEncoding("UTF-8");
	
	Member member = (Member)session.getAttribute("login"); // 관리자 검사를위한 세션 들고오기.
	boolean isAdmin = false;
	if(member != null){
		isAdmin = CertHelper.isAdmin(member.getMno(), member.getToken());
	}
	
	if( !isAdmin){
		out.print("FAIL");
	}
	else 
	{
		String onoParam = request.getParameter("ono");
		String state = request.getParameter("state");
		
		int ono=0;
		if(onoParam!= null && !onoParam.equals(""))
		{
			ono = Integer.parseInt(onoParam);
		}
		
		boolean isSuccess = false;
		
		DBManager db = new DBManager();
		if(db.connect()){
			
			String sql = "UPDATE orders SET state=? WHERE ono=?";
			
			if(db.prepare(sql).setString(state).setInt(ono).update() >0 ){
				isSuccess = true;
			}
			db.disconnect();	
		}
		
		if(isSuccess){
			out.print("SUCCESS");
		}
		else {
			out.print("FAIL");
		}
	}
	
%>