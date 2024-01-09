<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="allkeyboard.vo.Member" %>
<%  
	request.setCharacterEncoding("UTF-8"); 
	Member member = (Member)session.getAttribute("login");	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 탈퇴</title>
<link href="<%=request.getContextPath()%>/css/base.css" type="text/css"
	rel="stylesheet">
<link href="<%=request.getContextPath()%>/css/mypage_delete.css" type="text/css"
	rel="stylesheet">
<script src="<%= request.getContextPath()%>/js/jquery-3.7.1.min.js"></script>
<script>
	function deleteCheck(){
		console.log("함수는 실행");
		let mid = document.frm.mid.value;
		let mpw = document.frm.mpw.value;
		let mno = <%=member.getMno()%>;
		let checkall = false;
		
		$.ajax({ 
			url : "checkall.jsp",
			async : false,
			type : "post",
			data : {mid : mid , mno : mno , mpw : mpw}, //나의 mno와 내가 적은 아이디 비번을 넘긴다 (저기서 한번에 일치하는지 확인)
			success : function(data){
				let result = data.trim();
				console.log(result+"result값");
				if(result == 1){ //모두 일치하는 값이 존재하는 경우
					checkall = true;
				}else{ // 아닌경우
					checkall = false;
				}
			},error:function(){
				console.log("error");
				checkall = false;
			}
		});
		
		if(checkall){
			//확인하는 창 출력 -> 트루일경우
			let con = confirm("정말 회원을 탈퇴하실건가요?");
			if(con){
				document.frm.submit();
			}else{
				alert("회원을 유지해주셔서 감사합니다.");
			}
		}else{
			alert("아이디 또는 비밀번호가 일치하지않습니다.");
		}
	}
</script>
</head>
<body>
	<%@ include file="/include/header.jsp"%>
	<main>
        <hr id="main_line">
        <div class="inner_member clearfix">
            <h3>회원 탈퇴</h3>
            <hr id="main_line2">
        </div> <!--inner_member-->
        
        <div class="inner_member2 clearfix">
            <form name="frm" id="deleteBox" method="post" action="mypage_deleteOk.jsp" >
                <h4>회원 탈퇴하기</h4>
                <div class="textBox">
                    <input type="text" name="mid" class="margin1" placeholder="아이디를 입력하세요"><br>
                    <input type="password" name="mpw" class="margin1" placeholder="패스워드를 입력하세요">
                </div>
                <div class="submit">
                    <input type="button" id="submitButton" value="회원 탈퇴" onclick="deleteCheck();">
                </div>
                <div id="modifyLink" class="margin1">
                    <a href="<%=request.getContextPath()%>/member/mypage_modify.jsp">이전 페이지</a>
                </div>
                <input type="hidden" name="mno" value="<%=member.getMno()%>"> <!-- 내 mno가 보여도 되는지 궁금 -->
            </form>
        
        </div><!--inner_member2-->
    </main>
	<%@ include file="/include/footer.jsp"%>
</body>
</html>