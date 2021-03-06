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
		//로그인이 되어있지 않으면 메인화면으로 넘기기
		Member loginMember = (Member)session.getAttribute("loginMember");
		if(loginMember==null){
			response.sendRedirect(request.getContextPath()+"/index.jsp");
			return;
		}
		
		// 수정될 회원 번호
		int memberNo;
		if(request.getParameter("memberNo")==null || request.getParameter("memberNo")==""){
			response.sendRedirect(request.getContextPath()+"/index.jsp");
			return;
		}
		memberNo = Integer.parseInt(request.getParameter("memberNo"));
		
		MemberDao memberDao = new MemberDao();
		Member member = memberDao.selectMemberOne(memberNo);
	%>
   <!-- start : submenu include -->
   <div>
      <jsp:include page="/partial/mainMenu.jsp"></jsp:include>
   </div>
   <!-- end : submenu include -->
   <br>
   <div class="page-center">
   		<!-- breadcrumb -->
		<nav aria-label="breadcrumb">
			<ol class="breadcrumb" style="background: white;">
				<li class="breadcrumb-item"><a href="<%=request.getContextPath() %>/index.jsp">홈</a></li>
				<li class="breadcrumb-item"><a href="<%=request.getContextPath() %>/selectMyImfo.jsp">정보 확인</a></li>
				<li class="breadcrumb-item active" aria-current="page">정보 수정</li>
			</ol>
		</nav>
   </div>
	<div class="join-form content-center">
		
		<form action="<%=request.getContextPath() %>/updateMyImfoAction.jsp" id="updateMyImfo" method="post">
		    <div class="form-group">
		        아이디
		        <input type="text" class="form-control" name="id" id="id" value="<%=member.getMemberId() %>">
		    </div>
		
		    <div class="form-group">
		        이름
		        <input type="text" class="form-control" name="name" id="name" value="<%=member.getMemberName() %>">
		    </div>
			
			<table style="width: 100%;">
				<tr>
					<td>
						<div class="form-group">
							나이 :
							<select name="age">
							<%
								for(int i=1;i<=120;i++){
									if(i==member.getMemberAge()){
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
						</div>
					</td>
					<td>
						<div class="form-group">
							성별 :
							<%
								if(member.getMemberGender().equals("남")){
							%>
									<input type="radio" name="gender" class="memberGender" value="남" checked="checked"> 남성
									<input type="radio" name="gender" class="memberGender" value="여"> 여성
							<%
								} else{
							%>
									<input type="radio" name="gender" class="memberGender" value="남"> 남성
									<input type="radio" name="gender" class="memberGender" value="여" checked="checked"> 여성
							<%
								}
							%>
							
						</div>
					</td>
				</tr>
			</table>
			<br><br>
			<input type="hidden" name="memberNo" value="<%=memberNo %>">
			<div class="btn-center">
		    	<button type="button" style="width:100%" id="btn" class="btn btn-primary">내정보 수정</button>
			</div>
	
		</form>
	</div>
		
	<!-- footer -->
	<div>
      <jsp:include page="/partial/footer.jsp"></jsp:include>
   </div>
   
	<script>
		$('#btn').click(function(){
			// 버튼을 click했을때
			let memberGedner = $('.memberGender:checked'); // .클래스속성으로 부르면 리턴값은 배열
	        
	        if($('#id').val()==''){ // id가 공백이면
				alert('ID를 입력하세요.');
			} else if($('#name').val()==''){ 
				alert('이름을 입력하세요.');
			} else if(memberGedner.length == 0) {
		        alert('성별을 선택하세요');
			} else {
				$('#updateMyImfo').submit();
			}
		});
	</script>
	
	
</body>
</html>