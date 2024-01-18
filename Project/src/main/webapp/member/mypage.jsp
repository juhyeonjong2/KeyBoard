<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="allkeyboard.vo.Member" %>    
<%
	Member member = (Member)session.getAttribute("login");


	String mnoParam = request.getParameter("mno"); //mno 받아오는 링크 작성해야해

	System.out.println(mnoParam);
	int mno=0;
	
	if(mnoParam != null && !mnoParam.equals("")){
		mno = Integer.parseInt(mnoParam);
	}
	
	Connection conn = null;
	PreparedStatement psmt= null;
	ResultSet rs = null;
	String url = "jdbc:mysql://localhost:3306/allkeyboard";
	String user = "keytester";
	String pass = "1234";
	
	int mno2 = 0;
	String mname = "";
	String memail = "";
	String mphone = "";
	String maddr = "";

	
	try{
		
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = "SELECT * FROM member WHERE mno = ?";
		psmt = conn.prepareStatement(sql);
		
		psmt.setInt(1,mno);
		
		rs = psmt.executeQuery();
		
		if(rs.next()){
			mno2 = rs.getInt("mno");
			mname = rs.getString("mname");
			memail = rs.getString("memail");
			mphone = rs.getString("mphone");
			maddr = rs.getString("maddr");
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null) conn.close();
		if(psmt != null) psmt.close();
		if(rs != null) rs.close();
	}
	

	if(member == null 
			|| (!member.getMid().equals("admin") 
					&& member.getMno()!= mno)){
	%>
		<script>
			alert("로그인 후 이용해 주세요.");
			location.href="<%=request.getContextPath()%>/login/test.jsp";
		</script>
	<%	
	}
%>    
    
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<link href="<%=request.getContextPath()%>/css/base.css" type="text/css"
	rel="stylesheet">
<link href="<%=request.getContextPath()%>/css/mypage.css" type="text/css"
	rel="stylesheet">
</head>
<body>
	<%@ include file="/include/header.jsp"%>
	<main>
        <hr id="main_line">
        <div class="inner_member clearfix">
            <h3>마이페이지</h3>
            <hr id="main_line2">
        </div> <!--inner_member-->

        <div class="inner_member2 clearfix" id="myPageBorder">
            <table id="myPageBox">
                <colgroup>
                    <col align="right" width="30%">
                    <col>
                </colgroup>
                    <tbody>                         
                        <tr>
                            
                            <tr>
                                <th>이름 :</th>
                                <td><%=mname%></td>
                            </tr> 

                            <tr>
                                <th>이메일 :</th>
                                <td><%=memail%></td>
                            </tr>

                            <tr>
                                <th>연락처 :</th>
                                <td><%=mphone%></td>
                            </tr>
                            
                            <tr>
                                <th>주소 :</th>
                                <td><%=maddr%></td>
                            </tr>                
                    </tbody>
                </table>
                <div id="myPageLink">
                    <div class="myPageLinkSize"><a href="<%=request.getContextPath()%>/order/cart.jsp">장바구니 보기</a></div>
                    <div class="myPageLinkSize" id="myPageLinkmd"><a href="<%=request.getContextPath()%>/order/list.jsp">주문내역 보기</a></div>
                    <div class="myPageLinkSize"><a href="<%=request.getContextPath()%>/member/mypage_modify.jsp?mno=<%=mno2%>">회원 정보 수정</a></div>
                </div>


        </div><!--inner_member2-->
    </main>
	<%@ include file="/include/footer.jsp"%>
</body>
</html>