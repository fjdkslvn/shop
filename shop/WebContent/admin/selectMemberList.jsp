<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<%
	request.setCharacterEncoding("utf-8");

	// 로그인이 되어있지 않거나 일반 회원이라면 메인화면으로 넘기기
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember==null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 검색어
	String searchMemberId = "";
	if(request.getParameter("searchMemberId")!=null){
		searchMemberId = request.getParameter("searchMemberId");
	}
	System.out.println(searchMemberId + " <--searchMemberId");
	
	// 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage+" <--selectMemberList currentPage");
	final int ROW_PER_PAGE = 10; // 상수: 변하지않을 값, java에서 final은 상수로 만든다는 뜻, 전부 대문자로 써서 상수임을 편하게 확인하자
	
	int  beginRow = (currentPage-1)*ROW_PER_PAGE;
	
	MemberDao memberDao = new MemberDao();
	ArrayList<Member> memberList = new ArrayList<>();
	
	// 검색어 여부에 따라 다르게 회원 목록을 불러온다.
	if(searchMemberId.equals("")){
		memberList = memberDao.selectMemberListAllByPage(beginRow, ROW_PER_PAGE);
	} else {
		memberList = memberDao.selectMemberListAllBySearchMemberId(beginRow, ROW_PER_PAGE, searchMemberId);
	}

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
	<title>회원 목록</title>
</head>
<body>
	<h1>회원 목록</h1>
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
				<th>memberNo</th>
				<th>memberId</th>
				<th>memberLevel</th>
				<th>memberName</th>
				<th>memberAge</th>
				<th>memberGender</th>
				<th>updateDate</th>
				<th>createDate</th>
				<th>등급수정</th>
				<th>비밀번호수정</th>
				<th>강제탈퇴</th>
			</tr>
		</thead>
		<tbody>
			<%
				for(Member m : memberList){
			%>
					<tr>
						<td><%=m.getMemberNo() %></td>
						<td><%=m.getMemberId() %></td>
						<td>
							<%
								if(m.getMemberLevel() ==0){
									%>
										<span>일반회원</span>
									<%
								} else if(m.getMemberLevel() ==1){
									%>
									<span>관리자</span>
								<%
							}
							%>
						</td>
						<td><%=m.getMemberName() %></td>
						<td><%=m.getMemberAge() %></td>
						<td><%=m.getMemberGender() %></td>
						<td><%=m.getUpdateDate() %></td>
						<td><%=m.getCreateDate() %></td>
						<td>
							<!-- 관리자의 비밀번호를 확인 후 특정회원의 등급수정 -->
							<a href="<%=request.getContextPath() %>/admin/updateMemberLevelForm.jsp?memberNo=<%=m.getMemberNo() %>">등급수정</a>
						</td>
						<td>
							<!-- 로그인된 관리자의 비밀번호를 확인 후 특정회원의 비밀번호를 수정 -->
							<a href="<%=request.getContextPath() %>/admin/updateMemberPwForm.jsp?memberNo=<%=m.getMemberNo() %>">비밀번호수정</a>
						</td>
						<td>
							<!-- 특정 회원을 강제 탈퇴 -->
							<a href="<%=request.getContextPath() %>/admin/deleteMember.jsp?memberNo=<%=m.getMemberNo() %>">강제탈퇴</a>
						</td>
					</tr>
			<%
				}
			%>
		</tbody>
	</table>
	
	<br><br>
	
	<!-- 페이지 -->
   <%	
   	   // 페이징을 위해 구해야 할 마지막 페이지 연산
       int lastPage;
   	   int currentnumPage=0; // 현재 페이지가 몇번째 묶음인지(이전,다음 구현을 위함)
   	   int lastnumPage=0; // 마지막 페이지가 몇번째 묶음인지(마지막 페이지에서 다음이 나오지 않도록 하기 위함)
   	   
   	   if(searchMemberId.equals("")){
   		lastPage = memberDao.selectMemberListLastPage(ROW_PER_PAGE);
   	   } else{
   		lastPage = memberDao.selectMemberListSearchLastPage(ROW_PER_PAGE, searchMemberId);
   	   }
	   
   %>
    <ul class="pagination body-back-color">
    <%
    	if(currentPage!=1){
    %>
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectMemberList.jsp?currentPage=<%=1 %>&searchMemberId=<%=searchMemberId %>">처음</a></li>
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
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectMemberList.jsp?currentPage=<%=ROW_PER_PAGE*(currentnumPage-1)+1 %>&searchMemberId=<%=searchMemberId %>">이전</a></li>
    <%
    	}
    
    	for(int i=0;i<ROW_PER_PAGE;i++){ // 중간 번호들
    		if(lastPage>=(ROW_PER_PAGE*currentnumPage)+i+1){
   	    %>
   		  <li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectMemberList.jsp?currentPage=<%=(ROW_PER_PAGE*currentnumPage)+i+1 %>&searchMemberId=<%=searchMemberId %>"><%=(ROW_PER_PAGE*currentnumPage)+i+1 %></a></li>
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
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectMemberList.jsp?currentPage=<%=ROW_PER_PAGE*(currentnumPage+1)+1 %>&searchMemberId=<%=searchMemberId %>">다음</a></li>
    <%
    	}
    	if(currentPage!=lastPage && lastPage!=0){
    %>
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectMemberList.jsp?currentPage=<%=lastPage %>&searchMemberId=<%=searchMemberId %>">맨끝</a></li>
    <%
    	}
    %>
	</ul>
	
	<!-- memberId로 검색 -->
	<div>
		<form action="<%=request.getContextPath() %>/admin/selectMemberList.jsp" method="get">
			memberId :
			<input type="text" name="searchMemberId">
			<button type="submit">검색</button>
		</form>
	</div>
	
</body>
</html>