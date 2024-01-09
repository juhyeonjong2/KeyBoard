<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	session.invalidate(); //로그아웃 
	response.sendRedirect(request.getContextPath()); //로그아웃후 이동 (이곳으로 오는 경로와 여기서 가는 경로가 아직 설정안됨)
%>