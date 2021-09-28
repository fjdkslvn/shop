<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<%
	Member loginMember = (Member)session.getAttribute("loginMember");
	// 로그인이 되어있지 않으면 로그인,회원가입 보여주고 / 로그인 되어있으면 로그아웃 보이기
	if(loginMember==null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
%>
<body>
	<!-- 관리자 메뉴 -->
	<h1>관리자 페이지</h1>
	<!-- start : submenu include -->
   <div>
      <jsp:include page="/partial/adminMenu.jsp"></jsp:include>
   </div>
   <!-- end : submenu include -->
	<a href="<%=request.getContextPath() %>/index.jsp">메인으로 돌아가기</a>
	<a href="<%=request.getContextPath() %>/logout.jsp">로그아웃</a></div>
</body>
</html>