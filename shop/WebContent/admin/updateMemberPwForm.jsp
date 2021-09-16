<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>

<!DOCTYPE html>
<html>
<head>
	<!-- style.css 불러오기 -->
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/style.css">
	
	<!-- 부트스트랩 -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	<meta charset="UTF-8">
	<title>회원비밀번호수정</title>
</head>
<%
	// 수정될 회원 번호
	int memberNo;
	if(request.getParameter("memberNo")!=null){
		memberNo = Integer.parseInt(request.getParameter("memberNo"));
	} else{
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	System.out.println(memberNo + " <--비밀번호 수정될 회원 번호");
	
	MemberDao memberDao = new MemberDao();
	Member member = memberDao.selectMemberOne(memberNo);
%>
<body>
	
	<div class="join-form content-center top-margin">
		<form action="updateMemberPwAction.jsp">
			<div class="form-group">
	            관리자 비밀번호
	            <input type="password" class="form-control" name="pw">
	        </div>
	        <br>
		    <div class="form-group">
		        아이디
		        <input type="text" class="form-control" name="id" value="<%=member.getMemberId() %>" readonly>
		    </div>
		
		    <div class="form-group">
		        비밀번호
		        <input type="password" class="form-control" name="newPw">
		    </div>
		
		    <div class="form-group">
		        이름
		        <input type="text" class="form-control" name="name" value="<%=member.getMemberName() %>" readonly>
		    </div>
		    
		    <div class="form-group">
		        회원 등급
		        <%
		        	if(member.getMemberLevel()==0){
		        %>
		        		<input type="text" class="form-control" name="name" value="일반회원" readonly>
		        <%
		        	} else if(member.getMemberLevel()==1){
		        %>
		        		<input type="text" class="form-control" name="name" value="관리자" readonly>
		        <%
		        	}
		        %>
		        
		    </div>
		
		    <div class="form-group">
				나이 :
				<select name="age" disabled>
				<%
					for(int i=1;i<=120;i++){
						if(i==member.getMemberAge()){
							%>
								<option value="<%=i %>" selected><%=i %></option>
							<%
						} else{
							%>
								<option value="<%=i %>"><%=i %></option>
							<%
						}
					}
				
				%>
				</select>
			</div>
			
			<div class="form-group">
				성별 :
				<%
					if(member.getMemberGender().equals("남")){
				%>
						<input type="radio" name="gender" value="남" checked="checked" disabled> 남성
						<input type="radio" name="gender" value="여" disabled> 여성
				<%
					} else{
				%>
						<input type="radio" name="gender" value="남" disabled> 남성
						<input type="radio" name="gender" value="여" checked="checked" disabled> 여성
				<%
					}
				%>
				
			</div>
			
			<div class="form-group">
		        회원정보 수정 날짜
		        <input type="text" class="form-control" name="name" value="<%=member.getUpdateDate() %>" readonly>
		    </div>
		    
		    <div class="form-group">
		        가입한 날짜
		        <input type="text" class="form-control" name="name" value="<%=member.getCreateDate() %>" readonly>
		    </div>
			<input type="hidden" name="memberNo" value="<%=memberNo %>">
			<div class="btn-center">
		    	<button type="submit" style="width:100%" class="btn btn-success">회원비번수정</button>
			</div>
	
		</form>
	</div>
</body>
</html>