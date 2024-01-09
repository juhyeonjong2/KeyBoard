<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %> <!--  멀티파트 처리용 cos.jar -->
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %> <!--  중복이름 처리규칙 -->
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="allkeyboard.util.CertHelper" %>
<%@ page import="allkeyboard.vo.NotificationAttach" %>
<%@ page import="allkeyboard.vo.Notification" %>
<%@ page import="allkeyboard.vo.Member" %>
<%@ page import="ateam.db.DBManager" %>


<%
	request.setCharacterEncoding("UTF-8");

	// 함수로 빼서 동적 경로로 변경하자.
	
	String saveDir = "image\\notification";
	String saveDirectoryPath = application.getRealPath(saveDir);
	int sizeLimit = 100*1024*1024; // 100mb 
	
	MultipartRequest multi = new MultipartRequest(request, saveDirectoryPath, sizeLimit, "UTF-8", new DefaultFileRenamePolicy());
	
	Member member = (Member)session.getAttribute("login");

	String method = request.getMethod();
	// get방식이거나 로그인되지 않았거나 관리자가 아닐때 이전페이지로 돌아가기
	if(method.equals("GET") || member == null || !CertHelper.isAdmin(member.getMno(), member.getToken())){
		response.sendRedirect("list.jsp");
	}
	
/* 	
 // path 가져오기
	out.print(request.getContextPath());
	out.print("<br>");
	out.print(pageContext.getServletContext().getRealPath("//"));
	out.print("<br>");
	out.print(request.getSession().getServletContext().getRealPath("/"));
	
	out.print(request.getSession().getServletContext().getContext("/upload").getRealPath(""));
	System.out.println(application.getRealPath("/storage"));
	 */
	 
	 boolean isSuccess = false;
	 Notification noti = new Notification();
	 noti.setNtitle(multi.getParameter("ntitle"));
	 noti.setNcontent(multi.getParameter("ncontent"));
	 
	 // 1. DB에 공지글을 추가한다.
	 DBManager db = new DBManager();
	 if(db.connect()){
		  String sql = "INSERT INTO notification(ntitle, ncontent, rdate, nhit, delyn) "
				      + "VALUES(?, ?, now(), 0, 'n') ";
		  
		
		if(db.prepare(sql).setString(noti.getNtitle()).setString(noti.getNcontent()).update() > 0)
		{ // 업데이트 성공시 nno를 가져온다.
			
			// 현재 삽입된 게시글의 기본키(bno)값을 조회하세요. 
			sql = "select last_insert_id() as nno from notification"; // DB샘에 알려준 mysql전용방법
			//sql = "select max(bno) as bno from board"; // 담임샘이 알려준 방법. (동기화 되지 않아서 위험할수도?)
			
			if(db.prepare(sql).read())
			{
				if(db.getNext()){
					noti.setNno(db.getInt("nno")); // nno 채움
				}
			}
			isSuccess = true;			
		}
		
		// 2. 저장된 파일을 정보를 생성한다.
		List<NotificationAttach> fileList = new ArrayList<NotificationAttach>();
		 
		// 순서가 지켜지지 않음. 소트 필요.
		Enumeration files = multi.getFileNames();
		while(files.hasMoreElements()) {
			String nameAttr = (String) files.nextElement();
			/* if(nameAttr.equals("thumbnail")){
				//특정 이름을 분류하고 싶을 떄.
			}
			else {
				// 이름뒤에 글자를짤라서 index를 얻자. ('notiFile_' + 숫자형태)
				
				
			} */
			
			String numberString =  nameAttr.replace("notiFile_",""); // 공백처리함.		
			NotificationAttach attach = new NotificationAttach();
			attach.setNfidx(Integer.parseInt(numberString) - 1);// 1부터 시작하므로 -1함.
			attach.setNno(noti.getNno()); // 공지글 외래키
			attach.setRealFileName(multi.getFilesystemName(nameAttr)); // 업로드된 실제 파일명(겹치는경우 이름이 바뀐다.)
			attach.setForeignFileName(multi.getOriginalFileName(nameAttr)); // 클라이언트에서 올린 파일명 */
			fileList.add(attach);
		} 
		
		// 3. 파일 정보를 DB에 입력한다.
		
		sql = "INSERT INTO notificationAttach(nfidx, nno, nfrealname, nforeignname, rdate) "
			+ " VALUES(?, ?, ?, ?, now())";
		
		for(NotificationAttach attach : fileList){
		
			db.prepare(sql)
			  .setInt(attach.getNfidx())
			  .setInt(attach.getNno())
			  .setString(attach.getRealFileName())
			  .setString(attach.getForeignFileName())
			  .update();
		}
		
		db.disconnect();
	 }
	
	 
	 ///////////////// 결과

	if(isSuccess){
		%>
		<script>
			alert("공지가 등록되었습니다.");
			location.href="list.jsp";
		</script>
		<%
	}else{
		%>
		<script>
			alert("공지가 등록되지 않았습니다.");
			location.href="list.jsp";
		</script>
		<%	
	}
%>