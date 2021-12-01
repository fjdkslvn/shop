<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>

<%
	request.setCharacterEncoding("utf-8");
	
	// 로그인이 되어있지 않거나 일반 회원이라면 메인화면으로 넘기기
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember==null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 공지 번호가 넘어오지 않았다면 공지 목록으로 보내기
	if(request.getParameter("noticeNo")=="" || request.getParameter("noticeNo")==null){
		response.sendRedirect(request.getContextPath()+"/admin/selectNoticeList.jsp");
		return;
	}
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	
	// 공지 내용 가져오기
	NoticeDao noticeDao = new NoticeDao();
	Notice notice = noticeDao.selectNoticeOne(noticeNo);
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
	<div class="content-center">
	<form action="<%=request.getContextPath() %>/admin/updateNoticeAction.jsp" id="updateNoticeAction" method="post" enctype="multipart/form-data">
		<input type="hidden" name="beforeImg" value="<%=notice.getImage()%>">
		<input type="hidden" id="noticeNo" name="noticeNo" value="<%=notice.getNotice_no() %>">
		<div class="form-group">
            공지 제목
            <input type="text" class="form-control" name="title" id="title" value="<%=notice.getNotice_title() %>">
        </div>
		<div class="form-group">
		  <label for="content">공지 내용</label>
		  <textarea class="form-control" rows="5" name="content" id="content"><%=notice.getNotice_content().replace("<br>","\r\n") %></textarea>
		 </div>
		 <!-- 이미지 -->
	    <div class="form-group">
	        수정할 공지 사진 : 
	        <input type="file" name="image" id="image">
	    </div>
		<br><br>
		<button type="button" class="btn btn-success" id="btn">수정</button>
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
				$('#updateNoticeAction').submit();
			}
		});
	</script>	
</body>
</html>