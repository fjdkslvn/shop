<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>

<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <title>전자책 상점</title>
</head>
<body>
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
	
	// 후기를 작성할 주문 번호와 책 번호를 받아옴
	int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
%>
   <!-- start : submenu include -->
   <div>
      <jsp:include page="/partial/mainMenu.jsp"></jsp:include>
   </div>
   <!-- end : submenu include -->
   <br>
   
	<div class="content-center">
		<form action="<%=request.getContextPath() %>/insertOrderCommentAction.jsp" method="post">
			<div class="form-group">
			  <label for="comment">후기 작성</label>
			  <textarea class="form-control" rows="5" name="comment"></textarea>
			</div>
			별점 : 
			<select name="starNum">
			<%
				for(int i=1;i<=10;i++){
			%>
					<option value="<%=i %>"><%=i %></option>
			<%
				}
			%>
			</select>
			<input type="hidden" name="orderNo" value="<%=orderNo %>">
			<input type="hidden" name="ebookNo" value="<%=ebookNo %>">
			<br><br><br>
			<button type="submit" style="width:100%" class="btn btn-primary">작성</button>
		</form>
	</div>
</body>
</html>