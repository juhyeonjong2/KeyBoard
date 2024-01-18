<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="ateam.db.DBManager" %>
<%@ page import="allkeyboard.vo.PagingVO" %>
<%@ page import="allkeyboard.vo.*" %>
<%@ page import="java.util.*" %>
<%
	request.setCharacterEncoding("UTF-8");
	Member member = (Member)session.getAttribute("login");
	String nowPageParam = request.getParameter("nowPage"); // 페이지 번호
	
	String pnoParam = request.getParameter("pno"); // list에서 상품 누르면 pno받아온다. 
	
	int pno= 1; /* 임시로 1로 값 지정 */ //아래 작업으로 인해 널값으로 바뀌는 듯함
	if(pnoParam != null  && !pnoParam.equals("")){
		pno = Integer.parseInt(pnoParam);
	}
	
	
	// 이미지파일 저장경로.
	String saveDir = "image/product";
	String saveDirectoryPath = application.getRealPath(saveDir); // 절대 경로 안쓰기위해 톰캣쪽에 저장됨. (디비 합치면 못씀.)
	
	Product product = new Product();
	List<ProductAttach> attachList = new ArrayList<ProductAttach>(); //이미지 배열
	List<Review> rlist = new ArrayList<Review>(); //리뷰 목록 리뷰 클래스
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
		
		// 상품이미지를 가져오는 sql문
 		sql = "SELECT pfno, pno, pfrealname, pforeignname, rdate, pfidx "
		+ " FROM productAttach "
		+ "WHERE pno = ?"; 
 		ProductAttach thumbnail = new ProductAttach(); // 썸네일 저장용 으로 여기다가
 			
		if(db.prepare(sql).setInt(product.getPno()).read()){
			while(db.getNext()){ //next로 차근차근 전부 가져온다.
				int index = db.getInt("pfidx");
			if(index == 0){
				thumbnail.setPfno(db.getInt("pfno"));
				thumbnail.setPno(db.getInt("pno"));
				thumbnail.setPfrealname(db.getString("pfrealname"));
				thumbnail.setPforeignname(db.getString("pforeignname"));
				thumbnail.setRdate(db.getString("rdate"));
				thumbnail.setPfidx(db.getInt("pfidx"));
				//attachList.add(thumbnail); 썸네일은 넣을 필요 없을 듯 함
			}else{
				ProductAttach attach = new ProductAttach();
				attach.setPfno(db.getInt("pfno"));
				attach.setPno(db.getInt("pno"));
				attach.setPfrealname(db.getString("pfrealname"));
				attach.setPforeignname(db.getString("pforeignname"));
				attach.setRdate(db.getString("rdate"));
				attach.setPfidx(db.getInt("pfidx"));
				attachList.add(attach);
			}
			}
		}
		
		//이부분이 순서 맞추는건데 일단 보류
		attachList.sort((a,b)->{
			return a.getPfidx() - b.getPfidx();
		});
	
	// 후기 파트 
	
	// 후기의 정보들을 가져온다 (m.mname은 받아오려면 db수정 필요 할듯하다)
	sql = " select r.rno, r.pno, m.mname, m.mno, r.rnote "
			+ "   from review r "
			+ " inner join member m "
			+ "     on r.mno = m.mno "
			+ "  where r.pno = ? ";
	
		Review review = new Review(); //다른데서도 쓸수 있게 일단 빼둠
	 if( db.prepare(sql).setInt(pno).read()) //상품번호는 일단 1로 나중에 수정 필요
	 {
		while(db.getNext()){
			// Review review = new Review();
			review.setRno(db.getInt("rno"));
			review.setPno(db.getInt("pno"));
			review.setMno(db.getInt("mno"));
			review.setRnote(db.getString("rnote"));
				
			rlist.add(review);
			}
	 }
	 	// 후기 페이징
	 	
		int nowPage = 1;
		if(nowPageParam != null && !nowPageParam.equals("")){
			nowPage = Integer.parseInt(nowPageParam);
		} 
	 PagingVO pagingVO = null;
			// 게시물의 개수를 읽어와서 페이징VO를 작성한다.
			sql = "SELECT count(*) as cnt FROM review WHERE pno = ?";
			
			db.prepare(sql);
			db.setInt(pno);
			
			if(db.read())
			{
				int totalCnt = 0;
				if(db.getNext()){
					totalCnt = db.getInt("cnt");
				}
				pagingVO = new PagingVO(nowPage, totalCnt, 5); 
			}
			
			db.release();
			
			sql = "SELECT * FROM review WHERE pno = ?";
			sql += " LIMIT ?, ?";// 페이징
			
			db.prepare(sql);
			db.setInt(pno);
			db.setInt(pagingVO.getStart()-1)
			  .setInt(pagingVO.getPerPage());
			if(db.read())
			{
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 상세 정보</title>
<link href="<%= request.getContextPath()%>/css/base.css" type="text/css" rel="stylesheet">
<link href="<%= request.getContextPath()%>/css/product/list.css" type="text/css" rel="stylesheet">
<link href="<%= request.getContextPath()%>/css/review.css" type="text/css" rel="stylesheet">
<script src="<%= request.getContextPath()%>/js/jquery-3.7.1.min.js"></script>
<script>
	function calFn(type, ths) {
		const resultE = document.getElementById("result");
		const allPrice = document.getElementById("allPrice");
		let	number = resultE.innerText;
	if(type == 'p') {
		number = parseInt(number) +1;
	} else if(type == 'm') {
		number = parseInt(number) -1;
	}
	
	resultE.innerText = number;
	allPrice.innerText = <%= product.getPrice() %>*number;
}	
 		//후기
 		
	let isModify = false;
	
	function modifyFn(obj, rno){
			if(!isModify){
				let value = $(obj).parent().prev("span").text().trim();
				console.log(value);
				
				let html = "<textarea name='rnote' id='textarea'  maxlength='100'>"+value+"</textarea>";
				html += "<input type='hidden' name='rno' value='"+rno+"'>";
				html += "<input type='hidden' name='oldRnote' value='"+value+"'>";
				
				$(obj).parent().prev("span").html(html);
				
				html = "<button onclick='saveFn(this)' class='reviewBt2'>저장</button>"
					 +"<button onclick='cancleFn(this)' class='reviewBt'>취소</button>";
				
				$(obj).parent().html(html);
				
				isModify = true;
			}else{
				alert("수정중인 댓글을 저장하세요.");
			}
	}
	
	function saveFn(obj){
		isModify = false;
		
		let value = $(obj).parent().prev("span")
						.find("textarea[name=rnote]").val();
		let rno = $(obj).parent().prev("span")
						.find("input[name=rno]").val();
		let originalValue = $(obj).parent().prev("span")
								.find("input[name=oldRnote]").val();

		$.ajax({
			url : "reviewModifyOk.jsp",
			tyep : "post",
			data : {rnote : value, rno : rno},
			success : function(data){
				if(data.trim() == 'SUCCESS'){
					$(obj).parent().prev("span").text(value);
					let deleteLink = "location.href='reviewDeleteOk.jsp?rno="+rno+"'";
					let html = '<button class="reviewBt2" onclick="modifyFn(this,'+rno+')">수정</button>';
					html += '<button class="reviewBt" onclick="'+deleteLink+'">삭제</button>';
					$(obj).parent().html(html);							
				}else{
					$(obj).parent().prev("span").text(originalValue);
					let deleteLink = "location.href='reviewDeleteOk.jsp?rno="+rno+"'";
					let html = '<button class="reviewBt2" onclick="modifyFn(this,'+rno+')">수정</button>';
					html += '<button class="reviewBt" onclick="'+deleteLink+'">삭제</button>';
					$(obj).parent().html(html);
					alert("권한이 없습니다.");
				}
			},error:function(){
				console.log("error");
			}
		});
		
	}
	
	function cancleFn(obj){
		let originalValue = $(obj).parent().prev("span").find("input[name=oldRnote]").val();
		console.log(originalValue);

		let rno = $(obj).parent().prev("span").find("input[name=rno]").val();
		
		$(obj).parent().prev("span").text(originalValue);
		
		let deleteLink = "location.href='reviewDeleteOk.jsp?rno="+rno+"'";
		
		let html = '<button class="reviewBt2" onclick="modifyFn(this,'+rno+')">수정</button>';
		html += '<button class="reviewBt" onclick="'+deleteLink+'">삭제</button>';
		
		$(obj).parent().html(html);
		
		isModify = false;
		
	}
	
	function modiFn(){
		let isDel = confirm("정말 수정하시겠습니까?");
		 
		if(isDel){
			location.href="<%=request.getContextPath()%>/product/modify.jsp?pno=<%=pno%>";
		}
	}
	
	function delFn(){
		let isDel = confirm("정말 삭제하시겠습니까?");
		 
		if(isDel){
			location.href="<%=request.getContextPath()%>/product/delete.jsp?pno=<%=pno%>";
		}
	}
</script>
</head>
<body>
	<%@ include file="/include/header.jsp"%>

	<main>
 		<hr id="main_line">
        <div class="is"> 
            <div class="mImage"> 
                <img src="<%= request.getContextPath() +"/" + saveDir + "/" + thumbnail.getPfrealname()%>" alt="<%= thumbnail.getPforeignname() %>">
            </div>
            <!-- 상품 정보 -->
            <div style="width: 680px; float:right"> 
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
                                    <span id="allPrice"><%= product.getPrice() %></span>
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
<%
				if(CertHelper.isAdmin(member.getMno(), member.getToken())){	
%>
				<div id="adminOption" class="inner_member2">
					<a onclick="modiFn()">상품 수정</a>
					<a onclick="delFn()">상품 삭제</a>
				</div>
<%
               }
%>
        
        <!-- 상세정보 하단부분 -->
        <div style="text-align: center"> 
            <div class="tab_content">
                <ul>
                	<li><a href="#detail">상세정보</a></li>
                	<li><a href="#qna">상품 후기</a></li>
                </ul>
            </div>
            <div id="detail">
                <h4 style="margin-bottom: 30px;" id="list1">상품 상세 정보</h3>
                <div class="imgBox">
                                
                <%
                	// 파일을 이어붙여보자
                	for(ProductAttach a : attachList )
                	{
				%>
                		 <div><img src="<%= request.getContextPath() +"/" + saveDir + "/" + a.getPfrealname()%>" alt="<%= a.getPforeignname() %>"></div>       	
				<%
                	}
                %>
                </div>
            </div>
           
            <div class="tab_content">
                 <ul>
                	<li><a href="#detail">상세정보</a></li>
                	<li><a href="#qna">상품 후기</a></li>
                </ul>
            </div>
            <div id="qna"><!-- 후기 -->
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
                	while(db.getNext()){
                		int mno = db.getInt("mno");
                		String rnote = db.getString("rnote");
                		int rno = db.getInt("rno");
%>
			<div class="reviewBox2">
				<div id="idBox"><%=mno%>번 유저</div> 
		            <span class="reviewarea"><%=rnote%></span> 
		            <span id="review_modifyBox">
			            <button class="reviewBt" onclick="modifyFn(this,<%=rno%>)">수정</button> 
			            <button class="reviewBt" onclick="location.href='reviewDeleteOk.jsp?rno=<%=rno%>'">삭제</button>		            		            
		       		</span>
	        </div>			
<%
                	} // while(db.getNext()){
				} // if(db.prepare(sql).read())
