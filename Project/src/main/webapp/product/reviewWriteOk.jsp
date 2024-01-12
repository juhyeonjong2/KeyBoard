<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="ateam.db.DBManager" %>
<%@ page import="allkeyboard.vo.*" %>
<%@ page import="java.util.*" %>
<%
	request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id ="review" class="allkeyboard.vo.Review" />
<jsp:setProperty property="*" name="review" />
<%
	
	String pno = request.getParameter("product");
	int pno2=0;
	if(pno != null && !pno.equals("")){
		pno2 = Integer.parseInt(pno);
	}
	System.out.println()

	Member member = (Member)session.getAttribute("login");
	if(member != null){
		review.setMno(member.getMno());
		
		DBManager db = new DBManager(); 

		 if(db.connect()){
			 
			 String sql = " INSERT INTO review( "
					    + "   pno "
					    + " , mno "
					    + " , rnote "
					    + " , rwritedate ) VALUES( "
			    		+ "   ?"
			    		+ " , ?"
			    		+ " , ?"
			    		+ " , now()) ";
			 
			db.prepare(sql);
			db.setInt(pno2); //pno값을 받아야 오류가 해결
			db.setInt(member.getMno());
			db.setString(review.getRnote());
	 		System.out.println(review.getPno());/////////////////
	 		System.out.println(member.getMno());////////////////////
	 		System.out.println(review.getRnote());////////////////
	 		System.out.println(sql);////////////////////
			int count = db.update();
			System.out.println(count);/////////////////
			if(count > 0 ){
								
			/*
			 댓글이 등록된 후에는 rno를 따로 가지고 있지 않기 때문에
			 현재 삭제버튼에 제공되고 있는 rno 값은 객체의 초기값 0이 전달되고 있다.
			 
			 정상 작동을 위하여 현재 등록된 댓글의 pk값을 가져와 reply객체 rno 필드에
			 값을 추가하는 로직이 필요하다.
			
			*/
			
			db.disconnect(); //만약 위 구문이 실행 된다면 닫고 다시 열어서 작업함
			int rno=0;
			if(db.connect()){
				System.out.println("연결 완료");
				sql = "select max(rno) as rno from review";
				if( db.prepare(sql).read()){

					 if(db.getNext()){
						 rno = db.getInt("rno");
						}
					 
					 db.disconnect(); 
			}		System.out.println(rno);
%>
			<div class="reviewRow">
                <div id="idBox"><%=member.getMname()%></div>
                <textarea class="reviewarea"><%=review.getRnote()%></textarea> 
                <div id="review_modifyBox">
                    <button class="reviewBt" onclick="modifyFn(this,<%=rno%>)">수정</button> 
                    <button class="reviewBt" onclick="replyDelFn(<%=rno%>,this)">삭제</button>
                </div>
			</div>
<%
		}else{
			out.print("FAIL");
		}
			
			
				db.disconnect();
			}
		 }
		 }
		
%>