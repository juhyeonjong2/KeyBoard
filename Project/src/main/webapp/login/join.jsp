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
		let allagree = document.frm.allagree.checked;
		
		
		//여기도 하나로 설정하면 마지막만 트루가 나오면 트루가 되버리니까 이름 바꿔서 여러개 작성하자
		let check = false;
		let check1 = false;
		let check2 = false;
		let check3 = false;
		let check4 = false;
		let check5 = false;
		let check6 = false;
		let check7 = false;
		let check8 = false;
	
		
		if(mid == ""){
			check = false;
			document.frm.mid.style.border="1px solid red";
		}else{
			check = true;
			document.frm.mid.removeAttribute("style");
		}
		
		
		if(mpw == ""){
			check1 = false;
			document.frm.mpw.style.border="1px solid red";
		}else{
			check1 = true;
			document.frm.mpw.removeAttribute("style");
		}
		
		
		if(mpwre != mpw || mpwre == ""){
			check2 = false;
			document.frm.mpwre.style.border="1px solid red";
		}else{
			check2 = true;
			document.frm.mpwre.removeAttribute("style");
		}
		
		if(mname == ""){
			check3 = false;
			document.frm.mname.style.border="1px solid red";
		}else{
			check3 = true;
			document.frm.mname.removeAttribute("style");
		}
		
		
		if(mphone == ""){
			check4 = false;
			document.frm.mphone.style.border="1px solid red";
		}else{
			check4 = true;
			document.frm.mphone.removeAttribute("style");
		}
		
		
		if(mphone2 == ""){
			check5 = false;
			document.frm.mphone2.style.border="1px solid red";
		}else{
			check5 = true;
			document.frm.mphone2.removeAttribute("style");
		}
		
		
		if(memail == ""){
			check6 = false;
			document.frm.memail.style.border="1px solid red";
		}else{
			check6 = true;
			document.frm.memail.removeAttribute("style");
		}
		
		
		if(maddr == ""){
			check7 = false;
			document.frm.maddr.style.border="1px solid red";
		}else{
			check7 = true;
			document.frm.maddr.removeAttribute("style");
		}
		
		if(allagree == false){ //체크 안하면 false 반환
			check8 = false;
		}else{
			check8 = true;
		}
		
		
		
		if(check&&check1&&check2&&check3&&check4&&check5&&check6&&check7&&check8&&checkIdFlag){
			document.frm.submit();
		}else{
			alert("아이디 중복검사, 비밀번호확인, 개인정보 수집 및 이용동의, 입력양식을 확인해주세요.");
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
                        <input type="checkbox" name="allowemail" value="y">
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
                        <input type="checkbox" name="allowphone" value="y">
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
					<input type="checkbox" name="allagree" value="y">동의
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