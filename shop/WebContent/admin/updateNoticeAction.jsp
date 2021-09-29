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
	if(request.getParameter("noticeNo")=="" || request.getParameter("noticeNo")==null || request.getParameter("title")=="" || request.getParameter("title")==null || request.getParameter("content")=="" || request.getParameter("content")==null){
		response.sendRedirect(request.getContextPath()+"/admin/selectNoticeList.jsp");
	}
	
	// 공지 제목과 내용
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String title = request.getParameter("title");
	String content = request.getParameter("content");
	
	// Notice vo에 공지 관련 내용 담기
	Notice notice = new Notice();
	notice.setNotice_title(title);
	notice.setNotice_content(content);
	notice.setMember_no(memberNo);
	notice.setNotice_no(noticeNo);
	
	// 공지 DB에 저장
	NoticeDao noticeDao = new NoticeDao();
	noticeDao.updateNotice(notice);
	
	// 수정 후 상세보기로 이동
	response.sendRedirect(request.getContextPath()+"/admin/selectNoticeOne.jsp?noticeNo="+noticeNo);
	return;
%>