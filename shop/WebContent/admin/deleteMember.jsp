<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>

<%
	// 삭제할 회원 번호
	if(request.getParameter("memberNo")==null){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}

	// 회원 삭제
	MemberDao memberDao = new MemberDao();
	memberDao.deleteMemberByAdmin(Integer.parseInt(request.getParameter("memberNo")));
	
	// 회원 목록 페이지로 이동
	response.sendRedirect(request.getContextPath()+"/admin/selectMemberList.jsp");
	return;
%>