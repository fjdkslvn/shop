<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<%
	//로그인이 되어있지 않았다면 메인화면으로 넘기기
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember==null){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 주문 목록 리스트에 넣기
   OrderDao orderDao = new OrderDao();
   ArrayList<OrderEbookMember> list = orderDao.selectOrderListByMember(loginMember.getMemberNo());
%>
<!DOCTYPE html>
<html>
<head>
	<!-- 부트스트랩 -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	<meta charset="UTF-8">
	<title>나의 주문 목록</title>
</head>
<body>
	<h1>나의 주문 목록</h1>
	<!-- 주문 목록 출력 -->
   <table class="table" border="1">
      <thead>
         <tr>
            <th>orderNo</th>
            <th>ebookTitle</th>
            <th>orderPrice</th>
            <th>createDate</th>
            <th>memberId</th>
            <th>상세주문내역</th>
            <th>ebook후기</th>
         </tr>
      </thead>
      <tbody>
         <%
            // 반복을 통해 카테고리 목록을 표로 출력
            for(OrderEbookMember oem : list){
         %>
               <tr>
                  <td><%=oem.getOrder().getOrderNo() %></td>
                  <td><%=oem.getEbook().getEbookTitle() %></td>
                  <td><%=oem.getOrder().getOrderPrice() %></td>
                  <td><%=oem.getOrder().getCreateDate() %></td>
                  <td><%=oem.getMember().getMemberId() %></td>
                  <td><a href="">상세주문내역</a></td>
                  <td><a href="<%=request.getContextPath() %>/insertOrderCommentForm.jsp?orderNo=<%=oem.getOrder().getOrderNo() %>&ebookNo=<%=oem.getEbook().getEbookNo() %>">ebook후기</a></td>
               </tr>
         <%
            }
         %>
      </tbody>
   </table>
	
</body>
</html>