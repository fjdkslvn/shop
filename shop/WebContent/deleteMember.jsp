<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>

<%
	request.setCharacterEncoding("utf-8");
	
	// 삭제할 회원 번호
	if(request.getParameter("memberNo")==null){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}

	// 회원 탈퇴
	MemberDao memberDao = new MemberDao();
	memberDao.deleteMemberByAdmin(Integer.parseInt(request.getParameter("memberNo")));
	
	// 메인화면으로 이동
	session.invalidate(); // 로그아웃
	response.sendRedirect(request.getContextPath()+"/index.jsp");
	return;
%>