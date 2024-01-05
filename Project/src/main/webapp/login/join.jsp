<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<link href="<%=request.getContextPath()%>/css/base.css" type="text/css"
	rel="stylesheet">
<link href="<%=request.getContextPath()%>/css/join.css" type="text/css"
	rel="stylesheet">
<script src="<%= request.getContextPath()%>/js/jquery-3.7.1.min.js"></script>
<script></script> <!-- 중복검사용 제작해야함 -->
</head>
<body>
	<%@ include file="/include/header.jsp"%>
	
	<main>
		<div class="inner_member clearfix">
            <h3>회원가입</h3>
            <hr id="main_line2">
        </div> <!--inner_member-->

        <div class="inner_member2 clearfix">
            <h4>기본정보</h4>

            <form name="frm" id="joinBox" action="joinOk.jsp" method="post" >
				<div class="text">
					<label for="id">아이디 :</label>
				</div>
				<div class="textBox">
					<input type="text" name="mid" >
					<input type="button" id="idCheck" value="중복확인">
				</div>
                <br>
				<div class="text">
					<label for="password">비밀번호 :</label>
				</div>
				<div class="textBox">
					<input type="password" name="mpw">
				</div>
                <br>
				<div class="text">
					<label for="passwordre">비밀번호 확인 :</label>
				</div>
                <div class="textBox">
					<input type="password" name="mpwre">
				</div>
                <br>
				<div class="text">
					<label for="name">이름 :</label>
				</div>
				<div class="textBox">
					<input type="text" name="mname">
				</div>
                <br>
				<div class="text">
					<label for="email" id="email">이메일 :</label>
				</div>
				<div class="textBox" id="emailerror">
					<input type="text" name="memail" >
                    <select name="memail2" id="email2">
						<option value="0">직접입력</option>
						<option value="1">@naver.com</option>
						<option value="2">@daum.net</option>
						<option value="3">@gmail.com</option>
						<option value="4">@nate.com</option>
						<option value="5">@icloud.com</option>
					</select>
                    <br>
                    <div class="agreeBox">
                        <input type="checkbox" name="agree">
                    </div>
                    <div class="agreeText">
                        <label for="check">메일수신에 동의</label>
                    </div>
				</div>
                <br>
				<div class="text">
					<label for="phone" id="phone" >연락처 :</label>
				</div>
				<div class="textBox" id="phoneerror">
					<select name="phone1" id="phone1">
						<option value="010">010</option>
						<option value="010">011</option>
						<option value="010">016</option>
					</select>&nbsp;
					<input type="text" name="mphone" >&nbsp;
					<input type="text" name="mphone2" >
                    <br>
                    <div class="agreeBox">
                        <input type="checkbox" name="agree" >
                    </div>
                    <div class="agreeText">
                        <label for="check" >메일수신에 동의</label>
                    </div>
				</div>
                <br>
                <div class="text">
					<label for="addr" id="addr">주소 :</label>
				</div>
                <div class="textBox">
                    <textarea name="maddr" id="addr3"></textarea>
				</div>
                <br>
                <div class="text" id="check">
					<label for="check">개인정보 수집 및 이용</label>
				</div>
                <div class="textBox">
					<input type="checkbox" name="agree">동의
				</div>
                <br>
				<div class="textBox_submit">
					<label>
						<input type="submit" value="회원가입">
					</label>
				</div>
			</form> <!--joinBox-->

        </div><!--inner_member2-->
	</main>
	
	<%@ include file="/include/footer.jsp"%>
</body>
</html>