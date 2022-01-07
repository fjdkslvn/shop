<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<%
	Member loginMember = (Member)session.getAttribute("loginMember");
	// 로그인이 되어있지 않으면 로그인,회원가입 보여주고 / 로그인 되어있으면 로그아웃 보이기
	if(loginMember==null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	final int ROW_PER_PAGE = 10; // 페이지에 보일 전자책 개수
	int  beginRow = (currentPage-1)*ROW_PER_PAGE; // 전자책 목록 시작 부분
	
	// 최근 공지 가져오기
	NoticeDao noticeDao = new NoticeDao();
	ArrayList<Notice> noticeList = noticeDao.selectRecentNoticeList();
	
	// 답변이 달리지 않은 공지 가져오기
	QnaDao qnaDao = new QnaDao();
	ArrayList<Qna> qnaList = qnaDao.selectQnaListByNoComment(beginRow, ROW_PER_PAGE);
%>
<head>
   <!-- style.css 불러오기 -->
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/style.css">
	
	<!-- 부트스트랩 -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	
	<!-- 자바스크립트 -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
   
   <meta charset="UTF-8">
   <title>전자책 상점</title>
</head>
<body>
	<div class="text-center">
		<a href="<%=request.getContextPath() %>/admin/adminindex.jsp"><img src="<%=request.getContextPath() %>/image/adminbanner.PNG" width="650" height="130"></a>
	</div>
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
	<br>
	
	<h2>최근 공지</h2>
	<!-- 최근 공지사항 5개를 출력 -->
	<table class="table" border="1">
		<thead>
			<tr>
				<th>번호</th>
				<th>제목</th>
				<th>작성자</th>
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
						<td><%=n.getCreate_date() %></td>
						<td><a href="<%=request.getContextPath() %>/admin/selectNoticeOne.jsp?noticeNo=<%=n.getNotice_no() %>">상세보기</a></td>
					</tr>
			<%
				}
			%>
		</tbody>
	</table>
	<br><br>
	
	<h2>미답변 질문</h2>
	<table class="table" border="1">
		<thead>
			<tr>
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
				%>
					<tr>
						<td><%=q.getQnaNo() %></td>
						<td><a href="<%=request.getContextPath() %>/admin/selectQnaOne.jsp?qnaNo=<%=q.getQnaNo() %>"><%=q.getQnaTitle() %></a></td>
						<td><%=q.getMemberId() %></td>
						<td><%=q.getCreateDate() %></td>
					</tr>
				<%
				}
			%>
		</tbody>
	</table>
	<br><br>
	
	<%
		// 이전 버튼
		if(currentPage>1){
			%>
				<a href="<%=request.getContextPath() %>/admin/adminindex.jsp?currentPage=<%=currentPage-1 %>">이전</a>
			<%
		}
		
		int lastPage = qnaDao.selectQnaListByNoCommentLastPage(ROW_PER_PAGE);
		// 다음 버튼
		if(currentPage<lastPage){
			%>
				<a href="<%=request.getContextPath() %>/admin/adminindex.jsp?currentPage=<%=currentPage+1 %>">다음</a>
			<%
		}
	%>
	
	
</body>
</html>