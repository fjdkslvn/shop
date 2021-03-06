<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>

<%
	request.setCharacterEncoding("utf-8");
	
	// 방어코드
	if(request.getParameter("qnaNo")=="" || request.getParameter("qnaNo")==null){
		response.sendRedirect(request.getContextPath()+"/admin/selectQnaList.jsp");
		return;
	}
	
	// 상세보기할 질문 번호
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	
	// 정보 가져오기
	QnaDao qnaDao = new QnaDao();
	Qna qna = qnaDao.selectQnaOne(qnaNo);
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
			<td><%=qna.getQnaTitle() %></td>
		</tr>
		<tr>
			<td>내용</td>
			<td><%=qna.getQnaContent() %></td>
		</tr>
		<tr>
			<td>작성자</td>
			<td><%=qna.getMemberId() %></td>
		</tr>
		<tr>
			<td>작성일</td>
			<td><%=qna.getCreateDate() %></td>
		</tr>
		<tr>
			<td>수정일</td>
			<td><%=qna.getUpdateDate() %></td>
		</tr>
	</table>
	
	<%
		// 답변이 달려있는지에 대한 여부
		boolean is = qnaDao.IsQnaComment(qnaNo);
		
		// 답변이 달려있다면
		if(is){
			QnaCommentDao qnaCommentDao = new QnaCommentDao();
			QnaComment qc = qnaCommentDao.selectQnaCommentOne(qnaNo);
		%>
			<h2>답변</h2>
			<table class="table" border="1">
				<tr>
					<td>답변</td>
					<td><%=qc.getQnaCommentContent() %></td>
				</tr>
				<tr>
					<td>작성일</td>
					<td><%=qc.getCreateDate() %></td>
				</tr>
				<tr>
					<td>수정일</td>
					<td><%=qc.getUpdateDate() %></td>
				</tr>
			</table>
			<br>
			
			<table>
				<tr>
					<td>
						<!-- 답변 수정 버튼 -->
						<form action="<%=request.getContextPath() %>/admin/updateQnaCommentForm.jsp" id="updateQnaCommentForm" method="post">
							<input type="hidden" name="qnaNo" value="<%=qnaNo %>">
							<button class="btn btn-secondary" type="button" id="updateBtn">답변수정</button>
						</form>
					</td>
					<td>
						<!-- 답변 삭제 버튼 -->
						<form action="<%=request.getContextPath() %>/admin/deleteQnaComment.jsp" id="deleteQnaCommentForm" method="post">
							<input type="hidden" name="qnaNo" value="<%=qnaNo %>">
							<button class="btn btn-secondary" type="button" id="deleteBtn">답변삭제</button>
						</form>
					</td>
				</tr>
			</table>
		<%
		} else{ // 답변이 없다면
		%>
			<!-- 답변 추가 버튼 -->
			<form action="<%=request.getContextPath() %>/admin/insertQnaCommentForm.jsp" id="insertQnaCommentForm" method="post">
				<input type="hidden" name="qnaNo" value="<%=qnaNo %>">
				<button class="btn btn-secondary" type="button" id="insertBtn">답변작성</button>
			</form>
		<%
		}
	%>
	
	<script>
		$('#insertBtn').click(function(){
			// 버튼을 클릭하면 답변 생성폼으로 이동
			$('#insertQnaCommentForm').submit();
		});
		
		$('#updateBtn').click(function(){
			// 버튼을 클릭하면 답변 수정폼으로 이동
			$('#updateQnaCommentForm').submit();
		});
		
		$('#deleteBtn').click(function(){
			// 버튼을 클릭하면 답변 삭제
			$('#deleteQnaCommentForm').submit();
		});
	</script>
</body>
</html>