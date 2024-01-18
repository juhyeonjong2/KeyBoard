<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="ateam.db.DBManager" %>
<%@ page import="allkeyboard.vo.Member" %>
<%
  request.setCharacterEncoding("UTF-8");
  Member member = (Member)session.getAttribute("login");
  

	String rno = request.getParameter("rno");
	String pnoParma = request.getParameter("pno");
	
	int rno2=0;
	if(rno != null && !rno.equals("")){
		rno2 = Integer.parseInt(rno);
	}
	
	int pno=0;
	if(pnoParma != null && !pnoParma.equals("")){
		pno = Integer.parseInt(pnoParma);
	}
	
	
	DBManager db = new DBManager();
		
	
	if(db.connect())
	{	
		 String sql = "DELETE FROM review WHERE rno = ? AND mno = ?";
			 	 db.prepare(sql);
		 		 db.setInt(rno2);
		 		 if(member == null){
		 			 db.setInt(0);
		 		 }else{
			 		 db.setInt(member.getMno());
		 		 }
		 		int count = db.update();	 		

		 if(count > 0){
			 %>
				<script>
					alert("후기가 삭제되었습니다.");
					location.href="<%=request.getContextPath()%>/product/view.jsp?pno=<%=pno%>"
				</script>
			<%	 
		 }else{
			 %>
				<script>
					alert("후기삭제에 실패하였습니다.");
					location.href="<%=request.getContextPath()%>/product/view.jsp?pno=<%=pno%>"
				</script>
			<%	
		 }
		 db.disconnect();
	}
	
	 
 %>