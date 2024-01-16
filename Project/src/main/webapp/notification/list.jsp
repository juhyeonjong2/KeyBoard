<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="allkeyboard.vo.PagingVO" %>
<%@ page import="allkeyboard.vo.Member" %>
<%@ page import="allkeyboard.util.CertHelper" %>
<%@ page import="ateam.db.DBManager" %>


<%
	request.setCharacterEncoding("UTF-8"); //인코딩
	
	Member member = (Member)session.getAttribute("login"); // 관리자 검사를위한 세션 들고오기.
	String nowPageParam = request.getParameter("nowPage"); // 페이지 번호
	String searchType = request.getParameter("searchType"); // 검색 방법
	String searchValue = request.getParameter("searchValue"); // 검색 값
	
	
	// admin 체크
	boolean isAdmin = false; 
	if(member != null){
		isAdmin = CertHelper.isAdmin(member.getMno(), member.getToken());
	}
	
	
	int nowPage = 1;
	if(nowPageParam != null && !nowPageParam.equals("")){
		nowPage = Integer.parseInt(nowPageParam);
	} 
	
	
	
	// DB에서 공지사항 목록을 가져온다.
	DBManager db = new DBManager();
	PagingVO pagingVO = null;
	if(db.connect())
	{
		
		// 게시물의 개수를 읽어와서 페이징VO를 작성한다.
		String sql = "SELECT count(*) as cnt FROM notification WHERE delyn='n'";
		// 검색 조건추가
		if(searchType != null){
			if(searchType.equals("title")){
				sql += " AND ntitle LIKE CONCAT('%',?,'%') ";
			}else if(searchType.equals("content")){
				sql += " AND ncontent LIKE CONCAT('%',?,'%') ";
			}
		}
		
		db.prepare(sql);
		
		if(searchType !=null && (searchType.equals("title") ||searchType.equals("content"))){
			db.setString(searchValue);
		}
		
		if(db.read())
		{
			int totalCnt = 0;
			if(db.getNext()){
				totalCnt = db.getInt("cnt");
			}
			pagingVO = new PagingVO(nowPage, totalCnt, 5); 
		}
		
		db.release();
		
		// 공지 데이터를 가져온다.
		// ws comment - 회원 외래키가 필요 없을줄 알았는데 미래를 생각하면 관리자 mno를 기록했어야 함. 현 프로젝트에는 필요 없으니 그대로 진행함. 
		//              회원 외래키가 없어서 작성자 이름으로 검색 불가.
		sql = "SELECT nno, ntitle, ncontent, rdate, nhit FROM notification WHERE delyn='n'";
		// 옵션들
		if(searchType != null){
			if(searchType.equals("title")){
				sql += " AND ntitle LIKE CONCAT('%',?,'%') ";
			}else if(searchType.equals("content")){
				sql += " AND ncontent LIKE CONCAT('%',?,'%') ";
			}
		}
		sql += " ORDER BY nno DESC";  // 역순정렬
		sql += " LIMIT ?, ?";// 페이징
		
		db.prepare(sql);
		if(searchType !=null && (searchType.equals("title") ||searchType.equals("content"))){
			db.setString(searchValue);
		}
		db.setInt(pagingVO.getStart()-1)
		  .setInt(pagingVO.getPerPage());
		
		if(db.read())
		{
		
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항</title>
<link href="<%=request.getContextPath()%>/css/base.css" type="text/css" rel="stylesheet">
<link href="<%=request.getContextPath()%>/css/notification/list.css" type="text/css" rel="stylesheet">
</head>
<body>
	<%@ include file="/include/header.jsp"%>
	<main>
		<hr id="main_line">
		 <div class="inner_member clearfix">
            <h3>공지사항</h3>
            <hr class="main_line2">
        </div> <!--inner_member-->
		<div class="content_box">
            
            <table class="result_list">
                <colgroup>
                        <col width="8%"> <!-- 번호 -->
                        <col > <!-- 제목 -->
                        <col width="15%"> <!-- 날짜 -->
                        <col width="20%"> <!-- 작성자 -->
                        <col width="8%">           <!-- 조회 -->
                </colgroup>
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>제목</th>
                        <th>날짜</th>
                        <th>작성자</th>
                        <th>조회</th>
                    </tr>
                </thead>
                <tbody>
                <%
                	while(db.getNext()){
                		int nno = db.getInt("nno");
                		String ntitle = db.getString("ntitle");
                		String ncontent = db.getString("ncontent");
                		String rdate = db.getString("rdate");
                		int nhit = db.getInt("nhit");
                %>
                    <tr>
                        <td><%= nno %></td>
                        <td><a href="view.jsp?nno=<%=nno%>"><%= ntitle %></a></td>
                        <td><%= rdate %></td>
                        <td>관리자</td>
                        <td><%= nhit %></td>
                    </tr>
				<%
                	} // while(db.getNext()){
				} // if(db.prepare(sql).read())
                %>
                </tbody>
            </table>
            
             <div class="pagination">
                <ul>
<%
				// 이전 페이지
				if(pagingVO.getStartPage() > pagingVO.getCntPage())
				{
					if(searchType!=null) 
					{
%>
	 					<li class="prev"><a href="list.jsp?nowPage=<%= pagingVO.getStartPage()-1%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>">이전</a></li>
<%		 					
		 			} else{
%>
						<li class="prev"><a href="list.jsp?nowPage=<%= pagingVO.getStartPage()-1%>">이전</a></li>
<%
		 			}
				}
%>
     
<%
                for(int i= pagingVO.getStartPage(); i<= pagingVO.getEndPage(); i++) {
					// 현제 페이지인경우 class="active" 주고 링크 X				
					if(nowPage == i) {	
%>
		 			<li class="active"><%=i%></li>
<%
		 			} else { 
		 				if(searchType!=null) 
		 				{
%>
		 					<li><a href="list.jsp?nowPage=<%=i%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>"><%=i%></a></li>
<%		 					
			 			} else{
%>
 							<li><a href="list.jsp?nowPage=<%=i%>"><%=i%></a></li>
<%
			 			}
					}
				}
%>

<%
				//다음페이지
				if(pagingVO.getEndPage() < pagingVO.getLastPage())
				{
					if(searchType!=null) 
					{
%>
	 					<li class="next"><a href="list.jsp?nowPage=<%= pagingVO.getEndPage()+1%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>">다음</a></li>
<%		 					
		 			} else{
%>
						<li class="next"><a href="list.jsp?nowPage=<%= pagingVO.getEndPage()+1 %>">다음</a></li>
<%
		 			}
				}
%>

              	<div class="align_right" >
<%
                    if(isAdmin)
                    { // 관리자일경우
%>
                        <button type="button" class="medium_btn btn_red" onclick="location.href='write.jsp';">글쓰기</button>
<%
                    }// if(isAdmin)
%> 
                </div>
                
                
	           </ul>     
            </div>

            <div class="search_box">
                <form name="search_frm" action="list.jsp" method="get">
                    <select name="searchType" class="medium_text">
                    
                    <%
                    	int checkedNum = -1;
                    	if(searchType!=null){
                    		if(searchType.equals("title")){
                    			checkedNum = 0;
                    		}else if(searchType.equals("content")){
                    			checkedNum = 1;
                    		}
                    	}
                    %>
                        <option value="title" <% if(checkedNum==0) out.print("selected"); %>>제목</option>
                        <option value="content" <% if(checkedNum==1) out.print("selected"); %>>내용</option>
                        <!-- <option value="2">작성자</option>  -->
                    </select>
                    <input type="text" class="medium_text" name="searchValue" value="<%if(checkedNum!=-1) out.print(searchValue); %>">
                    <button class="medium_btn btn_red">검색</button>
                </form>                
            </div>
        </div>
	</main>
	<%@ include file="/include/footer.jsp"%>
</body>
</html>

<%		
	
	db.disconnect();
} // if(db.connect())
%>
