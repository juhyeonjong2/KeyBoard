
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %> <!--  멀티파트 처리용 cos.jar -->
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %> <!--  중복이름 처리규칙 -->
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator"%>
<%@ page import="allkeyboard.util.CertHelper" %>
<%@ page import="allkeyboard.vo.NotificationAttach" %>
<%@ page import="allkeyboard.vo.Notification" %>
<%@ page import="allkeyboard.vo.Member" %>
<%@ page import="ateam.db.DBManager" %>
<%@ page import="ateam.util.FileUtil" %>

<%
	request.setCharacterEncoding("UTF-8");

	String saveDir = "image/notification";
	String saveDirectoryPath = application.getRealPath(saveDir); // 절대 경로 안쓰기위해 톰캣쪽에 저장됨. (디비 합치면 못씀.) 
	int sizeLimit = 100*1024*1024; // 100mb 
	
	MultipartRequest multi = new MultipartRequest(request, saveDirectoryPath, sizeLimit, "UTF-8", new DefaultFileRenamePolicy());
	
	String nnoParam = multi.getParameter("nno");
	int nno = 0;
	if(nnoParam != null  && !nnoParam.equals("")){
		nno = Integer.parseInt(nnoParam);
	}
	
	String fileCountParam =  multi.getParameter("fileCount");
	int fileCount = 0;
	if(fileCountParam != null  && !fileCountParam.equals("")){
		fileCount = Integer.parseInt(fileCountParam);
	}	
	
	Member member = (Member)session.getAttribute("login");

	String method = request.getMethod();
	// get방식이거나 로그인되지 않았거나 관리자가 아닐때 이전페이지로 돌아가기
	if(method.equals("GET") || member == null || !CertHelper.isAdmin(member.getMno(), member.getToken())){
		if(nno != 0 ) response.sendRedirect("view.jsp?nno="+nno);
		else response.sendRedirect("list.jsp");// 파라메터없는경우 리스트로.
	}
	
	
	// 1. 넘어온 공지 정보 설정
	Notification noti = new Notification();
	noti.setNno(nno);
	noti.setNtitle(multi.getParameter("ntitle"));
 	noti.setNcontent(multi.getParameter("ncontent"));
	
	// 2. 넘어온 파일을 hashMap에 넣음.
	HashMap<Integer, NotificationAttach> modifyFiles = new HashMap<Integer, NotificationAttach>();
	Enumeration files = multi.getFileNames();
	while(files.hasMoreElements()) {
		String nameAttr = (String)files.nextElement();
		String numberString =  nameAttr.replace("notiFile_",""); // 공백처리함.
		NotificationAttach attach = new NotificationAttach();
		attach.setNfidx(Integer.parseInt(numberString) - 1);// 1부터 시작하므로 -1함.
		attach.setNno(noti.getNno()); // 공지글 외래키
		attach.setRealFileName(multi.getFilesystemName(nameAttr)); // 업로드된 실제 파일명(겹치는경우 이름이 바뀐다.)
		attach.setForeignFileName(multi.getOriginalFileName(nameAttr)); // 클라이언트에서 올린 파일명 

		// 파일 해시생성
		try{
			//System.out.println(saveDirectoryPath+"\\" + attach.getRealFileName());
			attach.setNfhash(FileUtil.getMD5Checksum(saveDirectoryPath+"\\" + attach.getRealFileName()));
		}catch(Exception e){
			e.printStackTrace();
			attach.setNfhash(""); // 오류시 해시는 공백으로채움.
		}
		
		modifyFiles.put(attach.getNfidx(),attach);
	} 
	
	//3. DB에서 해당 공지의 파일정보를 불러옴.
	boolean isSuccess = false;
	HashMap<Integer, NotificationAttach> savedFiles = new HashMap<Integer, NotificationAttach>();
	DBManager db = new DBManager();
	
	if(db.connect()){
		
		String sql = "SELECT nfno, nno, nfrealname, nforeignname, rdate, nfidx, nfhash " 
			     + "FROM notificationAttach "
			     + "WHERE nno=?";
		
		if(db.prepare(sql).setInt(noti.getNno()).read()){
			while(db.getNext()){
				NotificationAttach attach = new NotificationAttach();
				attach.setNfno(db.getInt("nfno"));
				attach.setNno(db.getInt("nno"));
				attach.setRealFileName(db.getString("nfrealname"));
				attach.setForeignFileName(db.getString("nforeignname"));
				attach.setRdate(db.getString("rdate"));
				attach.setNfidx(db.getInt("nfidx"));
				attach.setNfhash(db.getString("nfhash"));
				savedFiles.put(attach.getNfidx(),attach);
			}
		}
			
		
		// 4. 업데이트 실행 (4-1 ~ 4-2는 원래 트랜잭션으로 묶여야 한다)
		// 4-1 공지사항 nno, ntitle, ncontent, rdate, nhit FROM notification WHERE nno=? AND delyn='n'";
		sql = "UPDATE notification " 
		    + " SET ntitle=?, ncontent=?, rdate=now() "
		    + " WHERE nno=?";
		
		if(db.prepare(sql)
			 .setString(noti.getNtitle())
			 .setString(noti.getNcontent())
			 .setInt(noti.getNno())
			 .update()>0)
		{
			isSuccess = true;	
		}
		
		if(isSuccess)
		{ 
			// 트랜젝션 없으니 이전께 성공하면 수행하자.
		
			// 4-2. 파일 업데이트(변경된건 UPDATE, 추가 된건 INSERT)
			List<NotificationAttach> removalFileList = new ArrayList<NotificationAttach>(); // DB업데이트가 끝나면 변경정 서버에 저장된 파일은 삭제한다.
			// 추가된 목록중에서 원래 목록과 일치하면 UPDATE, 일치하는게 없다면 INSERT처리. 
			// 업데이트했다면 해당객체의 이전데이터를 removalFileList에 넣고 DB업데이트이후 제거한다.
		
			for (Map.Entry<Integer, NotificationAttach> entry : modifyFiles.entrySet()) 
			{
				int key = entry.getKey();
				NotificationAttach attach = entry.getValue();
			    
				// 원래 저장된 파일을 수정하는 것이라면. (UPDATE)
				if(savedFiles.containsKey(key))
				{
					// 업데이트하기.
					sql = "UPDATE notificationAttach "
					    + " SET nfrealname=?, nforeignname=?, rdate=now(), nfhash=?"
					    + " WHERE nno=? AND nfidx=? ";
					
					if( db.prepare(sql)
						  .setString(attach.getRealFileName())
						  .setString(attach.getForeignFileName())
						  .setString(attach.getNfhash())
						  .setInt(attach.getNno())
						  .setInt(attach.getNfidx())
						  .update() == 0  ) // 업데이트가 실패한경우 실패처리.
					{
						isSuccess = false;
					}
					
					
					// 삭제할 리스트에 넣기
					removalFileList.add(savedFiles.get(key));
				}
				else {
					// 없는 파일이라면 (INSERT)
					
					sql = "INSERT INTO notificationAttach(nfidx, nno, nfrealname, nforeignname, nfhash, rdate) "
						+ " VALUES(?, ?, ?, ?, ?, now())";

					if( db.prepare(sql)
						  .setInt(attach.getNfidx())
						  .setInt(attach.getNno())	
						  .setString(attach.getRealFileName())
						  .setString(attach.getForeignFileName())
						  .setString(attach.getNfhash())
						  .update() == 0  ) // 인서트가 실패한경우 실패처리.
					{
						isSuccess = false;
					}
					
				}
				
			}
			
			System.out.println(fileCount);
			System.out.println(savedFiles.size());
			
			// 4-3. 삭제된 번호가 있다면 해당 데이터 제거.
			// ex) 예전에 4개 등록했다가 3개로 변경한 경우. 추가 삭제 (반대의 경우 필요 없음)
			// 저장된 데이터가 더 많음.
			if(savedFiles.size() > fileCount)
			{
				List<Integer> list = new ArrayList<>(savedFiles.keySet());
				
				// 정렬
				list.sort((a,b)->{
					return b-a; //역순으로 정렬 (뒤에서 부터 삭제하기위함)
				});
				
				int diff = savedFiles.size() - fileCount;
				Iterator<Integer> it = list.iterator();
				for(int i=0;i<diff;i++){
					if(it.hasNext()){
						Integer key = it.next();
						
						// 삭제 대상
						NotificationAttach attach = savedFiles.get(key);
						
						sql = "DELETE FROM notificationAttach WHERE nno=? AND nfidx=?";
							
						if( db.prepare(sql)
							  .setInt(attach.getNno())
							  .setInt(attach.getNfidx())
							  .update() == 0  ) // 업데이트가 실패한경우 실패처리.
						{
							isSuccess = false;
						}
						else { // 성공의 경우						
						// 파일 삭제 목록에 넣음.
						removalFileList.add(attach);
						}
					}
				} 
				
			}
			
			
			// 4-4. DB 업데이트 후에 서버에서 필요없는 파일 삭제.
			for(NotificationAttach attach : removalFileList)
			{
				try
				{
					//System.out.println(saveDirectoryPath+"\\" + attach.getRealFileName());
					FileUtil.removeFile(saveDirectoryPath+"\\" + attach.getRealFileName());
				}catch (Exception e){
					e.printStackTrace();
				}
			}
		}
	}

%>

<%
 ///////////////// 결과

	if(isSuccess){
		%>
		<script>
			alert("공지가 수정 되었습니다.");
			location.href="view.jsp?nno=<%=nno%>";
		</script>
		<%
	}else{
		%>
		<script>
			alert("공지가 수정되지 않았습니다.");
			location.href="view.jsp?nno=<%=nno%>";
		</script>
		<%	
	}
%>