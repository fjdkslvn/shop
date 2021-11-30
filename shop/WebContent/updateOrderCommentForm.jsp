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
   <!-- start : submenu include -->
   <div>
      <jsp:include page="/partial/mainMenu.jsp"></jsp:include>
   </div>
   <!-- end : submenu include -->
   <br>
	<div class="content-center">
		<form id="updateForm" action="<%=request.getContextPath() %>/updateOrderCommentAction.jsp" method="post">
			<div class="form-group">
			  <label for="comment">후기 작성</label>
			  <textarea id="content" class="form-control" rows="5" name="comment"><%=orderComment.getOrderCommentContent().replace("<br>","\r\n") %></textarea>
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
			
			<table style="width:100%">
				<tr>
					<td style="width:60%">
							<button type="button" id="updateBtn" style="width:100%;" class="btn btn-primary">작성</button>
						</form>
					</td>
					<td style="width:20%"></td>
					<td style="width:20%">
						<form id="deleteForm" action="<%=request.getContextPath() %>/deleteOrderComment.jsp" method="post">
							<input type="hidden" name="orderNo" value="<%=orderNo %>">
							<button type="button" id="deleteBtn" style="width:100%;" class="btn btn-danger">삭제</button>
						</form>
					</td>
				</tr>
			</table>
	</div>
	
	<!-- footer -->
	<div>
      <jsp:include page="/partial/footer.jsp"></jsp:include>
   </div>
   
	<script>
		// 수정 버튼 클릭 시
		$('#updateBtn').click(function(){
			// 버튼을 click했을때
			if($('#content').val()==''){ // 후기 내용이 공백이면
				alert('후기를 입력하세요.');
			} else{
				$('#updateForm').submit();	
			}
		});
		
		// 삭제 버튼 클릭 시
		$('#deleteBtn').click(function(){
			// 버튼을 click했을때
			$('#deleteForm').submit();
		});
	</script>
</body>
</html>