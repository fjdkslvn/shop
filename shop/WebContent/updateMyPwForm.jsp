<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	request.setCharacterEncoding("utf-8");
	
	// 로그인되지 않았다면 메인으로 보내기
	if(session.getAttribute("loginMember") == null){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 입력값의 null이나 공백을 거르는 코드
	if(request.getParameter("memberNo")==null || request.getParameter("memberNo")==""){
		response.sendRedirect(request.getContextPath()+"/selectMyImfo.jsp");
		return;
	}
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
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
	<title>비밀번호 수정</title>
</head>
<body>
	<div class="content-center top-margin">
	    <form action="<%=request.getContextPath() %>/updateMyPwAction.jsp" id="updateMyPw" method="post">
	        <div class="form-group">
	            비밀번호
	            <input type="password" class="form-control" name="pw" id="pw">
	        </div>
	        
	        <div class="form-group">
	            비밀번호 확인
	            <input type="password" class="form-control" name="pw2" id="pw2">
	        </div>
	        <br>
	        <div class="btn-center">
	            <button type="button" id="btn" class="btn btn-success">비밀번호 변경</button>
	        </div>
	        <input type="hidden" name="memberNo" value="<%=memberNo %>">
	    </form>
	</div>
	
	<script>
		$('#btn').click(function(){
			// 버튼을 click했을때
			if($('#pw').val()==''){ // pw가 공백이면
				alert('비밀번호를 입력하세요.');
			} else if($('#pw2').val==''){
				alert('비밀번호 확인을 입력하세요.');
			} else if($('#pw').val()!=$('#pw2').val()){// 비밀번호가 다르다면
				alert('비밀번호와 비밀번호 확인이 다릅니다.');
			} else{
				$('#updateMyPw').submit();
			}
		});
	</script>
</body>
</html>