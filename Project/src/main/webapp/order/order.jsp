<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.ArrayList" %>
<%@ page import="allkeyboard.vo.BuyItem" %>
<%@ page import="allkeyboard.util.CertHelper" %>
<%@ page import="ateam.db.DBManager" %>

<%
	request.setCharacterEncoding("UTF-8");

	ArrayList<BuyItem> orderItemList = (ArrayList<BuyItem>)session.getAttribute("orderList");
	// 오더리스트가 null 이거나 size가 0이면. 팝업과 함께 리다이렉트.
	
	if(orderItemList == null || orderItemList.size() == 0)
	{
		%>
		<script>
			alert("주문 목록이 없습니다.");
			location.href="<%=request.getContextPath()%>/product/list.jsp";
		</script>
		<%			
	}
	else  // 주문목록이 있을 때
	{
		boolean isMember = false; 
		//1. 로그인 정보 확인
		Member member = (Member)session.getAttribute("login");
		if(member != null && !CertHelper.isExpired(member.getMno(), member.getToken()))
		{ 
			isMember = true;
		}
		
		int itemSize =  orderItemList.size();
		
%>			

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문</title>
<link href="<%=request.getContextPath()%>/css/base.css" type="text/css" rel="stylesheet">
<link href="<%=request.getContextPath()%>/css/order/order.css" type="text/css" rel="stylesheet">
<script src="<%=request.getContextPath()%>/js/jquery-3.7.1.min.js"></script>
<script>
	//페이지가 열리고 모든 totalPrice를 계산해서 배송비 넣기. (20만이상시 무료)
	$(document).ready(function(){
		calculatePriceArea();
		
	});
	
	function updateDeliveryFee(){
		
		// td_delivery를 찾아서 삭제.
		$("#td_delivery").remove();
		
		// 테이블의 tr을 게산해서 배송비용 td 추가.
		let trList = $("#itemList tbody tr");
		let html = '<td id="td_delivery" rowspan="' +trList.length  + '"></td>';
		console.log(trList.first().last());
		trList.first().last().append(html);
	}
	
	function calculatePriceArea(){
		updateDeliveryFee();
		
		let totalPrice = 0;
		let productCnt = 0;
		
		let reg = /원/gi;
		$("#itemList .td_total_price").each(function(index,data){
				totalPrice += parseInt($(data).text().replace(reg,''));
				productCnt++;
			}	
		);
		
		let deliveryFee = 2500;
		//20만 이상일때 배송비 무료
		if(totalPrice >= 200000 || totalPrice == 0){
			deliveryFee = 0;
		}
		// itemList deliveryFee
		let html = "기본-금액별<br>배송비 "+ deliveryFee +"원<br>(택배)";
		$("#td_delivery").html(html);
		
		/// price info
		$(".totalItemsCnt").text(productCnt);
		$(".totalItemPrice").text(totalPrice);
		$(".deliveryFee").text(deliveryFee);
		$(".totalPrice").text(totalPrice+deliveryFee);
	} 
	
	function isValid()
	{
		// 필수 체크 - 우선 발리데이션 없음. 
		
		return true;
	}
	
	function toggleAllAgree(o)
	{
		let checked = $(o).is(':checked');
		$(".agree_box .agree_chk").prop('checked',checked);
	}
	
	function toggleAgree(o)
	{
		let checked = $(o).is(':checked');
		
		// o가 true인경우 - 모두 true인지 확인하고 모두 true인경우 allChk를 true
		if(checked){
			let isAll = true;
			
			$(".agree_box .agree_chk").each(function(index,data){
				if($(data).is(':checked') == false){
					isAll = false;
					return false;
				}
			});
			
			if(isAll){
				$("#agree_all_chk").prop('checked',true);
			}
		}else { // o가 false인경우 - allChk를 false
			$("#agree_all_chk").prop('checked',false);
		} 
	}
	
</script>
</head>
<body>
	<%@ include file="/include/header.jsp"%>
	
	<main>
        <hr id="main_line">
        <div class="inner_member clearfix">
            <h3>주문서작성/결제</h3>
            <hr class="main_line2">
        </div> <!--inner_member-->

        <div class="content_box">
			 <div class="item_area">
			     <!-- 배송 정보 -->
			     <div class="inner_member clearfix">
			         <h4>주문상세내역</h4>
			     </div> <!--inner_member-->
			     
			     <!-- 테이블 -->
			     <table class="itemList" id="itemList">
			         <colgroup>
			                 <col width="53%"> <!-- 이미지+제목 공간 -->
			                 <col width="13%"> <!-- 금액 -->
			                 <col width="10%"> <!-- 수량 -->
			                 <col width="13%"> <!-- 합계 -->
			                 <col >           <!-- 배송비 -->
			         </colgroup>
			         <thead>
			             <tr>
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
						for(int i=0;i<itemSize;i++)
                   		{
							// DB에서 상품정보 가져옴.
                   			BuyItem item = orderItemList.get(i);
                    		if(db.prepare(sql).setInt(item.getPno()).read())
                    		{
								if(db.getNext())
								{
									String name = db.getString("pname");
									int price = db.getInt("price");
									int inventory = db.getInt("inventory"); // 재고 : ws comment - 아직 재고없음 처리 안되어있음.
%>
                        <tr>
                            <td class="td_product" name="pno_<%=item.getPno()%>"><a href="<%=request.getContextPath()%>/product/view.jsp?pno=<%=item.getPno()%>"><%=name%></a></td>
                            <td><strong class="td_price"><%= price %></strong>원</td>
                            <td><strong class="td_quantity"><%=item.getQuantity()%></strong>개</td>
                            <td><strong class="td_total_price"><%= price * item.getQuantity() %></strong>원</td> 
                        </tr>
<%
                            		} // if(db.getNext())
	                    		} //if(db.prepare(sql).setInt(item.getPno()).read())
                    		}//for(int i=0;i<itemSize;i++)	
							db.disconnect();
						} // if(db.connect())
