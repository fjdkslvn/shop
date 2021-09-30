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
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	
	<!-- 자바스크립트 -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	
	<meta charset="UTF-8">
	<title>공지 관리</title>
</head>

<%
	request.setCharacterEncoding("utf-8");
	
	// 로그인이 되어있지 않거나 일반 회원이라면 메인화면으로 넘기기
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
	System.out.println(currentPage+" <--공지사항 currentPage");
	
	final int ROW_PER_PAGE = 10; // 페이지에 보일 공지사항 개수
	int  beginRow = (currentPage-1)*ROW_PER_PAGE; // 공지사항 목록 시작 부분
	
	// 공지 목록을 리스트에 담기
	NoticeDao noticeDao = new NoticeDao();
	ArrayList<Notice> noticeList = noticeDao.selectNoticeList(beginRow,ROW_PER_PAGE);
%>
<body>
	<h1>공지사항 목록</h1>
	<div class="right">
		<a href="<%=request.getContextPath() %>/index.jsp">메인으로 돌아가기</a>
		<a href="<%=request.getContextPath() %>/logout.jsp">로그아웃</a>
	</div>
	<br>
	<div>
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
	</div>
	
	
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
						<td><a href="<%=request.getContextPath() %>/admin/selectNoticeOne.jsp?noticeNo=<%=n.getNotice_no() %>">상세보기</a></td>
					</tr>
			<%
				}
			%>
		</tbody>
	</table>
	<form action="<%=request.getContextPath() %>/admin/insertNoticeForm.jsp" id="insertNoticeForm" method="post">
		<button class="btn btn-secondary" type="button" id="btn">공지사항 추가</button>
	</form>
	
	<script>
		$('#btn').click(function(){
			// 버튼을 클릭하면 공지사항 생성폼으로 이동
			$('#insertNoticeForm').submit();
		});
	</script>
	
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
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectNoticeList.jsp?currentPage=<%=1 %>">처음</a></li>
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
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectNoticeList.jsp?currentPage=<%=ROW_PER_PAGE*(currentnumPage-1)+1 %>">이전</a></li>
    <%
    	}
    
    	for(int i=0;i<ROW_PER_PAGE;i++){ // 중간 번호들
    		if(lastPage>=(ROW_PER_PAGE*currentnumPage)+i+1){
   	    %>
   		  <li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectNoticeList.jsp?currentPage=<%=(ROW_PER_PAGE*currentnumPage)+i+1 %>"><%=(ROW_PER_PAGE*currentnumPage)+i+1 %></a></li>
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
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectNoticeList.jsp?currentPage=<%=ROW_PER_PAGE*(currentnumPage+1)+1 %>">다음</a></li>
    <%
    	}
    	if(currentPage!=lastPage && lastPage!=0){
    %>
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectNoticeList.jsp?currentPage=<%=lastPage %>">맨끝</a></li>
    <%
    	}
    %>
	</ul>
</body>
</html>