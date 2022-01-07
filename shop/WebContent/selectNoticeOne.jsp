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
	request.setCharacterEncoding("utf-8");
	
	// 공지 번호
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	
	// 공지 목록을 리스트에 담기
	NoticeDao noticeDao = new NoticeDao();
	Notice notice = noticeDao.selectNoticeOne(noticeNo);
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
				<li class="breadcrumb-item"><a href="<%=request.getContextPath() %>/selectNoticeList.jsp">공지사항</a></li>
				<li class="breadcrumb-item active" aria-current="page">공지사항 상세</li>
			</ol>
		</nav>
   		
   		<h4><%=notice.getNotice_title() %></h4>
   		<br><br>
   		<hr style="height:2px;">
   		<div><img src="<%=request.getContextPath() %>/image/<%=notice.getImage() %>" width="100%"></div>
   		<br><br>
   		<%=notice.getNotice_content() %>
   		<br><br><br><br><br><br>
   		작성일 : <%=notice.getUpdate_date() %>
   </div>
   
   <!-- footer -->
	<div>
      <jsp:include page="/partial/footer.jsp"></jsp:include>
   </div>
</body>
</html>