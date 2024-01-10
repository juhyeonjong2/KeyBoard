<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="ateam.db.DBManager" %>
<%@ page import="allkeyboard.vo.Member" %>
<%@ page import="java.sql.*" %>
<%
request.setCharacterEncoding("UTF-8"); //인코딩
/*
<jsp:useBean id ="member" class="allkeyboard.vo.Member" />
<jsp:setProperty property="*" name="member" /> 
*/
	
 	String mid = request.getParameter("mid");
	String mpw = request.getParameter("mpw");
	String mname = request.getParameter("mname");
	String mphone1 = request.getParameter("mphone1");
	String mphone = request.getParameter("mphone");
	String mphone2 = request.getParameter("mphone2");
	String memail = request.getParameter("memail");
	String memail2 = request.getParameter("memail2");
	String maddr = request.getParameter("maddr"); 
	String allowemail = request.getParameter("allowemail");
	String allowphone = request.getParameter("allowphone"); 

	
	/* Connection conn = null;
	PreparedStatement psmt=null;
	String url = "jdbc:mysql://localhost:3306/allkeyboard";
	String user = "keytester";
	String pass = "1234";
	
	int insertRow =0;
	
	try{
		Class.forName("com.mysql.cj.jdbc.Driver");
		conn = DriverManager.getConnection(url,user,pass);
		System.out.println("연결성공!");
		
		String sql = "INSERT INTO member(mid,mname,mphone,memail,maddr,mpw,rdate)"
				+" VALUES(?,?,?,?,?,?,now())";
		
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, mid);
		psmt.setString(2, mname);
		psmt.setString(3, mphone);
		psmt.setString(4, memail);
		psmt.setString(5, maddr);
		psmt.setString(6, mpw);
		
		insertRow = psmt.executeUpdate(); //변화하면 1추가
		System.out.println(insertRow);
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null) conn.close();
		if(psmt != null) conn.close();
	} */
	
		
	
 	DBManager db = new DBManager(); 

	 if(db.connect())
	{
		String sql = "INSERT INTO member(mid,mname,mphone,memail,maddr,mlevel,allowemail,allowphone,mpw,rdate)"
					+" VALUES(?,?,?,?,?,?,?,?,md5(?),now())";

		db.prepare(sql);
		db.setString(mid); 
		db.setString(mname);
		db.setString(mphone1+"-"+mphone+"-"+mphone2);
		db.setString(memail+memail2);
		db.setString(maddr);
		db.setInt(1); // level 추가함. 기본적으로 가입시 회원이므로 1설정.
		
		if(allowemail == null){ //체크안되면 n 되면 value값인 y
			db.setString("n");
		}else{
			db.setString(allowemail); 
		}
		
		if(allowphone == null){
			db.setString("n");
		}else{
			db.setString(allowphone); 
		}
			
		db.setString(mpw);
		
		 int count = db.update();
					
			if(count > 0 )
			{
				%>
					<script>
						alert("회원가입 되었습니다. 로그인을 시도하세요");
						location.href="<%=request.getContextPath()%>"
					</script>
				<%
			}else{
				%>
				<script>
					alert("회원가입을 실패하였습니다.");
					location.href="<%=request.getContextPath()%>"
				</script>
				<%
			}

			
			db.disconnect();
		}
		
		
%>