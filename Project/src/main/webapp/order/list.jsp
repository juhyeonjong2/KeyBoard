<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<%@ page import="java.util.ArrayList" %>
<%@ page import="allkeyboard.vo.OrderResultItem" %>
<%@ page import="allkeyboard.vo.Order" %>
<%@ page import="allkeyboard.util.CertHelper" %>
<%@ page import="ateam.db.DBManager" %>

<%
	request.setCharacterEncoding("UTF-8");

	//비회원 처리
	String orderName = request.getParameter("ordername");
	String orderNo = request.getParameter("orderno");
	
	// 비회원의 경우 파라메터로 주문자명 + 주문번호를 같이 넘겨야 한다
	// 회원의 경우는 그냥 열려도 됨.
	boolean isMember = false; 
	//1. 로그인 정보 확인
	Member member = (Member)session.getAttribute("login");
	if(member != null && !CertHelper.isExpired(member.getMno(), member.getToken()))
	{ 
		isMember = true;
	}
	else if((orderName == null || orderName.equals(""))  
			|| (orderNo == null || orderNo.equals("")))
	{
		// 로그인되지 않았는데 비회원도 아니면 로그인창으로 보냄.
		response.sendRedirect(request.getContextPath()+"//login//login.jsp?order=2");
	}
	
	
	// 리스트를 채운뒤에 아래 페이지 생성.
	ArrayList<OrderResultItem> orderItemList = new ArrayList<OrderResultItem>();
	DBManager db = new DBManager();
	if(db.connect())
	{
		String sql = "";
		
		ArrayList<Order> orderList = new ArrayList<Order>();
		if(isMember)
		{ 
			// 회원의 경우 주무한것이 있는지 확인.
			sql = "SELECT ono, mno, oname, otell, ophone, oemail, recipient, arrivallocation, "
			    + "recipienttell, recipientphone, onote, paymenttype, deliveryfee, state, depositor, rdate"
			    + " FROM orders WHERE mno=?";
			
			db.prepare(sql).setInt(member.getMno());
		}
		else 
		{
			int ono = 0;
			if(orderNo != null  && !orderNo.equals("")){
				ono = Integer.parseInt(orderNo);
			}	
			
			sql = "SELECT ono, mno, oname, otell, ophone, oemail, recipient, arrivallocation, "
				    + "recipienttell, recipientphone, onote, paymenttype, deliveryfee, state, depositor, rdate"
				    + " FROM orders WHERE ono=? AND oname=?";
			
			db.prepare(sql).setInt(ono).setString(orderName);
		}
		
		// orderList 채우기
		if(db.read())
		{
			while(db.getNext())
			{
				Order order = new Order();
				order.setOno(db.getInt("ono"));
				order.setMno(db.getInt("mno"));
				order.setOname(db.getString("oname"));
				order.setOtell(db.getString("otell"));
				order.setOphone(db.getString("ophone"));
				order.setOemail(db.getString("oemail"));
				order.setRecipient(db.getString("recipient"));
				order.setArrivalLocation(db.getString("arrivallocation"));
				order.setRecipientTell(db.getString("recipienttell"));
				order.setRecipientPhone(db.getString("recipientphone"));
				order.setOnote(db.getString("onote"));
				order.setPaymentType(db.getString("paymenttype"));
				order.setDeliveryFee(db.getInt("deliveryfee"));
				order.setState(db.getString("state"));
				order.setDepositor(db.getString("depositor"));
				order.setRdate(db.getString("rdate"));
				orderList.add(order);
			}
		}
		
			
		// orderItems 가져오기
		sql = "SELECT O.ino as ino, " 
				+ "O.ono as ono,  "
				+ "O.pno as pno, " 
				+ " P.pname as pname, "
				+ " O.price as price, " 
				+ " O.quantity as quantity " 
			+ " FROM orderitem O "
			+ " INNER JOIN product P "
			+ " ON O.pno = P.pno "
			+ " WHERE O.ono =? ";
		
		for(Order order : orderList)
		{
			if(db.prepare(sql).setInt(order.getOno()).read())
			{
				while(db.getNext())
				{
					OrderResultItem orderItem = new OrderResultItem();
					orderItem.setIno(db.getInt("ino"));
					orderItem.setOno(db.getInt("ono"));
					orderItem.setPno(db.getInt("pno"));
					orderItem.setPrice(db.getInt("price"));
					orderItem.setQuantity(db.getInt("quantity"));
					orderItem.setPname(db.getString("pname"));
					orderItem.setRdate(order.getRdate());
					orderItem.setState(order.getState());
					orderItemList.add(orderItem);
				}
			}
		}
		
		db.disconnect();
	}	
	
	int size = orderItemList.size();
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 배송 조회</title>
<link href="<%=request.getContextPath()%>/css/base.css" type="text/css" rel="stylesheet">
<link href="<%=request.getContextPath()%>/css/order/list.css" type="text/css" rel="stylesheet">
<script src="<%=request.getContextPath()%>/js/jquery-3.7.1.min.js"></script>
</head>
<body>
	<%@ include file="/include/header.jsp"%>
	
	<main>
        <hr id="main_line">
        <div class="inner_member clearfix">
            <h3>주문목록/배송조회</h3>
            <hr class="main_line2">
        </div> <!--inner_member-->

        <div class="content_box">
