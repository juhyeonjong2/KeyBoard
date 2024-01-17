<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="allkeyboard.vo.Product" %>
<%@ page import="ateam.db.DBManager" %>
<%@ page import="allkeyboard.vo.Member" %>
<%@ page import="allkeyboard.util.CertHelper" %>
<%
  request.setCharacterEncoding("UTF-8");
  Member member = (Member)session.getAttribute("login");
  String method = request.getMethod();

	String pnoParam = request.getParameter("pno");

	
	int pno=0;
	if(pnoParam != null && !pnoParam.equals("")){
		pno = Integer.parseInt(pnoParam);
	}
	
	// admin 체크
	boolean isAdmin1 = false; 
	if(member != null){
		isAdmin1 = CertHelper.isAdmin(member.getMno(), member.getToken());
	}
	
	// admin이 아니면 접근 불가.
	if(!isAdmin1)
	{
		%>
		<script>
			alert("잘못된 접근입니다.");
			location.href='list.jsp';
		</script>
		<%
		// js 실행은 클라에서 되는거고 서버단에서 먼저 실행되버린다. 따라서 else로 아래 실행을 못하게 막는다. (else처리 안하면 잘못된접근입니다 뜨면서 아래 실행됨.)	
	} else {
	
	
		
		String pname = "";
		int price = 0;
		String brand = "";
		String description = "";
		int inventory = 0;
		String delyn = "";
		
	DBManager db = new DBManager();
	
	if(db.connect())
	{
		 String sql = "SELECT pname   "
					+" , price "
					+" , brand " 
					+" , description " //아직 사용처 없음
					+" , inventory " 
					+" , delyn " //부활용
				 	+"  FROM product"
					+" WHERE pno=? ";
		 
		 if( db.prepare(sql).setInt(pno).read())
		 {
			 if(db.getNext())
			 {
					pname = db.getString("pname");
					price = db.getInt("price");
					brand = db.getString("brand");
					description = db.getString("description"); 
					inventory = db.getInt("inventory");
					delyn = db.getString("delyn"); //생각해보니 여기 들어올려면 상품 상세페이지 와야하는데 delyn이 y면 상세페이지가 안보임			 			
			 }
		 }
		 db.disconnect();
	} //디비 커넥트			

	}//else문
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 상품 수정</title>
<link href="<%= request.getContextPath()%>/css/base.css" type="text/css" rel="stylesheet">
<link href="<%= request.getContextPath()%>/css/product.css" type="text/css" rel="stylesheet">
</head>
<body>
	<%@ include file="/include/header.jsp"%>
	
	<main>
		<hr id="main_line">
		<h2 style="margin: 20px 0; text-align: center;">상품 수정</h2>
        <div>
            <form name="frm" action="./addOk.jsp" method="post" enctype="multipart/form-data">
                <table class="tab1">
                    <tbody>
                        <tr>
                            <th>상품번호</th>
                            <td>1</td>
                        </tr>
                        <tr>
                            <th>상품명</th>
                            <td><input type="text" name="pname" placeholder="<%= request.getParameter("pname") %>"></td>
                        </tr>
                        <tr>
                            <th>판매가</th>
                            <td><input type="text" name="price" placeholder="금액만 표기"></td>
                        </tr>
                        <tr>
                            <th>브랜드</th>
                            <td><input type="text" name="brand"></td>
                        </tr>
                        <tr>
                            <th>재고수량</th>
                            <td><input type="text" placeholder="수량만 표기" name="inventory"></td>
                        </tr>
                        <tr>
                            <th>상세설명</th>
                            <td>
                                <input type="file" name="description">
                            </td>
                        </tr>
                        <tr>
                            <th>이미지</th>
                            <td>
                                <input type="file" name="pfno">
                            </td>
                        </tr>
                    </tbody>
                </table>
            	<div class="divA">
            		<button type="submit" class="btn_red">수정</button>
                	<a href="<%=request.getContextPath()%>/login/adminPage.jsp" class="btn_white ex">취소</a>
            	</div>
           	</form>
        </div>
	</main>
	
	<%@ include file="/include/footer.jsp"%>
	
</body>
</html>