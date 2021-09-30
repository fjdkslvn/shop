<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
    
<%
	request.setCharacterEncoding("utf-8");
	
	// 로그인되지 않았다면 메인으로 보내기
	if(session.getAttribute("loginMember") == null){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 입력값의 null이나 공백을 거르는 코드
	if(request.getParameter("memberNo")==null || request.getParameter("id")==null || request.getParameter("name")==null || request.getParameter("age")==null || request.getParameter("gender")==null){
		response.sendRedirect(request.getContextPath()+"/selectMyImfo.jsp");
		return;
	}
	
	if(request.getParameter("memberNo")=="" || request.getParameter("id")=="" || request.getParameter("name")=="" || request.getParameter("age")=="" || request.getParameter("gender")==""){
		response.sendRedirect(request.getContextPath()+"/selectMyImfo.jsp");
		return;
	}
	
	// 받아온 값을 멤버객체에 담기
	Member member = new Member();
	member.setMemberNo(Integer.parseInt(request.getParameter("memberNo")));
	member.setMemberId(request.getParameter("id"));
	member.setMemberName(request.getParameter("name"));
	member.setMemberAge(Integer.parseInt(request.getParameter("age")));
	member.setMemberGender(request.getParameter("gender"));
	
	MemberDao mdao = new MemberDao();
	mdao.updateMyImfo(member);
	
	// 정보 수정 후 내정보 확인으로 이동
	response.sendRedirect(request.getContextPath()+"/selectMyImfo.jsp");
	return;
	

%>