<%
        if(isMember){
        	 // 아쉽지만 시간 관계상 기능 축소. (조회기간 X)
%>        

<!--             <form name="tracking_frm">
                <div class="tracking_area" > hidden
                    <div>
                        조회 기간
                    </div>
                    <div>
                        <input type="radio" name="tracking_range_unit" >오늘
                        <input type="radio" name="tracking_range_unit" checked>7일
                        <input type="radio" name="tracking_range_unit" >15일
                        <input type="radio" name="tracking_range_unit" >1개월
                        <input type="radio" name="tracking_range_unit" >3개월
                        <input type="radio" name="tracking_range_unit" >1년
                    </div>
                    <div>
                        <input id="startTime" type="date" name="starttime" value="2024-01-07">
                        ~
                        <input id="endTime" type="date" name="endtime" value="2024-01-01">
                    </div>
                    <div>
                        <button type="button" class="medium_btn btn_red" > 조회 </button>
                    </div>
                </div>
            </form>
 -->
 <%
        }            
%>

            <div class="tracking_result_area">
                <!-- 배송 정보 -->
                <div class="inner_member clearfix">
                    <h4>주문 목록/배송조회 내역 총 <strong classs="totalCount"><%=size%></strong>건</h4>
                </div> 
<%               
                if(size == 0){
%>
				<p class="no_data">
					주문 내역이 없습니다.
				</p>
<%
				}else {
%>
                <!-- 테이블 -->
                <table class="result_table">
                    <colgroup>
                            <col width="15%"> <!-- 날짜/주문번호 -->
                            <col width="50%"> <!-- 상품명 -->
                            <col width="13%"> <!-- 상품금액/수량 -->
                            <col> <!-- 주문상태 -->
                    </colgroup>
                    <thead>
                        <tr>
                            <th>날짜/주문번호</th>
                            <th>상품명</th>
                            <th>상품금액/수량</th>
                            <th>주문상태</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                    for(int i=0;i<size;i++)
                    {
                    	OrderResultItem or = orderItemList.get(i);
                    %>
                        <tr>
                            <td>
                                <%=or.getRdate()%><br>
                                <%=or.getOno()%>
                            </td>
                            <td><a href="<%=request.getContextPath()%>/product/view.jsp?pno=<%=or.getPno()%>"><%=or.getPname()%></a></td> <!-- 상품 디테일뷰 링크-->
                            <td>
                                <strong><%=or.getPrice()%></strong>원<br>
                                <%=or.getQuantity()%>개
                            </td>
                            <td>
                            <% 
                            	String state = "입금 대기";
                            	switch(or.getState()){
                            	case "0" : 
                            		state = "입금 대기";
                            		break;
                            	case "1" : 
                            		state = "배송 준비";
                            		break;
                            	case "2" : 
                            		state = "배송 중";
                            		break;
                            	case "3" : 
                            		state = "배송 완료";
                            		break;
                            	}
                            %>
                            <%=state%>
                            </td>
                        </tr>
<%
					} // for(int i=0;i<size;i++)
%>
                           
                    </tbody>

                </table>
<%
				}
%>
            </div>

        </div>
    </main>
	
	<%@ include file="/include/footer.jsp"%>
</body>
</html>




