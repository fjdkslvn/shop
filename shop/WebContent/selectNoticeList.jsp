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
	
	// 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage+" <--공지사항 currentPage");
	
	final int ROW_PER_PAGE = 10; // 페이지에 보일 공지사항 개수
	int  beginRow = (currentPage-1)*ROW_PER_PAGE; // 공지사항 목록 시작 부분
	
	// 공지 목록을 리스트에 담기
	NoticeDao noticeDao = new NoticeDao();
	ArrayList<Notice> noticeList = noticeDao.selectNoticeList(beginRow,ROW_PER_PAGE);
%>
   <!-- start : submenu include -->
   <div>
      <jsp:include page="/partial/mainMenu.jsp"></jsp:include>
   </div>
   <!-- end : submenu include -->
   <br>
   
   <div class="page-center">
   
   <!-- breadcrumb -->
	<nav aria-label="breadcrumb">
		<ol class="breadcrumb" style="background: white;">
			<li class="breadcrumb-item"><a href="<%=request.getContextPath() %>/index.jsp">홈</a></li>
			<li class="breadcrumb-item active" aria-current="page">공지사항</li>
		</ol>
	</nav>
	
	<table class="table">
			<thead>
				<tr>
					<th>공지사항</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>
						<div class="list-group">
					<%
						for(Notice n : noticeList){
					%>
  							<a href="<%=request.getContextPath() %>/selectNoticeOne.jsp?noticeNo=<%=n.getNotice_no() %>" class="list-group-item list-group-item-action"><%=n.getNotice_title() %></a>
					<%	
						}
					%>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	
	<br><br>
	
	<!-- 페이지 -->
   <%	
   	   // 페이징을 위해 구해야 할 마지막 페이지 연산
       int lastPage;
   	   int currentnumPage=0; // 현재 페이지가 몇번째 묶음인지(이전,다음 구현을 위함)
   	   int lastnumPage=0; // 마지막 페이지가 몇번째 묶음인지(마지막 페이지에서 다음이 나오지 않도록 하기 위함)
   	   
   	   lastPage = noticeDao.selectNoticeListLastPage(ROW_PER_PAGE);
	   
   %>
    <ul class="pagination body-back-color">
    <%
    	if(currentPage!=1){
    %>
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectNoticeList.jsp?currentPage=<%=1 %>"><<</a></li>
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
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectNoticeList.jsp?currentPage=<%=ROW_PER_PAGE*(currentnumPage-1)+1 %>"><</a></li>
    <%
    	}
    	
    	for(int i=0;i<ROW_PER_PAGE;i++){ // 중간 번호들
    		if(lastPage>=(ROW_PER_PAGE*currentnumPage)+i+1){
    			if(currentPage == (ROW_PER_PAGE*currentnumPage)+i+1){
  				%>
  					<li class="page-item active"><a class="page-link" href="<%=request.getContextPath() %>/selectNoticeList.jsp?currentPage=<%=(ROW_PER_PAGE*currentnumPage)+i+1 %>"><%=(ROW_PER_PAGE*currentnumPage)+i+1 %></a></li>
  				<%
    			} else{
   				%>
   		   		  	<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectNoticeList.jsp?currentPage=<%=(ROW_PER_PAGE*currentnumPage)+i+1 %>"><%=(ROW_PER_PAGE*currentnumPage)+i+1 %></a></li>
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
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectNoticeList.jsp?currentPage=<%=ROW_PER_PAGE*(currentnumPage+1)+1 %>">></a></li>
    <%
    	}
    	if(currentPage!=lastPage && lastPage!=0){
    %>
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectNoticeList.jsp?currentPage=<%=lastPage %>">>></a></li>
    <%
    	}
    %>
	</ul>
	</div>
	
	<!-- footer -->
	<div>
      <jsp:include page="/partial/footer.jsp"></jsp:include>
   </div>
</body>
</html>