<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
   <!-- style.css 불러오기 -->
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/style.css">
	
	<!-- 부트스트랩 -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
	
	<!-- 자바스크립트 -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
   
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
            Member loginMember = (Member)session.getAttribute("loginMember");
            %>
               <%=loginMember.getMemberId() %>회원님 반갑습니다.
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
      
      <div class="page-center">
      
		<!-- 최근 공지사항 5개를 출력 -->
		<table class="table" border="1">
			<thead>
				<tr>
					<th>최근 공지사항</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>
					<%
						for(Notice n : noticeList){
					%>
						  <div class="card">
						    <div class="card-header" id="heading<%=n.getNotice_no() %>">
						      <h5 class="mb-0">
						        <button class="btn btn-link" data-toggle="collapse" data-target="#<%=n.getNotice_no() %>" aria-controls="<%=n.getNotice_no() %>">
						          * <%=n.getNotice_title() %> - <%=n.getCreate_date().substring(0,10) %>
						        </button>
						      </h5>
						    </div>
						
						    <div id="<%=n.getNotice_no() %>" class="collapse" aria-labelledby="heading<%=n.getNotice_no() %>" data-parent="#accordion">
						      <div class="card-body">
						        <%=n.getNotice_content() %>
						      </div>
						    </div>
						  </div>
					<%	
						}
					%>
					</td>
				</tr>
			</tbody>
		</table>
		<br><br><br><br>
      
      <h2>신상품 목록</h2>
      <!-- 주문 목록 출력 -->
	   <table class="table" border="1">
	   		<tr>
	         <%
	            for(Ebook e : newEbookList){
	         %>
		               <td class="size-19">
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
	   <br><br><br><br>
      
      <h2>인기 상품 목록</h2>
      <!-- 주문 목록 출력 -->
	   <table class="table" border="1">
	   		<tr>
	         <%
	            for(Ebook e : popularEbookList){
	         %>
		               <td class="size-19">
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
	   <br><br><br><br>
      
      <h2>전체 상품 목록</h2>
   <!-- 주문 목록 출력 -->
   <table class="table" border="1">
      <tr>
         <%
            int j = 0;
         
            // 반복을 통해 카테고리 목록을 표로 출력
            for(Ebook e : ebookList){
         %>
               <td class="size-19">
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
            
            if(ebookList.size()%5!=0){
            	for(int i=0; i<5-(ebookList.size()%5);i++){
    		%>
    				<td class="size-19"></td>
    		<%
            	}
            }
         %>
      </tr>
   </table>
   
   <br>
   
   <!-- 페이지 -->
   <%	
   	   // 페이징을 위해 구해야 할 마지막 페이지 연산
       int lastPage;
   	   int currentnumPage=0; // 현재 페이지가 몇번째 묶음인지(이전,다음 구현을 위함)
   	   int lastnumPage=0; // 마지막 페이지가 몇번째 묶음인지(마지막 페이지에서 다음이 나오지 않도록 하기 위함)
   	   
   	   lastPage = ebookDao.selectEbookListLastPage(ROW_PER_PAGE); // 상품의 개수를 통해 마지막 페이지가 몇번인지 추출
	   
   %>
   <div>
    <ul class="pagination pagination-lg body-back-color">
    <%
    	if(currentPage!=1){
    %>
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/index.jsp?currentPage=<%=1 %>"><<</a></li>
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
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/index.jsp?currentPage=<%=ROW_PER_PAGE*(currentnumPage-1)+1 %>"><</a></li>
    <%
    	}
    
    	for(int i=0;i<ROW_PER_PAGE;i++){ // 중간 번호들
    		if(lastPage>=(ROW_PER_PAGE*currentnumPage)+i+1){
    			if(currentPage == (ROW_PER_PAGE*currentnumPage)+i+1){
  				%>
  					<li class="page-item active"><a class="page-link" href="<%=request.getContextPath() %>/index.jsp?currentPage=<%=(ROW_PER_PAGE*currentnumPage)+i+1 %>"><%=(ROW_PER_PAGE*currentnumPage)+i+1 %></a></li>
  				<%
    			} else{
   				%>
   		   		  	<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/index.jsp?currentPage=<%=(ROW_PER_PAGE*currentnumPage)+i+1 %>"><%=(ROW_PER_PAGE*currentnumPage)+i+1 %></a></li>
   		   	   <%	
    			}
    		}
    	}
    	if(lastPage%ROW_PER_PAGE==0){ // 마지막 페이지가 몇번째 묶음인지
    		lastnumPage =(lastPage/ROW_PER_PAGE)-1;
    	} else{
    		lastnumPage = lastPage/ROW_PER_PAGE;
    	}
    	
    	if(lastnumPage>currentnumPage){
    %>
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/index.jsp?currentPage=<%=ROW_PER_PAGE*(currentnumPage+1)+1 %>">></a></li>
    <%
    	}
    	if(currentPage!=lastPage && lastPage!=0){
    %>
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/index.jsp?currentPage=<%=lastPage %>">>></a></li>
    <%
    	}
    %>
    </div>
	</ul>
	</div>
</body>
</html>