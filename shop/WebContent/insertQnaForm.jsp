<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>

<%
	request.setCharacterEncoding("utf-8");
	
	// 로그인이 되어있지 않으면 로그인 화면으로 보내기
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember==null){
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}
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
	<div class="content-center">
		<form action="<%=request.getContextPath() %>/insertQnaAction.jsp" id="insertQnaAction" method="post">
			<div class="form-group">
	        	카테고리 : 
	        	<select name="category">
	       		<%
	       			String[] category = {"전자책관련","개인정보관련","기타"};
	       			for(String c:category){
				%>
						<option value="<%=c %>"><%=c %></option>
				<%
	       			}
	       		%>
	        	</select>
	        </div>
			<div class="form-group">
	            질문 제목
	            <input type="text" class="form-control" name="title" id="title">
	        </div>
			<div class="form-group">
			  <label for="content">질문 내용</label>
			  <textarea class="form-control" rows="5" name="content" id="content"></textarea>
			</div>
			<div class="form-group">
				<input type="checkbox" name="secret" value="Y"> 비밀글
			</div>
			<br><br>
			<button type="button" class="btn btn-success" id="btn">작성</button>
		</form>
	</div>

	<script>
		// 작성 버튼을 눌렀을 경우
		$('#btn').click(function(){
			if($('#title').val()==''){
				alert('질문 제목을 작성하세요');
			} else if($('#content').val()==''){
				alert('질문 내용을 작성하세요');
			} else{
				// 버튼을 클릭하면 질문 생성
				$('#insertQnaAction').submit();
			}
		});
	</script>	
</body>
</html>