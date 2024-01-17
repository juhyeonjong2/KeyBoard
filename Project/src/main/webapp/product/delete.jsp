<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="ateam.db.DBManager" %>
<%@ page import="allkeyboard.vo.Member" %>
<%@ page import="allkeyboard.util.CertHelper" %>
<%
  request.setCharacterEncoding("UTF-8");
  Member member = (Member)session.getAttribute("login");
  String method = request.getMethod();

	String pnoParam = request.getParameter("pno");

	
	int pno=0;
	if(pnoParam != null && !pnoParam.equals("")){
		pno = Integer.parseInt(pnoParam);
	}
	
	// admin 체크
	boolean isAdmin = false; 
	if(member != null){
		isAdmin = CertHelper.isAdmin(member.getMno(), member.getToken());
	}
	
	// Get방식이거나 admin이 아니면 접근 불가.
	if(!isAdmin)
	{
		%>
		<script>
			alert("잘못된 접근입니다.");
			location.href='list.jsp';
		</script>
		<%
		// js 실행은 클라에서 되는거고 서버단에서 먼저 실행되버린다. 따라서 else로 아래 실행을 못하게 막는다. (else처리 안하면 잘못된접근입니다 뜨면서 아래 실행됨.)	
	} else {
	
	
	DBManager db = new DBManager();
		 
	if(db.connect())
	{	
		 String sql = "UPDATE product SET delyn = 'y' WHERE pno = ? ";
			 	 db.prepare(sql);
		 		 db.setInt(pno);
		 		int count = db.update();
		 		

		 if(count > 0){
			 %>
				<script>
					alert("상품이 삭제되었습니다.");
					location.href="<%=request.getContextPath()%>/product/list.jsp"
				</script>
			<%	 
		 }else{
			 %>
				<script>
					alert("상품 삭제에 실패했습니다.");
					location.href="<%=request.getContextPath()%>/product/list.jsp"
				</script>
			<%	
		 }
		 db.disconnect();
	}
	}
	
	 
 %>