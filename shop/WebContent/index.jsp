<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>

<!DOCTYPE html>
<html>
<head>
	<!-- style.css 불러오기 -->
	<link rel="stylesheet" type="text/css" href="style.css">
	
	<meta charset="UTF-8">
	<title>index.jsp</title>
</head>
<body>
	<div class="right">
		<%
			// 로그인이 되어있지 않으면 로그인,회원가입 보여주고 / 로그인 되어있으면 로그아웃 보이기
			if(session.getAttribute("loginMember")==null){
				%>
					   <a href="<%=request.getContextPath() %>/loginForm.jsp">로그인</a>
					   <a href="<%=request.getContextPath() %>/insertMemberForm.jsp">회원가입</a>
				<%
			} else {
				Member loginMember = (Member)session.getAttribute("loginMember");
				%>
					*<%=loginMember.getMemberLevel() %>레벨* <%=loginMember.getMemberId() %>회원님 반갑습니다.
					<a href="<%=request.getContextPath() %>/logout.jsp">로그아웃</a>
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
	   <h1>메인페이지</h1>
</body>
</html>