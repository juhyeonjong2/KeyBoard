<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="ateam.db.DBManager" %>
<%@ page import="allkeyboard.vo.product" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>

<%
	request.setCharacterEncoding("UTF-8");

	String directory = "D:/EzenTeamProjectFirst/Project/src/main/webapp/image/product";
	int sizeLimit = 100*1024*1024;//100mb 제한
	
	MultipartRequest multi = new MultipartRequest(request
										, directory
										,sizeLimit
										,"UTF-8"
										, new DefaultFileRenamePolicy());



	String pname = multi.getParameter("pname");
	String price = multi.getParameter("price");
	String brand = multi.getParameter("brand");
	String inventory = multi.getParameter("inventory");
	String description = multi.getOriginalFileName("description");
	String description2 = multi.getFilesystemName("description");
	String flag = multi.getParameter("flag");
	String pfno = multi.getOriginalFileName("pfno");
	String pfno2 = multi.getFilesystemName("pfno");
	//File file = request.getFile("description");
 

	Integer price2;
	Integer inventory2;

	if(price.isEmpty()) {
		price2 = 0;
	} else {
		price2 = Integer.valueOf(price);
	}
	
	if(inventory.isEmpty()) {
		inventory2 = 0;
	} else {
		inventory2 = Integer.valueOf(inventory);
	}
	
	System.out.println(pname);
	System.out.println(price);
	System.out.println(brand);
	System.out.println(inventory);
	System.out.println(description);
	System.out.println(description2);
	System.out.println(flag);
	System.out.println(pfno);
	System.out.println(pfno2);
		

	DBManager db = new DBManager(); 
	
	
	 if(db.connect())
	{
		String sql = "INSERT INTO product(pname,price,brand,inventory) "
					+" VALUES(?,?,?,?) ";
		db.prepare(sql);
		
		db.setString(pname);
		db.setString(price); 
		db.setString(brand);
		db.setString(inventory);
		
		int count = db.update();
			if(count>0) {
				%>
				<script>
					alert("등록이 완료되었습니다.");
					location.href="add.jsp"
				</script>
				<%
			}else {
				%>
				<script>
					alert("등록을 실패하였습니다.");
					location.href="<%=request.getContextPath()%>"
				</script>
				<%
			}
		db.disconnect();
	}
	
%>
