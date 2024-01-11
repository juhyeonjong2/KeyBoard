<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="allkeyboard.vo.Member" %>
<%@ page import="allkeyboard.util.CertHelper" %>
<%@ page import="ateam.db.DBManager" %>
<%@ page import="allkeyboard.vo.NotificationAttach" %>
<%@ page import="allkeyboard.vo.Notification" %>

<%
	request.setCharacterEncoding("UTF-8");
	Member member = (Member)session.getAttribute("login"); // 관리자 검사를위한 세션 들고오기.

	// 공지번호
	String nnoParam = request.getParameter("nno");
	int nno = 0;
	if(nnoParam != null  && !nnoParam.equals("")){
		nno = Integer.parseInt(nnoParam);
	}
	
	
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
		
	// DB에서 기존 정보를 가져와서 미리 채워줘야한다.	
	String saveDir = "image/notification";
	String saveDirectoryPath = application.getRealPath(saveDir); // 절대 경로 안쓰기위해 톰캣쪽에 저장됨. (디비 합치면 못씀.) 
	Notification noti = new Notification();
	List<NotificationAttach> attachList = new ArrayList<NotificationAttach>();
	DBManager db = new DBManager();
	if(db.connect()){
		
		// 공지 가져오기
		String sql = "SELECT nno, ntitle, ncontent, rdate, nhit FROM notification WHERE nno=? AND delyn='n'";
				
		if(db.prepare(sql).setInt(nno).read())
		{
			if(db.getNext()){
				noti.setNno(db.getInt("nno"));
				noti.setNtitle(db.getString("ntitle"));
				noti.setNcontent(db.getString("ncontent"));
				noti.setRdate(db.getString("rdate"));
				noti.setNhit(db.getInt("nhit"));
			}
		}
		
	
		// 파일 정보를 가져온다.
		sql = "SELECT nfno, nno, nfrealname, nforeignname, rdate, nfidx " 
			     + "FROM notificationAttach "
			     + "WHERE nno=?";
		
		if(db.prepare(sql).setInt(noti.getNno()).read()){
			while(db.getNext()){
				NotificationAttach attach = new NotificationAttach();
				attach.setNfno(db.getInt("nfno"));
				attach.setNno(db.getInt("nno"));
				attach.setRealFileName(db.getString("nfrealname"));
				attach.setForeignFileName(db.getString("nforeignname"));
				attach.setRdate(db.getString("rdate"));
				attach.setNfidx(db.getInt("nfidx"));
				attachList.add(attach);
			}
		}
		
		
		// attachList를 index를 가지고 정렬한다.
		attachList.sort((a,b)->{
			return a.getNfidx() - b.getNfidx();
		});
		
		
		db.disconnect();
	}	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 수정</title>
<link href="<%=request.getContextPath()%>/css/base.css" type="text/css" rel="stylesheet">
<link href="<%=request.getContextPath()%>/css/notification/modify.css" type="text/css" rel="stylesheet">
<script src="<%=request.getContextPath()%>/js/jquery-3.7.1.min.js"></script>
<script>

	function refreshAddButton() {
		//혹시 모르니 모든 추가 버튼 삭제 class="img_Add" 제거 (모든 "추가"버튼 제거)
		$("#imageList .img_add").remove();
		
		// 마지막에 "추가" 버튼 다시 추가 
		$("#imageList div").last().append(' <Button type="button" class="img_add small_btn btn_white" onclick="addImage()">추가</Button>');
		
	}

	function addImage(){
		
		// 추가 버튼은 맨 아래 자식에만 존재해야 함.
		let childCnt = $("#imageList").children().length;
		
		
		// class="img_Add" 제거
		$("#imageList .img_add").remove();
		
		// 추가 버튼을 포함하여 맨 아래에 추가
		let html = '<div>';
		html += ' <input type="file" class="input_file" name="notiFile_' + (childCnt +1) + '">';
		html += ' <Button type="button" class="img_remove small_btn btn_red" onclick="removeImage(this)">제거</Button>';
		//html += ' <Button type="button" class="img_modify small_btn btn_red" onclick="modifyImage(this)">수정</Button>'; // 새로 추가한 친구들은 수정이 아니라 버튼이 없음
		html += ' <Button type="button" class="img_add small_btn btn_white" onclick="addImage()">추가</Button>';
		html += '</div>';
			
		$("#imageList").append(html);   
		
		
	}
	
	function modifyImage(o){
		// 해당지점에 input창을 넣음. 기존꺼 하이드. 옆에 버튼이 나타남 (수정/취소)
		// 수정을 누르면 실제로 목록이 수정되고 [제거][수정] {[추가]} 형태가 됨.
		
		// 해당라인의 부모 div를 찾고
		// input을 찾은다음에 name을 가져온다. 해당값을 저장해둠
		let parent = $(o).parent("div");
		let name = parent.children("input").attr("name");
		let value = parent.children("input").attr("value");
		
		let html ='<input type="file" class="input_file" name="'+ name + '" value="'+ value +'">'; 
		parent.children(".input_txt").before(html); // 삭제할 INPUT의 앞에넣기
		parent.children(".input_txt").remove(); // 그리고 그 INPUT을 삭제
		parent.children(".img_remove").remove(); //기존 버튼제거
		parent.children(".img_modify").remove(); //기존 버튼제거
		
		
		// 완료/취소 버튼 추가.
		html = ' <Button type="button" class="img_modify_sub small_btn btn_red" onclick="modifyImageCancel(this)" >취소</Button> '; 
		html+= ' <Button type="button" class="img_modify_sub small_btn btn_white" onclick="modifyImageOk(this)" >완료</Button> ';
		parent.children(".input_file").after(html);
		
	}
	
	function modifyImageOk(o){
		// 해당라인의 부모 div를 찾고
		// input을 찾은다음에 name을 가져온다. 해당값을 저장해둠
		let parent = $(o).parent("div");
		
		//수정용 버튼들 삭제
		parent.children(".img_modify_sub").each(function (index, item){
			console.log("remove: " + index);
			$(item).remove();});
		
		// 원래 버튼들 추가. (완료라면 수정은 다시 못함.)                      	
		let html = ' <Button type="button" class="img_remove small_btn btn_red" onclick="removeImage(this)">제거</Button> ';
		parent.children(".input_file").after(html);
		
		refreshAddButton();
	}
	
	function modifyImageCancel(o){
		// 취소한경우 input=text로 바꾸고 원래 있떤 value를 넣어줘야한다.
		
		// 해당라인의 부모 div를 찾고
		// input을 찾은다음에 name을 가져온다. 해당값을 저장해둠
		let parent = $(o).parent("div");
		let name = parent.children("input").attr("name");
		let value = parent.children("input").attr("value");
		
		let html ='<input type="text" class="input_txt" name="'+ name + '" readonly value="'+ value +'">'; 
		parent.children(".input_file").before(html); // 삭제할 INPUT의 앞에넣기
		parent.children(".input_file").remove(); // 그리고 그 INPUT을 삭제
		
		//수정용 버튼들 삭제
		parent.children(".img_modify_sub").each(function (index, item){
			console.log("remove: " + index);
			$(item).remove();});
		
		
		// 원래 버튼들 추가.                        	
		html = ' <Button type="button" class="img_remove small_btn btn_red" onclick="removeImage(this)">제거</Button> '; 
		html+= ' <Button type="button" class="img_modify small_btn btn_red" onclick="modifyImage(this)">수정</Button> ';
		parent.children(".input_txt").after(html);
		
		refreshAddButton();
		
	}
	
	
	
	
	function removeImage(o){

		// 자신을 삭제
		$(o).parent().remove(); // 부모 div를 삭제해서 항목을 삭제함.
		
		
		// 모든 자식리스트를 돌면서 input="file"의 번호를 순차부여
		let childCnt = $("#imageList").children().length;
		
		$("#imageList div input").each(function (index, item)
			{
				$(item).attr("name", "notiFile_" + (index+1) );
			}
		);
		
		// 추가 버튼을 모두 삭제하고 맨아래에 다시 추가.
		refreshAddButton();
		
		// 모든 input이 삭제되었을때 처리 안되어있음.
	}
	
	function modify(o){
		// Input이 몇개인지 기록해서 보낸다.
		let childCnt = $("#imageList").children().length;
		$("#fileCount").attr("value", childCnt);
		
		console.log($("#fileCount").attr("value"));
		
		
		
		document.notification_frm.submit();
	}
