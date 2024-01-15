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
	
	function updateDeliveryFee(){
		
		// td_delivery를 찾아서 삭제.
		$("#td_delivery").remove();
		
		// 테이블의 tr을 게산해서 배송비용 td 추가.
		let trList = $("#cart_table tbody tr");
		let html = '<td id="td_delivery" rowspan="' +trList.length  + '"></td>';
		trList.first().last().append(html);
		
	}
	
	function calculateCartArea(){
		
		updateDeliveryFee();
		
		// 모두 구입(체크)한다는 가정하에 배송비 책정됨.
		let totalPrice = 0;
		
		let reg = /원/gi;
		$("#cart_table .td_total_price").each(function(index,data){
				totalPrice += parseInt($(data).text().replace(reg,''));
			}	
		);
		
		let deliveryFee = 2500;
		//20만 이상일때 배송비 무료
		if(totalPrice >= 200000 || totalPrice == 0){
			deliveryFee = 0;
		}
		
		let html = "기본-금액별<br>배송비 "+ deliveryFee +"원<br>(택배)";
		$("#td_delivery").html(html);
	}
	
	function calculatePriceArea()
	{
		// 실제 금액으로 선택된 상품들 기준으로 가격과 배송비가 책정됨.
		let totalPrice = 0; // 선택된 총금액
		let productCnt = 0; // 선택된 개수
		
		let reg = /원/gi;
		$("#cart_table .td_chk").each(function(index,data){	
				if($(data).is(':checked')) {
					// closest은 모든 부모요소중 선택해서 들고올수 있고, find는 자손도 찾울수 있다.
					totalPrice += parseInt($(data).closest("tr").find(".td_total_price").text().replace(reg,''));
					productCnt++;
				}
			}	
		);
		
		let deliveryFee = 2500;
		//20만 이상일때 배송비 무료
		if(totalPrice >= 200000 || totalPrice == 0){
			deliveryFee = 0;
		}
		
		/// price area
		$("#totalItemsCnt").text(productCnt);
		$("#totalItemPrice").text(totalPrice);
		$("#delivery").text(deliveryFee);
		$("#totalPrice").text(totalPrice+deliveryFee);
	}

	
	function editQuantity(o){
		let val = parseInt($(o).val());
		if(val < 0){ // 음수 안됨
			val = 0;
			$(o).val(val);
		}
		
		// 1. html 데이터 갱신 td_total_price 찾아서 변경.
		let trParent = $(o).closest("tr");
		// 금액 가져오기
		let price = parseInt(trParent.find(".td_price").text());
		// 총 금액 입력
		let totalPrice = price * val;
		trParent.find(".td_total_price").text(totalPrice);
		
		
		// 2. 세션 데이터 갱신 (ajax를 통해 서버에 갱신)
		let pno = parseInt(trParent.find(".td_chk").attr("name").replace("pno_", ""));
		// 스크립틀릿 사용가능? ㄴㄴ 안됨 이미 페이지가 만들어진 이후라 코드없음. 어찌됬든 리퀘스트가 일어나야함.
		// 해당페이지에서 처리하는건 ajax로 가능함.
		// 전송전에 객체를 비활성처리
		$(o).attr("disabled",true);
		
		$.ajax({
			url : "<%=request.getContextPath()%>/order/cartUpdateOk.jsp",
			type : "post",
			data : {pno:pno, quantity:val},
			success : function(data){
				// 연속으로 호출하면 처리에 부담이 되므로 수량 변경시에  기능을 잠구고 SUCCESS가 오면 잠금을 풀어주자.
				if(data.trim() == 'SUCCESS'){
					$(o).removeAttr("disabled"); 
				}
			},
			error : function(){
				//consloe.log("FAIL");
				$(o).removeAttr("disabled"); 
			}
		});

		// 3. 금액 제계산.
		calculateCartArea();
		calculatePriceArea();
	}
	
	function toggleAllProduct(o){
		// o 에들어온 체크가 false 면 모두 체크해제.
		let checked = $(o).is(':checked');
		$("#cart_table .td_chk").prop('checked',checked);
		
		calculatePriceArea();
	}
	
	function toggleProduct(o){
		let checked = $(o).is(':checked');
		
		// o가 true인경우 - 모두 true인지 확인하고 모두 true인경우 allChk를 true
		if(checked){
			let isAll = true;
			
			$("#cart_table .td_chk").each(function(index,data){
				if($(data).is(':checked') == false){
					isAll = false;
					return false;
				}
			});
			
			if(isAll){
				$("#allchk").prop('checked',true);
			}
		}else { // o가 false인경우 - allChk를 false
			$("#allchk").prop('checked',false);
		}
		
		calculatePriceArea();
	}
	
	function removeSelectedItem()
	{
		$("#cart_table .td_chk").each(function(index,data)
		{
			let pno = parseInt($(data).attr("name").replace("pno_", ""));
			if($(data).is(':checked') == true)
			{
				$.ajax( 
				{
					url : "<%=request.getContextPath()%>/order/cartRemoveOk.jsp",
					type : "post",
					data : {pno:pno},
					success : function(resData)
					{
						if(resData.trim() == 'SUCCESS')
						{
							$(data).closest("tr").remove();
							calculateCartArea();
							calculatePriceArea();
						}
					},
					error : function()
					{
						//consloe.log("FAIL");	 
					}
				});
			}
		});
	}
	
	function buySelectedItem(){
		// 선택된 데이티만 가져오기.
		let selectedItemList = [];

		$("#cart_table .td_chk").each(function(index,data) {
			if($(data).is(':checked') == true)
			{
				let pno = parseInt($(data).attr("name").replace("pno_", ""));
				let quantity = parseInt($(data).closest("tr").find(".td_quantity").val());
				
				let item = {
					"pno" :  pno,
					"quantity" :quantity
				}
				selectedItemList.push(item);
			}
		});
			
		let paramList = {
				"paramList" : JSON.stringify(selectedItemList)
		}
			
		$.ajax( 
		{
			url : "<%=request.getContextPath()%>/order/orderListOk.jsp",
			type : "post",
			data : paramList,
			success : function(resData)
			{
				if(resData.trim() == 'SUCCESS')
				{
					$(data).closest("tr").remove();
					// ws comment - 여기서 페이지 넘김처리 할것.
				}
			},
			error : function()
			{
				//consloe.log("FAIL");	 
			}
		}); 
	}
	
	function buyAllItem(){
		// ajax로 리스트 만들어서 넘기기.
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
                            <th><input type="checkbox" id="allchk" name="cart_list_all" onclick="toggleAllProduct(this)" checked></th>
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
			                            <td><input type="checkbox" class="td_chk" name="pno_<%=item.getPno()%>" onclick="toggleProduct(this)" checked></td>
										<td><a href="<%=request.getContextPath()%>/order/cart/detailView.jsp?pno=<%=item.getPno()%>"><%=name%></a></td>		
										<td><strong class="td_price"><%= price %></strong>원</td>
										<td><input type="number" class="td_quantity" onchange="editQuantity(this)" value="<%=item.getQuantity()%>"></td>
										<td><strong class="td_total_price"><%= price * item.getQuantity() %></strong>원</td>

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
                        <button type="button" class="medium_btn btn_white" onclick="removeSelectedItem()" >선택 상품 삭제</button>
                    </div>
                    
                    <div class="order_right_area">
                        <button type="button" class="large_btn btn_white" onclick="buySelectedItem()">선택 상품 구매</button>
                        <button type="button" class="large_btn btn_red" onclick="buyAllItem()">전체 상품 구매</button>
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