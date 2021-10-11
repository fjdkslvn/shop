<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>

<%
	request.setCharacterEncoding("utf-8");

	//로그인이 되어있지 않거나 일반 회원이라면 메인화면으로 넘기기
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember==null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	// 현재 로그인된 관리자 번호
	int memberNo = loginMember.getMemberNo();
	
	// 방어코드
	if(request.getParameter("qnaNo")=="" || request.getParameter("qnaNo")==null || request.getParameter("content")=="" || request.getParameter("content")==null){
		response.sendRedirect(request.getContextPath()+"/admin/insertQnaCommentForm.jsp");
	}
	
	// 질문 번호와 답변
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	String content = request.getParameter("content");
	
	// QnaComment vo에 답변 내용 담기
	QnaComment qnaComment = new QnaComment();
	qnaComment.setQnaNo(qnaNo);
	qnaComment.setQnaCommentContent(content);
	qnaComment.setMemberNo(memberNo);
	
	// 답변 추가하기
	QnaCommentDao qnaCommentDao = new QnaCommentDao();
	qnaCommentDao.insertqnaComment(qnaComment);
	
	response.sendRedirect(request.getContextPath()+"/admin/selectQnaOne.jsp?qnaNo="+qnaNo);
	return;
%>