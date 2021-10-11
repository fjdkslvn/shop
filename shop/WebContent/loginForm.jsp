<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
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
            Member loginMember = (Member)session.getAttribute("loginMember");
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