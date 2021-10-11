<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>

<%
	request.setCharacterEncoding("utf-8");
	
	// 삭제할 주문 번호
	if(request.getParameter("orderNo")==null){
		response.sendRedirect(request.getContextPath()+"/selectOrderListByMember.jsp");
		return;
	}

	// 주문 취소
	OrderDao orderDao = new OrderDao();
	orderDao.deleteOrder(Integer.parseInt(request.getParameter("orderNo")));
	
	// 주문 취소 후 주문목록으로 이동
	response.sendRedirect(request.getContextPath()+"/selectOrderListByMember.jsp");
	return;
%>