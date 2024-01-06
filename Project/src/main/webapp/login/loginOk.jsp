<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="ateam.db.DBManager" %>
<%@ page import="allkeyboard.vo.Member" %>
<%@ page import="java.sql.*" %>
<%
	request.setCharacterEncoding("UTF-8"); //인코딩
	
	String mid = request.getParameter("mid");
	String mpw = request.getParameter("mpw");
	
	Connection conn = null;
	PreparedStatement psmt= null;
	ResultSet rs = null;
	String url = "jdbc:mysql://localhost:3306/allkeyboard";
	String user = "keytester";
	String pass = "1234";
	
	boolean Login = false;
	
	try{
		
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(url,user,pass);
		System.out.println("연결됨");
		String sql = "SELECT mid   "
				+"      ,mname "
				+"      ,mno   " 
			 	+"  FROM member"
				+" WHERE mid=? "
			 	+"   AND mpw= md5(?)";
		
		psmt = conn.prepareStatement(sql);
		
		psmt.setString(1,mid);
		psmt.setString(2,mpw);
		
		rs = psmt.executeQuery();
		if(rs.next()) Login = true;
		
		
		if(Login){ //여기가 트루여도 실행 안됨 그래서 일단 이렇게 변경
		System.out.println(1);
			Member member = new Member();
			member.setMno(rs.getInt("mno"));
			member.setMid(rs.getString("mid"));
			member.setMname(rs.getString("mname"));
			member.setMid(rs.getString("mid"));
			member.setMname(rs.getString("mname"));
			
			
			session.setAttribute("login",member); //프린트해보니 섹션은 들어감
			}
	}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(conn != null) conn.close();
			if(psmt != null) psmt.close();
			if(rs != null) rs.close();
		}
	
	
	
		if(Login){ //여기 트루일 경우의 링크가 잘 안됨 그래서 테스트로 일단 이동
			%>
				<script>
					alert("로그인 되었습니다");
					location.href="<%=request.getContextPath()%>/login/test.jsp";
				</script>
			<%
			}else{
				%>
				<script>
					alert("아이디와 비밀번호를 확인하세요.");
					location.href="<%=request.getContextPath()%>/login/login.jsp";
				</script>
			<%
			}
			
		%>
	
	