%>
                            
                     </tbody>
                 </table>
             </div>

             <div class="cart_go_link">
                 <a href="<%=request.getContextPath()%>/order/cart.jsp"> <em>&lt;장바구니 가기</em></a>
             </div>

            <div class="price_area">
                <div class="price_sum_list">
                    <div>
                        총 <strong class="totalItemsCnt">2</strong>개의 상품금액 <br>
                        <strong class="totalItemPrice">350,000</strong>원
                    </div>
                    <div>
                        <!--<img src="#" alt="+">--> +
                    </div>
                    <div>
                        배송비 <br>
                        <strong class="deliveryFee">0</strong>원
                    </div>
                    <div>
                        <!--<img src="#" alt="+">--> =
                    </div>
                    <div>
                        합계 <br>
                        <strong class="totalPrice">0</strong>원
                    </div>
                </div>
            </div>
                
			<form name="order_frm" action="orderOk.jsp" method="post">
<%
				if(!isMember )
				{ // 멤버가 아닐때 동의 박스.
%>
                <div class="agree_box">
                    <!-- 비회원일 때 동의사항 출력-->
                    <input type="checkbox" id="agree_all_chk" onclick="toggleAllAgree(this)"> 세상모든키보드 이용약관 및 비회원 주문에 대한 개인정보 수집 이용 동의를 확인하고 전체 동의합니다.
                    <div class="agree_area">
                        <h4>비회원 주문에 대한 개인정보 수집 이용 동의</h4>
                        <div class="scroll_box">
                            - 수집항목: 성명, 비밀번호, 이메일, 휴대폰번호, 주소, 전화번호 <br>
                            - 수집/이용목적: 서비스 제공 및 계약의 이행, 구매 및 대금결제, 물품배송 또는 청구지 발송, 불만처리 등 민원처리, 회원관리 등을 위한 목적<br>
                            - 이용기간: 원칙적으로 개인정보 수집 및 이용목적이 달성된 후에는 해당 정보를 지체 없이 파기합니다.<br>
                            단, 관계법령의 규정에 의하여 보전할 필요가 있는 경우 일정기간 동안 개인정보를 보관할 수 있습니다.<br>
                            그 밖의 사항은 (주) 000 개인정보처리방침을 준수합니다.
                        </div>
                        <div class="agree_chk_area">
                            <input type="checkbox" class="agree_chk" name="agree_chk_1" onclick="toggleAgree(this)" required> <strong>(필수)</strong> 비회원 개인정보 수집 이용에 대한 내용을 확인 하였으며 이에 동의 합니다.
                        </div>
                    </div>

                    <div class="agree_area">
                        <h4>이용약관 동의</h4>
                        <div class="scroll_box">
                            제24조(재판권 및 준거법) <br>
                            ① "몰"과 이용자간에 발생한 전자상거래 분쟁에 관한 소송은 제소 당시의 이용자의 주소에 의하고, 주소가 없는 경우에는 거소를 관할하는 지방법원의 전속관할로 합니다. 다만, 제소 당시 이용자의 주소 또는 거소가 분명하지 않거나 외국 거주자의 경우에는 민사소송법상의 관할법원에 제기합니다.<br>
                            ② "몰"과 이용자간에 제기된 전자상거래 소송에는 한국법을 적용합니다.<br>
                            <br>
                            부칙 <br>
                            <br>
                            1. 이 약관은 2020년 03월 15일부터 적용됩니다.
                        </div>
                        <div class="agree_chk_area">
                            <input type="checkbox" class="agree_chk" name="agree_chk_2" onclick="toggleAgree(this)" required> <strong>(필수)</strong>이용약관에 대한 내용을 확인 하였으며 이에 동의 합니다.
                        </div>
                    </div>
                </div>
<%
				}
