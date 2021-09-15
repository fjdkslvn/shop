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
	
	int currentPage = 1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	final int ROW_PER_PAGE = 10; // 상수: 변하지않을 값, java에서 final은 상수로 만든다는 뜻, 전부 대문자로 써서 상수임을 편하게 확인하자
	
	int  beginRow = (currentPage-1)*ROW_PER_PAGE;
	MemberDao memberDao = new MemberDao();
	ArrayList<Member> memberList = memberDao.selectMemberListAllByPage(beginRow, ROW_PER_PAGE);

%>
<!DOCTYPE html>
<html>
<head>
	<!-- 부트스트랩 -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
		
	<meta charset="UTF-8">
	<title>회원 목록</title>
</head>
<body>
	<h1>회원 목록</h1>
	<div>
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
	</div>
	<table border="1">
		<thead>
			<tr>
				<th>memberNo</th>
				<th>memberLevel</th>
				<th>memberName</th>
				<th>memberAge</th>
				<th>memberGender</th>
				<th>updateDate</th>
				<th>createDate</th>
				<th></th>
			</tr>
		</thead>
		<tbody>
			<%
				for(Member m : memberList){
			%>
					<tr>
						<td><%=m.getMemberNo() %></td>
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
       int lastPage = memberDao.selectMemberListLastPage(ROW_PER_PAGE);
	   int currentnumPage=0; // 현재 페이지가 몇번째 묶음인지(이전,다음 구현을 위함)
	   int lastnumPage=0; // 마지막 페이지가 몇번째 묶음인지(마지막 페이지에서 다음이 나오지 않도록 하기 위함)
   %>
    <ul class="pagination body-back-color">
    <%
    	if(currentPage!=1){
    %>
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectMemberList.jsp?currentPage=<%=1 %>">처음</a></li>
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
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectMemberList.jsp?currentPage=<%=ROW_PER_PAGE*(currentnumPage-1)+1 %>">이전</a></li>
    <%
    	}
    
    	for(int i=0;i<ROW_PER_PAGE;i++){ // 중간 번호들
    		if(lastPage>=(ROW_PER_PAGE*currentnumPage)+i+1){
   	    %>
   		  <li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectMemberList.jsp?currentPage=<%=(ROW_PER_PAGE*currentnumPage)+i+1 %>"><%=(ROW_PER_PAGE*currentnumPage)+i+1 %></a></li>
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
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectMemberList.jsp?currentPage=<%=ROW_PER_PAGE*(currentnumPage+1)+1 %>">다음</a></li>
    <%
    	}
    	if(currentPage!=lastPage){
    %>
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectMemberList.jsp?currentPage=<%=lastPage %>">맨끝</a></li>
    <%
    	}
    %>
	</ul>
	
</body>
</html>