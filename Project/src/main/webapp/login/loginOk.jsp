<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="ateam.db.DBManager" %>
<%@ page import="allkeyboard.vo.Member" %>
<%@ page import="java.sql.*" %>
<%
	request.setCharacterEncoding("UTF-8"); //인코딩
	
	String mid = request.getParameter("mid");
	String mpw = request.getParameter("mpw");
	

	DBManager db = new DBManager(); 

	 if(db.connect())
	{
		 String sql = "SELECT mid, mname, mno FROM member WHERE mid=? AND mpw= md5(?)";
		db.prepare(sql);
		db.setString(mid);
		db.setString(mpw);
		
		 boolean count = db.read();
			if(count)
			{
				%>
					<script>
						alert("로그인 성공");
						location.href="<%=request.getContextPath()%>"
					</script>
				<%
						Member member = new Member();
						member.setMno(db.getInt("mno"));
						member.setMid(db.getString("mid"));
						member.setMname(db.getString("mname"));
						
						session.setAttribute("login",member);
						System.out.println(db.getString("mname"));
			}else{
				%>
				<script>
					alert("로그인 실패하였습니다.");
					location.href="<%=request.getContextPath()%>"
				</script>
				<%
			}

			
			db.disconnect();
		}
		
		
%>
