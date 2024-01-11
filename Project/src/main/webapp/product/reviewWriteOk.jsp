<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="ateam.db.DBManager" %>
<%@ page import="allkeyboard.vo.*" %>
<%@ page import="java.util.*" %>
<%
	request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id ="reply" class="allkeyboard.vo.Review" />
<jsp:setProperty property="*" name="reply" />
<%
	Member member = (Member)session.getAttribute("login");
	if(member != null){
		reply.setMno(member.getMno());
	}
%>