<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="allkeyboard.vo.Product" %>
<%@ page import="ateam.db.DBManager" %>
<%@ page import="allkeyboard.vo.Member" %>
<%@ page import="allkeyboard.vo.ProductAttach" %>
<%@ page import="allkeyboard.util.CertHelper" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
  request.setCharacterEncoding("UTF-8");
  Member member = (Member)session.getAttribute("login");
  String method = request.getMethod();
  List<ProductAttach> attachList = new ArrayList<ProductAttach>();
  Product p = new Product();

	String pnoParam = request.getParameter("pno");
	
	int pno=0;
	if(pnoParam != null && !pnoParam.equals("")){
		pno = Integer.parseInt(pnoParam);
	}
	
	// admin 체크
	boolean isAdmin1 = false; 
	if(member != null){
		isAdmin1 = CertHelper.isAdmin(member.getMno(), member.getToken());
	}
	
	// admin이 아니면 접근 불가.
	if(!isAdmin1)
	{
		%>
		<script>
			alert("잘못된 접근입니다.");
			location.href='list.jsp';
		</script>
		<%
		// js 실행은 클라에서 되는거고 서버단에서 먼저 실행되버린다. 따라서 else로 아래 실행을 못하게 막는다. (else처리 안하면 잘못된접근입니다 뜨면서 아래 실행됨.)	
	} else {
		
		// DB에서 기존 정보를 가져와서 미리 채워줘야한다.	
		String saveDir = "image/product";
		String saveDirectoryPath = application.getRealPath(saveDir); // 절대 경로 안쓰기위해 톰캣쪽에 저장됨. (디비 합치면 못씀.) 
		// List<ProductAttach> attachList = new ArrayList<ProductAttach>();
		// Product p = new Product(); 이 두가지를 인식 못함
		
		
		DBManager db = new DBManager();
	
	if(db.connect())
	{
		 String sql = "SELECT pname   "
					+" , price "
					+" , brand " 
					+" , description " //아직 사용처 없음
					+" , inventory " 
				 	+"  FROM product"
					+" WHERE pno=? ";
		 
		 if( db.prepare(sql).setInt(pno).read())
		 {
			 if(db.getNext())
			 {
					p.setPname(db.getString("pname"));
					p.setPrice(db.getInt("price"));
					p.setBrand(db.getString("brand"));
					p.setDescription(db.getString("description")); 
					p.setInventory(db.getInt("inventory"));			 			
			 }
		 }
		 
		 	//이미지 파일 가져오기
	 		sql = "SELECT pfno, pno, pfrealname, pforeignname, rdate, pfidx "
	 				+ " FROM productAttach "
	 				+ "WHERE pno = ?"; 
	 		ProductAttach thumbnail = new ProductAttach(); // 썸네일 저장용 으로 여기다가
			ProductAttach attach = new ProductAttach();
	 		
			if(db.prepare(sql).setInt(pno).read()){
				while(db.getNext()){ //next로 차근차근 전부 가져온다.
					int index = db.getInt("pfidx");
				if(index == 0){
					thumbnail.setPfno(db.getInt("pfno"));
					thumbnail.setPno(db.getInt("pno"));
					thumbnail.setPfrealname(db.getString("pfrealname"));
					thumbnail.setPforeignname(db.getString("pforeignname"));
					thumbnail.setRdate(db.getString("rdate"));
					thumbnail.setPfidx(db.getInt("pfidx"));
					//attachList.add(thumbnail); 썸네일은 넣을 필요 없을 듯 함
				}else{
					attach.setPfno(db.getInt("pfno"));
					attach.setPno(db.getInt("pno"));
					attach.setPfrealname(db.getString("pfrealname"));
					attach.setPforeignname(db.getString("pforeignname"));
					attach.setRdate(db.getString("rdate"));
					attach.setPfidx(db.getInt("pfidx"));
					attachList.add(attach);
				}
				}
			}
			
			//이부분이 순서 맞추는건데 일단 보류
			attachList.sort((a,b)->{
				return a.getPfidx() - b.getPfidx();
			});
	 		 		
	 		
		 db.disconnect();
	} //디비 커넥트			

	}//else문
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 상품 수정</title>
<link href="<%= request.getContextPath()%>/css/base.css" type="text/css" rel="stylesheet">
<link href="<%= request.getContextPath()%>/css/product/list.css" type="text/css" rel="stylesheet">
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
	console.log("2");
}

function addImage(){
	

	// 추가 버튼은 맨 아래 자식에만 존재해야 함.
	//let childCnt = $("#imageList").children().length;
	let childCnt = $("#imageList div").length;
	
	// 추가 버튼을 포함하여 맨 아래에 추가
	let html = '<div>';
	html += ' <input type="file" class="input_file" name="productFile_' + (childCnt) + '">';
	html += ' <Button type="button" class="img_remove small_btn btn_red" onclick="removeImage(this)">제거</Button>';
	html += ' <Button type="button" class="img_add small_btn btn_white" onclick="addImage()">추가</Button>';
	html += '</div>';
		
	$("#imageList").append(html);   
	console.log("1");
	refreshAddButton();	
	
	
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
	console.log("3");
}

