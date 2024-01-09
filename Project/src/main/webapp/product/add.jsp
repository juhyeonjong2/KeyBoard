<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 상품등록</title>
<link href="<%= request.getContextPath()%>/css/base.css" type="text/css" rel="stylesheet">
<link href="<%= request.getContextPath()%>/css/product.css" type="text/css" rel="stylesheet">
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
                            <th>상품번호</th>
                            <td><input type="text" name="pno"></td>
                        </tr>
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
                                <input type="file" name="description">
                            </td>
                        </tr>
                        <tr>
                            <th>이미지</th>
                            <td>
                                <input type="file" name="pfno"> <!-- name에 어떤 것을 지정해야될지 모르겟음 -->
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