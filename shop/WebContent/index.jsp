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
      
      // 인기 상품 목록 10개
      ArrayList<Ebook> popularEbookList = ebookDao.selectPopularEbookList();
      
      // 신상품 목록 10개
      ArrayList<Ebook> newEbookList = ebookDao.selectNewEbookList();
      int rotateNum=0;
      %>
      
      <div class="page-center">
      <br>
		<!-- 최근 공지사항 3개를 출력 -->
		<table class="table">
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
      
      <h2>화제의 신간</h2>
      <!-- 신상품 목록 출력 -->
	   <table class="table" border="1">
	   		<tr>
	         <%
	            for(Ebook e : newEbookList){
	         %>
		               <td class="size-19">
		                  <div>
		                  	<a href="<%=request.getContextPath() %>/selectEbookOne.jsp?ebookNo=<%=e.getEbookNo() %>">
		                  	<div id="square"><img src="<%=request.getContextPath() %>/image/<%=e.getEbookImg() %>"></div>
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
			 	   rotateNum+=1; // for문 끝날때마다 i는 1씩 증가
	               if(rotateNum%5==0){
	         %>
	                  </tr><tr> <!-- 줄바꿈 -->
	         <%
	               }
	            }
	            rotateNum=0;
	         %>
	      </tr>
	   </table>
	   <br><br><br><br>
      
      <h2>베스트 셀러</h2>
      <!-- 인기상품 목록 출력 -->
	   <table class="table" border="1">
	   		<tr>
	         <%
	            for(Ebook e : popularEbookList){
	         %>
		               <td class="size-19">
		                  <div>
			                  <a href="<%=request.getContextPath() %>/selectEbookOne.jsp?ebookNo=<%=e.getEbookNo() %>">
			                  	<div id="square"><img src="<%=request.getContextPath() %>/image/<%=e.getEbookImg() %>"></div>
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
				 	   rotateNum+=1; // for문 끝날때마다 i는 1씩 증가
		               if(rotateNum%5==0){
		         %>
		                  </tr><tr> <!-- 줄바꿈 -->
		         <%
		               }
	            }
	         	rotateNum=0;
	         %>
	      </tr>
	   </table>
	   <br><br><br><br>
      
      <h2>전체 상품 목록</h2>
   <!-- 주문 목록 출력 -->
   <table class="table" border="1">
      <tr>
         <%
            // 반복을 통해 카테고리 목록을 표로 출력
            for(Ebook e : ebookList){
         %>
               <td class="size-19">
                  <div>
                  	<a href="<%=request.getContextPath() %>/selectEbookOne.jsp?ebookNo=<%=e.getEbookNo() %>">
                  		<div id="square"><img src="<%=request.getContextPath() %>/image/<%=e.getEbookImg() %>"></div>
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
         	   rotateNum+=1; // for문 끝날때마다 rotateNum는 1씩 증가
               if(rotateNum%5==0){
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
    <ul class="pagination body-back-color">
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
	
	<!-- footer -->
	<div>
      <jsp:include page="/partial/footer.jsp"></jsp:include>
   </div>
</body>
</html>