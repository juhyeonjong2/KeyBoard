<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	String orderParam = request.getParameter("order");
	
	//오더 받아온 뒤 int타입으로 변경
	int order =0;
	
	if(orderParam != null && !orderParam.equals("")){
		order = Integer.parseInt(orderParam);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<link href="<%=request.getContextPath()%>/css/base.css" type="text/css"
	rel="stylesheet">
<link href="<%=request.getContextPath()%>/css/login.css" type="text/css"
	rel="stylesheet">
	
	<script>
			function handleOnInput(e){
				 e.value = e.value.replace(/[^A-Za-z0-9]/ig, '')
				}
	</script>
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
                    <input type="text" name="mid" class="margin1" oninput="handleOnInput(this)" placeholder="아이디"><br>
                    <input type="password" name="mpw" class="margin1" placeholder="비밀번호">
                </div>
                <div class="submit">
                    <input type="submit" value="로그인" >
                </div>
                <div id="joinLink" class="margin1">
                    <a href="<%=request.getContextPath()%>/login/join.jsp">회원가입하기</a>
                </div>
            </form>
<%
			if(order == 1){
%>
			<form name="frm2" id="notLoginBox" action="notloginOk.jsp" method="post">
				<div>
					<input type="submit" id="notLoginOrder" value="비회원으로 주문하기">
				</div>
			</form>
<%
			}else{
%>
            <form name="frm2" id="notLoginBox" action="notloginOk2.jsp" method="post">
                <h4>비회원 주문조회 하기</h4>
                <div class="textBox">
                    <input type="text" name="orderName" class="margin1" placeholder="주문자명"><br>
                    <input type="password" name="orderNum" class="margin1" placeholder="주문번호">
                </div>
                <div class="submit">
                    <input type="submit" value="확인">
                </div>
            </form>
<%
			}
%>
        </div><!--inner_member2-->
    </main>
    <%@ include file="/include/footer.jsp"%>
</body>
</html>