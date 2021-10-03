<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>

<%
	request.setCharacterEncoding("utf-8");

	//사용하고자 하는 아이디 값 가져오기
	String memberIdCheck ="";

	if(request.getParameter("memberIdCheck")=="" || request.getParameter("memberIdCheck")==null){
		response.sendRedirect(request.getContextPath()+"/insertMemberForm.jsp");
		return;
	}
	memberIdCheck = request.getParameter("memberIdCheck");
	System.out.println("memberIdCheck 중복검사로 넘겨짐:"+memberIdCheck);
	
	// MemberDao.selectMemberId()메서드 호출 / 아이디 중복 검사
	MemberDao memberDao = new MemberDao();
	String result = memberDao.selectMemberId(memberIdCheck);
	
	// 사용할 수 있으면 값을 넘겨주고 사용할 수 없으면 공백을 넘긴다
	if(result == null){
		response.sendRedirect(request.getContextPath()+"/insertMemberForm.jsp?memberIdCheck="+memberIdCheck);
		System.out.println(memberIdCheck+"는 사용가능한 아이디 입니다.");
	} else{
		response.sendRedirect(request.getContextPath()+"/insertMemberForm.jsp?idCheckResult=This ID is already taken");
		return;
	}
%>