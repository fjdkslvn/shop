<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.Member" %>

<!-- style.css 불러오기 -->
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/style.css">

<!-- 부트스트랩 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">

<!-- 자바스크립트 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>

<!-- 폰트 -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">

<style type="text/css">
		*{
			font-family: 'Noto Sans KR', sans-serif;
			font-size: 13px;
		}
</style>

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
           if(loginMember.getMemberLevel()>0){
        	   %>
        	   	   <%=loginMember.getMemberId() %> 관리자님 반갑습니다.
        	   <%
           } else{
        	   %>
        	   	   <%=loginMember.getMemberId() %> 회원님 반갑습니다.
        	   <%
           }
           %>
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
<div>
	<nav class="navbar navbar-expand-sm bg-light" style="width: 100%;">
		<ul class="navbar-nav">
			<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/index.jsp">메인</a></li>
			<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/selectNoticeList.jsp">공지사항</a></li>
			<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/selectQnaList.jsp">질문게시판</a></li>
		</ul>
	</nav>
</div>