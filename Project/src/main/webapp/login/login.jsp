<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<link href="<%=request.getContextPath()%>/css/base.css" type="text/css"
	rel="stylesheet">
<link href="<%=request.getContextPath()%>/css/login.css" type="text/css"
	rel="stylesheet">
</head>
<body>
	<%@ include file="/include/header.jsp"%>
	
	 <div class="inner_member clearfix">
            <h3>로그인</h3>
            <hr id="main_line2">
        </div> <!--inner_member-->

        <div class="inner_member2 clearfix">
            <form name="frm" id="loginBox" action="loginOk.jsp" method="post">
                <h4>회원로그인</h4>
                <div class="textBox">
                    <input type="text" name="mid" class="margin1"><br>
                    <input type="password" name="mpw" class="margin1">
                </div>
                <div class="submit">
                    <input type="submit" value="로그인" >
                </div>
                <div id="joinLink" class="margin1">
                    <a href="#">회원가입하기</a><!-- 링크넣기 -->
                </div>
            </form>

            <form name="frm2" id="notLoginBox" action="notloginOk.jsp" method="post">
                <h4>비회원 주문조회 하기</h4>
                <div class="textBox">
                    <input type="text" name="orderName" class="margin1"><br>
                    <input type="password" name="orderNum" class="margin1">
                </div>
                <div class="submit">
                    <input type="submit" value="확인">
                </div>
            </form>
        </div><!--inner_member2-->
    </main>
    <%@ include file="/include/footer.jsp"%>
</body>
</html>