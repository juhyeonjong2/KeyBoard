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
	
	
	// admin 체크
	boolean isAdmin = false; 
	if(member != null){
		isAdmin = CertHelper.isAdmin(member.getMno(), member.getToken());
	}
	
	// 이미지파일 저장경로.
	String saveDir = "image\\notification";
	String saveDirectoryPath = application.getRealPath(saveDir);
	
	//1 DB에서 공지를 읽어옴
	Notification noti = new Notification();
	List<NotificationAttach> attachList = new ArrayList<NotificationAttach>();
	DBManager db = new DBManager();
	if(db.connect()){
		
		String sql = "SELECT nno, ntitle, ncontent, rdate, nhit FROM notification WHERE nno=? AND delyn='n'";
		
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
		sql = "SELECT nfno, nno, nfrealname, nforeignname, rdate, nfidx " 
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
		
		//https://claver-pickle.tistory.com/10
			
		
%>
	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항</title>
<link href="<%=request.getContextPath()%>/css/base.css" type="text/css" rel="stylesheet">
<link href="<%=request.getContextPath()%>/css/notification/view.css" type="text/css" rel="stylesheet">
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
                
                %>
                    <img src="./img/mx2a_event.jpg">
                    <img src="./img/mx2a_event2.jpg">  <!-- 이렇게 두개를 넣을수 있게 할지는? 디비 구조상 안될듯? 일단 설계한데로 한개만 처리-->
                </div>
            </div>
        </div>

        <div class="action_box">
            <div>
            	<%
            		if(isAdmin){ 	//<!-- 관리자일경우-->
                %>
                <button type="button" class="small_btn btn_red">삭제</button>
                <button type="button" class="small_btn btn_white">수정</button>
                <%
            		}
            	%>                
                <!-- 기본-->
                <button type="button" class="small_btn btn_white">목록</button>
            </div>
        </div>
    </main>
	
	<%@ include file="/include/footer.jsp"%>
</body>
</html>
	
<%		
		db.disconnect();
	}
%>