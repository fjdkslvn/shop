<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
	<!-- Favicons -->
	<link href="<%=request.getContextPath() %>/image/logo.png" rel="icon">
	<link href="<%=request.getContextPath() %>/image/logo.png" rel="apple-touch-icon">
	
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
	
   <meta charset="UTF-8">
   <title>전자책 상점</title>
</head>
<body>
   <!-- start : submenu include -->
   <div>
      <jsp:include page="/partial/mainMenu.jsp"></jsp:include>
   </div>
   <!-- end : submenu include -->
   <br>
   
      <!-- 상품 목록 출력 -->
      <%
      request.setCharacterEncoding("utf-8");
      
      // 최근 공지 가져오기
  	  NoticeDao noticeDao = new NoticeDao();
  	  ArrayList<Notice> noticeList = noticeDao.selectRecentNoticeList();
      
      // 인기 상품 목록 10개
      EbookDao ebookDao = new EbookDao();
      ArrayList<Ebook> popularEbookList = ebookDao.selectPopularEbookList();
      
      // 신상품 목록 10개
      ArrayList<Ebook> newEbookList = ebookDao.selectNewEbookList();
      int rotateNum=0;
      %>
      
      <div class="page-center">
      <br>
		<!-- 최근 공지사항 3개를 출력 -->
		<div id="carouselExampleSlidesOnly" class="carousel slide" data-bs-ride="carousel">
		  <div class="carousel-inner">
		    <%
				for(int i=0;i<noticeList.size();i++){
					if(i==0){
			%>
						<div class="carousel-item active">
					      <a href="<%=request.getContextPath() %>/selectNoticeOne.jsp?noticeNo=<%=noticeList.get(i).getNotice_no() %>">
					      	<img src="<%=request.getContextPath() %>/image/<%=noticeList.get(i).getImage() %>" class="d-block w-100">
					      </a>
					     </div>
			<%
					} else{
			%>
						<div class="carousel-item">
					      <a href="<%=request.getContextPath() %>/selectNoticeOne.jsp?noticeNo=<%=noticeList.get(i).getNotice_no() %>">
					      	<img src="<%=request.getContextPath() %>/image/<%=noticeList.get(i).getImage() %>" class="d-block w-100">
					      </a>
					    </div>
			<%
					}
				}
			%>
		  </div>
		</div>
		 
		<br><br><br><br>
      
      <h2 class="center">화제의 신간</h2>
      <!-- 신상품 목록 출력 -->
	   <table class="table">
	   		<tr>
	         <%
	            for(Ebook e : newEbookList){
	         %>
		               <td class="size-19">
		                  <div>
		                  	<div class="card" style="width: 18rem;">
							  <img class="card-img-top" src="<%=request.getContextPath() %>/image/ebook/<%=e.getEbookImg() %>" height="300px;">
							  <div class="card-body">
							    <h5 class="card-title"><%=e.getEbookTitle()  %></h5>
							    <p class="card-text">₩ <%=e.getEbookPrice() %></p>
							    <a href="<%=request.getContextPath() %>/selectEbookOne.jsp?ebookNo=<%=e.getEbookNo() %>" class="btn btn-outline-primary">상세보기</a>
							  </div>
							</div>
		               </td>
	         <%
			 	   rotateNum+=1; // for문 끝날때마다 i는 1씩 증가
	               if(rotateNum%5==0){
	         %>
	                  </tr><tr> <!-- 줄바꿈 -->
	         <%
	               }
	            }
	            rotateNum=0;
	         %>
	      </tr>
	   </table>
	   <br><br><br><br>
      
      <h2 class="center">베스트 셀러</h2>
      <!-- 인기상품 목록 출력 -->
	   <table class="table">
	   		<tr>
	         <%
	            for(Ebook e : popularEbookList){
	         %>
		               <td class="size-19">
		                  <div class="card" style="width: 18rem;">
						  <img class="card-img-top" src="<%=request.getContextPath() %>/image/ebook/<%=e.getEbookImg() %>" height="300px;">
						  <div class="card-body">
						    <h5 class="card-title"><%=e.getEbookTitle()  %></h5>
						    <p class="card-text">₩ <%=e.getEbookPrice() %></p>
						    <a href="<%=request.getContextPath() %>/selectEbookOne.jsp?ebookNo=<%=e.getEbookNo() %>" class="btn btn-outline-primary">상세보기</a>
						  </div>
						</div>
		               </td>
				 <%
				 	   rotateNum+=1; // for문 끝날때마다 i는 1씩 증가
		               if(rotateNum%5==0){
		         %>
		                  </tr><tr> <!-- 줄바꿈 -->
		         <%
		               }
	            }
	         	rotateNum=0;
	         %>
	      </tr>
	   </table>
	   </div>
	
	<!-- footer -->
	<div>
      <jsp:include page="/partial/footer.jsp"></jsp:include>
   </div>
</body>
</html>