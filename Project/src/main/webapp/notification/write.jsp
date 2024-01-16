<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="allkeyboard.vo.Member" %>
<%@ page import="allkeyboard.util.CertHelper" %>

    
<%
	request.setCharacterEncoding("UTF-8");
	Member member = (Member)session.getAttribute("login"); // 관리자 검사를위한 세션 들고오기.

	// admin 체크
	boolean isAdmin = false; 
	if(member != null){
		isAdmin = CertHelper.isAdmin(member.getMno(), member.getToken());
	}
	
	//admin이 아니면 접근 불가.
	if( !isAdmin)
	{
%>
		<script>
			alert("잘못된 접근입니다.");
			location.href='list.jsp';
		</script>
<%
	} else {
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
	function refreshAddButton() {
		//혹시 모르니 모든 추가 버튼 삭제 class="img_Add" 제거 (모든 "추가"버튼 제거)
		$("#imageList .img_add").remove();
		
		// 마지막에 "추가" 버튼 다시 추가 
		//let childCnt = $("#imageList").children().length;
		let childCnt = $("#imageList div").length;
		if(childCnt != 0){ // 자식이 하나라도 있으면 마지막 자식에 추가
			$("#imageList div").last().append(' <Button type="button" class="img_add small_btn btn_white" onclick="addImage()">추가</Button>');
		}else { // 자식이 하나도 없으면 imageList에 자식으로 추가
			$("#imageList").append(' <Button type="button" class="img_add small_btn btn_white" onclick="addImage()">추가</Button>');
		}
		
	}
	function addImage(){
		
		// 추가 버튼은 맨 아래 자식에만 존재해야 함.
		let childCnt = $("#imageList div").length;
		
	
		// 추가 버튼을 포함하여 맨 아래에 추가
		let html = '<div>';
		html += ' <input type="file" name="notiFile_' + (childCnt +1) + '">';
		html += ' <Button type="button" class="img_remove small_btn btn_red" onclick="removeImage(this)">제거</Button>';
		html += '</div>';
			
		$("#imageList").append(html);   
		
		refreshAddButton();	
	}
	
	function removeImage(o){

		// 자신을 삭제
		$(o).parent().remove(); // 부모 div를 삭제해서 항목을 삭제함.
		
		// 모든 자식리스트를 돌면서 input="file"의 번호를 순차부여
		//let childCnt = $("#imageList").children().length;
		let childCnt = $("#imageList div").length;
		
		$("#imageList div input[type=file]").each(function (index, item)
			{
				$(item).attr("name", "notiFile_" + (index+1) );
			}
		);
		
		refreshAddButton();
	}
	
	function isValid(){
		// 	제목 내용이 비어있지 않은지 확인.
		if( $("#ntitle").val() == "" ||$("#ntitle").val() == null)
		{
			alert("제목 없음");
			return false;
		}
		
		if( $("#ncontent").val() == "" ||$("#ncontent").val() == null)
		{
			alert("내용 없음");
			return false;
		}
		
		// 파일이 있다면 첨부되어 있지 않은지 확인.
		let fileForm = /(.*?)\.(jpg|jpeg|png)$/; // 이미지 파일만
		let maxSize = 20 * 1024 * 1024; // 파일사이즈 제한 (20MB)
		let fileSize;
		let isError =  false;
		
		$("#imageList div input[type=file]").each(
				function (index, item)
				{
					let imgFile = $(item).val();
					
					
					if(imgFile == "" || imgFile== null) 
					{
						alert("첨부파일은 필수!");
						item.focus();
						isError = true;
					    return false; // break;
					}
					
					if(imgFile != "" && imgFile != null) {
						fileSize = $(item)[0].files[0].size;
					    if(!imgFile.match(fileForm)) {
					    	alert("이미지 파일만 업로드 가능");
					    	isError = true;
							return false; // break;
					    } else if(parseInt(fileSize) >= parseInt(maxSize)) {
					    	alert("파일 사이즈는 20MB까지 가능");
					    	isError = true;
							return false; // break;
					    }
					}
				}
			);
		
		if(isError){
			return false;
		} 
		return true;
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
                            <td><input id="ntitle" type="text" name="ntitle" maxlength="200"></td>
                        </tr>
                        <tr>
                            <td>내용</td>
                            <td><textarea id="ncontent" name="ncontent" rows="10" cols="50"></textarea></td>
                        </tr>
                        <tr>
                            <td>이미지파일</td>  
                            <td>
                            	<div id="imageList">	                            	
	                            	<Button type="button" class="img_add small_btn btn_white" onclick="addImage()">추가</Button>
                            	</div>
                            </td>
                        </tr>
                    </tbody>

                </table>
            </div>

            <div class="action_box">
                <div>
                    <button type="button" class="large_btn btn_white" onclick="location.href='list.jsp'">취소</button>
                    <button type="submit" class="large_btn btn_red" onclick="return isValid();">등록</button>
                </div>
            </div>
        </form>
    </main>
	
	<%@ include file="/include/footer.jsp"%>
</body>
</html>

<%		
	}
%>