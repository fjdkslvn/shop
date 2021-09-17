<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>selectCategoryList.jsp 페이징 X</title>
</head>
<%
	request.setCharacterEncoding("utf-8");
	
	// 로그인이 되어있지 않거나 일반 회원이라면 메인화면으로 넘기기
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember==null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 카테고리 목록을 리스트에 담기
	CategoryDao categoryDao = new CategoryDao();
	ArrayList<Category> categoryList = categoryDao.selectCategoryList();
%>
<body>
	<h1>카테고리 목록</h1>
	<div>
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
	</div>
	
	
	<table class="table" border="1">
		<thead>
			<tr>
				<th>categoryName</th>
				<th>updateDate</th>
				<th>createDate</th>
				<th>categoryState</th>
			</tr>
		</thead>
		<tbody>
			<%
				// 반복을 통해 카테고리 목록을 표로 출력
				for(Category c : categoryList){
			%>
					<tr>
						<td><%=c.getCategoryName() %></td>
						<td><%=c.getUpdateDate() %></td>
						<td><%=c.getCreateDate() %></td>
						<td>
							<%
								// 카테고리 상태가 Y이면 사용, 아니면 미사용으로 / 클릭되게 해서 상태가 뒤바뀌도록 설정
								if(c.getCategoryState().equals("Y")){
									%>
										<a href="<%=request.getContextPath() %>/admin/updateCategoryStateAction.jsp?categoryName=<%=c.getCategoryName() %>&categoryState=<%=c.getCategoryState() %>">사용</a>
									<%
								} else{
									%>
										<a href="<%=request.getContextPath() %>/admin/updateCategoryStateAction.jsp?categoryName=<%=c.getCategoryName() %>&categoryState=<%=c.getCategoryState() %>">미사용</a>
									<%
							}
							%>
						</td>
					</tr>
			<%
				}
			%>
		</tbody>
	</table>
</body>
</html>