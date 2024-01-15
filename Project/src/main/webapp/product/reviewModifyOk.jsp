<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="ateam.db.DBManager" %>
<%@ page import="allkeyboard.vo.Member" %>
<%
	request.setCharacterEncoding("UTF-8");
	Member member = (Member)session.getAttribute("login");
	

	String rnote = request.getParameter("rnote");
	String rnoParam = request.getParameter("rno");
	
	
	
	int rno = 0;
	if(rnoParam != null && !rnoParam.equals("")){
		rno = Integer.parseInt(rnoParam);
	}
	
		
		DBManager db = new DBManager();

			if(db.connect())
			{	
				 String sql =  " UPDATE review "
						    + "  SET rnote = ? "
						    + "  WHERE rno = ? AND mno = ?";
					 	 db.prepare(sql);
				 		 db.setString(rnote);
				 		 db.setInt(rno);
				 		 db.setInt(member.getMno());
				 		 System.out.println(rnote);
				 		 System.out.println(rno);
				 		
				 		int count = db.update();
				
				if(count > 0){
					out.print("SUCCESS");
				}else{
					out.print("FAIL");
				}
				db.disconnect();
			}
		
%>