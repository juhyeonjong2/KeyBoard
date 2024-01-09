<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="ateam.db.DBManager" %>
<%
	
	String mpwnow = request.getParameter("mpwnow");

	String mno = request.getParameter("mno");
	int mno2=0;
	if(mno != null && !mno.equals("")){
		mno2 = Integer.parseInt(mno);
	}

	DBManager db = new DBManager(); 
	
	if(db.connect()){
		String sql = "select count(*) as cnt from member where mno = ? and mpw = md5(?)";  //내 비번이랑 맞아야 해서 mno도 가저와야 할듯
		 
		int cnt = 0;

		if(mpwnow != null && !mpwnow.equals("")){
			 if( db.prepare(sql).setInt(mno2).setString(mpwnow).read())
			 {
				 if(db.getNext())
				 {
					 cnt = db.getInt("cnt");
				 }
			 }
		}
		 out.print(cnt);
		 
		
		 
		 db.disconnect();
	}
		
		
%>