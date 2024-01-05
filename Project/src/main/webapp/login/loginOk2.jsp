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

		String sql = "SELECT mid, mname, mno FROM member WHERE mid=? AND mpw= md5(?)"; //md5 넣으면 로그인이 안됨 아마 db에 md5안 넣어서 인듯함
		
		psmt = conn.prepareStatement(sql);
		
		psmt.setString(1,mid);
		psmt.setString(2,mpw);
		
		rs = psmt.executeQuery();
		System.out.println(mpw);
		System.out.println(mid);
		System.out.println(rs.next());
		
		if(rs.next()){ //여기가 트루여도 실행 안됨;;;
			Member member = new Member();
			member.setMno(rs.getInt("mno"));
			member.setMid(rs.getString("mid"));
			member.setMname(rs.getString("mname"));
			
			session.setAttribute("login",member);
			Login = true;
			System.out.println(Login); 
			System.out.println(1);
			}
	}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(conn != null) conn.close();
			if(psmt != null) psmt.close();
			if(rs != null) rs.close();
		}
		System.out.println(Login);
	
		if(Login == false){
			%>
				<script>
					alert("아이디와 비밀번호를 확인하세요.");
					location.href="<%=request.getContextPath()%>/login/login.jsp";
				</script>
			<%
			}else if(Login){
			%>
				<script>
					alert("로그인 되었습니다");
					location.href="<%=request.getContextPath()%>;
				</script>
			<%
			}
			
		%>
	
	
	
	
<%-- 	DBManager db = new DBManager(); 

	 if(db.connect())
	{
		String sql = "SELECT mid, mname, mno FROM member WHERE mid=? AND mpw= md5(?)";
		
		db.prepare(sql);
		db.setString(mid);
		db.setString(mpw);
		
		boolean count =	db.read();
		
		if(count)
		{
			%>
				<script>
					alert("로그인 되었습니다.");
					location.href="<%=request.getContextPath()%>/login/test.jsp"
				</script>
			<%
				Member member = new Member();
				member.setMno(db.getInt("mno"));
				member.setMid(db.getString("mid"));
				member.setMname(db.getString("mname"));
				session.setAttribute("login",member);
				System.out.println(count.getString(mid));
			%>
			<%
		}else{
			%>
			<script>
				alert("로그인에 실패하였습니다.");
				location.href="<%=request.getContextPath()%>"
			</script>
			<%
		}
		
		db.disconnect();
	}
%> --%>
