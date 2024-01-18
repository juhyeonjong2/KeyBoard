<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 상품등록</title>
<link href="<%= request.getContextPath()%>/css/base.css" type="text/css" rel="stylesheet">
<link href="<%= request.getContextPath()%>/css/product/list.css" type="text/css" rel="stylesheet">
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
	html += ' <input type="file" name="productFile_' + (childCnt) + '">';
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
			$(item).attr("name", "productFile_" + (index) );
		}
	);
	
	refreshAddButton();
}

function delFn(){
	let isDel = confirm("정말 취소하시겠습니까?");
	 
	if(isDel){
		location.href="<%=request.getContextPath()%>/login/adminPage.jsp";
	}
}
</script>
</head>
<body>
	<%@ include file="/include/header.jsp"%>
	
	<main>
		<div class="inner_member clearfix">
            <h3>상품 등록</h3>
            <hr id="main_line2">
        </div> <!--inner_member-->
        
        <div class="inner_member2 clearfix">
            <form name="frm" action="addOk.jsp" method="post" enctype="multipart/form-data">
                <table class="tab1"> 
                    <tbody>
                        <tr>
                            <th>상품명</th>
                            <td><input type="text" name="pname"></td>
                        </tr>
                        <tr>
                            <th>판매가</th>
                            <td><input type="text" name="price" placeholder="금액만 표기" oninput="this.value=this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"></td>
                        </tr>
                        <tr>
                            <th>브랜드</th>
                            <td><input type="text" name="brand"></td>
                        </tr>
                        <tr>
                            <th>재고수량</th>
                            <td><input type="text" placeholder="수량만 표기" name="inventory" oninput="this.value=this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"></td>
                        </tr>
                        <tr>
                            <th>상세설명</th>
                            <td>
                                <textarea rows=5px cols=22px name="description"></textarea>
                            </td>
                        </tr>
                        <tr> <!-- 이미지부분만 있는 곳 -->
                            <th>이미지</th>
                            <td>
                            	<div id="imageList">
	                            	<Button type="button" class="img_add small_btn btn_white" onclick="addImage()">추가</Button>                            	
                            	</div> 
                            </td>
                        </tr> <!-- 이미지부분만 있는 곳 -->
                    </tbody>
                </table>
                
            	<div class="divA"> <!-- 등록과 취소만 적힌 곳 -->
            		<button type="submit" class="btn_red">등록</button>
                	<a href="<%=request.getContextPath()%>/login/adminPage.jsp" class="btn_white ex">취소</a>
            	</div> <!-- 등록과 취소만 적힌 곳 -->
           	</form> <!-- 전체 폼태그 끝 -->
        </div>
	</main>
	
	<%@ include file="/include/footer.jsp"%>
	
</body>
</html>