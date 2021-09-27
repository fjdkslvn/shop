<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
   <!-- style.css 불러오기 -->
   <link rel="stylesheet" type="text/css" href="style.css">
   
   <meta charset="UTF-8">
   <title>index.jsp</title>
</head>
<body>
   <div class="right">
      <%
         // 로그인이 되어있지 않으면 로그인,회원가입 보여주고 / 로그인 되어있으면 로그아웃 보이기
         if(session.getAttribute("loginMember")==null){
            %>
                  <a href="<%=request.getContextPath() %>/loginForm.jsp">로그인</a>
                  <a href="<%=request.getContextPath() %>/insertMemberForm.jsp">회원가입</a>
            <%
         } else {
            Member loginMember = (Member)session.getAttribute("loginMember");
            %>
               *<%=loginMember.getMemberLevel() %>레벨* <%=loginMember.getMemberId() %>회원님 반갑습니다.
               <a href="<%=request.getContextPath() %>/logout.jsp">로그아웃</a>
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
      <h1>메인페이지</h1>
      <!-- 상품 목록 출력 -->
      <%
      // 페이지
      int currentPage = 1;
      if(request.getParameter("currentPage")!=null){
         currentPage = Integer.parseInt(request.getParameter("currentPage"));
      }
      System.out.println(currentPage+" <--selectEbookList currentPage");
      
      final int ROW_PER_PAGE = 10; // 페이지에 보일 주문 개수
      int  beginRow = (currentPage-1)*ROW_PER_PAGE; // 주문 목록 시작 부분
      EbookDao ebookDao = new EbookDao();
      ArrayList<Ebook> ebookList = ebookDao.selectEbookList(beginRow, ROW_PER_PAGE);
      %>
      
   <!-- 주문 목록 출력 -->
   <table class="table" border="1">
      <tr>
         <%
            int i = 0;
         
            // 반복을 통해 카테고리 목록을 표로 출력
            for(Ebook e : ebookList){
         %>
               <td>
                  <div><img src="<%=request.getContextPath() %>/image/<%=e.getEbookImg() %>" width="200" height="200"></div>
                  <div><%=e.getEbookTitle()  %></div>
                  <div>₩ <%=e.getEbookPrice() %></div>
               </td>
         <%
               i+=1; // for문 끝날때마다 i는 1씩 증가
               if(i%5==0){
         %>
                  </tr><tr> <!-- 줄바꿈 -->
         <%
               }
            }
         %>
      </tr>
   </table>
      
</body>
</html>