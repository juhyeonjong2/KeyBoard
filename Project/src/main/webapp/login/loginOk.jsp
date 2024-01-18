<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="ateam.db.DBManager" %>
<%@ page import="allkeyboard.util.CertHelper" %>
<%@ page import="allkeyboard.vo.Member" %>
<%
	request.setCharacterEncoding("UTF-8"); //인코딩
	
	String mid = request.getParameter("mid");
	String mpw = request.getParameter("mpw");
	
	boolean isLogin = false;
	Member member = null;
 	DBManager db = new DBManager(); 

	if(db.connect())
	{
		// member 확인
		 String sql = "SELECT mid   "
					+"      ,mname "
					+"      ,mno   " 
				 	+"  FROM member"
					+" WHERE mid=? "
				 	+"   AND mpw= md5(?) AND (delyn is null or delyn = 'n') ";
		 
		 if( db.prepare(sql).setString(mid).setString(mpw).read())
		 {
			 if(db.getNext())
			 {
				member = new Member();
				
				member.setMno(db.getInt("mno"));
				member.setMid(db.getString("mid"));
				member.setMname(db.getString("mname"));
				member.setMid(db.getString("mid"));
				member.setMname(db.getString("mname"));
				
				isLogin = true;
			 }
		 }
		 
		 db.disconnect();
	}
	
	if(isLogin && member!=null){
		// 토큰 추가.
		String token = CertHelper.createToken(member.getMno());
		member.setToken(token);
		
		session.setAttribute("login",member); //프린트해보니 섹션은 들어감
	}
		
	
	// page 처리
	if(isLogin){ //여기 트루일 경우의 링크가 잘 안됨 그래서 테스트로 일단 이동
		%>
			<script>
				alert("로그인 되었습니다");
				location.href="<%=request.getContextPath()%>";
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
	
	
