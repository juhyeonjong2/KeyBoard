<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.*" %>
<%@ page import="allkeyboard.util.CertHelper" %>
<%@ page import="allkeyboard.vo.*" %>
<%@ page import="ateam.db.DBManager" %>

<%
	request.setCharacterEncoding("UTF-8");
	Member member = (Member)session.getAttribute("login"); // 관리자 검사를위한 세션 들고오기.
	
	String nnoParam = request.getParameter("nno");
	
	int nno = 0;
	if(nnoParam != null  && !nnoParam.equals("")){
		nno = Integer.parseInt(nnoParam);
	}
	
	
	// 조회수 처리용 쿠키
	boolean isNnoCookie = false;
	Cookie[] cookies = request.getCookies();
	for(Cookie tempCookie : cookies){
		if(tempCookie.getName().equals("notification"+nno)){
			isNnoCookie = true;
			break;
		}
	}
	
	if(!isNnoCookie){
		Cookie cookie = new Cookie("notification"+nno,"ok");
		cookie.setMaxAge(60*60*24); //하루
		response.addCookie(cookie);
	}
	
	// admin 체크
	boolean isAdmin = false; 
	if(member != null){
		// 어드민이고 로그인유효시간 경과가 아닌경우.
		isAdmin = CertHelper.isAdmin(member.getMno(), member.getToken());
	}
	
	// 이미지파일 저장경로.
	String saveDir = "image/notification";
	String saveDirectoryPath = application.getRealPath(saveDir); // 절대 경로 안쓰기위해 톰캣쪽에 저장됨. (디비 합치면 못씀.) 
	// 아예 지정경로로 빼고싶으면 아래 참고  
	//https://kimcoder.tistory.com/204
	//https://byson.tistory.com/20
	
	
	//1 DB에서 공지를 읽어옴
	Notification noti = new Notification();
	List<NotificationAttach> attachList = new ArrayList<NotificationAttach>();
	DBManager db = new DBManager();
	if(db.connect()){
		
		String sql = "";
		
		if(!isNnoCookie){
			// 조회수 처리
			sql = "UPDATE notification " 
				    + "	  SET nhit = nhit+1"
				    + " WHERE nno = ? ";
			
			db.prepare(sql).setInt(nno).update();
		}
		
		// 공지 가져오기
		sql = "SELECT nno, ntitle, ncontent, rdate, nhit FROM notification WHERE nno=? AND delyn='n'";
		
		if(db.prepare(sql).setInt(nno).read())
		{
			if(db.getNext()){
				noti.setNno(db.getInt("nno"));
				noti.setNtitle(db.getString("ntitle"));
				noti.setNcontent(db.getString("ncontent"));
				noti.setRdate(db.getString("rdate"));
				noti.setNhit(db.getInt("nhit"));
			}
		}
		
	
		// 파일 정보를 가져온다.
		sql = "SELECT nfno, nno, nfrealname, nforeignname, rdate, nfidx, nfhash " 
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
				attachList.add(attach);
			}
		}
		
		
		// attachList를 index를 가지고 정렬한다.
		attachList.sort((a,b)->{
			return a.getNfidx() - b.getNfidx();
		});
		
		// 확인용
		
		/* for(NotificationAttach a : attachList ){
			
			System.out.println("----------"+ a.getNfidx() +"--------------");
			System.out.println(a.getRealFileName());
			System.out.println(a.getNfno());
		} */
		
		
%>
	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항</title>
<link href="<%=request.getContextPath()%>/css/base.css" type="text/css" rel="stylesheet">
<link href="<%=request.getContextPath()%>/css/notification/view.css" type="text/css" rel="stylesheet">

<script>
	function delFn(){
		let isDel = confirm("정말 삭제하시겠습니까?");
		 
		if(isDel){
			document.frm.submit();
		}
	}
</script>
</head>
<body>
	<%@ include file="/include/header.jsp"%>
	
	<main>
        <hr id="main_line">
        <div class="inner_member clearfix">
            <h3>공지사항</h3>
            <!-- <hr class="main_line2"> -->
        </div>


        <div class="content_box">

            <div class="title_area">
                <h4><%=noti.getNtitle()%></h4>
            </div>

            <div class="info_area">
                <div class="writer"><strong>관리자</strong></div>
                <div class="date"><%=noti.getRdate() %></div>
                <div class="hit"><strong>조회수</strong> <%=noti.getNhit() %></div>
            </div>

            <div class="content_area">
                <div class="content">
                <%= noti.getNcontent() %> 
                </div>
                <div class="image_area">
                
                <%
                	// 파일을 이어붙여보자
                	for(NotificationAttach a : attachList )
                	{
				%>
                		 <img src="<%= request.getContextPath() +"/" + saveDir + "/" + a.getRealFileName()%>" alt="<%= a.getForeignFileName() %>">        	
				<%
                	}
                %>
                </div>
            </div>
        </div>

        <div class="action_box">
            <div>
            	<%
            		if(isAdmin){ 	//<!-- 관리자일경우-->
                %>
                
                <button type="button" class="small_btn btn_red" onclick="delFn()">삭제</button>
                <button type="button" class="small_btn btn_white" onclick="location.href='modify.jsp?nno=<%=noti.getNno()%>'">수정</button>
                <%
            		}
            	%>                
                <!-- 기본-->
                <button type="button" class="small_btn btn_white" onclick="location.href='list.jsp';">목록</button>
            </div>
            <form name="frm" action="delete.jsp" method="post">
				<input type="hidden" name="nno" value="<%=noti.getNno()%>">
			</form>
        </div>
    </main>
	
	<%@ include file="/include/footer.jsp"%>
</body>
</html>
	
<%		
		db.disconnect();
	}
%>