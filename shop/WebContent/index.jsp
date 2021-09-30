<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
   <!-- style.css 불러오기 -->
   <link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/style.css">
   
   <meta charset="UTF-8">
   <title>index.jsp</title>
</head>
<body>
	<h1>메인페이지</h1>
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
            Member loginMember = (Member)session.getAttribute("loginMember");
            %>
               *<%=loginMember.getMemberLevel() %>레벨* <%=loginMember.getMemberId() %>회원님 반갑습니다.
               <a href="<%=request.getContextPath() %>/logout.jsp">로그아웃</a>
               <a href="<%=request.getContextPath() %>/selectMyImfo.jsp">회원정보</a>
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
      
      <!-- 상품 목록 출력 -->
      <%
      // 페이지
      int currentPage = 1;
      if(request.getParameter("currentPage")!=null){
         currentPage = Integer.parseInt(request.getParameter("currentPage"));
      }
      System.out.println(currentPage+" <--selectEbookList currentPage");
      
      final int ROW_PER_PAGE = 10; // 페이지에 보일 주문 개수
      int beginRow = (currentPage-1)*ROW_PER_PAGE; // 주문 목록 시작 부분
      
      // 최근 공지 가져오기
  	  NoticeDao noticeDao = new NoticeDao();
  	  ArrayList<Notice> noticeList = noticeDao.selectRecentNoticeList();
      
      // 전체 상품 목록
      EbookDao ebookDao = new EbookDao();
      ArrayList<Ebook> ebookList = ebookDao.selectEbookList(beginRow, ROW_PER_PAGE);
      
      // 인기 상품 목록 5개
      ArrayList<Ebook> popularEbookList = ebookDao.selectPopularEbookList();
      
      // 신상품 목록 5개
      ArrayList<Ebook> newEbookList = ebookDao.selectNewEbookList();
      %>
      
      <h2>최근 공지</h2>
		<!-- 최근 공지사항 5개를 출력 -->
		<table class="table" border="1">
			<thead>
				<tr>
					<th>번호</th>
					<th>제목</th>
					<th>작성자</th>
					<th>수정일</th>
					<th>생성일</th>
					<th>상세보기</th>
				</tr>
			</thead>
			<tbody>
				<%
					// 반복을 통해 카테고리 목록을 표로 출력
					for(Notice n : noticeList){
				%>
						<tr>
							<td><%=n.getNotice_no() %></td>
							<td><%=n.getNotice_title() %></td>
							<td><%=n.getMember_name() %></td>
							<td><%=n.getUpdate_date() %></td>
							<td><%=n.getCreate_date() %></td>
							<td><a href="<%=request.getContextPath() %>/selectNoticeOne.jsp?noticeNo=<%=n.getNotice_no() %>">상세보기</a></td>
						</tr>
				<%
					}
				%>
			</tbody>
		</table>
		<br>
      
      <h2>신상품 목록</h2>
      <!-- 주문 목록 출력 -->
	   <table class="table" border="1">
	   		<tr>
	         <%
	            for(Ebook e : newEbookList){
	         %>
		               <td>
		                  <div>
		                  	<a href="<%=request.getContextPath() %>/selectEbookOne.jsp?ebookNo=<%=e.getEbookNo() %>">
		                  	<img src="<%=request.getContextPath() %>/image/<%=e.getEbookImg() %>" width="200" height="200">
		                  	</a>
		                  </div>
		                  <div>
		                  	<a href="<%=request.getContextPath() %>/selectEbookOne.jsp?ebookNo=<%=e.getEbookNo() %>">
		                  		<%=e.getEbookTitle()  %>
		                  	</a>
		                  </div>
		                  <div>₩ <%=e.getEbookPrice() %></div>
		               </td>
	         <%
	            }
	         %>
	      </tr>
	   </table>
	   <br>
      
      <h2>인기 상품 목록</h2>
      <!-- 주문 목록 출력 -->
	   <table class="table" border="1">
	   		<tr>
	         <%
	            for(Ebook e : popularEbookList){
	         %>
		               <td>
		                  <div>
			                  <a href="<%=request.getContextPath() %>/selectEbookOne.jsp?ebookNo=<%=e.getEbookNo() %>">
			                  	<img src="<%=request.getContextPath() %>/image/<%=e.getEbookImg() %>" width="200" height="200">
			                  </a>
		                  </div>
		                  <div>
		                  	<a href="<%=request.getContextPath() %>/selectEbookOne.jsp?ebookNo=<%=e.getEbookNo() %>">
		                  		<%=e.getEbookTitle()  %>
		                  	</a>
		                  </div>
		                  <div>₩ <%=e.getEbookPrice() %></div>
		               </td>
	         <%
	            }
	         %>
	      </tr>
	   </table>
	   <br>
      
      <h2>전체 상품 목록</h2>
   <!-- 주문 목록 출력 -->
   <table class="table" border="1">
      <tr>
         <%
            int j = 0;
         
            // 반복을 통해 카테고리 목록을 표로 출력
            for(Ebook e : ebookList){
         %>
               <td>
                  <div>
                  	<a href="<%=request.getContextPath() %>/selectEbookOne.jsp?ebookNo=<%=e.getEbookNo() %>">
                  		<img src="<%=request.getContextPath() %>/image/<%=e.getEbookImg() %>" width="200" height="200">
                  	</a>
                  </div>
                  <div>
                  	<a href="<%=request.getContextPath() %>/selectEbookOne.jsp?ebookNo=<%=e.getEbookNo() %>">
                  		<%=e.getEbookTitle()  %>
                  	</a>
                  </div>
                  <div>₩ <%=e.getEbookPrice() %></div>
               </td>
         <%
               j+=1; // for문 끝날때마다 i는 1씩 증가
               if(j%5==0){
         %>
                  </tr><tr> <!-- 줄바꿈 -->
         <%
               }
            }
         %>
      </tr>
   </table>
   
   <div></div>
   
   <!-- 페이지 -->
   <%	
   	   // 페이징을 위해 구해야 할 마지막 페이지 연산
       int lastPage;
   	   int currentnumPage=0; // 현재 페이지가 몇번째 묶음인지(이전,다음 구현을 위함)
   	   int lastnumPage=0; // 마지막 페이지가 몇번째 묶음인지(마지막 페이지에서 다음이 나오지 않도록 하기 위함)
   	   
   	   lastPage = ebookDao.selectEbookListLastPage(ROW_PER_PAGE); // 상품의 개수를 통해 마지막 페이지가 몇번인지 추출
	   
   %>
    <ul class="pagination body-back-color">
    <%
    	if(currentPage!=1){
    %>
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/index.jsp?currentPage=<%=1 %>">처음</a></li>
    <%	
    	}
    	if(currentPage%ROW_PER_PAGE==0){ // 현재 페이지가 몇번째 묶음인지
    		currentnumPage =(currentPage/ROW_PER_PAGE)-1;
    	} else{
    		currentnumPage = currentPage/ROW_PER_PAGE;
    	}
   	%>
    <%
    	if((currentnumPage)>0){ // 이전
    %>
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/index.jsp?currentPage=<%=ROW_PER_PAGE*(currentnumPage-1)+1 %>">이전</a></li>
    <%
    	}
    
    	for(int i=0;i<ROW_PER_PAGE;i++){ // 중간 번호들
    		if(lastPage>=(ROW_PER_PAGE*currentnumPage)+i+1){
   	    %>
   		  <li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/index.jsp?currentPage=<%=(ROW_PER_PAGE*currentnumPage)+i+1 %>"><%=(ROW_PER_PAGE*currentnumPage)+i+1 %></a></li>
   	   <%
    		}
    	}
    	if(lastPage%ROW_PER_PAGE==0){ // 마지막 페이지가 몇번째 묶음인지
    		lastnumPage =(lastPage/ROW_PER_PAGE)-1;
    	} else{
    		lastnumPage = lastPage/ROW_PER_PAGE;
    	}
    	
    	if(lastnumPage>currentnumPage){
    %>
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/index.jsp?currentPage=<%=ROW_PER_PAGE*(currentnumPage+1)+1 %>">다음</a></li>
    <%
    	}
    	if(currentPage!=lastPage && lastPage!=0){
    %>
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/index.jsp?currentPage=<%=lastPage %>">맨끝</a></li>
    <%
    	}
    %>
	</ul>
      
</body>
</html>