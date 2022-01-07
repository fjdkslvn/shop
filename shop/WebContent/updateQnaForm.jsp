<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>

<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <title>전자책 상점</title>
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");
	
	// 로그인이 되어있지 않으면 로그인 화면으로 보내기
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember==null){
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}
	
	// 방어코드
	if(request.getParameter("qnaNo")==null || request.getParameter("qnaNo")==""){
		response.sendRedirect(request.getContextPath()+"/selectQnaList.jsp");
		return;
	}
	
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	
	QnaDao qnaDao = new QnaDao();
	Qna qna = qnaDao.selectQnaOne(qnaNo);
%>
   <!-- start : submenu include -->
   <div>
      <jsp:include page="/partial/mainMenu.jsp"></jsp:include>
   </div>
   <!-- end : submenu include -->
   <br>
   
   <div class="page-center">
   		<!-- breadcrumb -->
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb" style="background: white;">
				<li class="breadcrumb-item"><a href="<%=request.getContextPath() %>/index.jsp">홈</a></li>
				<li class="breadcrumb-item"><a href="<%=request.getContextPath() %>/selectQnaList.jsp">QnA</a></li>
				<li class="breadcrumb-item active" aria-current="page">내 질문 수정</li>
			</ol>
		</nav>
   </div>
   
	<div class="content-center">
		<form action="<%=request.getContextPath() %>/updateQnaAction.jsp" id="updateQnaAction" method="post">
			<div class="form-group">
	        	카테고리 : 
	        	<select name="category">
	       		<%
	       			String[] category = {"전자책관련","개인정보관련","기타"};
	       			for(String c:category){
	       				if(c.equals(qna.getQnaCategory())){
       					%>
       						<option value="<%=c %>" selected><%=c %></option>
       					<%
	       				} else{
	       				%>
							<option value="<%=c %>"><%=c %></option>
						<%
	       				}
	       			}
	       		%>
	        	</select>
	        </div>
			<div class="form-group">
	            질문 제목
	            <input type="text" class="form-control" name="title" id="title" value="<%=qna.getQnaTitle() %>">
	        </div>
			<div class="form-group">
			  <label for="content">질문 내용</label>
			  <textarea class="form-control" rows="5" name="content" id="content"><%=qna.getQnaContent().replace("<br>","\r\n") %></textarea>
			</div>
			<div class="form-group">
				<%
					if(qna.getQnaSecret().equals("Y")){
					%>
						<input type="checkbox" name="secret" value="Y" checked> 비밀글
					<%	
					} else{
					%>
						<input type="checkbox" name="secret" value="Y"> 비밀글
					<%	
					}
				%>
			</div>
			<input type="hidden" name="qnaNo" value="<%=qnaNo %>">
			<br><br>
			<button type="button" style="width:100%" class="btn btn-primary" id="btn">수정</button>
		</form>
	</div>
	
	<!-- footer -->
	<div>
      <jsp:include page="/partial/footer.jsp"></jsp:include>
   </div>

	<script>
		// 작성 버튼을 눌렀을 경우
		$('#btn').click(function(){
			if($('#title').val()==''){
				alert('질문 제목을 작성하세요');
			} else if($('#content').val()==''){
				alert('질문 내용을 작성하세요');
			} else{
				// 버튼을 클릭하면 질문 생성
				$('#updateQnaAction').submit();
			}
		});
	</script>	
</body>
</html>