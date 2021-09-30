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
	<!-- style.css 불러오기 -->
	<link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/style.css">
	
	<!-- 부트스트랩 -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
	
	<!-- 자바스크립트 -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	
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
		<br><br>
		<table class="table">
			<tr>
				<td>제목</td>
				<td><%=ebook.getEbookTitle() %></td>
			</tr>
			<tr>
				<td>저자</td>
				<td><%=ebook.getEbookAuthor() %></td>
			</tr>
			<tr>
				<td>가격</td>
				<td><%=ebook.getEbookPrice() %></td>
			</tr>
			<tr>
				<td>분량</td>
				<td><%=ebook.getEbookPageCount() %>p</td>
			</tr>
			<tr>
				<td>소개</td>
				<td><%=ebook.getEbookSummary() %></td>
			</tr>
		</table>
	</div>
	<div>
		<!-- 주문 입력하는 폼 -->
		<%
			Member loginMember = (Member)session.getAttribute("loginMember");
			boolean ebookSaleCheck = ebookDao.ebookSaleCheck(ebookNo);
			if(!ebookSaleCheck){
			%>
				<p>구매할수 없는 서적입니다.</p>
			<%
			} else if(loginMember == null){ // 로그인 되어있지 않은 경우
		%>
				<div>
					로그인 후에 주문이 가능합니다.
					<a href="<%=request.getContextPath() %>/loginForm.jsp">로그인 페이지로 이동</a>
				</div>
		<%
			} else{
				// 전자책 보유 여부 확인
				OrderDao orderDao = new OrderDao();
				boolean existence = orderDao.orderExistence(loginMember.getMemberNo(), ebookNo);
				
				if(existence){ // 이미 해당 전자책을 주문했다면
				%>
					<p>해당 서적을 보유중입니다.</p>
				<%
				} else{ // 전자책을 주문한적이 없다면
				%>
						<form method="post" action="<%=request.getContextPath() %>/insertOrderAction.jsp" id="insertOrder">
							<input type="hidden" name="ebookNo" value="<%=ebookNo %>">
							<input type="hidden" name="memberNo" value="<%=loginMember.getMemberNo() %>">
							<input type="hidden" name="orderPrice" value="<%=ebook.getEbookPrice() %>">
							<button type="button" id="orderBtn" class="btn btn-secondary">주문하기</button>
						</form>
						<script>
							$('#orderBtn').click(function(){
								// 버튼을 click했을때
								$('#insertOrder').submit();
							});
						</script>
				<%
				}
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