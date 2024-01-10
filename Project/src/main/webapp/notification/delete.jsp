<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="allkeyboard.vo.Member" %>
<%@ page import="allkeyboard.util.CertHelper" %>
<%@ page import="ateam.db.DBManager" %>

<%
	Member member = (Member)session.getAttribute("login"); // 관리자 검사를위한 세션 들고오기.
	String method = request.getMethod();

	// admin 체크
	boolean isAdmin = false; 
	if(member != null){
		isAdmin = CertHelper.isAdmin(member.getMno(), member.getToken());
	}
	
	// Get방식이거나 admin이 아니면 접근 불가.
	if(method.equals("GET") || !isAdmin)
	{
		%>
		<script>
			alert("잘못된 접근입니다.");
			location.href='list.jsp';
		</script>
		<%
		// js 실행은 클라에서 되는거고 서버단에서 먼저 실행되버린다. 따라서 else로 아래 실행을 못하게 막는다. (else처리 안하면 잘못된접근입니다 뜨면서 아래 실행됨.)
		
	} else {

		// nno 가져옴
		String nnoParam = request.getParameter("nno");
		int nno=0;
		if(nnoParam!= null && !nnoParam.equals("")){
			nno = Integer.parseInt(nnoParam);
		}
		
		// 여기로 오면 admin 상태이기때문에 그냥 삭제 가능.
		
		boolean isSuccess = false;
		DBManager db = new DBManager();
		
		if(db.connect()){
			
			String sql = "UPDATE notification "
					   + " SET delyn = 'y'"
					   + " WHERE nno = ? ";
			
			if(db.prepare(sql).setInt(nno).update() > 0){
				isSuccess = true;
			}
			db.disconnect();
		}
		
		if(isSuccess){
			%>
			<script>
				alert("삭제 되었습니다.");
				location.href="list.jsp";
			</script>
			<%
		}else{
			%>
			<script>
				alert("삭제되지 않았습니다.");
				location.href="list.jsp";
			</script>
			<%	
		}
	}
%>