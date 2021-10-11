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
   <!-- style.css 불러오기 -->
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/style.css">
	
	<!-- 부트스트랩 -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	
	<!-- 자바스크립트 -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
   
   <meta charset="UTF-8">
   <title>전자책 상점</title>
</head>
<body>
	<div class="text-center">
		<a href="<%=request.getContextPath() %>/index.jsp"><img src="<%=request.getContextPath() %>/image/banner.PNG" width="550" height="130"></a>
	</div>
   <div class="right">
      <%
      	 request.setCharacterEncoding("utf-8");
      
         // 로그인이 되어있지 않으면 로그인,회원가입 보여주고 / 로그인 되어있으면 로그아웃 보이기
         if(session.getAttribute("loginMember")==null){
            %>
                  <a href="<%=request.getContextPath() %>/loginForm.jsp">로그인</a>
                  <a href="<%=request.getContextPath() %>/insertMemberForm.jsp">회원가입</a>
            <%
         } else {
            loginMember = (Member)session.getAttribute("loginMember");
            %>
               *<%=loginMember.getMemberLevel() %>레벨* <%=loginMember.getMemberId() %>회원님 반갑습니다.
               <a href="<%=request.getContextPath() %>/logout.jsp">로그아웃</a>
               <a href="<%=request.getContextPath() %>/selectMyImfo.jsp">내정보</a>
               <a href="<%=request.getContextPath() %>/selectOrderListByMember.jsp">나의주문</a>
            <%
            if(loginMember.getMemberLevel()>0){
               %>
                  <a href="<%=request.getContextPath() %>/admin/adminindex.jsp">관리자 페이지</a>
               <%
            }
         }
      %>
   </div>
   <br>
   <!-- start : submenu include -->
   <div>
      <jsp:include page="/partial/mainMenu.jsp"></jsp:include>
   </div>
   <!-- end : submenu include -->
   <br>
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
	
</body>
</html>