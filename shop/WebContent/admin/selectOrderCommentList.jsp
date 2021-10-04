<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<%
	request.setCharacterEncoding("utf-8");
	
	//로그인이 되어있지 않거나 일반 회원이라면 메인화면으로 넘기기
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember==null || loginMember.getMemberLevel() < 1){
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
	<title>후기 목록보기</title>
</head>
<body>
	<h1>상품평 목록</h1>
    <div class="right">
		<a href="<%=request.getContextPath() %>/index.jsp">메인으로 돌아가기</a>
		<a href="<%=request.getContextPath() %>/logout.jsp">로그아웃</a>
	</div>
	<br>
    <!-- 메뉴 -->
    <div>
       <jsp:include page="/partial/adminMenu.jsp"></jsp:include>
    </div>
		<%
			OrderCommentDao orderCommentDao = new OrderCommentDao();
			
			// 후기 리스트 추출
			ArrayList<OrderComment> commentList = orderCommentDao.selectOrderCommentList(beginRow, ROW_PER_PAGE);
			
			// 후기 리스트 마지막 페이지
			int lastPage = orderCommentDao.selectOrderCommentListLastPage(ROW_PER_PAGE);
		%>
		
		<!-- 후기 목록 출력 -->
		<table class="table" border="1">
			<tr>
				<th>상품번호</th>
				<th>상품명</th>
				<th>별점</th>
				<th>후기</th>
				<th>날짜</th>
			</tr>
		<%
			for(OrderComment o:commentList){
		%>
				<tr>
					<td><%=o.getEbookNo() %></td>
					<td><%=o.getEbookTitle() %></td>
					<td><%=o.getOrderScore() %></td>
					<td><%=o.getOrderCommentContent() %></td>
					<td><%=o.getUpdateDate() %></td>
				</tr>
		<%
			}
		%>
		</table>
		<!-- 페이지 -->
	   <%
	   	   int currentnumPage=0; // 현재 페이지가 몇번째 묶음인지(이전,다음 구현을 위함)
	   	   int lastnumPage=0; // 마지막 페이지가 몇번째 묶음인지(마지막 페이지에서 다음이 나오지 않도록 하기 위함)
		   
	   %>
	    <ul class="pagination body-back-color">
	    <%
	    	if(currentPage!=1){
	    %>
	    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectOrderCommentList.jsp?currentPage=<%=1 %>">처음</a></li>
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
	    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectOrderCommentList.jsp?currentPage=<%=ROW_PER_PAGE*(currentnumPage-1)+1 %>">이전</a></li>
	    <%
	    	}
	    
	    	for(int i=0;i<ROW_PER_PAGE;i++){ // 중간 번호들
	    		if(lastPage>=(ROW_PER_PAGE*currentnumPage)+i+1){
	   	    %>
	   		  <li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectOrderCommentList.jsp?currentPage=<%=(ROW_PER_PAGE*currentnumPage)+i+1 %>"><%=(ROW_PER_PAGE*currentnumPage)+i+1 %></a></li>
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
	    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectOrderCommentList.jsp?currentPage=<%=ROW_PER_PAGE*(currentnumPage+1)+1 %>">다음</a></li>
	    <%
	    	}
	    	if(currentPage!=lastPage && lastPage!=0){
	    %>
	    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectOrderCommentList.jsp?currentPage=<%=lastPage %>">맨끝</a></li>
	    <%
	    	}
	    %>
		</ul>

</body>
</html>