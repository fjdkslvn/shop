<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <title>전자책 상점</title>
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");

	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
	
	//페이지
	int currentPage = 1;
	if(request.getParameter("currentPage")!=null){
	   currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	final int ROW_PER_PAGE = 10; // 페이지에 보일 후기 개수
	int beginRow = (currentPage-1)*ROW_PER_PAGE; // 리스트 목록 시작 부분
%>
   <!-- start : submenu include -->
   <div>
      <jsp:include page="/partial/mainMenu.jsp"></jsp:include>
   </div>
   <!-- end : submenu include -->
   <br>
	<div class="page-center">
		<!-- 상품상세출력 -->
		<%
			EbookDao ebookDao = new EbookDao();
			Ebook ebook = ebookDao.selectEbookOne(ebookNo);
		%>
		
		<!-- 표지와 상세정보를 가로로 나열 -->
		<table style="width: 100%;">
			<tr>
				<td style="width: 30%;">
					<!-- 전자책 표지 -->
					<div style="text-align : center;">
						<img src="<%=request.getContextPath() %>/image/<%=ebook.getEbookImg() %>" width="100%";>
					</div>
				</td>
				<td style="width: 10%;"></td>
				<td style="width: 60%;">
					<!-- 전자책 상세정보 -->
					<table class="table">
						<tr>
							<td style="width: 13%;">제목</td>
							<td style="width: 87%;"><%=ebook.getEbookTitle() %></td>
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
						<tr>
							<td>상태</td>
							<td><%=ebook.getEbookState() %></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<br>
		
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
		<br><br>
	
		<h2>상품 후기</h2>
		<!-- 이 상품의 별점의 평균 -->
		<!-- select avg(order_score) from order_comment where ebook_no=? order by ebook_no -->
		
		<div>
		<%
			OrderCommentDao orderCommentDao = new OrderCommentDao();
			double avgScore = orderCommentDao.selectOrderScoreAvg(ebookNo);
			
			// 후기 리스트 추출
			Map<String, Object> commentList = orderCommentDao.selectOrderComment(ebookNo, beginRow, ROW_PER_PAGE);
			ArrayList<OrderComment> comment = (ArrayList<OrderComment>)commentList.get("comment");
			ArrayList<String> memberName = (ArrayList<String>)commentList.get("memberName");
			
			// 후기 리스트 마지막 페이지
			int lastPage = orderCommentDao.selectOrderCommentListLastPageOne(ROW_PER_PAGE, ebookNo);
		%>
			별점 평균 : <%=avgScore %>
		</div>
		
		<!-- 이 상품의 후기(페이징) -->
		<!-- select * from order_comment where ebook_no=? limit ?,? -->
		<div>
			<table class="table">
				<tr>
					<td style="width:10%;">별점</td>
					<td style="width:55%;">후기</td>
					<td style="width:20%;">작성자</td>
					<td style="width:15%;">날짜</td>
				</tr>
			<%
				for(int i=0; i<comment.size();i++){
			%>
					<tr>
						<td><%=comment.get(i).getOrderScore() %></td>
						<td><%=comment.get(i).getOrderCommentContent() %></td>
						<td><%=memberName.get(i) %></td>
						<td><%=comment.get(i).getUpdateDate() %></td>
					</tr>
			<%
				}
			%>
			</table>
		</div>
		<ul class="pagination pagination-lg body-back-color">
		<%
			if(currentPage>1){
		%>
				<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectEbookOne.jsp?ebookNo=<%=ebookNo %>&currentPage=<%=currentPage-1 %>"><</a></li>
		<%
			}
			
			if(currentPage<lastPage){
		%>
				<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectEbookOne.jsp?ebookNo=<%=ebookNo %>&currentPage=<%=currentPage+1 %>">></a></li>
		<%
			}
		%>
		</ul>
		<br><br>
	</div>
	
	<!-- footer -->
	<div>
      <jsp:include page="/partial/footer.jsp"></jsp:include>
   </div>
</body>
</html>