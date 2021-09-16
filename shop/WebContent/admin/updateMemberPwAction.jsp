<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
    
    
<%
	Member member = new Member();
	// 수정될 회원 번호
	if(request.getParameter("memberNo")==null){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	member.setMemberNo(Integer.parseInt(request.getParameter("memberNo")));
	System.out.println(member.getMemberNo() + " <--등급 수정될 회원 번호");
	
	// 비밀번호가 입력되지 않았다면 전 화면으로 이동
	if(request.getParameter("pw")==null){
		response.sendRedirect(request.getContextPath()+"/updateMemberPwForm.jsp?memberNo="+member.getMemberNo());
		return;
	}
	
	// 관리자 비번이 틀렸다면 전 화면으로 이동
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(!loginMember.getMemberPw().equals(request.getParameter("pw"))){
		response.sendRedirect(request.getContextPath()+"/updateMemberPwForm.jsp?memberNo="+member.getMemberNo());
		return;
	}
	
	// 레벨이 입력되지 않았다면 전 화면으로 이동
	if(request.getParameter("newPw")==null){
		response.sendRedirect(request.getContextPath()+"/updateMemberPwForm.jsp?memberNo="+member.getMemberNo());
		return;
	}
	member.setMemberPw(request.getParameter("newPw"));
	System.out.println(member.getMemberPw() + " <--수정될 비밀번호");
	
	MemberDao memberDao = new MemberDao();
	memberDao.updateMemberPwByAdmin(member);
	
	// 회원 목록 페이지로 이동
	response.sendRedirect(request.getContextPath()+"/admin/selectMemberList.jsp");
	return;
%>