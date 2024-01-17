<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<%@ page import="java.util.ArrayList" %>
<%@ page import="allkeyboard.vo.OrderResultItem" %>
<%@ page import="allkeyboard.vo.Order" %>
<%@ page import="allkeyboard.util.CertHelper" %>
<%@ page import="ateam.db.DBManager" %>

<%
	request.setCharacterEncoding("UTF-8");
	
	Member member = (Member)session.getAttribute("login"); // 관리자 검사를위한 세션 들고오기.
	boolean isAdmin = false;
	if(member != null){
		isAdmin = CertHelper.isAdmin(member.getMno(), member.getToken());
	}
	
	
	// 어드민일때만 처리한다.
	
	if( !isAdmin){
		// home으로 보내기
		response.sendRedirect(request.getContextPath());
	}
	else 
	{
		// 기간이 넘어올수 있으므로 파라메터 확인
		String startDate = request.getParameter("st"); // 무조건있어야함.
		String edDate = request.getParameter("st");// 무조건있어야함.
		// 없으면 7일 강제 설정.
		
		
		ArrayList<Order> orderList = new ArrayList<Order>();
		DBManager db = new DBManager();
		if(db.connect())
		{
			String sql = "";
			if(startDate != null && edDate != null){
				sql = "SELECT ono, mno, oname, otell, ophone, oemail, recipient, arrivallocation, "
					    + "recipienttell, recipientphone, onote, paymenttype, deliveryfee, state, depositor, rdate"
					    + " FROM orders WHERE rdate BETWEEN ? AND ?";
				
				db.prepare(sql).setString(startDate).setString(edDate); 
			}
			else {
				// 모두
				
				sql = "SELECT ono, mno, oname, otell, ophone, oemail, recipient, arrivallocation, "
					    + "recipienttell, recipientphone, onote, paymenttype, deliveryfee, state, depositor, rdate"
					    + " FROM orders ";
				
				db.prepare(sql);
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
			db.disconnect();
		}
		
		int size = orderList.size();
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 정보 수정</title>
<link href="<%=request.getContextPath()%>/css/base.css" type="text/css" rel="stylesheet">
<link href="<%=request.getContextPath()%>/css/order/list.css" type="text/css" rel="stylesheet">
<script src="<%=request.getContextPath()%>/js/jquery-3.7.1.min.js"></script>
<script>
	
	$(document).ready(function(){
		calculatePeriod();
		
	});
	
	
	function calculatePeriod()
	{
		 // 날짜 기록
	}

	function modify(o){
		// 쿼리 보내기.
		
		//console.log($(o).val());
		
		
		
		
		// 변경된 ono를 가져와서 아작스로 날림.
		// SUCCESS 돌아오면 페이지 리로드.
	}
</script>
</head>
<body>
	<%@ include file="/include/header.jsp"%>
	
	<main>
        <hr id="main_line">
        <div class="inner_member clearfix">
            <h3>주문목록</h3>
            <hr class="main_line2">
        </div> <!--inner_member-->

        <div class="content_box">

            <form name="tracking_frm" method="get" action="modify.jsp">
                <div class="tracking_area" > <!-- hidden -->
                    <div>
                        조회 기간
                    </div>
                     
                    <div>
                        <input type="radio" name="tracking_range_unit" value="1">오늘
                        <input type="radio" name="tracking_range_unit" value="2" checked>7일
                        <input type="radio" name="tracking_range_unit" value="3">15일
                        <input type="radio" name="tracking_range_unit" value="4">1개월
                        <input type="radio" name="tracking_range_unit" value="5">3개월
                        <input type="radio" name="tracking_range_unit" value="6">1년
                    </div>
                    
                    <div>
                        <input type="date" name="stDate" value="2024-01-07">
                        ~
                        <input type="date" name="edDate" value="2024-01-01">
                    </div>
                    <div>
                        <button type="submit" class="medium_btn btn_red" > 조회 </button>
                    </div>
                </div>
            </form>

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
                            <col width="40%"> <!-- 날짜 -->
                            <col width="25%"> <!-- 주문번호 -->
                            <col> <!-- 주문상태 -->
                    </colgroup>
                    <thead>
                        <tr>
                            <th>날짜</th>
                            <th>주문번호</th>
                            <th>주문상태</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                    for(int i=0;i<size;i++)
                    {
                    	Order order = orderList.get(i);
                    %>
                        <tr>
                            <td><%=order.getRdate()%></td>
                            <td class="ono"><%=order.getOno()%></td>
                            <td>
		                    	<select name="state" onchange="modify(this)">
		                    		<option value="0" <%if(order.getState().equals("0")) out.print("selected");%> >입금 대기</option>
		                    		<option value="1" <%if(order.getState().equals("1")) out.print("selected");%> >배송 준비</option>
		                    		<option value="2" <%if(order.getState().equals("2")) out.print("selected");%> >배송 중</option>
		                    		<option value="3" <%if(order.getState().equals("3")) out.print("selected");%> >배송 완료</option>
								</select>
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

			<!-- 여기 페이지네이션 넣어야 하는데 시간이 없음. -->
			
            </div>

        </div>
    </main>
	
	<%@ include file="/include/footer.jsp"%>
</body>
</html>



<%
	} // else {
%>
