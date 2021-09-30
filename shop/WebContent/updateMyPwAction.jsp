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
	if(request.getParameter("pw")==null || request.getParameter("pw")=="" || request.getParameter("memberNo")==null || request.getParameter("memberNo")==""){
		response.sendRedirect(request.getContextPath()+"/selectMyImfo.jsp");
		return;
	}
	
	// 받아온 값을 멤버객체에 담기
	Member member = new Member();
	member.setMemberNo(Integer.parseInt(request.getParameter("memberNo")));
	member.setMemberPw(request.getParameter("pw"));
	
	// 비밀번호 수정
	MemberDao mdao = new MemberDao();
	mdao.updateMemberPwByAdmin(member);
	
	// 자동 로그아웃 후, 비밀번호 수정 후 로그인 화면으로 이동
	session.invalidate();
	response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
	return;
	

%>