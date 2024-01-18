<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="allkeyboard.vo.Member" %>
<%@ page import="allkeyboard.util.CertHelper" %>
<%
	Member memberHeader = (Member)session.getAttribute("login"); //인덱스에 합쳐지는 헤드가 인덱스와 겹쳐서 이름 바꿔준다.
%>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
	<header>
        <div class="inner clearfix">
            <h1 id="logo">
                <a href="<%=request.getContextPath()%>"><img src="<%=request.getContextPath()%>/image/logo/logo1.png" alt="top logo"></a>
            </h1>

            <nav id="nav">  
                <ul>
<%
			if(memberHeader != null){
%>
                    <li><a href="<%=request.getContextPath()%>/login/logout.jsp">로그아웃</a></li>
<%
                    if(CertHelper.isAdmin(memberHeader.getMno(), memberHeader.getToken())){
%>
                    <li><a href="<%=request.getContextPath()%>/login/adminPage.jsp">관리페이지</a></li>
<%
                    }else{
%>
					<li><a href="<%=request.getContextPath()%>/member/mypage.jsp?mno=<%=memberHeader.getMno()%>">마이페이지</a></li>
<%	
                    } //member1이 널이 아닐경우
			}else{
%>
				<li><a href="<%=request.getContextPath()%>/login/login.jsp">로그인</a></li>
                <li><a href="<%=request.getContextPath()%>/login/join.jsp">회원가입</a></li>
               
<%
			}
%>
                     <li><a href="<%=request.getContextPath()%>/order/cart.jsp">장바구니</a></li>
                    <li><a href="<%=request.getContextPath()%>/order/list.jsp">주문조회</a></li>
                </ul>
            </nav>
        </div> <!--inner-->
        
        <div class="inner">
            <ul id="category">
                <li>
                    <a href="<%=request.getContextPath()%>/product/list.jsp?brand=FILCO">FILCO 키보드</a>
                    <ul class="hidden">
                        <li><a href="<%=request.getContextPath()%>/product/list.jsp?brand=FILCO&type=마제스터치">FILCO 마제스터치</a></li>
                        <li><a href="<%=request.getContextPath()%>/product/list.jsp?brand=FILCO&type=닌자">FILCO 닌자</a></li>
                        <li><a href="<%=request.getContextPath()%>/product/list.jsp?brand=FILCO&type=컴버터블">FILCO 컴버터블</a></li>
                        <li><a href="<%=request.getContextPath()%>/product/list.jsp?brand=FILCO&type=MINILA">FILCO MINILA</a></li>
                        <li><a href="<%=request.getContextPath()%>/product/list.jsp?brand=FILCO&type=하쿠아">FILCO 하쿠아</a></li>
                    </ul>
                </li>
                <li>
                    <a href="<%=request.getContextPath()%>/product/list.jsp?brand=Mistel">Mistel 키보드</a>
                </li>
                <li>
                    <a href="<%=request.getContextPath()%>/product/list.jsp?brand=Vortex">Vortex 키보드</a>
                </li>
                <li>
                    <a href="<%=request.getContextPath()%>/product/list.jsp?brand=iKBC">iKBC 키보드</a>
                </li>
                <li>
                    <a href="<%=request.getContextPath()%>/product/list.jsp?brand=DUCKY">DUCKY 키보드</a>
                </li>
                <li>
                    <a href="<%=request.getContextPath()%>/product/list.jsp?brand=LEOPOLD">LEOPOLD 키보드</a>
                    <ul class="hidden">
                        <li><a href="<%=request.getContextPath()%>/product/list.jsp?brand=LEOPOLD&type=FC650NDS">FC650NDS</a></li>
                        <li><a href="<%=request.getContextPath()%>/product/list.jsp?brand=LEOPOLD&type=FC660M">FC660M</a></li>
                        <li><a href="<%=request.getContextPath()%>/product/list.jsp?brand=LEOPOLD&type=FC750R">FC750R</a></li>
                        <li><a href="<%=request.getContextPath()%>/product/list.jsp?brand=LEOPOLD&type=FC900R">FC900R</a></li>
                        <li><a href="<%=request.getContextPath()%>/product/list.jsp?brand=LEOPOLD&type=FC750R MX2A">FC750R MX2A</a></li>
                        <li><a href="<%=request.getContextPath()%>/product/list.jsp?brand=LEOPOLD&type=FC900R MX2A">FC900R MX2A</a></li>
                    </ul>
                </li>
                <li>
                    <a href="<%=request.getContextPath()%>/product/list.jsp?brand=NUMPAD">숫자 패드</a>
                </li>
                <li>
                    <a href="<%=request.getContextPath()%>/product/list.jsp?brand=CAPACITY">정전용량 키보드</a>
                </li>
            </ul>
        </div>
        <hr id="main_line">
	</header>
</body>
</html>


