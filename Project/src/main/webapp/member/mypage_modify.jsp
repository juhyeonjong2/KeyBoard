<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="allkeyboard.vo.Member" %>
<%@ page import="ateam.db.DBManager" %>
<%
	request.setCharacterEncoding("UTF-8"); //인코딩
	
	String mnoParam = request.getParameter("mno");

	int mno=0;
	
	if(mnoParam != null && !mnoParam.equals("")){
		mno = Integer.parseInt(mnoParam);
	}
	
	int mno2 = 0;
	String mname = "";
	String memail = "";
	String mpw = "";
	String mphone = "";
	String mphone2 = "";
	String maddr = "";

	
 	DBManager db = new DBManager(); 

	if(db.connect())
	{
		// member 확인
		 String sql = "select * , substr(memail, 1,  instr(memail,'@')-1) as memail2" 
		 			+ " , substr(mphone, 5,  instr(mphone,'-')) as mphone2"
		 			+ " , substr(mphone, 10) as mphone3 from member where mno = ?";
		 
		 if( db.prepare(sql).setInt(mno).read())
		 {
			 if(db.getNext())
			 {
				
				mno2 = db.getInt("mno");
				mname = db.getString("mname");
				memail = db.getString("memail2");
				mpw = db.getString("mpw"); 
				mphone = db.getString("mphone2");
				mphone2 = db.getString("mphone3");
				maddr = db.getString("maddr");

			 }
		 }
		 db.disconnect();
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지 수정</title>
<link href="<%=request.getContextPath()%>/css/base.css" type="text/css"
	rel="stylesheet">
<link href="<%=request.getContextPath()%>/css/mypage_modify.css" type="text/css"
	rel="stylesheet">
<script src="<%= request.getContextPath()%>/js/jquery-3.7.1.min.js"></script>	
<script>
	function validation(){
		console.log("called validation()")
		let mpw = document.frm.mpw.value;
		let mpwre = document.frm.mpwre.value;
		let mpwnow = document.frm.mpwnow.value;
		
		let mname = document.frm.mname.value;
		let mphone2 = document.frm.mphone2.value;
		let mphone3 = document.frm.mphone3.value;
		let memail = document.frm.memail.value;
		let maddr = document.frm.maddr.value;
		
		// 트루가 하나 false가 나온다 하더라도 아래에서 true가 나오면 결과적으로 트루가 나옴 그래서 여러개로 나눔
		let checkpw = false;
		let check1 = true;
		let check2 = true;
		let check3 = true;
		let check4 = true;
		let check5 = true;
		let check6 = true;
		
		$.ajax({ 
			url : "checkpw.jsp",
			async : false,
			type : "post",
			data : {mpwnow : mpwnow , mno : <%=mno2%>},
			success : function(data){
				let result = data.trim();
				if(result == 1){
					checkpw = true;
					document.frm.mpwnow.removeAttribute("style");
				}else{
					checkpw = false;
					document.frm.mpwnow.style.border="1px solid red";
				}
			},error:function(){
				console.log("error");
				checkpw = false;
			}
		});
		
		
		if(mpw != mpwre){
			check1 = false;
			document.frm.mpw.style.border="1px solid red";
		}else{
			check1 = true;
			document.frm.mpw.removeAttribute("style");
		}
		
		
		
		if(mname == ""){
			check2 = false;
			document.frm.mname.style.border="1px solid red";
		}else{
			check2 = true;
			document.frm.mname.removeAttribute("style");
		}
		
		
		if(mphone2 == ""){
			check3 = false;
			document.frm.mphone2.style.border="1px solid red";
		}else{
			check3 = true;
			document.frm.mphone2.removeAttribute("style");
		}
		
		
		if(mphone3 == ""){
			check4 = false;
			document.frm.mphone3.style.border="1px solid red";
		}else{
			check4 = true;
			document.frm.mphone3.removeAttribute("style");
		}
		
		
		if(memail == ""){
			check5 = false;
			document.frm.memail.style.border="1px solid red";
		}else{
			check5 = true;
			document.frm.memail.removeAttribute("style");
		}
		
		
		if(maddr == ""){
			check6 = false;
			document.frm.maddr.style.border="1px solid red";
		}else{
			check6 = true;
			document.frm.maddr.removeAttribute("style");
		}
		
		
		if(checkpw&&check1&&check2&&check3&&check4&&check5&&check6){
			document.frm.submit();
		}else{
			alert("현재 비밀번호, 비밀번호 확인, 입력양식을 확인해주세요.");
		}
	}
	
</script>	
	
</head>
<body>
	<%@ include file="/include/header.jsp"%>
	<main>
        <hr id="main_line">
        <div class="inner_member clearfix">
            <h3>마이페이지 수정</h3>
            <hr id="main_line2">
        </div> <!--inner_member-->

        <div class="inner_member2 clearfix" id="joinBox12345">
            <form name="frm" id="joinBox" action="mypage_modifyOk.jsp" method="post">
				<div class="text">
					<label for="name">이름 :</label>
				</div>
				<div class="textBox">
					<input type="text" name="mname" value="<%=mname%>">
				</div>
                <br>
				<div class="text">
					<label for="email" id="email">이메일 :</label>
				</div>
				<div class="textBox" id="emailerror" >
					<input type="text" name="memail"  value="<%=memail%>" >
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
					<select name="mphone1" id="phone1" >
						<option value="010">010</option>
						<option value="011">011</option>
						<option value="016">016</option>
					</select>&nbsp;
					<input type="text" name="mphone2"  value="<%=mphone%>">&nbsp; 
					<input type="text" name="mphone3"  value="<%=mphone2%>">
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
					<label for="password">현재 비밀번호 :</label>
				</div>
				<div class="textBox">
					<input type="password" name="mpwnow" >
				</div>
                <br>
				<div class="text">
					<label for="password">비밀번호 변경:</label>
				</div>
				<div class="textBox">
					<input type="password" name="mpwre">
				</div>
                <br>
                <div class="text">
					<label for="password">비밀번호 변경 확인:</label>
				</div>
				<div class="textBox">
					<input type="password" name="mpw">
				</div>
                <br>
                <div class="text">
					<label for="addr" id="addr">주소 :</label>
				</div>
                <div class="textBox">
                    <textarea name="maddr" id="addr3"><%=maddr%></textarea>
				</div>
                <br>
				<div class="textBox_submit">
						<input type="button" value="회원정보 수정" onclick="validation();return false;">
				</div>
				<div id="deleteBt">
					<a href="<%=request.getContextPath()%>/member/mypage_delete.jsp">회원탈퇴</a>
				</div>
				<input type="hidden" name="mno" value="<%=mno2%>">
			</form> <!--joinBox-->
        </div><!--inner_member2-->
    </main>
	<%@ include file="/include/footer.jsp"%>
</body>
</html>