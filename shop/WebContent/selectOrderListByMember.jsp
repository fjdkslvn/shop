<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <title>전자책 상점</title>
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");

	//로그인이 되어있지 않았다면 메인화면으로 넘기기
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember==null){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	//페이지
	int currentPage = 1;
	if(request.getParameter("currentPage")!=null){
	   currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	final int ROW_PER_PAGE = 10; // 페이지에 보일 후기 개수
	int beginRow = (currentPage-1)*ROW_PER_PAGE; // 리스트 목록 시작 부분
	OrderDao orderDao = new OrderDao();
	int lastPage = orderDao.selectOrderListByMemberLastPage(ROW_PER_PAGE,loginMember.getMemberNo());
	
	// 주문 목록 리스트에 넣기
   ArrayList<OrderEbookMember> list = orderDao.selectOrderListByMember(loginMember.getMemberNo(),beginRow,ROW_PER_PAGE);
%>
   <!-- start : submenu include -->
   <div>
      <jsp:include page="/partial/mainMenu.jsp"></jsp:include>
   </div>
   <!-- end : submenu include -->
   <br>
   
   <div class="page-center">
	<!-- 주문 목록 출력 -->
   <table class="table">
      <thead>
         <tr>
            <th>주문번호</th>
            <th>전자책</th>
            <th>금액</th>
            <th>주문일</th>
            <th>상세주문내역</th>
            <th>후기</th>
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
                  <td><%=oem.getOrder().getOrderPrice() %>원</td>
                  <td><%=oem.getOrder().getCreateDate().substring(0,10) %></td>
                  <td><a href="<%=request.getContextPath() %>/selectOrderOneByMember.jsp?orderNo=<%=oem.getOrder().getOrderNo() %>">상세주문내역</a></td>
                  <%
                  	OrderCommentDao orderCommentDao = new OrderCommentDao();
                  	boolean existence = orderCommentDao.selectOrderCommentExistence(oem.getOrder().getOrderNo());
                  	
                  	// 후기가 존재한다면
                  	if(existence){
                	%>
	           			<td><a href="<%=request.getContextPath() %>/updateOrderCommentForm.jsp?orderNo=<%=oem.getOrder().getOrderNo() %>&ebookNo=<%=oem.getEbook().getEbookNo() %>">후기 수정</a></td>
	           		<%
                  	} else{ // 후기가 존재하지 않는다면
	           		%>
	           			<td><a href="<%=request.getContextPath() %>/insertOrderCommentForm.jsp?orderNo=<%=oem.getOrder().getOrderNo() %>&ebookNo=<%=oem.getEbook().getEbookNo() %>">후기 작성</a></td>
	           		<%
                  	}
                  %>
               </tr>
         <%
            }
         %>
      </tbody>
   </table>
   <br><br>
   
   <ul class="pagination pagination-lg body-back-color">
		<%
			if(currentPage>1){
		%>
				<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectOrderListByMember.jsp?currentPage=<%=currentPage-1 %>"><</a></li>
		<%
			}
			
			if(currentPage<lastPage){
		%>
				<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectOrderListByMember.jsp?currentPage=<%=currentPage+1 %>">></a></li>
		<%
			}
		%>
	</ul>
	<br><br>
</div>
</body>
</html>