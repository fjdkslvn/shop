<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

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

<%
	request.setCharacterEncoding("utf-8");

	//로그인이 되어있지 않거나 일반 회원이라면 메인화면으로 넘기기
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember==null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
%>

	<div class="join-form content-center top-margin">
		
		<!-- 전자책 생성 폼 -->
		<form id="insertEbook" action="<%=request.getContextPath() %>/admin/insertEbookAction.jsp" method="post" enctype="multipart/form-data">
		    <div class="form-group">
		        고유코드
		        <input type="text" class="form-control" name="isbn" id="isbn" >
		    </div>
		
		    <div class="form-group">
				카테고리 : 
				<select name="category">
				<%
					CategoryDao categoryDao = new CategoryDao();
					ArrayList<Category> cateList = categoryDao.selectCategoryList();
					for(Category c :cateList){
				%>
						<option value="<%=c.getCategoryName() %>"><%=c.getCategoryName() %></option>
				<%
					}
				
				%>
				</select>
			</div>
		
		    <div class="form-group">
		        제목
		        <input type="text" class="form-control" name="title" id="title">
		    </div>
		
		    <div class="form-group">
		        저자
		        <input type="text" class="form-control" name="author" id="author">
		    </div>
		    
		    <div class="form-group">
		        회사
		        <input type="text" class="form-control" name="company" id="company">
		    </div>
		    
		    <div class="form-group">
		        분량
		        <input type="text" class="form-control" name="page" id="page">
		    </div>
		    
		    <div class="form-group">
		        가격
		        <input type="text" class="form-control" name="price" id="price">
		    </div>
		    
		    <!-- 이미지 -->
		    <div class="form-group">
		        책 사진 : 
		        <input type="file" name="image" id="image">
		    </div>
		    
		    <div class="form-group">
			 	<label for="content">소개</label>
			 	<textarea class="form-control" rows="5" name="content" id="content"></textarea>
			 </div>
		
		    <div class="form-group">
				상태 : 
				<select name="state">
					<option value="판매중">판매중</option>
					<option value="구편절판">구편절판</option>
					<option value="품절">품절</option>
				</select>
			</div>
		
			<div class="btn-center">
		    	<button type="button" id="btn" class="btn btn-success">추가</button>
			</div>
	
		</form>
	</div>
	
	<script>
		$('#btn').click(function(){
			// 버튼을 click했을때 공백이면 alert, 모두 채워졌다면 추가
			if($('#isbn').val()==''){
				alert('고유코드를 입력하세요.');
			} else if($('#title').val()==''){
				alert('제목을 입력하세요.');
			} else if($('#author').val()==''){
				alert('저자 입력하세요.');
			} else if($('#company').val()==''){
				alert('회사를 입력하세요.');
			} else if($('#page').val()==''){
				alert('쪽수를 입력하세요.');
			} else if($('#price').val()==''){
				alert('가격을 입력하세요.');
			} else{
				$('#insertEbook').submit();
			}
		});
	</script>

</body>
</html>