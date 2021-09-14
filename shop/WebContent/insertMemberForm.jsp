<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<!-- style.css 불러오기 -->
	<link rel="stylesheet" type="text/css" href="style.css">
	
	<!-- 부트스트랩 -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	
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
	
	<form action="insertMemberAction.jsp">
	    <div class="form-group">
	        아이디
	        <input type="text" class="form-control" name="id">
	    </div>
	
	    <div class="form-group">
	        비밀번호
	        <input type="password" class="form-control" name="pw">
	    </div>
	
	    <div class="form-group">
	        비밀번호 재확인
	        <input type="password" class="form-control" name="pw2">
	    </div>
	
	    <div class="form-group">
	        이름
	        <input type="text" class="form-control" name="name">
	    </div>
	
	    <div class="form-group">
			나이 :
			<select name="age">
			<%
				for(int i=1;i<120;i++){
			%>
					<option value="<%=i %>"><%=i %></option>
			<%
				}
			
			%>
			</select>
		</div>
		
		<div class="form-group">
			성별 : 
			<input type="radio" name="gender" value="남"> 남성
			<input type="radio" name="gender" value="여"> 여성
		</div>
	
		<div class="btn-center">
	    <button type="submit" style="width:100%" class="btn btn-success">가입하기</button>
			</div>

	</form>
</div>

</body>
</html>