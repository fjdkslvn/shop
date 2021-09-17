<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
    
<%
	request.setCharacterEncoding("utf-8");
	
	//로그인이 되어있지 않거나 일반 회원이라면 메인화면으로 넘기기
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember==null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 입력값의 null이나 공백을 거르는 코드
	if(request.getParameter("categoryName")==null || request.getParameter("categoryName")==""){
		response.sendRedirect(request.getContextPath()+"/insertMemberForm.jsp");
		return;
	}
	
	// 카테고리명 받아오기
	String categoryName = request.getParameter("categoryName");
	
	// 카테고리 추가
	CategoryDao categoryDao = new CategoryDao();
	categoryDao.insertCategory(categoryName);
	
	// 카테고리 추가 후 카테고리 목록으로 이동
	response.sendRedirect(request.getContextPath()+"/admin/selectCategoryList.jsp");
	return;
	

%>