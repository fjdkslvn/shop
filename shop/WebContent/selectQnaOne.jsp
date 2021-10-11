<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>

<%
	request.setCharacterEncoding("utf-8");
	
	// 방어코드
	if(request.getParameter("qnaNo")=="" || request.getParameter("qnaNo")==null){
		response.sendRedirect(request.getContextPath()+"/selectQnaList.jsp");
		return;
	}
	
	// 상세보기할 공지 번호
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	
	// 정보 가져오기
	QnaDao qnaDao = new QnaDao();
	Qna qna = qnaDao.selectQnaOne(qnaNo);
	
	Member loginMember = (Member)session.getAttribute("loginMember");
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
		<a href="<%=request.getContextPath() %>/index.jsp"><img src="<%=request.getContextPath() %>/image/banner.PNG" width="550" height="130"></a>
	</div>
   <div class="right">
      <%
      	 request.setCharacterEncoding("utf-8");
      
         // 로그인이 되어있지 않으면 로그인,회원가입 보여주고 / 로그인 되어있으면 로그아웃 보이기
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
   <h2>질문</h2>
	<table class="table" border="1">
		<tr>
			<td>카테고리</td>
			<td><%=qna.getQnaCategory() %></td>
		</tr>
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
		if(loginMember!=null && loginMember.getMemberId().equals(qna.getMemberId())){
		%>
			<table>
				<tr>
					<td>
						<!-- 질문 수정 버튼 -->
						<form action="<%=request.getContextPath() %>/updateQnaForm.jsp" id="updateQnaForm" method="post">
							<input type="hidden" value="<%=qnaNo %>" name="qnaNo">
							<button class="btn btn-secondary" type="button" id="updateBtn">질문수정</button>
						</form>
					</td>
					<td>
						<!-- 질문 삭제 버튼 -->
						<form action="<%=request.getContextPath() %>/deleteQna.jsp" id="deleteQnaForm" method="post">
							<input type="hidden" value="<%=qnaNo %>" name="qnaNo">
							<button class="btn btn-secondary" type="button" id="deleteBtn">질문삭제</button>
						</form>
					</td>
				</tr>
			</table>
		<%
		}
	%>
	
	<br><br>
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
		<%
			}
		%>
	
	<script>
		// 수정 버튼 클릭 시
		$('#updateBtn').click(function(){
			// 버튼을 클릭하면 질문 수정폼으로 이동
			$('#updateQnaForm').submit();
		});
		
		/// 삭제 버튼 클릭 시
		$('#deleteBtn').click(function(){
			// 버튼을 클릭하면 질문 삭제
			$('#deleteQnaForm').submit();
		});
	</script>
</body>
</html>