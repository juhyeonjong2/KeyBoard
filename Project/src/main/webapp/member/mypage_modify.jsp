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
		 String sql = "SELECT * FROM member WHERE mno = ?";
		 
		 if( db.prepare(sql).setInt(mno).read())
		 {
			 if(db.getNext())
			 {
				
				mno2 = db.getInt("mno");
				mname = db.getString("mname");
				memail = db.getString("memail");
				mpw = db.getString("mpw");
				mphone = db.getString("mphone");
				mphone2 = db.getString("mphone2");
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
					<input type="text" name="name" value="<%=mname%>">
				</div>
                <br>
				<div class="text">
					<label for="email" id="email">이메일 :</label>
				</div>
				<div class="textBox" id="emailerror" >
					<input type="email" name="email"  value="<%=memail%>" > <!-- 셀렉트도 포함된 문자가 들어감 -->
                    <select name="email2" id="email2">
						<option value="@naver.com">@naver.com</option>
						<option value="@daum.ne">@daum.net</option>
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
					<select name="phone1" id="phone1" >
						<option value="010">010</option>
						<option value="010">011</option>
						<option value="010">016</option>
					</select>&nbsp;
					<input type="text" name="phone2"  value="<%=mphone%>">&nbsp; <!-- mysql 그 짜르는거 사용해서 이 안에 넣기 -->
					<input type="text" name="phone3"  value="<%=mphone2%>"> <!-- 이곳에는 null값이 들어감 위는 010-1234-1234이렇게 들어가고 -->
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
					<label for="password">현재 비밀번호 :</label>
				</div>
				<div class="textBox">
					<input type="password" name="password" >
				</div>
                <br>
				<div class="text">
					<label for="password">비밀번호 변경:</label>
				</div>
				<div class="textBox">
					<input type="password" name="password">
				</div>
                <br>
                <div class="text">
					<label for="password">비밀번호 변경 확인:</label>
				</div>
				<div class="textBox">
					<input type="password" name="password">
				</div>
                <br>
                <div class="text">
					<label for="addr" id="addr">주소 :</label>
				</div>
                <div class="textBox">
                    <textarea name="addr3" id="addr3"><%=maddr%></textarea>
				</div>
                <br>
				<div class="textBox_submit">
						<input type="submit" value="회원정보 수정">
				</div>
				<div id="deleteBt">
					<a href="<%=request.getContextPath()%>/member/mypage_delete.jsp">회원탈퇴</a>
				</div>
				<input type="hidden" name="mno" value="<%=mno%>"> <!-- 이 값을 post로 넘기기위한 히든박스 -->
			</form> <!--joinBox-->
        </div><!--inner_member2-->
    </main>
	<%@ include file="/include/footer.jsp"%>
</body>
</html>