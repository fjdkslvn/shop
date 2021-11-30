<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>

<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <title>전자책 상점</title>
</head>
<body>
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
   <!-- start : submenu include -->
   <div>
      <jsp:include page="/partial/mainMenu.jsp"></jsp:include>
   </div>
   <!-- end : submenu include -->
   <br>
   
   <div class="page-center">
	<table class="table">
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
			<td><%=oem.getOrder().getOrderPrice() %>원</td>
		</tr>
		<tr>
			<td>구매자</td>
			<td><%=oem.getMember().getMemberId() %></td>
		</tr>
		<tr>
			<td>구매일</td>
			<td><%=oem.getOrder().getCreateDate() %></td>
		</tr>
	</table>
	<br><br>
	<form action="<%=request.getContextPath() %>/deleteOrder.jsp" id="deleteForm" class="join-form">
		<input type="hidden" value="<%=orderNo %>" name="orderNo">
		<button class="btn btn-danger" type="button" id="btn">주문취소</button>
	</form>
	</div>
	<!-- footer -->
	<div>
      <jsp:include page="/partial/footer.jsp"></jsp:include>
   </div>
	<script>
		$('#btn').click(function(){
			// 버튼을 click했을때
			$('#deleteForm').submit();
		});
	</script>
</body>
</html>