<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>

<%
	request.setCharacterEncoding("utf-8");

	//로그인이 되어있지 않다면 로그인 화면으로 이동
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember==null){
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}
	// 현재 로그인된 회원 번호
	int memberNo = loginMember.getMemberNo();
	
	// 방어코드
	if(request.getParameter("qnaNo")==null || request.getParameter("qnaNo")=="" || request.getParameter("category")=="" || request.getParameter("category")==null || request.getParameter("title")=="" || request.getParameter("title")==null || request.getParameter("content")=="" || request.getParameter("content")==null){
		response.sendRedirect(request.getContextPath()+"/selectQnaList.jsp");
	}
	
	// 질문 제목, 내용, 카테고리, 비밀글 여부
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	String title = request.getParameter("title");
	String content = request.getParameter("content");
	String category = request.getParameter("category");
	String secret;
	if(request.getParameter("secret")==null || request.getParameter("secret")==""){
		secret = "N";
	} else{
		secret = "Y";
	}
	
	// Qna vo에 질문 관련 내용 담기
	Qna qna = new Qna();
	qna.setQnaNo(qnaNo);
	qna.setMemberNo(memberNo);
	qna.setQnaCategory(category);
	qna.setQnaTitle(title);
	qna.setQnaContent(content);
	qna.setQnaSecret(secret);
	
	
	// 질문 DB에 추가
	QnaDao qnaDao = new QnaDao();
	qnaDao.updateQna(qna);
	
	response.sendRedirect(request.getContextPath()+"/selectQnaList.jsp?qnaNo="+qnaNo);
	return;
%>