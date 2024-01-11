<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="allkeyboard.vo.Member" %>
<%@ page import="allkeyboard.util.CertHelper" %>
    
<%
	request.setCharacterEncoding("UTF-8");
	Member member = (Member)session.getAttribute("login"); // 관리자 검사를위한 세션 들고오기.
	// 어드민이 아니면 원래 있던 공지사항으로 보냄
	if(member == null || !CertHelper.isAdmin(member.getMno(), member.getToken()) )
	{
%>
		<script>
			alert("잘못된 접근입니다.");
			location.href='list.jsp';
		</script>
<%
	}
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 작성</title>
<link href="<%=request.getContextPath()%>/css/base.css" type="text/css" rel="stylesheet">
<link href="<%=request.getContextPath()%>/css/notification/write.css" type="text/css" rel="stylesheet">
<script src="<%=request.getContextPath()%>/js/jquery-3.7.1.min.js"></script>
<script>
	function addImage(){
		
		// 추가 버튼은 맨 아래 자식에만 존재해야 함.
		let childCnt = $("#imageList").children().length;
		console.log(childCnt);
		
		// class="img_Add" 제거
		$("#imageList .img_add").remove();
		
		// 추가 버튼을 포함하여 맨 아래에 추가
		let html = '<div>';
		html += ' <input type="file" name="notiFile_' + (childCnt +1) + '">';
		html += ' <Button type="button" class="img_remove small_btn btn_red" onclick="removeImage(this)">제거</Button>';
		html += ' <Button type="button" class="img_add small_btn btn_white" onclick="addImage()">추가</Button>';
		html += '</div>';
			
		$("#imageList").append(html);   
		
		
	}
	
	function removeImage(o){

		// 자신을 삭제
		$(o).parent().remove(); // 부모 div를 삭제해서 항목을 삭제함.
		
		// class="img_Add" 제거 (모든 "추가"버튼 제거)
		$("#imageList .img_add").remove();
		
		// 모든 자식리스트를 돌면서 input="file"의 번호를 순차부여
		let childCnt = $("#imageList").children().length;
		console.log(childCnt);
		
		$("#imageList div input[type=file]").each(function (index, item)
			{
				$(item).attr("class", "notiFile_" + (index+1) );
			}
		);
		
		// 마지막에 "추가" 버튼 추가 
		$("#imageList div").last().append(' <Button type="button" class="img_add small_btn btn_white" onclick="addImage()">추가</Button>');
	}
</script>


</head>
<body>
	<%@ include file="/include/header.jsp"%>
	
	 <main>
        <hr id="main_line">
        <div class="inner_member clearfix">
            <h3>공지사항 작성</h3>
            <hr class="main_line2">
        </div>

        <form name="notification_frm" action="writeOk.jsp" method="post"  enctype="multipart/form-data">
            <div class="content_box">
                <table class="info_table">
                    <colgroup>
                            <col width="15%"> <!-- 항목 -->
                            <col width="85%"> <!-- 내용  -->
                    </colgroup>
                    <tbody>
                        <tr>
                            <td>제목</td>
                            <td><input type="text" name="ntitle" maxlength="200"></td>
                        </tr>
                        <tr>
                            <td>내용</td>
                            <td><textarea name="ncontent" rows="10" cols="50"></textarea></td>
                        </tr>
                        <tr>
                            <td>이미지파일</td>
                            <!-- <td><input type="file" name="notiFile" multiple ></td> -->
                            
                            <td>
                            	<div id="imageList">
	                            	<div>
	                            	<input type="file" name="notiFile_1">
	                            	<Button type="button" class="img_remove small_btn btn_red" onclick="removeImage(this)">제거</Button>
	                            	<Button type="button" class="img_add small_btn btn_white" onclick="addImage()">추가</Button>
	                            	</div>
                            	</div>
                            </td>
                        </tr>
                    </tbody>

                </table>
            </div>

            <div class="action_box">
                <div>
                    <button type="button" class="large_btn btn_white">취소</button>
                    <button type="submit" class="large_btn btn_red">등록</button>
                </div>
            </div>
        </form>
    </main>
	
	<%@ include file="/include/footer.jsp"%>
</body>
</html>