function modifyImageOk(o){
	// 해당라인의 부모 div를 찾고
	// input을 찾은다음에 name을 가져온다. 해당값을 저장해둠
	let parent = $(o).parent("div");
	
	//수정용 버튼들 삭제
	parent.children(".img_modify_sub").each(function (index, item){
		$(item).remove();});
	
	// 원래 버튼들 추가. (완료라면 수정은 다시 못함.)                      	
	let html = ' <Button type="button" class="img_remove small_btn btn_red" onclick="removeImage(this)">제거</Button> ';
	parent.children(".input_file").after(html);
	
	refreshAddButton();
	console.log("4");
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
		$(item).remove();});
	
	
	// 원래 버튼들 추가.                        	
	html = ' <Button type="button" class="img_remove small_btn btn_red" onclick="removeImage(this)">제거</Button> '; 
	html+= ' <Button type="button" class="img_modify small_btn btn_red" onclick="modifyImage(this)">수정</Button> ';
	parent.children(".input_txt").after(html);
	
	refreshAddButton();
	console.log("5");
	
}




function removeImage(o){

	// 자신을 삭제
	$(o).parent().remove(); // 부모 div를 삭제해서 항목을 삭제함.
	
	
	// 모든 자식리스트를 돌면서 input="file"의 번호를 순차부여
	//let childCnt = $("#imageList").children().length;
	let childCnt = $("#imageList div").length;
	
	$("#imageList div input").each(function (index, item)
		{
			$(item).attr("name", "productFile_" + (index) );
		}
	);
	
	// 추가 버튼을 모두 삭제하고 맨아래에 다시 추가.
	refreshAddButton();
	
}

function modify(o){
	

	// 	제목 내용이 비어있지 않은지 확인.
	if( $("#pname").val() == "" ||$("#pname").val() == null)
	{
		alert("이름 없음");
		return false;
	}
	
	if( $("#price").val() == "" ||$("#price").val() == null)
	{
		alert("가격 없음");
		return false;
	}
	
	if( $("#brand").val() == "" ||$("#brand").val() == null)
	{
		alert("브랜드 없음");
		return false;
	}
	
	if( $("#inventory").val() == "" ||$("#inventory").val() == null)
	{
		alert("재고량 없음");
		return false;
	}
	
	
	
	// Input이 몇개인지 기록해서 보낸다.
	let childCnt = $("#imageList div input").length;
	$("#fileCount").attr("value", childCnt);
	
	
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
				
				
				if(imgFile != "" && imgFile != null) 
				{
					fileSize = $(item)[0].files[0].size;
				    if(!imgFile.match(fileForm)) 
				    {
				    	alert("이미지 파일만 업로드 가능");
				    	isError = true;
						return false; // break;
				    } else if(parseInt(fileSize) >= parseInt(maxSize)) 
				    {
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
		<h2 style="margin: 20px 0; text-align: center;">상품 수정</h2>
        <div>
            <form name="frm" action="modifyOk.jsp" method="post" enctype="multipart/form-data">
                <table class="tab1">
                    <tbody>
                        <tr>
                            <th>상품번호</th>
                            <td><%=pno %></td>
                        </tr>
                        <tr>
                            <th>상품명</th>
                            <td><input type="text" id="pname" name="pname" value="<%=p.getPname()%>"></td>
                        </tr>
                        <tr>
                            <th>판매가</th>
                            <td><input type="number" id="price" name="price" value="<%=p.getPrice()%>"></td>
                        </tr>
                        <tr>
                            <th>브랜드</th>
                            <td><input type="text" name="brand" id="brand" value="<%=p.getBrand()%>"></td>
                        </tr>
                        <tr>
                            <th>재고수량</th>
                            <td><input type="number" id="inventory" value="<%=p.getInventory()%>" name="inventory"></td>
                        </tr>
                        <tr>
                            <th>상세설명</th>
                            <td>
                                <textarea name="description" id="description"><%=p.getDescription()%></textarea>
                            </td>
                        </tr>
                        <tr>
                            <th>이미지</th>
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
	                            	<input type="text" class="input_txt" name="productFile_<%=i%>" readonly value="<%=attachList.get(i).getPforeignname()%>">
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
                            		// 아무것도 없다면 추가 버튼 넣어두기.
                            	%>
                            		<Button type="button" class="img_add small_btn btn_white" onclick="addImage()">추가</Button>
	                            <%
                            	}
                            	%>
                            	</div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            	<div class="divA">
            		<button type="submit" class="btn_red">수정</button>
                	<a href="<%=request.getContextPath()%>/login/adminPage.jsp" class="btn_white ex">취소</a>
            	</div>
           	</form>
        </div>
	</main>
	
	<%@ include file="/include/footer.jsp"%>
	
</body>
</html>