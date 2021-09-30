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
	if(request.getParameter("orderNo")==null || request.getParameter("orderNo")==""){
		response.sendRedirect(request.getContextPath()+"/selectOrderListByMember.jsp");
		return;
	}
	
	// 후기를 수정할 주문 번호
	int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	
	// 기존에 작성한 후기값 받아오기
	OrderCommentDao orderCommentDao = new OrderCommentDao();
	OrderComment orderComment = orderCommentDao.selectOrderCommentOne(orderNo);
	
	
%>
<!DOCTYPE html>
<html>
<head>
	<!-- 부트스트랩 -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	
	<!-- style.css 불러오기 -->
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/style.css">
	
	<!-- 자바스크립트 -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	
	<meta charset="UTF-8">
	<title>후기 수정하기</title>
</head>
<body class="content-center">
	<form id="updateForm" action="<%=request.getContextPath() %>/updateOrderCommentAction.jsp" method="post">
		<div class="form-group">
		  <label for="comment">후기:</label>
		  <textarea id="content" class="form-control" rows="5" name="comment"><%=orderComment.getOrderCommentContent() %></textarea>
		</div>
		별점 : 
		<select name="starNum">
		<%
			for(int i=1;i<=10;i++){
				if(i==orderComment.getOrderScore()){
		%>
					<option value="<%=i %>" selected><%=i %></option>
		<%
				} else{
		%>
					<option value="<%=i %>"><%=i %></option>
		<%
				}
			}
		%>
		</select>
		<input type="hidden" name="orderNo" value="<%=orderNo %>">
		<br><br>
		<button type="button" id="updateBtn" class="btn btn-success">작성</button>
	</form>
	<script>
		$('#updateBtn').click(function(){
			// 버튼을 click했을때
			if($('#content').val()==''){ // 후기 내용이 공백이면
				alert('후기를 입력하세요.');
			} else{
				$('#updateForm').submit();	
			}
		});
	</script>
</body>
</html>