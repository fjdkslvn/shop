<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>

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
	
	// 이미지 번호가 없다면 강제이동
	if(request.getParameter("ebookNo")=="" || request.getParameter("ebookNo")==null){
		response.sendRedirect(request.getContextPath()+"/admin/adminindex.jsp");
	}
	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
%>
	<!-- 관리자 메뉴 -->
	<div>
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
	</div>
	<form action="<%=request.getContextPath()%>/admin/updateEbookImgAction.jsp" method="post"
        enctype="multipart/form-data"> 
        <!-- multipart/form-data : 액션으로 기계어코드를 넘길때 사용 -->
        <!-- application/x-www-form-urlencoded : 액션으로 문자열 넘길때 사용 -->
      <input type="text" name="ebookNo" value="<%=ebookNo%>" readonly="readonly"> <!-- type="hidden" -->
      <input type="file" name="ebookImg">
      <button type="submit">이미지파일 수정</button>
   </form>

</body>
</html>