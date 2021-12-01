<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>

<%
	request.setCharacterEncoding("utf-8");
	
	// 로그인이 되어있지 않거나 일반 회원이라면 메인화면으로 넘기기
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember==null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
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
		<a href="<%=request.getContextPath() %>/admin/adminindex.jsp"><img src="<%=request.getContextPath() %>/image/adminbanner.PNG" width="650" height="130"></a>
	</div>
	<div class="right">
		<a href="<%=request.getContextPath() %>/index.jsp">메인으로 돌아가기</a>
		<a href="<%=request.getContextPath() %>/logout.jsp">로그아웃</a>
	</div>
	<br>
	<!-- start : submenu include -->
   <div>
      <jsp:include page="/partial/adminMenu.jsp"></jsp:include>
   </div>
   <!-- end : submenu include -->
	<br>
	<div class="content-center ">
	<form action="<%=request.getContextPath() %>/admin/insertNoticeAction.jsp" id="insertNoticeAction" method="post" enctype="multipart/form-data">
		<div class="form-group">
            공지 제목
            <input type="text" class="form-control" name="title" id="title">
        </div>
		<div class="form-group">
		  <label for="content">공지 내용</label>
		  <textarea class="form-control" rows="5" name="content" id="content"></textarea>
		 </div>
		 <!-- 이미지 -->
	    <div class="form-group">
	        공지 사진 : 
	        <input type="file" name="image" id="image">
	    </div>
		<br><br>
		<button type="button" class="btn btn-success" id="btn">작성</button>
	</form>
	</div>
	<script>
		// 작성 버튼을 눌렀을 경우
		$('#btn').click(function(){
			if($('#title').val()==''){
				alert('공지 제목을 작성하세요');
			} else if($('#content').val()==''){
				alert('공지 내용을 작성하세요');
			} else{
				// 버튼을 클릭하면 공지사항 생성
				$('#insertNoticeAction').submit();
			}
		});
	</script>	
</body>
</html>