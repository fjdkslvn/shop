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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>

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
     &nbsp;&nbsp;
  </div>
   <br>
	<div class="logo-center">
	  <br>
	  <table>
	  	<tr>
	  		<td>
	  			<a href="<%=request.getContextPath() %>/index.jsp">
	  				<img src="<%=request.getContextPath() %>/image/logo.png" width="100px">
	  			</a>
	  		</td>
	  		<td style="width : 5%;"></td>
	  		<td style="width : 90%;">
	  			<form class="form-inline" action="<%=request.getContextPath() %>/searchResult.jsp" id="searchForm">
			    	<input style="width:70%; height: 45px;" class="form-control mr-sm-2 all-margin-10" type="search" placeholder="원하는 서적을 입력해주세요" aria-label="Search" name="searchText" id="searchText">
			    	<button style="width:50px; padding-top:10px; padding-bottom:10px;" class="btn btn-outline-dark my-2 my-sm-0" id="searchBtn"type="button">검색</button>
			    </form>
	  		</td>
	  	</tr>
	  </table>
	  <br>
	</div>

<div>
	
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
	  <div class="container-fluid">
	    <a class="navbar-brand" href="<%=request.getContextPath() %>/index.jsp">홈</a>
	    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarColor02" aria-controls="navbarColor02" aria-expanded="false" aria-label="Toggle navigation">
	      <span class="navbar-toggler-icon"></span>
	    </button>
	
	    <div class="collapse navbar-collapse" id="navbarColor02">
	      <ul class="navbar-nav me-auto">
	      	<li class="nav-item">
	          <a class="nav-link active" href="<%=request.getContextPath() %>/selectEbookList.jsp">서적</a>
	        </li>
	        <li class="nav-item">
	          <a class="nav-link active" href="<%=request.getContextPath() %>/selectNoticeList.jsp">공지사항</a>
	        </li>
	        <li class="nav-item">
	          <a class="nav-link active" href="<%=request.getContextPath() %>/selectQnaList.jsp">QnA</a>
	        </li>
	      </ul>
	    </div>
	  </div>
	</nav>
</div>

<script>
		$('#searchBtn').click(function(){
			// 버튼을 click했을때
			if($('#searchText').val()=='' || $('#searchText').val()==' '){ // 검색어가 공백이면
				loaction.assign(location.href); // 현재페이지로 이동(새로고침)
			} else{
				$('#searchForm').submit();	
			}
		});
	</script>