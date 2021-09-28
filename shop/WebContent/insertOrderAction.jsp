<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>

<%
   // 주문 관련 정보 받아오기
   int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
   int memberNo = Integer.parseInt(request.getParameter("memberNo"));
   int orderPrice = Integer.parseInt(request.getParameter("orderPrice"));
   System.out.println("ebookNo : "+ ebookNo);
   System.out.println("memberNo : "+ memberNo);
   System.out.println("orderPrice : "+ orderPrice);
   
   Order order = new Order();
   order.setEbookNo(ebookNo);
   order.setMemberNo(memberNo);
   order.setOrderPrice(orderPrice);
   
   // 주문 DB에 저장하기
   OrderDao orderDao = new OrderDao();
   orderDao.insertOrder(order);
   
   // 나의 주문 화면으로 이동
   response.sendRedirect(request.getContextPath()+"/selectOrderListByMember.jsp");
   return;
   
%>