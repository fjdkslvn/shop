<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>

<%
	request.setCharacterEncoding("utf-8");
	
	// 로그인이 되어있지 않거나 일반 회원이라면 메인화면으로 넘기기
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember==null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 방어코드
	if(request.getParameter("qnaNo")=="" || request.getParameter("qnaNo")==null){
		response.sendRedirect(request.getContextPath()+"/admin/selectQnaList.jsp");
		return;
	}
	
	// 답변할 질문 번호
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	
	// 정보 가져오기
	QnaDao qnaDao = new QnaDao();
	Qna qna = qnaDao.selectQnaOne(qnaNo);
	
	// 답변 가져오기
	QnaCommentDao qnaCommentDao = new QnaCommentDao();
	QnaComment qnaComment = qnaCommentDao.selectQnaCommentOne(qnaNo);
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
	<br><br>
	
	<h3>답변</h3>
	<div class="content-center">
	<form action="<%=request.getContextPath() %>/admin/updateQnaCommentAction.jsp" id="updateQnaCommentAction" method="post">
		<div class="form-group">
		  <textarea class="form-control" rows="5" name="content" id="content"><%=qnaComment.getQnaCommentContent() %></textarea>
		 </div>
		 <input type="hidden" name="qnaNo" value="<%=qnaNo %>">
		<br><br>
		<button type="button" class="btn btn-success" id="btn">작성</button>
	</form>
	</div>
	<script>
		// 작성 버튼을 눌렀을 경우
		$('#btn').click(function(){
			if($('#content').val()==''){
				alert('답변을 작성하세요');
			} else{
				// 버튼을 클릭하면 답변 수정
				$('#updateQnaCommentAction').submit();
			}
		});
	</script>	
</body>
</html>