<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="ateam.db.DBManager" %>
<%@ page import="allkeyboard.vo.Member" %>
<%
  request.setCharacterEncoding("UTF-8");

	String mno = request.getParameter("mno");
	int mno2=0;
	if(mno != null && !mno.equals("")){
		mno2 = Integer.parseInt(mno);
	}
	
	
	
	String mpw = request.getParameter("mpw"); 
	String mname = request.getParameter("mname");
	String mphone1 = request.getParameter("mphone1");
	String mphone2 = request.getParameter("mphone2");
	String mphone3 = request.getParameter("mphone3");
	String memail = request.getParameter("memail");
	String memail2 = request.getParameter("memail2");
	String maddr = request.getParameter("maddr");
	String allowemail = request.getParameter("allowemail"); 
	String allowphone = request.getParameter("allowphone"); 
 
 	DBManager db = new DBManager(); 

	if(db.connect())
	{
		 String sql = "UPDATE member "
				   + " SET memail = ? "
				   + " , mphone = ? "
				   + " , mname = ? "
				   + " , maddr = ? "
		 		   + " , allowemail = ? "
		 		   + " , allowphone = ? ";
					
		 			if(mpw != null && !mpw.equals("")){ //비번확인이 null이거나 빈 문자열이면 구문 실행 안함
		 				sql +=" , mpw = md5(?) ";
		 			}
				   sql += " WHERE mno = ? ";
		 
			 			db.prepare(sql);
						db.setString(memail+memail2);
						db.setString(mphone1+"-"+mphone2+"-"+mphone3);
						db.setString(mname);
						db.setString(maddr);
						
						if(allowemail == null){ //email수신동의 체크 안하면 n 하면 y
							db.setString("n");
						}else{
							db.setString(allowemail);
						}
						
						if(allowphone == null){ //phone수신동의 체크 안하면 n 하면 y
							db.setString("n");
						}else{
							db.setString(allowphone);
						}
											
						if(mpw != null && !mpw.equals("")){
			 				db.setString(mpw);
			 			}
						db.setInt(mno2);
						int count =   db.update();
			
		if(count > 0 ){
			%>
				<script>
					alert("수정되었습니다.");
					location.href="<%=request.getContextPath()%>/login/test.jsp"
				</script>
			<%
		}else{
			%>
				<script>
					alert("수정에 실패하였습니다..");
					location.href="<%=request.getContextPath()%>"
				</script>
			<%
		}
		
		
		
		db.disconnect();
	}
 %>
