<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
	<title>login</title>
</head>
<body>
	<div class="content-center top-margin">
	    <form action="loginAction.jsp" id="loginForm" class="join-form">
	    
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
	            <button type="button" id="loginBtn" style="width:100%" class="btn btn-success">로그인</button>
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