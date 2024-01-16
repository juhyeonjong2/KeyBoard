<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	session.setAttribute("NMP","y");
	
	// response.sendRedirect(request.getContextPath()/order/order.jsp);
%>
			<script>
				location.href="<%=request.getContextPath()%>/order/order.jsp";
			</script>