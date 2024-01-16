<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
	String onoParam = request.getParameter("ono");
	
	int ono=0;
	if(onoParam != null  && !onoParam.equals("")){
		ono = Integer.parseInt(onoParam);
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 결과</title>
<link href="<%=request.getContextPath()%>/css/base.css" type="text/css" rel="stylesheet">
<link href="<%=request.getContextPath()%>/css/order/result.css" type="text/css" rel="stylesheet">
<script src="<%=request.getContextPath()%>/js/jquery-3.7.1.min.js"></script>
</head>
<body>
	<%@ include file="/include/header.jsp"%>
	
	 <main>
        <hr id="main_line">
        <div class="inner_member clearfix">
            <h3>구매 결과</h3>
            <hr class="main_line2">
        </div> <!--inner_member-->

        <div class="content_box">
            <form name="result_frm">
                <div class="result_area">
                    <div class="result_info">
                        주문이 완료 되었습니다.<br>
                        주문번호는 <strong id="order_no"><%=ono%></strong> 입니다.
                    </div>
                    <div>
                        <button type="button" class="large_btn btn_red" onclick="location.href='<%=request.getContextPath()%>'"> 확인 </button>
                    </div>
                </div>

            </form>
        </div>
    </main>
	
	<%@ include file="/include/footer.jsp"%>
</body>
</html>




