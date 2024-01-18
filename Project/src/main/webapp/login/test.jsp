<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="allkeyboard.vo.Member" %>

<%@ page import="allkeyboard.vo.Cert" %>
<%@ page import="allkeyboard.util.CertHelper" %>
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
		<h3>token = <%=member.getToken()%></h3>
		<h3>mno = <%=member.getMno()%></h3>
		<a href="<%=request.getContextPath()%>">인덱스 홈페이지로 가기</a>
		<a href="<%=request.getContextPath()%>/member/mypage.jsp?mno=<%=member.getMno()%>">마이페이지 홈페이지로 가기</a>
		<a href="<%=request.getContextPath()%>/product/view.jsp">상품 상세페이지로 가기</a>
	<%	
	
		/*  mno를 가지고 cer를 가져오고. cert 객체를 가지고 isExpiredTime을 검사한다*/
		Cert cert = CertHelper.getCert(member.getMno(), member.getToken());
		boolean isExpired = CertHelper.isExpiredTime(cert);
		// 아래처럼 한줄로도 가능.
		//boolean isExpired = CertHelper.isExpiredTime(CertHelper.getCert(member.getMno(), member.getToken()));
		
		int level = CertHelper.getLevel(cert);
		
	%>
		<h3>isExpired = <%=isExpired%></h3>
		<h3>level = <%=level%></h3>
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