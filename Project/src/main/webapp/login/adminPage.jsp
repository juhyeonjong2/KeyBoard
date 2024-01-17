<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
<link href="<%=request.getContextPath()%>/css/base.css" type="text/css"
	rel="stylesheet">
<link href="<%=request.getContextPath()%>/css/login.css" type="text/css"
	rel="stylesheet">
<link href="<%=request.getContextPath()%>/css/adminPage.css" type="text/css"
	rel="stylesheet">
</head>
<body>
	<%@ include file="/include/header.jsp"%>
	 <div class="inner_member clearfix">
            <h3>관리자 페이지</h3>
            <hr id="main_line2">
        </div> <!--inner_member-->

        <div class="inner_member2 clearfix">
            <form name="frm" id="loginBox">
                <h4></h4>
                <div class="adminBox"> 
                    <a href="<%=request.getContextPath()%>/product/add.jsp">상품 등록</a>
                </div>
                <div class="adminBox">
                    <a href="">주문 목록</a>
                </div>
            </form>
            </div><!--inner_member2-->
    <%@ include file="/include/footer.jsp"%>
</body>
</html>