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
		//member를 지우려면 외래키로 지정된 자식테이블에서부터 지워줘야 한다
		//진짜 지우는게 아니고 delyn에 넣어두고 보이는것만 안보이게 하는거 였다.
		//update를 사용해 delyn에 값을 변경시키고 삭제 되었다는 문구를 띄움
		//그후 로그인시 delyn이 y면 로그인이 안됨 만약 같은아이디로 회원가입을 (중복확인)한다면 이미 있는 아이디라고 뜨는게 맞다 .
		
		
		//지금 아래 구문도 mysql에서는 잘 작동하고 값도 잘 받아왔지만 실패가뜸;; 
	if(db.connect())
	{	
		 String sql = "UPDATE member SET delyn = 'Y' WHERE mno = ? and mid = ? and mpw = md5(?) ";
		 		 db.setString(sql);
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