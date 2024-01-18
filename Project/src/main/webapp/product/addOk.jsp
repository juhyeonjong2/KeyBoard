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
	Member member = (Member)session.getAttribute("login"); 

	String method = request.getMethod();
	// get방식이거나 로그인되지 않았거나 관리자가 아닐때 이전페이지로 돌아가기
	if(method.equals("GET") || member == null || !CertHelper.isAdmin(member.getMno(), member.getToken())){
		response.sendRedirect("list.jsp");
	}
	
	String saveDir = "image/product";
	String saveDirectoryPath = application.getRealPath(saveDir); // 절대 경로 안쓰기위해 톰캣쪽에 저장됨. (디비 합치면 못씀.) 
	int sizeLimit = 100*1024*1024;//100mb 제한
	
	MultipartRequest multi = new MultipartRequest(request
										, saveDirectoryPath
										,sizeLimit
										,"UTF-8"
										, new DefaultFileRenamePolicy());

	// form가 enctype="multipart/form-data" 이거면 리퀘스트로 가져오는게 안된다 그래서 아래방식으로 데이터를 받아온다.	
	String pname = multi.getParameter("pname");
	String price = multi.getParameter("price");
	String brand = multi.getParameter("brand");
	String inventory = multi.getParameter("inventory");
	String description = multi.getParameter("description");
	String type = multi.getParameter("type");
	// 업로드된 실제 파일명
	String realImgNM  = multi.getOriginalFileName("uploadimg");
	//원본 파일명
	String originImgNM = multi.getFilesystemName("uploadimg");
 
	int price2;
	int inventory2;

	//값이 비어있으면 트루반환
	if(price.isEmpty()) {
		price2 = 0;
	} else {
		price2 = Integer.parseInt(price);
		// Integer.valueOf(price); 래퍼객체로 받는것인데 일단 위 방식 사용
	}
	
	if(inventory.isEmpty()) {
		inventory2 = 0;
	} else {
		inventory2 = Integer.parseInt(inventory);
	}
	
	boolean isSuccess = false;
	Product product = new Product();

	DBManager db = new DBManager(); 
	
	
	 if(db.connect())
	{
		String sql = "INSERT INTO product(pname, price, brand, inventory, description, type, delyn) "
					+" VALUES(?,?,?,?,?,?,'n') ";
		
		if(db.prepare(sql).setString(pname).setInt(price2).setString(brand).setInt(inventory2).setString(description).setString(type).update() > 0)
		{ // 업데이트 성공시 pno를 가져온다.
			
			// 현재 삽입된 상품목록의 기본키(pno)값을 조회후 pno안에 순서대로 집어넣는다.
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
		 
		// 순서가 지켜지지 않음. 소트 필요. notification view안에 소트 함수 참고해서 작성
		Enumeration files = multi.getFileNames(); //input 파일 타입의 파일들을 Enumeration 타입으로 저장
		while(files.hasMoreElements()) {      //커서가 첫번째면 0이고 1개라도 있다면 트루반환
			String nameAttr = (String) files.nextElement();
			
			//배열쪽에 여러개가 들어가지 않는듯 하다
			if(nameAttr.equals("thumbnail")){
				//여기서는 썸네일 0번째 골라내기
				//썸네일은 관리번호가 0번인 이미지는 이름을 썸네일임을 알 수 있게 수정시키는 작업을 한다. 
				
				
				 
			} else {
				// 이름뒤에 글자를짤라서 index를 얻자. ('productFile_' + 숫자형태)
				String numberString =  nameAttr.replace("productFile_",""); // 공백처리함.
				
				
				ProductAttach attach = new ProductAttach();
				attach.setPfidx(Integer.parseInt(numberString)); //번호를 골라내서 관리번호에 집어넣는다.
				attach.setPno(product.getPno()); // 공지글 외래키
				attach.setPfrealname(multi.getFilesystemName(nameAttr)); // 업로드된 실제 파일명(겹치는경우 이름이 바뀐다.)
				attach.setPforeignname(multi.getOriginalFileName(nameAttr)); // 클라이언트에서 올린 파일명 */
				fileList.add(attach);
				
			}
		} 
		
		
		// 3. 파일 정보를 DB에 입력한다.
		int count = 0;
		sql = "INSERT INTO productAttach(pfidx, pno, pfrealname, pforeignname, rdate) "
			+ " VALUES(?, ?, ?, ?, now())";
		
		for(ProductAttach attach : fileList){ //상품이미지가 여러개 들어갈 가능성이 높으니 for문 사용
		
			db.prepare(sql)
			  .setInt(attach.getPfidx())
			  .setInt(attach.getPno())
			  .setString(attach.getPfrealname())
			  .setString(attach.getPforeignname());
			  count = db.update();
		}
		
			// 상품정보를 저장하고 동시에 상품이미지를 저장했을경우
			if(count>0) { //alert가 안나옴
				%>
				<script>
					alert("등록이 완료되었습니다.");
					location.href="<%=request.getContextPath()%>/product/view.jsp?pno=<%=product.getPno()%>"
				</script>
				<%
			}else {
				%>
				<script>
					alert("등록에 실패하였습니다 이미지가 1개이상있는지, 파일명이 너무 길진 않은지 확인해주세요");
					location.href="<%=request.getContextPath()%>/product/add.jsp"
				</script>
				<%
			}
		db.disconnect();
	}
	
%>