</script>
</head>
<body>
	<%@ include file="/include/header.jsp"%>
	
	 <main>
        <hr id="main_line">
        <div class="inner_member clearfix">
            <h3>공지사항 수정</h3>
            <hr class="main_line2">
        </div>

        <form name="notification_frm" action="modifyOk.jsp" method="post"  enctype="multipart/form-data">
        	<input type="hidden" name="nno" value="<%=nno%>">
        	<input type="hidden" name="fileCount" id="fileCount" value="0">
            <div class="content_box">
                <table class="info_table">
                    <colgroup>
                            <col width="15%"> <!-- 항목 -->
                            <col width="85%"> <!-- 내용  -->
                    </colgroup>
                    <tbody>
                        <tr>
                            <td>제목</td>
                            <td><input type="text" name="ntitle" maxlength="200" value="<%=noti.getNtitle()%>"></td>
                        </tr>
                        <tr>
                            <td>내용</td>
                            <td><textarea name="ncontent" rows="10" cols="50"><%=noti.getNcontent()%></textarea></td>
                        </tr>
                        <tr>
                            <td>이미지파일</td>
                            <!-- <td><input type="file" name="notiFile" multiple ></td> -->
                            
                            <td>
                            	<div id="imageList">
                            	<% 
                            	int max = attachList.size();
                            	if(max != 0)
                            	{
                            	  for(int i=0; i<max;i++)
                            	  {
                            		 
                            	%>
	                            	<div>
	                            	<input type="text" class="input_txt" name="notiFile_<%=i+1%>" readonly value="<%=attachList.get(i).getForeignFileName()%>">
	                            	<Button type="button" class="img_remove small_btn btn_red" onclick="removeImage(this)">제거</Button>
	                            	<Button type="button" class="img_modify small_btn btn_red" onclick="modifyImage(this)" >수정</Button>
	                            	<%
	                            	if(i == max-1){ // 마지막 요소에 추가버튼 
	                            	%>
	                            		<Button type="button" class="img_add small_btn btn_white" onclick="addImage()">추가</Button>
	                            	<%
                            	 	}
	                            	%>
	                            	</div>
	                            <% 	
	                            	}
                            	}
                            	else {
                            		// 아무것도 없다면 빈 입력파일 넣기.
                            	%>
                            		<div>
	                            	<input type="file" class="input_file" name="notiFile_1">
	                            	<Button type="button" class="img_remove small_btn btn_red" onclick="removeImage(this)">제거</Button>
	                            	<Button type="button" class="img_add small_btn btn_white" onclick="addImage()">추가</Button>
	                            	</div>
	                            <%
                            	}
                            	%>
                            	</div>
                            </td>
                        </tr>
                    </tbody>

                </table>
            </div>

            <div class="action_box">
                <div>
                    <button type="button" class="large_btn btn_white" onclick="location.href='view.jsp?nno=<%=nno%>'">취소</button>
                    <button type="button" class="large_btn btn_red" onclick="modify(this)">수정</button>
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