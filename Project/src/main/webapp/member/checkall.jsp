<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="ateam.db.DBManager" %>
<%
	String mid = request.getParameter("mid");
	String mpw = request.getParameter("mpw");
	
	String mno = request.getParameter("mno");
	int mno2=0;
	if(mno != null && !mno.equals("")){
		mno2 = Integer.parseInt(mno);
	}
	
	DBManager db = new DBManager(); 
	
	if(db.connect()){ //member에 나의 mno 내가적은 mid, mpw가 전부 일치하는 값이 있을 경우 1 반환 (그 이상이면 중복아이디 있는것)
		String sql = "select count(*) as cnt from member where mno = ? and mid = ? and mpw = md5(?)" ;
		 
		int cnt = 0;

			 if( db.prepare(sql).setInt(mno2).setString(mid).setString(mpw).read()) //sql문 실행후 값이 있다면 트루반환
			 {
				 if(db.getNext()) //sql문을 next로 이곳으로 가져와줌 (DBManager.java)
				 {
					 cnt = db.getInt("cnt");
				 }
			 }
		 out.print(cnt);
		 
		
		 
		 db.disconnect();
	}
		
%>