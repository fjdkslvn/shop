<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>

<%
	request.setCharacterEncoding("utf-8");

	//로그인이 되어있지 않거나 일반 회원이라면 메인화면으로 넘기기
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember==null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 방어코드
	if(request.getParameter("noticeNo")=="" || request.getParameter("noticeNo")==null){
		response.sendRedirect(request.getContextPath()+"/admin/selectNoticeList.jsp");
		return;
	}
	
	// 상세보기할 공지 번호
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	
	// 정보 가져오기
	NoticeDao noticeDao = new NoticeDao();
	Notice notice = noticeDao.selectNoticeOne(noticeNo);
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
	<table class="table" border="1">
		<tr>
			<td>제목</td>
			<td><%=notice.getNotice_title() %></td>
		</tr>
		<tr>
			<td>내용</td>
			<td><%=notice.getNotice_content() %></td>
		</tr>
		<tr>
			<td>작성자</td>
			<td><%=notice.getMember_name() %></td>
		</tr>
		<tr>
			<td>작성일</td>
			<td><%=notice.getCreate_date() %></td>
		</tr>
		<tr>
			<td>수정일</td>
			<td><%=notice.getUpdate_date() %></td>
		</tr>
	</table>
	
	<!-- 수정,삭제 버튼 가로로 배치 -->
	<table>
		<tr>
			<td>
				<!-- 공지사항 수정 버튼 -->
				<form action="<%=request.getContextPath() %>/admin/updateNoticeForm.jsp" id="updateNoticeForm" method="post">
					<input type="hidden" value="<%=notice.getNotice_no() %>" name="noticeNo" id="noticeNo">
					<button class="btn btn-secondary" type="button" id="updateBtn">공지사항 수정</button>
				</form>
			</td>
			<td>
				<!-- 공지사항 삭제 버튼 -->
				<form action="<%=request.getContextPath() %>/admin/deleteNotice.jsp" id="deleteNotice" method="post">
					<input type="hidden" value="<%=notice.getNotice_no() %>" name="noticeNo" id="noticeNo">
					<button class="btn btn-secondary" type="button" id="deleteBtn">공지사항 삭제</button>
				</form>
			</td>
		</tr>
	</table>
	
	<script>
		$('#updateBtn').click(function(){
			// 버튼을 클릭하면 공지사항 수정폼으로 이동
			$('#updateNoticeForm').submit();
		});
		
		$('#deleteBtn').click(function(){
			// 버튼을 클릭하면 공지사항 삭제
			$('#deleteNotice').submit();
		});
	</script>
</body>
</html>