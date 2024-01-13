<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="ateam.db.DBManager" %>
<%@ page import="allkeyboard.vo.*" %>
<%@ page import="java.util.*" %>
<%
request.setCharacterEncoding("UTF-8");
Member member = (Member)session.getAttribute("login");
	
	String pnoParam = request.getParameter("pno");
	
	int pno= 1; /* 임시로 1로 값 지정 */ //아래 작업으로 인해 널값으로 바뀌는 듯함
	if(pnoParam != null  && !pnoParam.equals("")){
		pno = Integer.parseInt(pnoParam);
	}
	
	
	/*String directory = "D:/EzenTeamProjectFirst/Project/src/main/webapp/image/product";*/
	
	Product product = new Product();
	/*List<ProductAttach> attachList = new ArrayList<ProductAttach>();*/
	
	List<Review> rlist = new ArrayList<Review>(); //리뷰 목록 리뷰 클래스 11111111111111111111111111111111111111111111111
	DBManager db = new DBManager();
	
	
	if(db.connect()) {
		
		String sql = "SELECT pno, pname, price, brand, inventory FROM product WHERE pno=? AND delyn='n'";
		
		if(db.prepare(sql).setInt(pno).read()) {
			if(db.getNext()) {
				product.setPno(db.getInt("pno"));
				product.setPname(db.getString("pname"));
				product.setPrice(db.getInt("price"));
				product.setBrand(db.getString("brand"));
				product.setInventory(db.getInt("inventory"));
			}
		}
		
		
/* 		sql = "SELECT pfno, pno, pfrealname, pforeignname, rdate, pfidx " // 후기파트 구문사용을 위해 미완성인 sql구문을 잠시 주석처리했습니다.
		+ " FROM productAttach "
		+ "WHERE pno = ?"; */
		
		/*
		if(db.prepare(sql).setInt(product.getPno()).read()){
			while(db.getNext()){
			productAttach attach = new productAttach();
			attach.setPfno(db.getInt("nfno"));
			attach.setPno(db.getInt("nno"));
			attach.setRealFileName(db.getString("pfrealname"));
			attach.setForeignFileName(db.getString("pforeignname"));
			attach.setRdate(db.getString("rdate"));
			attach.setPfidx(db.getInt("pfidx"));
			attachList.add(attach);
			}
		}
		
		attachList.sort((a,b)->{
			return a.getPfidx() - b.getPfidx();
		});
	*/
	
	// 후기 파트 ////////////////////////////////////////////////////////////////////////////////////////
	
	// 후기의 정보들을 가져온다 (m.mname은 받아오려면 db수정 필요 할듯하다)
	sql = " select r.rno, r.pno, m.mname, m.mno, r.rnote "
			+ "   from review r "
			+ " inner join member m "
			+ "     on r.mno = m.mno "
			+ "  where r.pno = ? ";
	
	 if( db.prepare(sql).setInt(1).read()) //상품번호는 일단 1로 나중에 수정 필요
	 {
		while(db.getNext()){
			Review review = new Review();
			review.setRno(db.getInt("rno"));
			review.setPno(db.getInt("pno"));
			review.setMno(db.getInt("mno"));
			review.setRnote(db.getString("rnote"));
				
			rlist.add(review);
			}
	 }
	 
	
	
	
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="<%= request.getContextPath()%>/css/base.css" type="text/css" rel="stylesheet">
<link href="<%= request.getContextPath()%>/css/product.css" type="text/css" rel="stylesheet">
<link href="<%= request.getContextPath()%>/css/review1.css" type="text/css" rel="stylesheet">
<script src="<%= request.getContextPath()%>/js/jquery-3.7.1.min.js"></script>
<script>
	function calFn(type, ths) {
		const resultE = document.getElementById("result");
	let number = resultE.innerText;
	
	if(type == 'p') {
		number = parseInt(number) +1;
	} else if(type == 'm') {
		number = parseInt(number) -1;
	}
	
	resultE.innerText = number;
}	
	
</script>
</head>
<body>
	<%@ include file="/include/header.jsp"%>

	<main>
 		<hr id="main_line">
        <div class="is"> <!-- 이미지 파일 -->
            <div class="mImage"> 
                <img src="../image/product/keyboard1.jpg"> 
            </div>
            <div style="width: 680px; float:right"> <!-- 상품 정보 -->
                <div>
                    <div style="height:45px; font-size:21px;">
                        <strong><%= product.getPname() %></strong>
                    </div>
                    <hr style="color:skyblue; width:570px;">
                    <div>
                        <table class="tab2">
                            <tbody>
                                <tr class="trs">
                                    <td width="95px">
                                        <strong>판매가</strong>
                                    </td>
                                    <td>
                                        <%= product.getPrice() %>
                                    </td>
                                </tr>
                                <tr class="trs">
                                    <td>
                                        <strong>배송비</strong>
                                    </td>
                                    <td>
                                        2,500원 / 주문시 결제(선결제) / 결제금액 20만원 이상 0원
                                    </td>
                                </tr>
                                <tr class="trs">
                                    <td>
                                        <strong>상품코드</strong>
                                    </td>
                                    <td>
                                        <%= product.getPno() %>
                                    </td>
                                </tr>
                                <tr class="trs">
                                    <td>
                                        <strong>브랜드</strong>
                                    </td>
                                    <td>
                                        <%= product.getBrand() %>
                                    </td>
                                </tr>
                                <tr class="trs">
                                    <td>
                                        <strong>상품재고</strong>
                                    </td>
                                    <td>
                                        <%= product.getInventory() %>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    <table class="tab3" style="border-collapse: collapse; background-color:aliceblue; height:65px; margin-top:10px;"> <!-- 가격 정보 -->
                        <tbody>
                            <tr>
                                <td style="width:390px;">
                                    <strong><%= product.getPname() %></strong>
                                </td>
                                <td width="100px">
                                    <span>
                                        <span>
                                            <div id="result">1</div>
                                            <span class="spa1">
                                                <button class="but1" type="button" title="증가" onclick="calFn('p', this);">∧</button>
                                                <button class="but2" type="button" title="감소" onclick="calFn('m', this);">∨</button>
                                            </span>
                                        </span>
                                    </span>
                                </td>
                                <td style="width: 90px">
                                    <span><strong>175,000원</strong></span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <hr style="color: skyblue; width:570px;">
                   </div>
                   
                	<div class="bDiv" style="float:right; margin: 15px 100px 0 0;">
                   		<button id="butt2" style="margin-right: 10px; background-color: white;">
                   	     	장바구니
                  	  	</button>
                   	 	<button id="butt2" style="width: 200px;">
                  	     	바로구매
                    	</button>
                	</div>
            	</div>
        	</div>
        </div>
        
        <!-- 상세정보 하단부분 -->
        <div style="text-align: center"> 
            <div class="tab_content">
                <ul>
                	<li><a href="#detail">상세정보</a></li>
                	<li><a href="#qna">상품 후기</a></li>
                </ul>
            </div>
            <div id="detail">
                <h3 style="margin-bottom: 30px;" id="list1">상품 상세 정보</h3>
                <div class="imgBox">
                    <p align="center">
                        <img src="#">
                        임시 상품 상세 정보
                    </p>
                    <p align="center">
                        <img src="#">
                    </p>
                </div>
            </div>
           
            <div class="tab_content">
                 <ul>
                	<li><a href="#detail">상세정보</a></li>
                	<li><a href="#qna">상품 후기</a></li>
                </ul>
            </div>
            <div id="qna"><!-- 후기!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! -->
<%
            	if(member != null){ //로그인 된 경우만 이게 보이도록
%>
                <div class="inner_member2 clearfix">
                <form name="reviewfrm" id="reviewBox" action="reviewWriteOk.jsp?pno=<%=pno %>" method="post">
                    <textarea id="textarea" name="rnote" maxlength = "100"></textarea>
                    <input type="submit" id="submitBt" value="후기 작성하기">
                </form>
<%
            	}
%> 
 		<div class="reviewRow inner_member2 clearfix">
<%
		for(Review review : rlist){
			
%>
			<div class="reviewBox2">
				<div id="idBox"><%=review.getMno()%>번 유저</div> 
		            <span class="reviewarea"><%=review.getRnote()%></span> 
		            <div id="review_modifyBox">
			            <button class="reviewBt" onclick="location.href='review_modifyOk.jsp?rno=<%=review.getRno()%>'">수정</button> 
			            <button class="reviewBt" onclick="location.href='review_deleteOk.jsp?rno=<%=review.getRno()%>'">삭제</button>
		       		</div>
	        </div>			
<%
		}
%>
		</div>
    </div><!--inner_member2--> 		
            </div> <!-- 후기!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! -->
     	</div>
     		<%@ include file="/include/footer.jsp"%>
	</main>
</body>
</html>

<%
	db.disconnect();
}
%>