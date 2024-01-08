<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	
	String mid = request.getParameter("mid");

	Connection conn = null;
	PreparedStatement psmt= null;
	ResultSet rs = null;
	String url = "jdbc:mysql://localhost:3306/allkeyboard";
	String user = "keytester";
	String pass = "1234";
	
	try{
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = "select count(*) as cnt from member where mid = ?";
		
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, mid);
		
		rs = psmt.executeQuery();
		
		int cnt = 1;
		
		
		if(rs.next()){
			cnt = rs.getInt("cnt");
		}
		
		 out.print(cnt);
		 
		 
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null) conn.close();
		if(psmt != null) psmt.close();
		if(rs != null) rs.close();
	}

%>
		