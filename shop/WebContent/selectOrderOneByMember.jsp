<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>

<%
	request.setCharacterEncoding("utf-8");

	//로그인이 되어있지 않으면 메인화면으로 넘기기
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember==null){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 방어코드
	if(request.getParameter("orderNo")=="" || request.getParameter("orderNo")==null){
		response.sendRedirect(request.getContextPath()+"/selectOrderListByMember.jsp");
		return;
	}
	
	// 상세보기할 주문 번호
	int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	
	// 정보 가져오기
	OrderDao orderDao = new OrderDao();
	OrderEbookMember oem = orderDao.selectOrderOne(orderNo);
%>

<!DOCTYPE html>
<html>
<head>
	<!-- style.css 불러오기 -->
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/style.css">
	
	<!-- 부트스트랩 -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	
	<!-- 자바스크립트 -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	
	<meta charset="UTF-8">
	<title>주문 상세보기</title>
</head>
<body>
	<h2>주문 상세보기</h2>
	<table class="table" border="1">
		<tr>
			<td>주문번호</td>
			<td><%=oem.getOrder().getOrderNo() %></td>
		</tr>
		<tr>
			<td>전자책</td>
			<td><%=oem.getEbook().getEbookTitle() %></td>
		</tr>
		<tr>
			<td>가격</td>
			<td><%=oem.getOrder().getOrderPrice() %></td>
		</tr>
		<tr>
			<td>구매자</td>
			<td><%=oem.getMember().getMemberId() %></td>
		</tr>
		<tr>
			<td>구매일</td>
			<td><%=oem.getOrder().getCreateDate() %></td>
		</tr>
		<tr>
			<td>수정일</td>
			<td><%=oem.getOrder().getUpdateDate() %></td>
		</tr>
	</table>
</body>
</html>