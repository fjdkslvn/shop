<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <title>전자책 상점</title>
</head>
<body>
	<%	
		// 이미 로그인 되어있으면 메인페이지로 보낸다.
		if(session.getAttribute("loginMember")!=null){
			response.sendRedirect(request.getContextPath()+"/index.jsp");
		}
	%>
	<!-- start : submenu include -->
   <div>
      <jsp:include page="/partial/mainMenu.jsp"></jsp:include>
   </div>
   <!-- end : submenu include -->
   <br>
	<div class="content-center">
	    <form action="<%=request.getContextPath() %>/loginAction.jsp" id="loginForm" class="join-form">
	    
	        <div class="form-group">
	            아이디
	            <input type="text" class="form-control" name="id" id="id">
	        </div>
	        
	        <div class="form-group">
	            비밀번호
	            <input type="password" class="form-control" name="pw" id="pw">
	        </div>
	        <br>
			<div style="float:right">
			<a href="./insertMemberForm.jsp">회원가입</a>
			</div>
	        <div class="btn-center">
	            <button type="button" id="loginBtn" style="width:100%" class="btn btn-primary">로그인</button>
	        </div>
	    </form>
	</div>
	
	<script>
		$('#loginBtn').click(function(){
			// 버튼을 click했을때
			if($('#id').val()==''){ // id가 공백이면
				alert('ID를 입력하세요.');
			} else if($('#pw').val==''){ // pw가 공백이면
				alert('PW를 입력하세요.');
			} else{
				$('#loginForm').submit();	
			}
		});
	</script>
</body>
</html>