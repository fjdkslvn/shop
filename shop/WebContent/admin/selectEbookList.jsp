<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");
	
	// 로그인이 되어있지 않거나 일반 회원이라면 메인화면으로 넘기기
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember==null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage+" <--selectEbookList currentPage");
	
	final int ROW_PER_PAGE = 10; // 페이지에 보일 전자책 개수
	int  beginRow = (currentPage-1)*ROW_PER_PAGE; // 전자책 목록 시작 부분
	
	
	// 전자책 목록을 리스트에 담기
	EbookDao ebookDao = new EbookDao();
	ArrayList<Ebook> ebookList = new ArrayList<>();
	String categoryName=""; // 선택한 카테고리
	if(request.getParameter("categoryName")=="" || request.getParameter("categoryName")==null){
		ebookList = ebookDao.selectEbookList(beginRow, ROW_PER_PAGE);
	} else{
		categoryName = request.getParameter("categoryName");
		ebookList = ebookDao.selectEbookListByCategory(beginRow, ROW_PER_PAGE,categoryName);
	}
	
	// 카테고리 목록을 리스트에 담기
	CategoryDao categoryDao = new CategoryDao();
	ArrayList<Category> categoryList = categoryDao.selectCategoryList();
%>

	<h1>전자책 관리</h1>
	<div>
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
	</div>
	
	<!-- 전자책 카테고리별 분류 / 카테고리명을 받아왔으면 그게 기본으로 설정되어있도록 함 -->
	<form action="<%=request.getContextPath() %>/admin/selectEbookList.jsp">
		<select name="categoryName">
			<%
				if(categoryName==""){
			%>
					<option value="" selected>전체목록</option>
			<%
				} else{
			%>
					<option value="">전체목록</option>
			<%
				}
			%>
			<%
				for(Category c : categoryList){
					if(categoryName.equals(c.getCategoryName())){
			%>
						<option value="<%=c.getCategoryName() %>" selected><%=c.getCategoryName() %></option>
			<%
					} else{
			%>
						<option value="<%=c.getCategoryName() %>"><%=c.getCategoryName() %></option>
			<%
					}
			%>
			<%	
				}
			%>
		</select>
		<button type="submit">출력</button>
	</form>
	
	<!-- 전자책 목록 출력 : 카테고리별 출력 -->
	<table class="table" border="1">
		<thead>
			<tr>
				<th>ebookNo</th>
				<th>categoryName</th>
				<th>ebookTitle</th>
				<th>ebookState</th>
			</tr>
		</thead>
		<tbody>
			<%
				// 반복을 통해 카테고리 목록을 표로 출력
				for(Ebook e : ebookList){
			%>
					<tr>
						<td><%=e.getEbookNo() %></td>
						<td><%=e.getCategoryName() %></td>
						<td><%=e.getEbookTitle() %></td>
						<td><%=e.getEbookState() %></td>
					</tr>
			<%
				}
			%>
		</tbody>
	</table>
	
	<br><br>
	
	<!-- 페이지 -->
   <%	
   	   // 페이징을 위해 구해야 할 마지막 페이지 연산
       int lastPage;
   	   int currentnumPage=0; // 현재 페이지가 몇번째 묶음인지(이전,다음 구현을 위함)
   	   int lastnumPage=0; // 마지막 페이지가 몇번째 묶음인지(마지막 페이지에서 다음이 나오지 않도록 하기 위함)
   	   
   	   if(categoryName.equals("")){
   		lastPage = ebookDao.selectEbookListLastPage(ROW_PER_PAGE);
   	   } else{
   		lastPage = ebookDao.selectEbookListLastPageByCategory(ROW_PER_PAGE, categoryName);
   	   }
	   
   %>
    <ul class="pagination body-back-color">
    <%
    	if(currentPage!=1){
    %>
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectEbookList.jsp?currentPage=<%=1 %>&categoryName=<%=categoryName %>">처음</a></li>
    <%	
    	}
    	if(currentPage%ROW_PER_PAGE==0){ // 현재 페이지가 몇번째 묶음인지
    		currentnumPage =(currentPage/ROW_PER_PAGE)-1;
    	} else{
    		currentnumPage = currentPage/ROW_PER_PAGE;
    	}
   	%>
    <%
    	if((currentnumPage)>0){ // 이전
    %>
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectEbookList.jsp?currentPage=<%=ROW_PER_PAGE*(currentnumPage-1)+1 %>&categoryName=<%=categoryName %>">이전</a></li>
    <%
    	}
    
    	for(int i=0;i<ROW_PER_PAGE;i++){ // 중간 번호들
    		if(lastPage>=(ROW_PER_PAGE*currentnumPage)+i+1){
   	    %>
   		  <li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectEbookList.jsp?currentPage=<%=(ROW_PER_PAGE*currentnumPage)+i+1 %>&categoryName=<%=categoryName %>"><%=(ROW_PER_PAGE*currentnumPage)+i+1 %></a></li>
   	   <%
    		}
    	}
    	if(lastPage%ROW_PER_PAGE==0){ // 마지막 페이지가 몇번째 묶음인지
    		lastnumPage =(lastPage/ROW_PER_PAGE)-1;
    	} else{
    		lastnumPage = lastPage/ROW_PER_PAGE;
    	}
    	
    	if(lastnumPage>currentnumPage){
    %>
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectEbookList.jsp?currentPage=<%=ROW_PER_PAGE*(currentnumPage+1)+1 %>&categoryName=<%=categoryName %>">다음</a></li>
    <%
    	}
    	if(currentPage!=lastPage && lastPage!=0){
    %>
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/admin/selectEbookList.jsp?currentPage=<%=lastPage %>&categoryName=<%=categoryName %>">맨끝</a></li>
    <%
    	}
    %>
	</ul>
	
</body>
</html>