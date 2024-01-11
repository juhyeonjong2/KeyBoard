<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "allkeyboard.vo.Product" %>
<%@ page import = "ateam.db.DBManager" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 목록</title>
<link href="<%= request.getContextPath()%>/css/base.css" type="text/css" rel="stylesheet">
<link href="<%= request.getContextPath()%>/css/product.css" type="text/css" rel="stylesheet">
</head>
<body>
<%@ include file="/include/header.jsp"%>
 <hr id="main_line">
	<div class="is">
    	<section>
	<div>
		<div>
			<div>
				<!-- <h3><a href="./product_DetailView.html"><img src="../image/< %= product.getPfrealname() %>" style="width:100%;"></a></h3> -->
				<p><a href="./product_DetailView.html"><Strong><%= request.getPname() %></Strong></a></p>
				<p><%= request.getPrice() %>원</p>
			</div>
		</div>
	</div>
	
	
	
	
			<!--  
                <h2 style="height: 100px;">LEOPOLD 키보드</h2>
                <div>
                <ul class="ul1">
                    <li>
                        <div>
                            <div>
                                <a href="./product_DetailView.html">
                                    <img src="./keyboard1.jpg">
                                </a>
                            </div>
                            <div class="listA">
                                <a href="./product_DetailView.html" >
                                    <Strong>레오폴드 FC750RBT MX2A코랄 블루 영문</Strong>
                                </a>
                            </div>
                            <div class="listB"><Strong>123,000원</Strong></div>
                        </div>
                    </li>
                    <li>                  
                        <div>
                            <div>
                                <a href="./product_DetailView.html">
                                    <img src="./keyboard1.jpg">
                                </a>
                            </div>
                            <div class="listA">
                                <a href="./product_DetailView.html" >
                                  <Strong>레오폴드 FC750RBT MX2A코랄 블루 영문</Strong>
                                      </a>
                            </div>
                            <div class="listB"><Strong>123,000원</Strong></div>
                        </div>
                    </li>
                    <li>
                        <div>
                            <div>
                                <a href="./product_DetailView.html">
                                    <img src="./keyboard1.jpg">
                                </a>
                            </div>
                            <div class="listA">
                                <a href="./product_DetailView.html" >
                                  <Strong>레오폴드 FC750RBT MX2A코랄 블루 영문</Strong>
                                      </a>
                            </div>
                            <div class="listB"><Strong>123,000원</Strong></div>
                            
                        </div>
                    </li>
                    <li>
                        <div>
                            <div>
                                <a href="./product_DetailView.html">
                                    <img src="./keyboard1.jpg">
                                </a>
                            </div>
                            <div class="listA">
                                <a href="./product_DetailView.html" >
                                  <Strong>레오폴드 FC750RBT MX2A코랄 블루 영문</Strong>
                                </a>
                            </div>
                            <div class="listB"><Strong>123,000원</Strong></div>
                        </div>
                   </li>
                   <li>
                    <div>
                        <div>
                                <a href="./product_DetailView.html">
                                    <img src="./keyboard1.jpg">
                                </a>
                            </div>
                            <div class="listA">
                                <a href="./product_DetailView.html" >
                                  <Strong>레오폴드 FC750RBT MX2A코랄 블루 영문</Strong>
                                      </a>
                           </div>
                          <div class="listB"><Strong>123,000원</Strong></div>
                    </div>
               </li>
                </ul>
                -->
        </div>
<%@ include file="/include/footer.jsp"%>
</body>
</html>