<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>

<%
	request.setCharacterEncoding("utf-8");
	
	// 삭제할 답변의 질문 번호
	if(request.getParameter("qnaNo")==null){
		response.sendRedirect(request.getContextPath()+"/admin/selectQnaList.jsp");
		return;
	}
	
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));

	// 질문 삭제
	QnaCommentDao qnaCommentDao = new QnaCommentDao();
	qnaCommentDao.deleteQnaComment(qnaNo);
	
	// 질문 삭제 후 질문목록으로 이동
	response.sendRedirect(request.getContextPath()+"/admin/selectQnaOne.jsp?qnaNo="+qnaNo);
	return;
%>