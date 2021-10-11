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
	
	// 로그인이 되어있지 않거나 일반 회원이라면 메인화면으로 넘기기
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember==null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 전자책 번호가 없다면 강제이동
	if(request.getParameter("ebookNo")=="" || request.getParameter("ebookNo")==null){
		response.sendRedirect(request.getContextPath()+"/admin/adminindex.jsp");
	}
	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
	
	// 상품정보 받아오기
	EbookDao ebookDao = new EbookDao();
	Ebook ebook = ebookDao.selectEbookOne(ebookNo);
%>
   <div class="join-form content-center top-margin">
		
		<!-- 전자책 수정 폼 -->
		<form id="updateEbook" action="<%=request.getContextPath()%>/admin/updateEbookAction.jsp" method="post" enctype="multipart/form-data">
		<!-- multipart/form-data : 액션으로 기계어코드를 넘길때 사용 -->
        <!-- application/x-www-form-urlencoded : 액션으로 문자열 넘길때 사용 -->
        <input type="hidden" name="ebookNo" value="<%=ebookNo%>">
        <input type="hidden" name="beforeImg" value="<%=ebook.getEbookImg()%>">
		    <div class="form-group">
		        고유코드
		        <input type="text" class="form-control" name="isbn" id="isbn" value="<%=ebook.getEbookISBN() %>" >
		    </div>
		
		    <div class="form-group">
				카테고리 : 
				<select name="category">
				<%
					CategoryDao categoryDao = new CategoryDao();
					ArrayList<Category> cateList = categoryDao.selectCategoryList();
					for(Category c :cateList){
						if(c.equals(ebook.getCategoryName())){
				%>
							<option value="<%=c.getCategoryName() %>" selected><%=c.getCategoryName() %></option>
				<%
						}else{
				%>
							<option value="<%=c.getCategoryName() %>"><%=c.getCategoryName() %></option>
				<%	
						}
					}
				
				%>
				</select>
			</div>
		
		    <div class="form-group">
		        제목
		        <input type="text" class="form-control" name="title" id="title" value="<%=ebook.getEbookTitle() %>">
		    </div>
		
		    <div class="form-group">
		        저자
		        <input type="text" class="form-control" name="author" id="author" value="<%=ebook.getEbookAuthor() %>">
		    </div>
		    
		    <div class="form-group">
		        회사
		        <input type="text" class="form-control" name="company" id="company" value="<%=ebook.getEbookCompany() %>">
		    </div>
		    
		    <div class="form-group">
		        분량
		        <input type="text" class="form-control" name="page" id="page" value="<%=ebook.getEbookPageCount() %>">
		    </div>
		    
		    <div class="form-group">
		        가격
		        <input type="text" class="form-control" name="price" id="price" value="<%=ebook.getEbookPrice() %>">
		    </div>
		    
		    <!-- 이미지 -->
		    <div class="form-group">
		        수정할 책 사진 : 
		        <input type="file" name="image" id="image">
		    </div>
		    
		    <div class="form-group">
			 	<label for="content">소개</label>
			 	<textarea class="form-control" rows="5" name="content" id="content"><%=ebook.getEbookSummary() %></textarea>
			 </div>
		
		    <div class="form-group">
				상태 : 
				<select name="state">
				<%
					String[] stateList = {"판매중","구편절판","품절"};
					for(String s : stateList){
						if(s.equals(ebook.getEbookState())){
				%>
							<option value="<%=s %>" selected><%=s %></option>
				<%
						} else{
				%>
							<option value="<%=s %>"><%=s %></option>
				<%
						}
					}
				%>
				</select>
			</div>
		
			<div class="btn-center">
		    	<button type="button" id="btn" class="btn btn-success">수정</button>
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
				$('#updateEbook').submit();
			}
		});
	</script>

</body>
</html>