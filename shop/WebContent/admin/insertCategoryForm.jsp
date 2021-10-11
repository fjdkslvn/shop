<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

<%
	request.setCharacterEncoding("utf-8");

	//로그인이 되어있지 않거나 일반 회원이라면 메인화면으로 넘기기
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember==null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
%>

<div class="join-form content-center top-margin">
<%
	// 카테고리 중복검사를 위한 코드
	String categoryNameCheck="";
	if(request.getParameter("categoryNameCheck")!= null){
		categoryNameCheck = request.getParameter("categoryNameCheck");
	}
	
	// 중복 여부에 따라 안내 표시를 할지 말지 정함
	// 카테고리명에 대한 안내 변수
	String categoryNamenews="";
	// 카테고리명이 중복검사를 통과했는지에 대한 여부
	Boolean categoryNameCheckResult=null; // 중복검사 미실시
	
	// 카테고리명 중복검사를 실행한 경우
	if(request.getParameter("categoryNameCheckResult")!=null){
		// 검사 결과를 넣어줌
		categoryNameCheckResult = Boolean.valueOf(request.getParameter("categoryNameCheckResult"));
		
		//
		if(categoryNameCheckResult==true){
			categoryNamenews = "Good CategoryName";
		} else if(categoryNameCheckResult==false){
			categoryNamenews = "This ID is already taken";
		}
	}
	
	

%>
	<!-- 카테고리명이 사용가능한지 확인 폼 -->
	<form action="<%=request.getContextPath() %>/admin/selectCategoryNameCheckAction.jsp" method="post">
		<div class="form-group">
			카테고리명을 입력하세요
		  <div class="input-group mb-3">
		      <input type="text" class="form-control" name="categoryNameCheck" value="<%=categoryNameCheck %>">
			  <div class="input-group-append">
			      <button class="btn btn-info" type="submit">중복검사</button>
			  </div>
		  </div>
		  <!-- 화면 시작때는 비어있고, 중복검사를 하면 그에 따른 여부를 알려줌 -->
		  <div><%=categoryNamenews %></div>
	</form>
	
	<%
		// 카테고리명이 중복검사를 통과한 경우에만 작동되는 버튼을 생성
		if(categoryNameCheckResult==null || categoryNameCheckResult==false){
	%>
			<button class="btn btn-success">추가하기</button>
	<%
		} else if(categoryNameCheckResult==true){
	%>
			<form action="<%=request.getContextPath() %>/admin/insertCategoryAction.jsp" method="post">
				<input type="hidden" class="form-control" name="categoryName" value="<%=categoryNameCheck %>" >
				<button class="btn btn-success" type="submit">추가하기</button>
			</form>
	<%
		}
	%>
	
</div>

</body>
</html>