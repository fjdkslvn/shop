<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
	
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
      request.setCharacterEncoding("utf-8");
      
      // 페이지
      int currentPage = 1;
      if(request.getParameter("currentPage")!=null){
         currentPage = Integer.parseInt(request.getParameter("currentPage"));
      }
      System.out.println(currentPage+" <--selectEbookList currentPage");
      
      final int ROW_PER_PAGE = 10; // 페이지에 보일 상품 개수
      int beginRow = (currentPage-1)*ROW_PER_PAGE; // 상품 목록 시작 부분
      
      // 전체 상품 목록
      EbookDao ebookDao = new EbookDao();
      ArrayList<Ebook> ebookList = ebookDao.selectEbookList(beginRow, ROW_PER_PAGE);
      %>
   <div class="page-center">
   		<!-- breadcrumb -->
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb" style="background: white;">
				<li class="breadcrumb-item"><a href="<%=request.getContextPath() %>/index.jsp">홈</a></li>
				<li class="breadcrumb-item active" aria-current="page">서적 목록</li>
			</ol>
		</nav>
   <!-- 상품 목록 출력 -->
   <table class="table">
      <tr>
         <%
         	int rotateNum=0;
            // 반복을 통해 전자책을 출력
            for(Ebook e : ebookList){
         %>
               <td class="size-19">
               	<div class="card" style="width: 18rem;">
				  <img class="card-img-top" src="<%=request.getContextPath() %>/image/ebook/<%=e.getEbookImg() %>" height="300px;">
				  <div class="card-body">
				    <h5 class="card-title"><%=e.getEbookTitle()  %></h5>
				    <p class="card-text">₩ <%=e.getEbookPrice() %></p>
				    <a href="<%=request.getContextPath() %>/selectEbookOne.jsp?ebookNo=<%=e.getEbookNo() %>" class="btn btn-outline-primary">상세보기</a>
				  </div>
				</div>
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
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectEbookList.jsp?currentPage=<%=1 %>"><<</a></li>
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
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectEbookList.jsp?currentPage=<%=ROW_PER_PAGE*(currentnumPage-1)+1 %>"><</a></li>
    <%
    	}
    
    	for(int i=0;i<ROW_PER_PAGE;i++){ // 중간 번호들
    		if(lastPage>=(ROW_PER_PAGE*currentnumPage)+i+1){
    			if(currentPage == (ROW_PER_PAGE*currentnumPage)+i+1){
  				%>
  					<li class="page-item active"><a class="page-link" href="<%=request.getContextPath() %>/selectEbookList.jsp?currentPage=<%=(ROW_PER_PAGE*currentnumPage)+i+1 %>"><%=(ROW_PER_PAGE*currentnumPage)+i+1 %></a></li>
  				<%
    			} else{
   				%>
   		   		  	<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectEbookList.jsp?currentPage=<%=(ROW_PER_PAGE*currentnumPage)+i+1 %>"><%=(ROW_PER_PAGE*currentnumPage)+i+1 %></a></li>
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
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectEbookList.jsp?currentPage=<%=ROW_PER_PAGE*(currentnumPage+1)+1 %>">></a></li>
    <%
    	}
    	if(currentPage!=lastPage && lastPage!=0){
    %>
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectEbookList.jsp?currentPage=<%=lastPage %>">>></a></li>
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