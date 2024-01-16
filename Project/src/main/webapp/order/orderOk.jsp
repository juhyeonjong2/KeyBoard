<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="allkeyboard.vo.BuyItem" %>
<%@ page import="allkeyboard.vo.Member" %>
<%@ page import="allkeyboard.vo.Order" %>
<%@ page import="allkeyboard.vo.OrderItem" %>
<%@ page import="allkeyboard.util.CertHelper" %>
<%@ page import="ateam.db.DBManager" %>

<%
	request.setCharacterEncoding("UTF-8");
	
	// 회원인경우, 비회원인경우 넘어오는 파라메터가 다름.
	boolean isRun = true;
	boolean isMember = false; 

	//1. 로그인 정보 확인
	Member member = (Member)session.getAttribute("login");
	if(member != null && !CertHelper.isExpired(member.getMno(), member.getToken()))
	{ 
		isMember = true;
	}
	
	// 일단 가능한모든 데이터 수집
	String agree_chk_1 = request.getParameter("agree_chk_1"); // 회원인경우 null
	String agree_chk_2 = request.getParameter("agree_chk_2"); // 회원인경우 null
	String payment_agree_chk_1 = request.getParameter("payment_agree_chk_1"); // 결제 동의
	String payment_type1_bank = request.getParameter("payment_type1_bank"); // 여기선 안쓰는정보 0만아니면됨. (입금 계좌번호)
	
	String method = request.getMethod();
	
	if(method.equals("GET"))
	{
		isRun = false;
	}
	
	if(!isMember){
		if( (agree_chk_1 == null || !agree_chk_1.equals("on")) 
			|| (agree_chk_2 == null || !agree_chk_2.equals("on")))
		{
			isRun = false;	
		}
	}
	
	if(payment_agree_chk_1 == null || !payment_agree_chk_1.equals("on"))
	{
		isRun = false;
	}
	
	// 입금 계좌번호 확인
	if(payment_type1_bank == null || payment_type1_bank.equals("0"))
	{
		isRun = false;
	}
	
	// 세션에 있는 주문 목록 가져옴.
	ArrayList<BuyItem> orderItemList = (ArrayList<BuyItem>)session.getAttribute("orderList");
	if(orderItemList == null){
		isRun = false;
	}
	
	
	
	if(!isRun)
	{
		%>
		<script>
			alert("잘못된 접근입니다.");
			location.href='<%= request.getContextPath()%>';
		</script>
		<%
	}
	else 
	{
		
		//String shiping_radio_chk = request.getParameter("shiping_radio_chk"); // 필요없는데이터.
		
		String order_name = request.getParameter("order_name");	 //(필수) oname : 주문자 
		String order_tell = request.getParameter("order_tell");	 // otell 주문자 전화번호
		String order_phone = request.getParameter("order_phone"); //(필수) ophone : 주문자 핸드폰 번호
		String order_email = request.getParameter("order_email"); // (필수)oemail : 주문자 이메일
		String shiping_name = request.getParameter("shiping_name"); // (필수) recipient : 받는사람
		String delivery_loc = request.getParameter("delivery_loc"); // (필수) arrivallocation : 받는곳
		String shiping_tell = request.getParameter("shiping_tell"); // recipienttell : 받는사람 전화번호
		String shiping_phone = request.getParameter("shiping_phone"); // (필수) recipientphone : 받는사람 휴대폰 번호
		String shiping_memo = request.getParameter("shiping_memo"); // onote : 남기는 말
		String payment_method_type = request.getParameter("payment_method_type"); //(필수) paymenttype :  입금 방법(1이 무통장인데 여기서는 체크 안함 그냥 넣음)
		String payment_type1_name = request.getParameter("payment_type1_name"); // (필수) depositor : 입금자
		String state = "입금 대기";  //State ={입금 대기, 배송 준비, 발송, 배송 완료}
		int deliveryFee = 2500; // 기본 배송비.
		int totalPrice = 0; // 20만 이상일경우 배송비 무료
		
		// order 생성 -> ws comment 이름을 이상하게 했더니 더 해깔림. (DB 이름이 이상한듯. 직관적이지 않음.)
		Order order = new Order();
		order.setOname(order_name);
		order.setOtell(order_tell);
		order.setOphone(order_phone);
		order.setOemail(order_email);
		order.setRecipient(shiping_name);
		order.setArrivalLocation(delivery_loc);
		order.setRecipientTell(shiping_tell);
		order.setRecipientPhone(shiping_phone);
		order.setOnote(shiping_memo);
		order.setPaymentType(payment_method_type);
		order.setDepositor(payment_type1_name);
		order.setState(state);
		if(isMember){ // 회원
			order.setMno(member.getMno());
		} else { // 비회원
			order.setMno(0);
		}	
		
		// ono, deliveryFee는 밑에서.
		
		boolean isSuccess = false;
		DBManager db = new DBManager();
		if(db.connect()){
			
			String sql = "SELECT price FROM product WHERE pno=?";
			for(BuyItem item : orderItemList){
				if(db.prepare(sql).setInt(item.getPno()).read()){
					if(db.getNext()){
						item.setPrice(db.getInt("price")); // 가격 갱신.		
					}
				}
			}
			
			// 총액 계산
			for(BuyItem item : orderItemList){
				totalPrice += (item.getPrice() * item.getQuantity());
			}
			
			// 배송비 계산
			if(totalPrice >= 200000){
				deliveryFee = 0;
			}
			
			// delivery Fee
			order.setDeliveryFee(deliveryFee);
			
			//1. order 객체 DB Insert
			sql = "INSERT INTO orders (mno, oname, otell, ophone, oemail, recipient, arrivallocation, recipienttell, recipientphone, onote, paymenttype, deliveryfee, state, depositor, rdate)" 
			    + " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now())";
			
			if( db.prepare(sql)
				  .setInt(order.getMno())
				  .setString(order.getOname())
				  .setString(order.getOtell())
				  .setString(order.getOphone())
				  .setString(order.getOemail())
				  .setString(order.getRecipient())
				  .setString(order.getArrivalLocation())
				  .setString(order.getRecipientTell())
				  .setString(order.getRecipientPhone())
				  .setString(order.getOnote())
				  .setString(order.getPaymentType())
				  .setInt(order.getDeliveryFee())
				  .setString(order.getState())
				  .setString(order.getDepositor())
				  .update() > 0 )
			{
				
				// 2. ono를 받아온다.
				sql = "select last_insert_id() as ono from orders"; // DB샘에 알려준 mysql전용방법
				//sql = "select max(bno) as bno from board"; // 담임샘이 알려준 방법. (동기화 되지 않아서 위험할수도?)
				
				if(db.prepare(sql).read())
				{
					if(db.getNext()){
						order.setOno(db.getInt("ono")); // ono 채움
						isSuccess = true;
					}
				}
				
			}
			  
			
			if(isSuccess)
			{
				//3. OrderItem 기록
				ArrayList<OrderItem> targetList = new ArrayList<OrderItem>();
				for(BuyItem item : orderItemList){
					OrderItem o = new OrderItem();
					o.setOno(order.getOno());
					o.setPno(item.getPno());
					o.setPrice(item.getPrice());
					o.setQuantity(item.getQuantity());
					targetList.add(o);
				}
				
				// 4. 기록된 orderItem 등록
				sql = "INSERT INTO orderitem (ono, pno, price, quantity) VALUES(?,?,?,?)";
				
				for(OrderItem item : targetList){
					
					if(db.prepare(sql)
					  .setInt(item.getOno())
					  .setInt(item.getPno())
					  .setInt(item.getPrice())
					  .setInt(item.getQuantity())
					  .update() == 0)
					{
						isSuccess = false;
						break;
					}
				}
			}
			
			db.disconnect();
			
			if(isSuccess)
			{
				// 업데이트 이후 order리스트를 확인해서 같은게 장바구니에 있으면 해당 아이템 장바구니에서 삭제(갯수로 확인)
				ArrayList<BuyItem> cartItemList = (ArrayList<BuyItem>)session.getAttribute("cartList");
				if(cartItemList != null)  // 장바구니가 비어있으면 세션 삭제하고 끝
				{
					int removeIndex = -1;
					int targetIndex = -1;
					for(BuyItem orderItem : orderItemList)
					{
						targetIndex = -1;
						// find
						for(int i=0; i< cartItemList.size(); i++){
							if(orderItem.getPno() == cartItemList.get(i).getPno())
							{
								targetIndex = i;
							}
						}
						removeIndex = -1;
						// compare and edit
						if(targetIndex != -1)
						{
							BuyItem cartItem = cartItemList.get(targetIndex);
							cartItem.setQuantity(cartItem.getQuantity()-orderItem.getQuantity()); // edit
							if(cartItem.getQuantity() <= 0)
							{
								removeIndex = targetIndex;
							}
						}
						
						// remove
						if(removeIndex != -1){
							cartItemList.remove(removeIndex);
						}
					}
				}
				
				// 어찌됬든 order List는 세션에서 삭제한다.
				session.removeAttribute("orderList");
				
				response.sendRedirect(request.getContextPath()+"/order/result.jsp?ono=" + order.getOno());
			}
			else {
				%>
				<script>
					alert("주문에 실패 했습니다.");
					location.href='<%= request.getContextPath()%>';
				</script>
				<%
			}
		}
	}
	
%>