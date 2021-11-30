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
	//로그인 상태에서는 진입할 수 없음
	if(session.getAttribute("loginMember") != null){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
%>
	<!-- start : submenu include -->
   <div>
      <jsp:include page="/partial/mainMenu.jsp"></jsp:include>
   </div>
   <!-- end : submenu include -->
   <br>

	<div class="join-form content-center">
	<%
		// 아이디 중복검사를 위한 코드
		String memberIdCheck="";
		if(request.getParameter("memberIdCheck")!= null){
			memberIdCheck = request.getParameter("memberIdCheck");
		}
	
	%>
		<!-- 멤버아이디가 사용가능한지 확인 폼 -->
		<form action="<%=request.getContextPath() %>/selectMemberIdCheckAction.jsp" method="post">
			<div class="form-group">
				아이디 중복 검사 
				<input type="text" class="form-control" name="memberIdCheck">
				<%
					if(request.getParameter("idCheckResult")==null || request.getParameter("idCheckResult")=="" || request.getParameter("idCheckResult")=="null"){
				%>
						<div style="display:none;"><%=request.getParameter("idCheckResult") %></div>
				<%
					} else{
				%>
						<div><%=request.getParameter("idCheckResult") %></div>
				<%
					}
				%>
				<button type="submit">확인</button>
			</div>
		</form>
		
		<!-- 회원가입 폼 -->
		<form id="joinForm" action="<%=request.getContextPath() %>/insertMemberAction.jsp" method="post">
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
			
			<table style="width: 100%;">
				<tr>
					<td>
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
					</td>
					<td>
						<div class="form-group">
							성별 : 
							<input type="radio" class="memberGender" name="gender" value="남">남
							<input type="radio" class="memberGender" name="gender" value="여">여
						</div>
					</td>
				</tr>
			</table>
			<br><br>
			<div class="btn-center">
		    <button type="button" id="btn" style="width:100%" class="btn btn-primary">가입하기</button>
				</div>
	
		</form>
		<br><br>
	</div>
	
	<!-- footer -->
	<div>
      <jsp:include page="/partial/footer.jsp"></jsp:include>
   </div>
	
	<script>
		$('#btn').click(function(){
			// 버튼을 click했을때
			let memberGedner = $('.memberGender:checked'); // . 클래스속성으로 부르면 리턴값은 배열
			
			if($('#id').val()==''){ // id가 공백이면
				alert('ID를 입력하세요.');
			} else if($('#pw').val()==''){ 
				alert('PW를 입력하세요.');
			} else if($('#pw2').val()==''){ 
				alert('PW2를 입력하세요.');
			} else if($('#name').val()==''){ 
				alert('이름을 입력하세요.');
			} else if(memberGedner.length == 0) {
	            alert('성별을 선택하세요');
			} else {
				$('#joinForm').submit();
			}
		});
	</script>
	
</body>
</html>