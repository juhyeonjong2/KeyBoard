<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 상품등록</title>
<link href="<%= request.getContextPath()%>/css/base.css" type="text/css" rel="stylesheet">
<link href="<%= request.getContextPath()%>/css/product.css" type="text/css" rel="stylesheet">
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
				$(item).attr("class", "productFile_" + (index+1) );
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
		<h2 style="margin: 20px 0; text-align: center;">상품 등록</h2>
        <div>
            <form name="frm" action="./addOk.jsp" method="post" enctype="multipart/form-data">
                <table class="tab1"> 
                	<input type="hidden" name="flag" value="i">
                    <tbody>
                        <tr>
                            <th>상품명</th>
                            <td><input type="text" name="pname"></td>
                        </tr>
                        <tr>
                            <th>판매가</th>
                            <td><input type="text" name="price" placeholder="금액만 표기"></td>
                        </tr>
                        <tr>
                            <th>브랜드</th>
                            <td><input type="text" name="brand"></td>
                        </tr>
                        <tr>
                            <th>재고수량</th>
                            <td><input type="text" placeholder="수량만 표기" name="inventory"></td>
                        </tr>
                        <tr>
                            <th>상세설명</th>
                            <td>
                                <textarea rows=5px cols=22px></textarea>
                            </td>
                        </tr>
                        <tr>
                            <th>이미지</th>
                            <td>
                            	<div id="imageList">
                            		<div>
                                		<input type="file" name="productFile_1"> <!-- name에 어떤 것을 지정해야될지 모르겟음 -->
                                		<Button type="button" class="img_remove small_btn btn_red" onclick="removeImage(this)">제거</Button>
	                            		<Button type="button" class="img_add small_btn btn_white" onclick="addImage()">추가</Button>                            	
	                            	</div>
                            	</div>
                            </td>
                        </tr>
                    </tbody>
                </table>
                
            	<div class="divA">
                	<input type="submit" value="등록">
                	<button><a href="./delete.jsp">취소</a></button>
            	</div>
           	</form>
        </div>
	</main>
	
	<%@ include file="/include/footer.jsp"%>
	
</body>
</html>