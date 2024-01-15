<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	session.invalidate(); //로그아웃 
%>
	<script>
		alert("로그아웃 되었습니다."); 
		location.href="<%=request.getContextPath()%>/login/test.jsp";
	</script>
<%
	response.sendRedirect(request.getContextPath()); //로그아웃후 이동 위가 실행 안되서 그냥 일단 이렇게
%>