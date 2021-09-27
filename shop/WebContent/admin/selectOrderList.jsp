<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="java.util.*" %>

<%
   request.setCharacterEncoding("utf-8");
   
   //로그인이 되어있지 않거나 일반 회원이라면 메인화면으로 넘기기
   Member loginMember = (Member)session.getAttribute("loginMember");
   if(loginMember==null || loginMember.getMemberLevel() < 1){
      response.sendRedirect(request.getContextPath()+"/index.jsp");
      return;
   }
   
   // 페이지
   int currentPage = 1;
   if(request.getParameter("currentPage")!=null){
      currentPage = Integer.parseInt(request.getParameter("currentPage"));
   }
   System.out.println(currentPage+" <--selectEbookList currentPage");
   
   final int ROW_PER_PAGE = 10; // 페이지에 보일 주문 개수
   int  beginRow = (currentPage-1)*ROW_PER_PAGE; // 주문 목록 시작 부분
   
   // 주문 목록 리스트에 넣기
   OrderDao orderDao = new OrderDao();
   ArrayList<OrderEbookMember> list = orderDao.selectOrderList(beginRow, ROW_PER_PAGE);
   
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
   <h1>주문 목록</h1>
   <!-- 메뉴 -->
   <div>
      <jsp:include page="/partial/adminMenu.jsp"></jsp:include>
   </div>
   
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
               </tr>
         <%
            }
         %>
      </tbody>
   </table>
   
   <!-- 페이징 완료합시다 -->
   

</body>
</html>