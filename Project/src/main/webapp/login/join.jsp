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
<script>
	function validation(){
		let mid = document.frm.mid.value;
		let mpw = document.frm.mpw.value;
		let mpwre = document.frm.mpwre.value;
		let mname = document.frm.mname.value;
		let mphone = document.frm.mphone.value;
		let mphone2 = document.frm.mphone2.value;
		let memail = document.frm.memail.value;
		let maddr = document.frm.maddr.value;
		
		let check = true;
		if(mid == ""){
			check = false;
			document.frm.mid.style.border="1px solid red";
		}else{
			check = true;
			document.frm.mid.removeAttribute("style");
		}
		
		
		if(mpw == ""){
			check = false;
			document.frm.mpw.style.border="1px solid red";
		}else{
			check = true;
			document.frm.mpw.removeAttribute("style");
		}
		
		
		if(mpwre != mpw || mpwre == ""){
			check = false;
			document.frm.mpwre.style.border="1px solid red";
		}else{
			check = true;
			document.frm.mpwre.removeAttribute("style");
		}
		
		if(mname == ""){
			check = false;
			document.frm.mname.style.border="1px solid red";
		}else{
			check = true;
			document.frm.mname.removeAttribute("style");
		}
		
		
		if(mphone == ""){
			check = false;
			document.frm.mphone.style.border="1px solid red";
		}else{
			check = true;
			document.frm.mphone.removeAttribute("style");
		}
		
		
		if(mphone2 == ""){
			check = false;
			document.frm.mphone2.style.border="1px solid red";
		}else{
			check = true;
			document.frm.mphone2.removeAttribute("style");
		}
		
		
		if(memail == ""){
			check = false;
			document.frm.memail.style.border="1px solid red";
		}else{
			check = true;
			document.frm.memail.removeAttribute("style");
		}
		
		
		if(maddr == ""){
			check = false;
			document.frm.maddr.style.border="1px solid red";
		}else{
			check = true;
			document.frm.maddr.removeAttribute("style");
		}
		
		
		if(check&&checkIdFlag){
			document.frm.submit();
		}else{
			alert("아이디 중복검사, 비밀번호확인, 입력양식을 확인해주세요.");
		}
	}
	
	let checkIdFlag = false; 
	
	function checkIdFn(){
		
		let id = document.frm.mid.value;
		
		$.ajax({ 
			url : "checkid.jsp",
			type : "post",
			data : {mid : id},
			success : function(data){
				let result = data.trim();
				if(result == 0){
					checkIdFlag = true;
					alert("사용가능한 아이디입니다.");
				}else{
					checkIdFlag = false;
					alert("이미 존재하는 아이디입니다.");
				}
			},error:function(){
				console.log("error");
				checkIdFlag = false;
			}
		});
		
	}
	
	function resetFn(){
		checkIdFlag = false;
	}

</script>
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
					<label for="id" >아이디 :</label>
				</div>
				<div class="textBox">
					<input type="text" name="mid" onblur="resetFn()" >
					<input type="button" id="idCheck" value="중복확인" onclick="checkIdFn()">
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
						<option value="@naver.com">@naver.com</option>
						<option value="@daum.net">@daum.net</option>
						<option value="@gmail.com">@gmail.com</option>
						<option value="@nate.com">@nate.com</option>
						<option value="@icloud.com">@icloud.com</option>
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
					<select name="mphone1" id="phone1">
						<option value="010">010</option>
						<option value="011">011</option>
						<option value="016">016</option>
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
						<input value="회원가입" type="button" onclick="validation();return false;">
					</label>
				</div>
			</form> <!--joinBox-->

        </div><!--inner_member2-->
	</main>
	
	<%@ include file="/include/footer.jsp"%>
</body>
</html>