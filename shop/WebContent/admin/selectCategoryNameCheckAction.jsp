<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>

<%
	request.setCharacterEncoding("utf-8");

	//사용하고자 하는 카테고리 값 가져오기
	String categoryNameCheck ="";

	if(request.getParameter("categoryNameCheck")=="" || request.getParameter("categoryNameCheck")==null){
		response.sendRedirect(request.getContextPath()+"/admin/insertCategoryForm.jsp");
		return;
	}
	categoryNameCheck = request.getParameter("categoryNameCheck");
	System.out.println("categoryNameCheck 중복검사로 넘겨짐:"+categoryNameCheck);
	
	// CategoryDao.selectCategoryName()메서드 호출 / 카테고리 중복 검사
	CategoryDao categoryDao = new CategoryDao();
	String result = categoryDao.selectCategoryName(categoryNameCheck);
	
	// 사용할 수 있으면 값을 넘겨주고 사용할 수 없으면 공백을 넘긴다
	// 중복검사를 통과했는지에 대한 여부를 Boolean으로 보낸다
	if(result == null){
		response.sendRedirect(request.getContextPath()+"/admin/insertCategoryForm.jsp?categoryNameCheck="+categoryNameCheck+"&categoryNameCheckResult="+true);
		System.out.println(categoryNameCheck+"는 사용가능한 카테고리 입니다:");
	} else{
		response.sendRedirect(request.getContextPath()+"/admin/insertCategoryForm.jsp?categoryNameCheckResult="+false);
		return;
	}
%>