<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="ateam.db.DBManager" %>
<%@ page import="allkeyboard.vo.*" %>
<%@ page import="java.util.*" %>
<%
	request.setCharacterEncoding("UTF-8");
	
	String pnoParam = request.getParameter("pno");
	
	int pno=0;
	if(pnoParam != null  && !pnoParam.equals("")){
		pno = Integer.parseInt(pnoParam);
	}
	
	String directory = "D:/EzenTeamProjectFirst/Project/src/main/webapp/image/product";
	
	product product = new product();
	List<productAttach> attachList = new ArrayList<productAttach>();
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
		
		sql = "SELECT pfno, pno, pfrealname, pforeignname, rdate, pfidx "
				+ " FROM productAttach "
				+ "WHERE pno = ?";
		
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
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="<%= request.getContextPath()%>/css/base.css" type="text/css" rel="stylesheet">
<link href="<%= request.getContextPath()%>/css/product.css" type="text/css" rel="stylesheet">
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
                    <div style="height:35px; font-size:21px;">
                        <strong>임시이름</strong>
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
                                        
                                    </td>
                                </tr>
                                <tr class="trs">
                                    <td>
                                        <strong>배송비</strong>
                                    </td>
                                    <td>
                                        2,500원 / 주문시 결제(선결제)
                                    </td>
                                </tr>
                                <tr class="trs">
                                    <td>
                                        <strong>상품코드</strong>
                                    </td>
                                    <td>
                                        99999
                                    </td>
                                </tr>
                                <tr class="trs">
                                    <td>
                                        <strong>브랜드</strong>
                                    </td>
                                    <td>
                                        LEOFOLD
                                    </td>
                                </tr>
                                <tr class="trs">
                                    <td>
                                        <strong>상품재고</strong>
                                    </td>
                                    <td>
                                        40개
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    <table class="tab3" style="border-collapse: collapse; background-color:aliceblue; height:65px"> <!-- 가격 정보 -->
                        <tbody>
                            <tr>
                                <td style="width:390px;">
                                    <strong>레오폴드 FC750RBT MX2A코랄 블루 영문</strong>
                                </td>
                                <td width="100px">
                                    <span>
                                        <span>
                                            <input type="text" value="1" style="width: 50px; height:36px; text-align:center; float: left;">
                                            <span class="spa1">
                                                <button class="but1" type="button" title="증가">∧</button>
                                                <button class="but1" type="button" title="감소">∨</button>
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
                   		<button id="but2" style="margin-right: 10px; background-color: white;">
                   	     	장바구니
                  	  	</button>
                   	 	<button id="but2" style="width: 200px;">
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
                	<li><a href="#delivery">배송안내</a></li>
                	<li><a href="#exchange">교환 및 반품 안내</a></li>
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
                	<li><a href="#delivery">배송안내</a></li>
                	<li><a href="#exchange">교환 및 반품 안내</a></li>
                	<li><a href="#qna">상품 후기</a></li>
                </ul>
            </div>
         	<div id="delivery">
                <h3 style="margin-bottom: 30px;">배송안내</h3>
                <p>
                임시 배송 안내
                </p>
            </div>
            
            <div class="tab_content">
                <ul>
                	<li><a href="#detail">상세정보</a></li>
                	<li><a href="#delivery">배송안내</a></li>
                	<li><a href="#exchange">교환 및 반품 안내</a></li>
                	<li><a href="#qna">상품 후기</a></li>
                </ul>
            </div>
               <div id="exchange">
                	<h3 style="margin-bottom: 30px;"> 교환 및 반품 안내</h3>
                	<p>
                	임시 교환 및 반품 안내
                	</p>
               </div>
            <div class="tab_content">
                 <ul>
                	<li><a href="#detail">상세정보</a></li>
                	<li><a href="#delivery">배송안내</a></li>
                	<li><a href="#exchange">교환 및 반품 안내</a></li>
                	<li><a href="#qna">상품 후기</a></li>
                </ul>
            </div>
            <div id="qna">
                <h3 style="margin-bottom: 30px;">상품 후기</h3>
                <p>
                임시 상품 후기
                </p>
            </div>
     	</div>
	</main>
</body>
</html>

<%
	db.disconnect();
}
%>