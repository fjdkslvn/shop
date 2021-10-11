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
   <!-- style.css 불러오기 -->
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/style.css">
	
	<!-- 부트스트랩 -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	
	<!-- 자바스크립트 -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
   
   <meta charset="UTF-8">
   <title>전자책 상점</title>
</head>
<body>
	<div class="text-center">
		<a href="<%=request.getContextPath() %>/index.jsp"><img src="<%=request.getContextPath() %>/image/banner.PNG" width="550" height="130"></a>
	</div>
   <div class="right">
      <%
      	 request.setCharacterEncoding("utf-8");
      
         // 로그인이 되어있지 않으면 로그인,회원가입 보여주고 / 로그인 되어있으면 로그아웃 보이기
         if(session.getAttribute("loginMember")==null){
            %>
                  <a href="<%=request.getContextPath() %>/loginForm.jsp">로그인</a>
                  <a href="<%=request.getContextPath() %>/insertMemberForm.jsp">회원가입</a>
            <%
         } else {
            loginMember = (Member)session.getAttribute("loginMember");
            %>
               *<%=loginMember.getMemberLevel() %>레벨* <%=loginMember.getMemberId() %>회원님 반갑습니다.
               <a href="<%=request.getContextPath() %>/logout.jsp">로그아웃</a>
               <a href="<%=request.getContextPath() %>/selectMyImfo.jsp">내정보</a>
               <a href="<%=request.getContextPath() %>/selectOrderListByMember.jsp">나의주문</a>
            <%
            if(loginMember.getMemberLevel()>0){
               %>
                  <a href="<%=request.getContextPath() %>/admin/adminindex.jsp">관리자 페이지</a>
               <%
            }
         }
      %>
   </div>
   <br>
   <!-- start : submenu include -->
   <div>
      <jsp:include page="/partial/mainMenu.jsp"></jsp:include>
   </div>
   <!-- end : submenu include -->
   <br>
	<div class="content-center">
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
	</div>
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