%>
		</div>
		
		<div class="pagination">
            <ul>
<%
				// 시작페이지가 보여질 페이지보다 큰경우 (11페이지 넘어가면 이전이 뜬다는 뜻 10까지만 보이게 해뒀으니까) 
				if(pagingVO.getStartPage() > pagingVO.getCntPage())
				{
%>
						<li class="prev"><a href="view.jsp?nowPage=<%= pagingVO.getStartPage()-1%>">이전</a></li>
<%
		 			}
%>
     
<%
                for(int i= pagingVO.getStartPage(); i<= pagingVO.getEndPage(); i++) {
					// 현제 페이지인경우 class="active" 주고 링크 X				
					if(nowPage == i) {	
%>
		 			<li class="active"><%=i%></li>
<%
		 			} else { //현재 페이지가 아닌경우 링크로 값을 보내줌
%>
 							<li><a href="view.jsp?nowPage=<%=i%>&pno=<%=pno%>"><%=i%></a></li>
<%
			 			}
					}
%>

<%
				//다음페이지
				//보여지는 페이지의 마지막부분이 전체페이지 끝보다 보다 작을경우 예) 보여지는페이지 마지막=10 전체페이지의 끝=15 이경우 다음페이지 보여줌 
				if(pagingVO.getEndPage() < pagingVO.getLastPage()){
%>
						<li class="next"><a href="view.jsp?nowPage=<%= pagingVO.getEndPage()+1 %>">다음</a></li>
<%
		 			}
%>
                
	           </ul>     
            </div>
            
    </div><!--inner_member2--> 		
            </div> <!-- 후기 -->
     	</div>
     		<%@ include file="/include/footer.jsp"%>
	</main>
</body>
</html>

<%
	db.disconnect();
}
%>