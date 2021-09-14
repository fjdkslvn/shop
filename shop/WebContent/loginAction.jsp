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
	
	// 로그인 값이 비어있다면 로그인 화면으로 돌려보내자
	if(request.getParameter("id")== null || request.getParameter("pw")==null){
		response.sendRedirect(request.getContextPath()+"/login.jsp");
		return;
	}
	if(request.getParameter("id")== "" || request.getParameter("pw")==""){
		response.sendRedirect(request.getContextPath()+"/login.jsp");
		return;
	}
	
	// join.jsp에서 받아온 값을 멤버객체에 담기
	Member member = new Member();
	member.setMemberId(request.getParameter("id"));
	member.setMemberPw(request.getParameter("pw"));
	
	MemberDao mdao = new MemberDao();
	Member returnMember = mdao.login(member);
	
	// 로그인 실패시 다시 로그인화면으로 이동
	if(returnMember == null){
		System.out.println("로그인 실패");
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	} else { // 로그인 성공시 메인화면으로 이동
		System.out.println("로그인 성공");
		// session에 로그인한 유저 정보 담기
		session.setAttribute("loginMember", returnMember);
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
%>