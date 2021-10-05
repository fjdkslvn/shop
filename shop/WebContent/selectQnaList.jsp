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
	<title>질문 게시판</title>
</head>

<%
	request.setCharacterEncoding("utf-8");
	
	// 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage+" <--질문 목록 currentPage");
	
	final int ROW_PER_PAGE = 10; // 페이지에 보일 질문 개수
	int  beginRow = (currentPage-1)*ROW_PER_PAGE; // 질문 목록 시작 부분
	
	// 공지 목록을 리스트에 담기
	QnaDao qnaDao = new QnaDao();
	ArrayList<Qna> qnaList = qnaDao.selectQnaList(beginRow,ROW_PER_PAGE);
%>
<body>
	<h1>질문 게시판</h1>
   <div class="right">
      <%
      	 request.setCharacterEncoding("utf-8");
      
         // 로그인이 되어있지 않으면 로그인,회원가입 보여주고 / 로그인 되어있으면 로그아웃 보이기
         Member loginMember=null;
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
	
	
	<table class="table" border="1">
		<thead>
			<tr>
				<th></th>
				<th>번호</th>
				<th>제목</th>
				<th>작성자</th>
				<th>날짜</th>
			</tr>
		</thead>
		<tbody>
			<%
				// 반복을 통해 질문 목록을 표로 출력
				for(Qna q : qnaList){
					// 만약 비밀글이라면
					if(q.getQnaSecret().equals("Y")){
						// 만약 비밀글의 작성자가 본인이라면 비밀글이라도 상세보기가 가능하도록 한다.
						if(loginMember!=null && q.getMemberId().equals(loginMember.getMemberId())){
						%>
							<tr>
								<td><img src="<%=request.getContextPath() %>/image/lock.PNG" width="20" height="20"></td>
								<td><%=q.getQnaNo() %></td>
								<td><a href="<%=request.getContextPath() %>/selectQnaOne.jsp?qnaNo=<%=q.getQnaNo() %>"><%=q.getQnaTitle() %></a></td>
								<td><%=q.getMemberId() %></td>
								<td><%=q.getCreateDate() %></td>
							</tr>
						<%
						} else{ // 상세보기는 불가능하도록 한다.
						%>
							<tr>
								<td><img src="<%=request.getContextPath() %>/image/lock.PNG" width="20" height="20"></td>
								<td><%=q.getQnaNo() %></td>
								<td><%=q.getQnaTitle() %></td>
								<td><%=q.getMemberId() %></td>
								<td><%=q.getCreateDate() %></td>
							</tr>
						<%
						}
					} else{ // 비밀글이 아니라면
					%>
						<tr>
							<td></td>
							<td><%=q.getQnaNo() %></td>
							<td><a href="<%=request.getContextPath() %>/selectQnaOne.jsp?qnaNo=<%=q.getQnaNo() %>"><%=q.getQnaTitle() %></a></td>
							<td><%=q.getMemberId() %></td>
							<td><%=q.getCreateDate() %></td>
						</tr>
					<%	
					}
				}
			%>
		</tbody>
	</table>
	<%
		if(session.getAttribute("loginMember")!=null){
	%>
			<!-- 질문 추가 버튼 -->
			<form action="<%=request.getContextPath() %>/insertQnaForm.jsp" id="insertQnaForm" method="post">
				<button class="btn btn-secondary" type="button" id="insertBtn">새질문</button>
			</form>
	<%
		}
	%>
	
	<br><br>
	
	<!-- 페이지 -->
   <%	
   	   // 페이징을 위해 구해야 할 마지막 페이지 연산
       int lastPage;
   	   int currentnumPage=0; // 현재 페이지가 몇번째 묶음인지(이전,다음 구현을 위함)
   	   int lastnumPage=0; // 마지막 페이지가 몇번째 묶음인지(마지막 페이지에서 다음이 나오지 않도록 하기 위함)
   	   
   	   lastPage = qnaDao.selectQnaListLastPage(ROW_PER_PAGE);
	   
   %>
    <ul class="pagination body-back-color">
    <%
    	if(currentPage!=1){
    %>
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectQnaListMain.jsp?currentPage=<%=1 %>">처음</a></li>
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
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectQnaListMain.jsp?currentPage=<%=ROW_PER_PAGE*(currentnumPage-1)+1 %>">이전</a></li>
    <%
    	}
    
    	for(int i=0;i<ROW_PER_PAGE;i++){ // 중간 번호들
    		if(lastPage>=(ROW_PER_PAGE*currentnumPage)+i+1){
   	    %>
   		  <li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectQnaListMain.jsp?currentPage=<%=(ROW_PER_PAGE*currentnumPage)+i+1 %>"><%=(ROW_PER_PAGE*currentnumPage)+i+1 %></a></li>
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
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectQnaListMain.jsp?currentPage=<%=ROW_PER_PAGE*(currentnumPage+1)+1 %>">다음</a></li>
    <%
    	}
    	if(currentPage!=lastPage && lastPage!=0){
    %>
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectQnaListMain.jsp?currentPage=<%=lastPage %>">맨끝</a></li>
    <%
    	}
    %>
	</ul>
	
	<script>
		$('#insertBtn').click(function(){
			// 버튼을 클릭하면 공지사항 수정폼으로 이동
			$('#insertQnaForm').submit();
		});
	</script>
</body>
</html>