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
	<title>관리자 메인</title>
</head>
<%
	Member loginMember = (Member)session.getAttribute("loginMember");
	// 로그인이 되어있지 않으면 로그인,회원가입 보여주고 / 로그인 되어있으면 로그아웃 보이기
	if(loginMember==null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 최근 공지 가져오기
	NoticeDao noticeDao = new NoticeDao();
	ArrayList<Notice> noticeList = noticeDao.selectRecentNoticeList();
%>
<body>
	<!-- 관리자 메뉴 -->
	<h1>관리자 페이지</h1>
	<div class="right">
		<a href="<%=request.getContextPath() %>/index.jsp">메인으로 돌아가기</a>
		<a href="<%=request.getContextPath() %>/logout.jsp">로그아웃</a>
	</div>
	<br>
	<!-- start : submenu include -->
   <div>
      <jsp:include page="/partial/adminMenu.jsp"></jsp:include>
   </div>
   <!-- end : submenu include -->
	<br><br>
	
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
						<td><a href="<%=request.getContextPath() %>/admin/selectNoticeOne.jsp?noticeNo=<%=n.getNotice_no() %>">상세보기</a></td>
					</tr>
			<%
				}
			%>
		</tbody>
	</table>
	
</body>
</html>