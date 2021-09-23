<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
		request.setCharacterEncoding("utf-8");
			
		// 로그인이 되어있지 않거나 일반 회원이라면 메인화면으로 넘기기
		Member loginMember = (Member)session.getAttribute("loginMember");
		if(loginMember==null || loginMember.getMemberLevel() < 1){
			response.sendRedirect(request.getContextPath()+"/index.jsp");
			return;
		}
		
		if(request.getParameter("ebookNo")=="" || request.getParameter("ebookNo")==null){
			response.sendRedirect(request.getContextPath()+"/admin/adminindex.jsp");
		}
		int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
	%>
	<!-- 관리자 메뉴 인클루드 시작-->
	<div>
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
	</div>
	<!-- 관리자 메뉴 인클루드 끝 -->
	<%
		EbookDao ebookDao = new EbookDao();
		Ebook ebook = ebookDao.selectEbookOne(ebookNo);
	%>
	<div>
		<%=ebook.getEbookNo() %>
	</div>
	<div>
		<img src="<%=request.getContextPath() %>/image/<%=ebook.getEbookImg() %>">
	</div>
	<div>
	   <a href="">삭제</a>
	   <a href="">가격수정</a>
	   <a href="<%=request.getContextPath() %>/admin/updateEbookImg.jsp?ebookNo=<%=ebook.getEbookNo() %>">이미지수정</a>
	</div>
	
</body>
</html>