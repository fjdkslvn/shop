<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
    
<%
	request.setCharacterEncoding("utf-8");
	
	// 로그인 상태에서는 진입할 수 없음
	if(session.getAttribute("loginMember") != null){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 입력값의 null이나 공백을 거르는 코드
	if(request.getParameter("id")==null || request.getParameter("pw")==null || request.getParameter("pw2")==null || request.getParameter("name")==null || request.getParameter("age")==null || request.getParameter("gender")==null){
		response.sendRedirect(request.getContextPath()+"/insertMemberForm.jsp");
		return;
	}
	
	if(request.getParameter("id")=="" || request.getParameter("pw")=="" || request.getParameter("pw2")=="" || request.getParameter("name")=="" || request.getParameter("age")=="" || request.getParameter("gender")==""){
		response.sendRedirect(request.getContextPath()+"/insertMemberForm.jsp");
		return;
	}
	
	// 비밀번호 검사
	if(!request.getParameter("pw").equals(request.getParameter("pw2"))){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 받아온 값을 멤버객체에 담기
	Member member = new Member();
	member.setMemberId(request.getParameter("id"));
	member.setMemberPw(request.getParameter("pw"));
	member.setMemberName(request.getParameter("name"));
	member.setMemberAge(Integer.parseInt(request.getParameter("age")));
	member.setMemberGender(request.getParameter("gender"));
	
	MemberDao mdao = new MemberDao();
	mdao.insertMember(member);
	
	// 회원가입 후 로그인화면으로 이동
	response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
	return;
	

%>