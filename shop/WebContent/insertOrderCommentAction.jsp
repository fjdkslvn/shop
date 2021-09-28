<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>

<%
	request.setCharacterEncoding("utf-8");
	
	//로그인이 되어있지 않았다면 메인화면으로 보내기
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember==null){
	   response.sendRedirect(request.getContextPath()+"/index.jsp");
	   return;
	}
	
	// 주문번호와 책번호가 받아지지 않는다면 나의 주문 화면으로 보내기
	if(request.getParameter("orderNo")==null || request.getParameter("orderNo")=="" || request.getParameter("ebookNo")==null || request.getParameter("ebookNo")==""){
	   response.sendRedirect(request.getContextPath()+"/selectOrderListByMember.jsp");
	   return;
	}
	
	// 후기 내용이 비어있다면 나의 주문 화면으로 보내기
	if(request.getParameter("comment")==null || request.getParameter("comment")=="" || request.getParameter("starNum")==null || request.getParameter("starNum")==""){
	   response.sendRedirect(request.getContextPath()+"/selectOrderListByMember.jsp");
	   return;
	}
	
	// 후기를 작성할 주문 번호와 책 번호를 받아옴
	int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
	String comment = request.getParameter("comment");
	int starNum = Integer.parseInt(request.getParameter("starNum"));
	
	// OrderComment 객체에 담기
	OrderComment orderComment = new OrderComment();
	orderComment.setOrderNo(orderNo);
	orderComment.setEbookNo(ebookNo);
	orderComment.setOrderCommentContent(comment);
	orderComment.setOrderScore(starNum);
	
	// 후기 DB에 저장하기
	OrderCommentDao orderCommentDao = new OrderCommentDao();
	orderCommentDao.insertOrderComment(orderComment);
	
	response.sendRedirect(request.getContextPath()+"/selectOrderListByMember.jsp");
	return;

%>