<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>

<%
	//상태를 수정할 카테고리의 이름
	if(request.getParameter("categoryName")==null || request.getParameter("categoryState")==null || request.getParameter("categoryName")=="" || request.getParameter("categoryState")==""){
		response.sendRedirect(request.getContextPath()+"/selectCategoryList.jsp");
		return;
	}

	// 카테고리명과 카테고리 상태값을 초기화
	String categoryName = request.getParameter("categoryName");
	String categoryState = request.getParameter("categoryState");
	
	// 상태를 수정
	CategoryDao categoryDao = new CategoryDao();
	categoryDao.updateCategoryState(categoryName, categoryState);
	
	// 작업을 끝낸 후 카테고리 목록 출력 화면으로 이동
	response.sendRedirect(request.getContextPath()+"/admin/selectCategoryList.jsp");
	return;
%>