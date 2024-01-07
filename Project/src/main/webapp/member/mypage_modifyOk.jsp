<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="ateam.db.DBManager" %>
<%@ page import="allkeyboard.util.CertHelper" %>
<%@ page import="allkeyboard.vo.Member" %>
<%
  request.setCharacterEncoding("UTF-8");
 %>
 <jsp:useBean id="member" class="allkeyboard.vo.Member" />
 <jsp:setProperty property="*" name="member" />
 <%
 	DBManager db = new DBManager(); 

	if(db.connect())
	{
		 String sql = "UPDATE member "
				   + "   SET mpw = ? "
				   + "     , memail = ? "
				   + "     , mphone = ? "
				   + "     , mname = ? "
				   + "     , maddr = ? "
				   + " WHERE mno = ? ";
		 
			int count = db.prepare(sql)
						.setString(member.getMpw())
					   .update();
		
		if(count > 0 )
		{
			
		}else{
			
		}
		
		
		
		db.disconnect();
	}
 %>
