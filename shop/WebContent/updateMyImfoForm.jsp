<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>

<!DOCTYPE html>
<html>
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
	<div class="join-form content-center top-margin">
		<form action="<%=request.getContextPath() %>/updateMyImfoAction.jsp" id="updateMyImfo" method="post">
		    <div class="form-group">
		        아이디
		        <input type="text" class="form-control" name="id" id="id" value="<%=member.getMemberId() %>">
		    </div>
		
		    <div class="form-group">
		        이름
		        <input type="text" class="form-control" name="name" id="name" value="<%=member.getMemberName() %>">
		    </div>
		
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
			
			<input type="hidden" name="memberNo" value="<%=memberNo %>">
			<div class="btn-center">
		    	<button type="button" id="btn" class="btn btn-success">내정보 수정</button>
			</div>
	
		</form>
		
		<script>
		$('#btn').click(function(){
			// 버튼을 click했을때
			let memberGedner = $('.memberGender:checked'); // . 클래스속성으로 부르면 리턴값은 배열
	        
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
	</div>
</body>
</html>