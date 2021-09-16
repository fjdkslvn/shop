<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 부트스트랩 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	
<div>
	<nav class="navbar navbar-expand-sm bg-light">
		<ul class="navbar-nav">
			<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/admin/selectMemberList.jsp">[회원 관리]</a></li>
			<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/admin/">[전자책 카테고리 관리]</a></li>
			<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/admin/">[전자책 관리]</a></li>
			<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/admin/">[주문 관리]</a></li>
			<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/admin/">[상품평 관리]</a></li>
			<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/admin/">[공지게시판 관리]</a></li>
			<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/admin/">[QnA게시판 관리]</a></li>
		</ul>
	</nav>
</div>