<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<!-- style.css 불러오기 -->
	<link rel="stylesheet" type="text/css" href="style.css">
	
	<!-- 부트스트랩 -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	<meta charset="UTF-8">
	<title>login</title>
</head>
<body>
	<div class="content-center top-margin">
	    <form action="loginAction.jsp" class="join-form">
	    
	        <div class="form-group">
	            아이디
	            <input type="text" class="form-control" name="id">
	        </div>
	        
	        <div class="form-group">
	            비밀번호
	            <input type="password" class="form-control" name="pw">
	        </div>
	        <br>
			<div style="float:right">
			<a href="./insertMemberForm.jsp">회원가입</a>
			</div>
	        <div class="btn-center">
	            <button type="submit" style="width:100%" class="btn btn-success">로그인</button>
	        </div>
	    </form>
	
	
	</div>
</body>
</html>