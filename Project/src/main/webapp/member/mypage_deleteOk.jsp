<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="ateam.db.DBManager" %>
<%@ page import="allkeyboard.vo.Member" %>
<%
  request.setCharacterEncoding("UTF-8");
  Member member = (Member)session.getAttribute("login");

	String mid = request.getParameter("mid");
	String mpw = request.getParameter("mpw");
	String mno = request.getParameter("mno");
	
	int mno2=0;
	if(mno != null && !mno.equals("")){
		mno2 = Integer.parseInt(mno);
	}
	
	
	DBManager db = new DBManager();
		
		
		//지금 아래 구문이 mysql에서는 잘 작동하고 값도 잘 받아왔지만 실패가뜸;; 
	if(db.connect())
	{	
		 String sql = "UPDATE member SET delyn = 'Y' WHERE mno = ? and mid = ? and mpw = md5(?) ";
			 	 db.prepare(sql);
		 		 db.setInt(mno2);
		 		 db.setString(mid);
		 		 db.setString(mpw);
		 		int count = db.update();
		 		
		 		System.out.println(mno2);
		 		System.out.println(mid);
		 		System.out.println(mpw);
		 		System.out.println(sql);		 		
		 		System.out.println(count);
		 		

		 if(count > 0){
			 %>
				<script>
					alert("회원 탈퇴되었습니다.");
					location.href="<%=request.getContextPath()%>/login/test.jsp"
				</script>
			<%	 
		 }else{
			 %>
				<script>
					alert("회원 탈퇴에 실패했습니다.");
					location.href="<%=request.getContextPath()%>/login/test.jsp"
				</script>
			<%	
		 }
		 db.disconnect();
	}
	
	 
 %>