%>
                <div class="order_info">
                    <!-- 주문자 정보 테이블 -->
                    <div class="inner_member clearfix">
                        <h4>주문자 정보</h4>
                    </div> <!--inner_member-->
                     
                    <table class="info_table">
                        <colgroup>
                                <col width="15%"> <!-- 항목 -->
                                <col width="85%"> <!-- 내용  -->
                        </colgroup>
                        <tbody>
                            <tr>
                                <td><span class="important">주문하시는 분</span></td>
                                <td><input type="text" name="order_name" maxlength="20" required></td>
                            </tr>
                            <tr>
                                <td>전화번호</span></td>
                                <td><input type="text" name="order_tell" maxlength="20"></td>
                            </tr>
                            <tr>
                                <td><span class="important">휴대폰 번호</span></td>
                                <td><input type="text" name="order_phone" maxlength="20" required></td>
                            </tr>
                            <tr>
                                <td><span class="important">이메일</span></td>
                                <td>
                                    <input type="email" name="order_email" maxlength="20" required>
                                </td>
                            </tr>
                        </tbody>

                    </table>
                </div>

                <div class="shiping_info">
                    <!-- 배송 정보 -->
                    <div class="inner_member clearfix">
                        <h4>배송 정보</h4>
                    </div> <!--inner_member-->

                    <table class="info_table">
                        <colgroup>
                                <col width="15%"> <!-- 항목 -->
                                <col width="85%"> <!-- 내용  -->
                        </colgroup>
                        <tbody>
                            <tr>
                                <td>배송지 확인</td>
                                <td>
                                <%
                                	if(isMember)
                                	{
                                %>
                                    <input type="radio" name="shiping_radio_chk" value="1">기본 배송지
                                    <input type="radio" name="shiping_radio_chk" value="2" checked>직접 입력
                                    <input type="radio" name="shiping_radio_chk" value="3">주문자 정보와 동일
                                
                                <%    
                                    }
                                    else {
								%>    
									<input type="radio" name="shiping_radio_chk" value="2" checked>직접 입력
                                    <input type="radio" name="shiping_radio_chk" value="3" >주문자 정보와 동일
                                <%    
                                    }
                              	%>
                                </td>
                            </tr>
                            <tr>
                                <td><span class="important">받으실 분</span></td>
                                <td><input type="text" name="shiping_name" maxlength="20" required></td>
                            </tr>
                            <tr>
                                <td><span class="important">받으실 곳</span></td>
                                <td><input type="text" name="delivery_loc" maxlength="200" required></td>
                            </tr>
                            <tr>
                                <td>전화번호</span></td>
                                <td><input type="text" name="shiping_tell" maxlength="20"></td>
                            </tr>
                            <tr>
                                <td><span class="important">휴대폰 번호</span></td>
                                <td><input type="text" name="shiping_phone" maxlength="13" required></td>
                            </tr>
                            <tr>
                                <td>남기는 말씀</td>
                                <td><input type="text" name="shiping_memo" maxlength="200"></td>
                            </tr>
                        </tbody>

                    </table>
                </div>

                <div class="payment_info">
                    <!-- 결제 정보 -->
                    <div class="inner_member clearfix">
                        <h4>결제 정보</h4>
                    </div> <!--inner_member-->

                    <table class="info_table">
                        <colgroup>
                                <col width="15%"> <!-- 항목 -->
                                <col width="85%"> <!-- 내용  -->
                        </colgroup>
                        <tbody>
                          
                            <tr>
                                <td>상품 합계 금액</td>
                                <td><strong class="totalItemPrice">350,000</strong>원</td>
                            </tr>
                            <tr>
                                <td>배송비</td>
                                <td><strong class="deliveryFee">0</strong>원</td>
                            </tr>
                            <tr>
                                <td>최종 결제 금액</td>
                                <td><strong class="totalPrice">350,000</strong>원</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="payment_method_area">
                    <!-- 결제 수단-->
                    <div class="inner_member clearfix">
                        <h4>결제수단 선택 / 결제</h4>
                    </div> <!--inner_member-->

                    <table class="payment_method_area_table">
                        <colgroup>
                                <col width="15%"> <!-- 항목 -->
                                <col width="85%"> <!-- 내용  -->
                        </colgroup>
                        <tbody>
                            <tr>
                                <td>일반결제</td>
                                <td>
                                    <input type="radio" name="payment_method_type" value="1" checked>무통장 입금
                                    <input type="radio" name="payment_method_type" value="2">신용 카드
                                    
                                    <div class="payment_type1"> <!--hidden-->
                                        <!-- 무통장 입금시-->
                                        <table class="payment_table">
                                            <colgroup>
                                                    <col width="25%"> <!-- 항목 -->
                                                    <col width="75%"> <!-- 내용  -->
                                            </colgroup>
                                            <tbody>
                                                <tr>
                                                    <td colspan="2">(무통장 입금의 경우 입금확인 후부터 배송단계가 진행됩니다.)</td>
                                                    <!--<td></td>-->
                                                </tr>
                                                <tr>
                                                    <td>입금자명</td>
                                                    <td> <input type="text" name="payment_type1_name"  maxlength="20" required></td>
                                                </tr>
                                                <tr>
                                                    <td>입금 은행</td>
                                                    <td> <select name="payment_type1_bank" id="payment_type1_bank" required>
                                                        <option value="0">선택하세요.</option>
                                                        <option value="1">이젠은행 고길동 522052-252-123412 </option>
                                                        </select>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

              
                <div class="order_area">
                    <div class="order_sum_list">
                        <div class="order_sum_list_first">
                            최종 결제 금액
                        </div>
                        <div>
                            <strong class="totalPrice">350,000</strong>원
                        </div>
                    </div>

                    <div class="payment_agree_chk_area">
                        <input type="checkbox" name="payment_agree_chk_1" required> <strong>(필수)</strong> 구매하실 상품의 결제정보를 확인하였으며, 구매진행에 동의합니다.
                    </div>
                    
                    <div>
                        <button type="submit" class="large_btn btn_red" onclick="return isValid()">결제 하기</button>
                    </div>
                </div>

            </form>
        </div>
    </main>
	
	<%@ include file="/include/footer.jsp"%>
</body>
</html>



<%	
	} // else
%>
