<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="allkeyboard.vo.Member" %>
<%
	Member member = (Member)session.getAttribute("login");//로그인은 키 멤버는 넣은 객체 오브젝트타입이니 형변환
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="<%=request.getContextPath()%>/css/base.css" type="text/css"
	rel="stylesheet">
</head>
<body>
	<%@ include file="/include/header.jsp" %>
	<section>
	<%
		if(member != null){
	%>
		<h2><%=member.getMname() %> 님 환영합니다.</h2>
		<a href="<%=request.getContextPath()%>">인덱스 홈페이지로 가기</a>
	<%	
		}else{
	%>
		<h2>저희 회원이 되어 주세요</h2>
	<%
		}
	%>
	 
	</section>
	<%@ include file="/include/footer.jsp" %>
</body>
</html>