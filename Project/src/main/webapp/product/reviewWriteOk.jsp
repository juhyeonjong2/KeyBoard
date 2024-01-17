<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="ateam.db.DBManager" %>
<%@ page import="allkeyboard.vo.*" %>
<%@ page import="java.util.*" %>
<%
	request.setCharacterEncoding("UTF-8"); //여기서 배열속에다가 리뷰 객체 집어넣고 뽑아내는 작업 해야함
%>
<jsp:useBean id ="review" class="allkeyboard.vo.Review" />
<jsp:setProperty property="*" name="review" />
<%

	String rnote = request.getParameter("rnote");	

	String pno = request.getParameter("pno");
	int pno2=0;
	if(pno != null && !pno.equals("")){
		pno2 = Integer.parseInt(pno);
	}

	System.out.println(pno2);
	
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
			db.setInt(pno2); //pno가 db에 존재하는 값과 일치할 경우 오류해결 지금 문제는 pno값이 0이 나온다는 것 일단 1로 수정
			db.setInt(review.getMno()); 
			db.setString(rnote); 
			int count = db.update();
			if(count > 0 ){
								
			/*
			 댓글이 등록된 후에는 rno를 따로 가지고 있지 않기 때문에
			 현재 삭제버튼에 제공되고 있는 rno 값은 객체의 초기값 0이 전달되고 있다.
			 
			 정상 작동을 위하여 현재 등록된 댓글의 pk값을 가져와 review객체 rno 필드에
			 값을 추가하는 로직이 필요하다.
			
			*/
			
			int rno=0;
			sql = "select max(rno) as rno from review";
			if( db.prepare(sql).read()){

					if(db.getNext()){
						rno = db.getInt("rno");
					}
					 
			} //db.prepare(sql).read()
			System.out.println(rno); //1234순이 아니고 이상하게 적힘
%>
			<script>
				alert("후기가 작성되었습니다.");
				location.href="<%=request.getContextPath()%>/product/view.jsp?pno=<%=pno2%>";
			</script>	
<%
		}else{
			%>
			<script>
				alert("후기 작성에 실패하였습니다.");
				location.href="<%=request.getContextPath()%>/login/test.jsp";
			</script>
			<%
		}
			
			
				db.disconnect();
			} // db연거 
		 } // member이 널이 아닐떄 한거
		 
		
%>