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
		response.sendRedirect(request.getContextPath()+"/updateMemberLevelForm.jsp?memberNo="+member.getMemberNo());
		return;
	}
	
	// 관리자 비번이 틀렸다면 전 화면으로 이동
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(!loginMember.getMemberPw().equals(request.getParameter("pw"))){
		response.sendRedirect(request.getContextPath()+"/updateMemberLevelForm.jsp?memberNo="+member.getMemberNo());
		return;
	}
	
	// 레벨이 입력되지 않았다면 전 화면으로 이동
	if(request.getParameter("level")==null){
		response.sendRedirect(request.getContextPath()+"/updateMemberLevelForm.jsp?memberNo="+member.getMemberNo());
		return;
	}
	member.setMemberLevel(Integer.parseInt(request.getParameter("level")));
	System.out.println(member.getMemberLevel() + " <--수정될 등급 번호");
	
	MemberDao memberDao = new MemberDao();
	memberDao.updateMemberLevelByAdmin(member);
	
	// 회원 목록 페이지로 이동
	response.sendRedirect(request.getContextPath()+"/admin/selectMemberList.jsp");
	return;
%>