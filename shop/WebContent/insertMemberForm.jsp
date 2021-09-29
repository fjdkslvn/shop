<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	<title>Insert title here</title>
</head>
<body>

<%
	//로그인 상태에서는 진입할 수 없음
	if(session.getAttribute("loginMember") != null){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
%>

	<div class="join-form content-center top-margin">
	<%
		// 아이디 중복검사를 위한 코드
		String memberIdCheck="";
		if(request.getParameter("memberIdCheck")!= null){
			memberIdCheck = request.getParameter("memberIdCheck");
		}
	
	%>
		<div><%=request.getParameter("idCheckResult") %></div> <!-- null or 이미사용중인아이디입니다 -->
		
		<!-- 멤버아이디가 사용가능한지 확인 폼 -->
		<form action="<%=request.getContextPath() %>/selectMemberIdCheckAction.jsp" method="post">
			<div class="form-group">
				회원아이디 
				<input type="text" class="form-control" name="memberIdCheck">
				<button type="submit">아이디 중복 검사</button>
			</div>
		</form>
		
		<!-- 회원가입 폼 -->
		<form id="joinForm" action="insertMemberAction.jsp" method="post">
		    <div class="form-group">
		        아이디
		        <input type="text" class="form-control" name="id" id="id" value="<%=memberIdCheck %>" readonly>
		    </div>
		
		    <div class="form-group">
		        비밀번호
		        <input type="password" class="form-control" name="pw" id="pw">
		    </div>
		
		    <div class="form-group">
		        비밀번호 재확인
		        <input type="password" class="form-control" name="pw2" id="pw2">
		    </div>
		
		    <div class="form-group">
		        이름
		        <input type="text" class="form-control" name="name" id="name">
		    </div>
		
		    <div class="form-group">
				나이 :
				<select name="age">
				<%
					for(int i=1;i<=120;i++){
				%>
						<option value="<%=i %>"><%=i %></option>
				<%
					}
				
				%>
				</select>
			</div>
			
			<div class="form-group">
				성별 : 
				<input type="radio" class="memberGender" name="memberGender" value="남">남
				<input type="radio" class="memberGender" name="memberGender" value="여">여
			</div>
		
			<div class="btn-center">
		    <button type="button" id="btn" style="width:100%" class="btn btn-success">가입하기</button>
				</div>
	
		</form>
	</div>
	
	<script>
		$('#btn').click(function(){
			// 버튼을 click했을때
			if($('#id').val()==''){ // id가 공백이면
				alert('ID를 입력하세요.');
			}
			if($('#pw').val()==''){ // id가 공백이면
				alert('PW를 입력하세요.');
			}
			if($('#pw2').val()==''){ // id가 공백이면
				alert('PW2를 입력하세요.');
			}
			if($('#name').val()==''){ // id가 공백이면
				alert('이름을 입력하세요.');
			}
			let memberGedner = $('.memberGender:checked'); // . 클래스속성으로 부르면 리턴값은 배열
	         if(memberGedner.length == 0) {
	            alert('memberGender를 선택하세요');
	            return;
	         }
	         
	         $('#joinForm').submit();
		});
	</script>

</body>
</html>