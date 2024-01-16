<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="ateam.db.DBManager" %>
<%@ page import="allkeyboard.vo.Product" %>
<%@ page import="allkeyboard.vo.ProductAttach" %>
<%@ page import="allkeyboard.util.CertHelper" %>
<%@ page import="allkeyboard.vo.Member" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>




<%
	request.setCharacterEncoding("UTF-8");

	String directory = "D:/EzenTeamProjectFirst/Project/src/main/webapp/image/product";
	int sizeLimit = 100*1024*1024;//100mb 제한
	
	MultipartRequest multi = new MultipartRequest(request
										, directory
										,sizeLimit
										,"UTF-8"
										, new DefaultFileRenamePolicy());

	Member member = (Member)session.getAttribute("login"); 
	
	String method = request.getMethod();
	// get방식이거나 로그인되지 않았거나 관리자가 아닐때 이전페이지로 돌아가기
	if(method.equals("GET") || member == null || !CertHelper.isAdmin(member.getMno(), member.getToken())){
		response.sendRedirect("listView.jsp");
	}


	
	
	String pname = multi.getParameter("pname");
	String price = multi.getParameter("price");
	String brand = multi.getParameter("brand");
	String inventory = multi.getParameter("inventory");
	String description = multi.getParameter("description");
	String flag = multi.getParameter("flag");
	String pfrealname  = multi.getOriginalFileName("pfrealname");
	String pforeignname = multi.getFilesystemName("pforeignname");
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
	System.out.println(flag);
	
	boolean isSuccess = false;
	Product product = new Product();

	DBManager db = new DBManager(); 
	
	
	 if(db.connect())
	{
		String sql = "INSERT INTO product(pname, price, brand, inventory, description, delyn) "
					+" VALUES(?,?,?,?,?,'N') ";
		
		if(db.prepare(sql).setString(product.getPname()).setString(product.getBrand()).update() > 0)
		{ // 업데이트 성공시 pno를 가져온다.
			
			// 현재 삽입된 게시글의 기본키(pno)값을 조회하세요. 
			sql = "select last_insert_id() as pno from product";
		
			
			if(db.prepare(sql).read())
			{
				if(db.getNext()){
					product.setPno(db.getInt("pno"));
				}
			}
			isSuccess = true;			
		}
		
		// 2. 저장된 파일을 정보를 생성한다.
		List<ProductAttach> fileList = new ArrayList<ProductAttach>();
		 
		// 순서가 지켜지지 않음. 소트 필요.
		Enumeration files = multi.getFileNames();
		while(files.hasMoreElements()) {
			String nameAttr = (String) files.nextElement();
			if(nameAttr.equals("thumbnail")){
				//특정 이름을 분류하고 싶을 떄.
				 
			} else {
				// 이름뒤에 글자를짤라서 index를 얻자. ('productFile_' + 숫자형태)
				String numberString =  nameAttr.replace("productFile_",""); // 공백처리함.		
				ProductAttach attach = new ProductAttach();
				attach.setPfidx(Integer.parseInt(numberString));
				attach.setPno(product.getPno()); // 공지글 외래키
				attach.setPfrealname(multi.getFilesystemName(nameAttr)); // 업로드된 실제 파일명(겹치는경우 이름이 바뀐다.)
				attach.setPforeignname(multi.getOriginalFileName(nameAttr)); // 클라이언트에서 올린 파일명 */
				fileList.add(attach);
			}
		} 
		
		// 3. 파일 정보를 DB에 입력한다.
		
		sql = "INSERT INTO productAttach(pfidx, pno, pfrealname, pforeignname, rdate) "
			+ " VALUES(?, ?, ?, ?, now())";
		
		for(ProductAttach attach : fileList){
		
			db.prepare(sql)
			  .setInt(attach.getPfidx())
			  .setInt(attach.getPno())
			  .setString(attach.getPfrealname())
			  .setString(attach.getPforeignname())
			  .update();
		}
		
		/*)
		
		db.prepare(sql);
		
		db.setString(pname);
		db.setString(price); 
		db.setString(brand);
		db.setString(inventory);
		db.setString(description);
		*/
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
