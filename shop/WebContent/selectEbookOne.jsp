<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>

<%
	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
	
	//페이지
	int currentPage = 1;
	if(request.getParameter("currentPage")!=null){
	   currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage+" <--selectEbookList currentPage");
	
	final int ROW_PER_PAGE = 10; // 페이지에 보일 후기 개수
	int beginRow = (currentPage-1)*ROW_PER_PAGE; // 리스트 목록 시작 부분
%>
<!DOCTYPE html>
<html>
<head>
	<!-- 부트스트랩 -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	
	<meta charset="UTF-8">
	<title>상품상세보기(주문)</title>
</head>
<body>
	<h1>상품상세보기</h1>
	<div>
		<!-- 상품상세출력 -->
		<%
			EbookDao ebookDao = new EbookDao();
			Ebook ebook = ebookDao.selectEbookOne(ebookNo);
		%>
		<img src="<%=request.getContextPath() %>/image/<%=ebook.getEbookImg() %>" width="200" height="200">
		<div>제목 : <%=ebook.getEbookTitle() %></div>
		<div>가격 : <%=ebook.getEbookPrice() %></div>
	</div>
	<div>
		<!-- 주문 입력하는 폼 -->
		<%
			Member loginMember = (Member)session.getAttribute("loginMember");
			if(loginMember == null){
		%>
				<div>
					로그인 후에 주문이 가능합니다.
					<a href="<%=request.getContextPath() %>/index.jsp">로그인 페이지로 이동</a>
				</div>
		<%
			} else{
		%>
				<form method="post" action="<%=request.getContextPath() %>/insertOrderAction.jsp">
					<input type="hidden" name="ebookNo" value="<%=ebookNo %>">
					<input type="hidden" name="memberNo" value="<%=loginMember.getMemberNo() %>">
					<input type="hidden" name="orderPrice" value="<%=ebook.getEbookPrice() %>">
					<button type="submit">주문하기</button>
				</form>
		<%
			}
		%>
	</div>
	<br><br>
	
	<div>
		<h2>상품 후기</h2>
		<!-- 이 상품의 별점의 평균 -->
		<!-- select avg(order_score) from order_comment where ebook_no=? order by ebook_no -->
		
		<div>
		<%
			OrderCommentDao orderCommentDao = new OrderCommentDao();
			double avgScore = orderCommentDao.selectOrderScoreAvg(ebookNo);
			
			// 후기 리스트 추출
			ArrayList<OrderComment> commentList = orderCommentDao.selectOrderComment(ebookNo, beginRow, ROW_PER_PAGE);
			
			// 후기 리스트 마지막 페이지
			int lastPage = orderCommentDao.selectOrderCommentListLastPage(ROW_PER_PAGE, ebookNo);
		%>
			별점 평균 : <%=avgScore %>
		</div>
		
		<!-- 이 상품의 후기(페이징) -->
		<!-- select * from order_comment where ebook_no=? limit ?,? -->
		<div>
			<table class="table">
				<tr>
					<td>별점</td>
					<td>후기</td>
					<td>작성일</td>
				</tr>
			<%
				for(OrderComment o:commentList){
			%>
					<tr>
						<td><%=o.getOrderScore() %></td>
						<td><%=o.getOrderCommentContent() %></td>
						<td><%=o.getCreateDate() %></td>
					</tr>
			<%
				}
			%>
			</table>
		</div>
		
		<%
			if(currentPage>1){
		%>
				<a href="<%=request.getContextPath() %>/selectEbookOne.jsp?ebookNo=<%=ebookNo %>&currentPage=<%=currentPage-1 %>">이전</a>
		<%
			}
			
			if(currentPage<lastPage){
		%>
				<a href="<%=request.getContextPath() %>/selectEbookOne.jsp?ebookNo=<%=ebookNo %>&currentPage=<%=currentPage+1 %>">다음</a>
		<%
			}
		%>
		
		
	</div>
</body>
</html>