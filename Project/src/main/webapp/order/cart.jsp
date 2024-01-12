<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    
<%@ page import="java.util.ArrayList" %>
<%@ page import="allkeyboard.vo.BuyItem" %>
<%@ page import="ateam.db.DBManager" %>

<%
request.setCharacterEncoding("UTF-8");

	//장바구니는 기본적으로 세션에 담겨있음. (회원인경우 세션정보를 DB에 저장함)
	ArrayList<BuyItem> cartItemList = (ArrayList<BuyItem>)session.getAttribute("cartList");
	
	// 데이터가 없으면 테스트 데이터 삽입
	if(cartItemList == null)
	{
		cartItemList = new ArrayList<BuyItem>();
		
		cartItemList.add(new BuyItem(1,1));
		cartItemList.add(new BuyItem(3,2));
		cartItemList.add(new BuyItem(5,1));
		cartItemList.add(new BuyItem(20,5));
		
		session.setAttribute("cartList", cartItemList);
		
	}
	
	if(cartItemList != null)
	{
	
		int size = cartItemList.size();		
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항</title>
<link href="<%=request.getContextPath()%>/css/base.css" type="text/css" rel="stylesheet">
<link href="<%=request.getContextPath()%>/css/order/cart.css" type="text/css" rel="stylesheet">
<script src="<%=request.getContextPath()%>/js/jquery-3.7.1.min.js"></script>
<script>
	
	// 페이지가 열리고 모든 totalPrice를 계산해서 배송비 넣기. (20만이상시 무료)
	$(document).ready(function(){
		calculateCartArea();
		calculatePriceArea();
    });
	
	
	function calculateCartArea(){
		let totalPrice = 0;
		
		// ws comment - 이거 수정중
		let reg = /원/gi;
		$("#cart_table .td_total_price").each(function(index,data){
				totalPrice += parseInt($(data).text().replace(reg,''));
			}	
		);
		
		let deliveryFee = 2500;
		//20만 이상일때 배송비 무료
		if(totalPrice >= 200000){
			deliveryFee = 0;
		}
		
		let html = "기본-금액별<br>배송비 "+ deliveryFee +"원<br>(택배)";
		$("#td_delivery").html(html);
		
		
		/// price area
		let productCnt = $(".cart_table tbody tr").length;
		console.log($(".cart_table tbody tr").length);
		$("#totalItemsCnt").text(productCnt);
		$("#totalItemPrice").text(totalPrice);
		$("#delivery").text(deliveryFee);
		$("#totalPrice").text(totalPrice+deliveryFee);
		
	}
	
	function calculatePriceArea()
	{
		
	}
	
	function calculatePriceArea()
	{
		
	}
	
	function editQuantity(o){
		
	}
</script>
</head>
<body>
	<%@ include file="/include/header.jsp"%>
	
	<main>
        <hr id="main_line">
        <div class="inner_member clearfix">
            <h3>장바구니</h3>
            <hr id="main_line2">
        </div> <!--inner_member-->

        <div class="content_box">
            <form name="cart_form">            	
<%
            	
				if(size == 0){
%>
				<p class="no_data">
					장바구니에 담겨있는 상품이 없습니다.
				</p>
<%
				}else {
%>
				<table class="cart_table" id="cart_table">
                    <colgroup>
                            <col width="3%"> <!-- 체크 -->
                            <col width="50%"> <!-- 이미지+제목 공간 -->
                            <col width="13%"> <!-- 금액 -->
                            <col width="5%"> <!-- 수량 -->
                            <col width="13%"> <!-- 합계 -->
                            <col >           <!-- 배송비 -->
                    </colgroup>
                    <thead>
                        <tr class="cart_list_head">
                            <th><input type="checkbox" name="cart_list_all" checked></th>
                            <th>상품명</th>
                            <th>금액</th>
                            <th>수량</th>
                            <th>합계</th>
                            <th>배송비</th>
                        </tr>
                    </thead>
                    <tbody>
<%		
						DBManager db = new DBManager();
						if(db.connect())
						{
							String sql = "SELECT pname, price, inventory FROM product WHERE pno=? and delyn='n'";
                    		for(int i=0;i<size;i++)
                    		{
                    			// DB에서 상품정보 가져옴.
	                    		BuyItem item = cartItemList.get(i);
	                    		if(db.prepare(sql).setInt(item.getPno()).read())
	                    		{
									if(db.getNext())
									{
										String name = db.getString("pname");
										int price = db.getInt("price");
										int inventory = db.getInt("inventory"); // 재고 : ws comment - 아직 재고없음 처리 안되어있음.
%>							
									<tr>
		                            <td class="td_chk"><input type="checkbox" name="pno_<%=item.getPno()%>" checked></td>
									<td><a href="<%=request.getContextPath()%>/order/cart/detailView.jsp?pno=<%=item.getPno()%>"><%=name%></a></td>		
									<td><strong class="td_price"><%= price %></strong>원</td>
									<td><input type="number" onChange="editQuantity(this)" value="<%=item.getQuantity()%>"  name="pcnt_<%=item.getPno()%>"></td>
									<td><strong class="td_total_price"><%= price * item.getQuantity() %></strong>원</td>
<%									
										if(i==0)
										{			
%>						
											<td id="td_delivery" rowspan="<%=size%>"></td>
<%
										} // if(size>=2 && i==0)
%>
									</tr>
<%
									} // if(db.getNext())
	                    		} //if(db.prepare(sql).setInt(item.getPno()).read())
                    		} // for(int i=0;i<size;i++)		
						} // if(db.connect())
%>
                    </tbody>

                </table>
<%					
				}   	
%>
            	
                <div class="shop_go_link">
                    <!-- 계속 쇼핑하기-->
                    <a href="#"> <em>&lt;계속 쇼핑하기</em></a>
                </div>

                <div class="price_area">
                    <div class="price_sum_list">
                        <div>
                            총 <strong id="totalItemsCnt">2</strong>개의 상품금액 <br>
                            <strong id="totalItemPrice">350,000</strong>원
                        </div>
                        <div>
                            <!--<img src="#" alt="+">--> +
                        </div>
                        <div>
                            배송비 <br>
                            <strong id="delivery">0</strong>원
                        </div>
                        <div>
                            <!--<img src="#" alt="+">--> =
                        </div>
                        <div>
                            합계 <br>
                            <strong id="totalPrice">0</strong>원
                        </div>

                    </div>

                </div>

                <div class="order_area">
                    <div class="order_left_area">
                        <button type="button" class="medium_btn btn_white" >선택 상품 삭제</button>
                    </div>
                    
                    <div class="order_right_area">
                        <button type="button" class="large_btn btn_white">선택 상품 구매</button>
                        <button type="button" class="large_btn btn_red">전체 상품 구매</button>
                    </div>
                </div>

            </form>
        </div>
        
        
        
    </main>
	
	<%@ include file="/include/footer.jsp"%>
</body>
</html>


<%		
	}
%>