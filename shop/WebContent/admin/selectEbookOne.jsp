<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>

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
	<title>상품상세보기</title>
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
	<h1>상품상세보기</h1>
	<div>
		<!-- 상품상세출력 -->
		<%
			// 상품 정보 받아오기
			EbookDao ebookDao = new EbookDao();
			Ebook ebook = ebookDao.selectEbookOne(ebookNo);
		%>
		<img src="<%=request.getContextPath() %>/image/<%=ebook.getEbookImg() %>" width="200" height="200">
		<br><br>
		<table class="table">
			<tr>
				<td>제목</td>
				<td><%=ebook.getEbookTitle() %></td>
			</tr>
			<tr>
				<td>저자</td>
				<td><%=ebook.getEbookAuthor() %></td>
			</tr>
			<tr>
				<td>가격</td>
				<td><%=ebook.getEbookPrice() %></td>
			</tr>
			<tr>
				<td>분량</td>
				<td><%=ebook.getEbookPageCount() %>p</td>
			</tr>
			<tr>
				<td>소개</td>
				<td><%=ebook.getEbookSummary() %></td>
			</tr>
			<tr>
				<td>상태</td>
				<td><%=ebook.getEbookState() %></td>
			</tr>
			<tr>
				<td>등록일</td>
				<td><%=ebook.getCreateDate() %></td>
			</tr>
			<tr>
				<td>최근 변경일</td>
				<td><%=ebook.getUpdateDate() %></td>
			</tr>
		</table>
	</div>
	
	<form action="<%=request.getContextPath() %>/admin/updateEbookForm.jsp?ebookNo=<%=ebook.getEbookNo() %>" id="updateEbook" method="post">
		<button class="btn btn-secondary" type="button" id="btn">수정</button>
	</form>
	
	<script>
		$('#btn').click(function(){
			// 버튼을 클릭하면 전자책 수정폼으로 이동
			$('#updateEbook').submit();
		});
	</script>
	
</body>
</html>