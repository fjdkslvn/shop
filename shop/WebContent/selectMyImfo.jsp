<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>

<%
	request.setCharacterEncoding("utf-8");
	
	//로그인이 되어있지 않았다면 메인화면으로 보내기
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember==null){
	   response.sendRedirect(request.getContextPath()+"/index.jsp");
	   return;
	}
	
	// 회원 정보 가져오기
	MemberDao memberDao = new MemberDao();
	Member member = memberDao.selectMemberOne(loginMember.getMemberNo());
	member.setMemberPw(loginMember.getMemberPw()); // 비밀번호 가져오기
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
	<form action="<%=request.getContextPath() %>/updateMyImfoForm.jsp" id="updateMyImfo" name="updateMyImfo" method="post">
		<table class="table">
			<tr>
				<td>아이디</td>
				<td><%=member.getMemberId() %></td>
			</tr>
			<tr>
				<td>비밀번호</td>
				<td><input type="password" name="pw" id="pw"></td>
			</tr>
			<tr>
				<td>이름</td>
				<td><%=member.getMemberName() %></td>
			</tr>
			<tr>
				<td>나이</td>
				<td><%=member.getMemberAge() %></td>
			</tr>
			<tr>
				<td>성별</td>
				<td><%=member.getMemberGender() %></td>
			</tr>
			<tr>
				<td>가입일</td>
				<td><%=member.getCreateDate() %></td>
			</tr>
		</table>
		<input type="hidden" name="memberNo" value="<%=member.getMemberNo() %>">
		<input type="hidden" id="pw2" value="<%=member.getMemberPw() %>">
		<table>
			<tr>
				<td><button type="button" id="updateBtn" class="btn btn-secondary">정보 수정</button></form></td>
				<td>
					<form action="<%=request.getContextPath() %>/updateMyPwForm.jsp" name="updateMyPw" id="updateMyPw" method="post">
						<input type="hidden" name="memberNo" value="<%=member.getMemberNo() %>">
						<input type="hidden" name="pw">
						<input type="hidden" id="pw2" value="<%=member.getMemberPw() %>">
						<button type="button" id="updatePwBtn" class="btn btn-secondary">비밀번호 수정</button>
					</form>
				</td>
				<td>
					<form action="<%=request.getContextPath() %>/deleteMember.jsp" name="deleteMember" id="deleteMember" method="post">
						<input type="hidden" name="memberNo" value="<%=member.getMemberNo() %>">
						<input type="hidden" id="pw2" value="<%=member.getMemberPw() %>">
						<button type="button" id="deleteMemberBtn" class="btn btn-secondary">회원탈퇴</button>
					</form>
				</td>
			</tr>
		</table>
	
	<script>
		// 회원 정보 수정 버튼
		$('#updateBtn').click(function(){
			// 버튼을 click했을때
			if($('#pw').val()==''){// 비밀번호가 입력되지 않았다면
				alert('비밀번호를 입력하세요.');
			} else if($('#pw').val()!= $('#pw2').val()){// 비밀번호가 다르다면
				alert('비밀번호가 틀렸습니다.');
			} else{
				$('#updateMyImfo').submit();
			}
		});
		
		// 비밀번호 수정 버튼
		$('#updatePwBtn').click(function(){
			// 비밀번호 입력이 있는 폼의 입력된 비밀번호를 가져온다.
			var form1 = document.updateMyImfo;
			var pw = form1.pw.value;
			
			if($('#pw').val()==''){// 비밀번호가 입력되지 않았다면
				alert('비밀번호를 입력하세요.');
			} else if(pw!= $('#pw2').val()){// 비밀번호가 다르다면
				alert('비밀번호가 틀렸습니다.');
			} else{
				$('#updateMyPw').submit();
			}
		});
		
		// 회원탈퇴 버튼
		$('#deleteMemberBtn').click(function(){
			// 비밀번호 입력이 있는 폼의 입력된 비밀번호를 가져온다.
			var form1 = document.updateMyImfo;
			var pw = form1.pw.value;
			
			if($('#pw').val()==''){// 비밀번호가 입력되지 않았다면
				alert('비밀번호를 입력하세요.');
			} else if(pw!= $('#pw2').val()){// 비밀번호가 다르다면
				alert('비밀번호가 틀렸습니다.');
			} else{
				$('#deleteMember').submit();
			}
		});
	</script>
</body>
</html>