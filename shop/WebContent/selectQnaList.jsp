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
	
	Member loginMember = null;
	if(session.getAttribute("loginMember")!=null){
		loginMember = (Member)session.getAttribute("loginMember");
	}
	
	// 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage+" <--질문 목록 currentPage");
	
	final int ROW_PER_PAGE = 10; // 페이지에 보일 질문 개수
	int  beginRow = (currentPage-1)*ROW_PER_PAGE; // 질문 목록 시작 부분
	
	// 질문 목록을 리스트에 담기
	QnaDao qnaDao = new QnaDao();
	Map<String,Object> map = qnaDao.selectQnaJoinCommentList(beginRow,ROW_PER_PAGE);
	ArrayList<Qna> qnaList = (ArrayList<Qna>)map.get("qnaList");
	ArrayList<QnaComment> qnaCommentList = (ArrayList<QnaComment>)map.get("qnaCommentList");
%>

   <!-- start : submenu include -->
   <div>
      <jsp:include page="/partial/mainMenu.jsp"></jsp:include>
   </div>
   <!-- end : submenu include -->
   <br>
	
	<div class="page-center">
	<table class="table">
		<thead>
			<tr>
				<th>QnA</th>
			</tr>
		</thead>
		<tbody>
		<tr>
			<td>
			<%
				// 반복을 통해 질문 목록을 표로 출력
				for(int i=0; i<qnaList.size();i++){
					Qna qna = qnaList.get(i);
					QnaComment qnaComment = qnaCommentList.get(i);
					
					// 만약 비밀글이라면
					if(qna.getQnaSecret().equals("Y")){
						// 만약 비밀글의 작성자가 본인이라면 비밀글이라도 상세보기가 가능하도록 한다.
						if(loginMember!=null && qna.getMemberId().equals(loginMember.getMemberId())){
						%>
							<div class="card">
							    <div class="card-header" id="heading<%=qna.getQnaNo() %>">
							      <h5 class="mb-0">
							        <button class="btn btn-link" data-toggle="collapse" data-target="#<%=qna.getQnaNo() %>" aria-controls="<%=qna.getQnaNo() %>">
							          🔑 [<%=qna.getQnaCategory() %>] <%=qna.getQnaTitle() %> - <%=qna.getMemberId() %>
							        </button>
							      </h5>
							    </div>
							
							    <div id="<%=qna.getQnaNo() %>" class="collapse" aria-labelledby="heading<%=qna.getQnaNo() %>" data-parent="#accordion">
							      <div class="card-body">
							      	<p>[질문]</p>
							        <%=qna.getQnaContent() %>
							        <p class="size-10">작성일 : <%=qna.getCreateDate().substring(0,10) %></p>
							        
							        <%
							        	if(qnaComment.getQnaCommentContent()!=null && qnaComment.getQnaCommentContent()!=""){
					        		%>
					        			<br><br><br>
								        <p>[답변]</p>
								        <%=qnaComment.getQnaCommentContent() %>
								        <p class="size-10">답변일 : <%=qnaComment.getCreateDate().substring(0,10) %></p>
					        		<%
							        	}
							        %>
					    			<table>
					    				<tr>
					    					<td>
					    						<!-- 질문 수정 버튼 -->
					    						<form action="<%=request.getContextPath() %>/updateQnaForm.jsp" id="updateQnaForm" method="post">
					    							<input type="hidden" value="<%=qna.getQnaNo() %>" name="qnaNo">
					    							<button class="btn btn-secondary" type="submit" id="updateBtn">질문수정</button>
					    						</form>
					    					</td>
					    					<td>
					    						<!-- 질문 삭제 버튼 -->
					    						<form action="<%=request.getContextPath() %>/deleteQna.jsp" id="deleteQnaForm" method="post">
					    							<input type="hidden" value="<%=qna.getQnaNo() %>" name="qnaNo">
					    							<button class="btn btn-danger" type="submit" id="deleteBtn">질문삭제</button>
					    						</form>
					    					</td>
					    				</tr>
					    			</table>
							      </div>
							    </div>
							 </div>
							
						<%
						} else{ // 상세보기는 불가능하도록 한다.
						%>
								<div class="card">
							    <div class="card-header" id="heading<%=qna.getQnaNo() %>">
							      <h5 class="mb-0">
							        <button class="btn btn-link" data-toggle="collapse" data-target="#<%=qna.getQnaNo() %>" aria-controls="<%=qna.getQnaNo() %>">
							          🔑 [<%=qna.getQnaCategory() %>] <%=qna.getQnaTitle() %> - <%=qna.getMemberId() %>
							        </button>
							      </h5>
							    </div>
							 </div>
						<%
						}
					} else{ // 비밀글이 아니라면
					%>
							<div class="card">
							    <div class="card-header" id="heading<%=qna.getQnaNo() %>">
							      <h5 class="mb-0">
							        <button class="btn btn-link" data-toggle="collapse" data-target="#<%=qna.getQnaNo() %>" aria-controls="<%=qna.getQnaNo() %>">
							          [<%=qna.getQnaCategory() %>] <%=qna.getQnaTitle() %> - <%=qna.getMemberId() %>
							        </button>
							      </h5>
							    </div>
							
							    <div id="<%=qna.getQnaNo() %>" class="collapse" aria-labelledby="heading<%=qna.getQnaNo() %>" data-parent="#accordion">
							      <div class="card-body">
							      	<p>[질문]</p>
							        <%=qna.getQnaContent() %>
							        <p class="size-10">작성일 : <%=qna.getCreateDate().substring(0,10) %></p>
							        
							        <%
							        	if(qnaComment.getQnaCommentContent()!=null && qnaComment.getQnaCommentContent()!=""){
					        		%>
					        			<br><br><br>
								        <p>[답변]</p>
								        <%=qnaComment.getQnaCommentContent() %>
								        <p class="size-10">답변일 : <%=qnaComment.getCreateDate().substring(0,10) %></p>
					        		<%
							        	}
							        %>
							        <%
										if(loginMember!=null && loginMember.getMemberId().equals(qna.getMemberId())){
										%>
											<table>
												<tr>
													<td>
														<!-- 질문 수정 버튼 -->
														<form action="<%=request.getContextPath() %>/updateQnaForm.jsp" id="updateQnaForm" method="post">
															<input type="hidden" value="<%=qna.getQnaNo() %>" name="qnaNo">
															<button class="btn btn-secondary" type="submit" id="updateBtn">질문수정</button>
														</form>
													</td>
													<td>
														<!-- 질문 삭제 버튼 -->
														<form action="<%=request.getContextPath() %>/deleteQna.jsp" id="deleteQnaForm" method="post">
															<input type="hidden" value="<%=qna.getQnaNo() %>" name="qnaNo">
															<button class="btn btn-danger" type="submit" id="deleteBtn">질문삭제</button>
														</form>
													</td>
												</tr>
											</table>
										<%
										}
									%>
							      </div>
							    </div>
							 </div>
					<%	
					}
				}
			%>
			</td>
			</tr>
		</tbody>
	</table>
	<%
		if(session.getAttribute("loginMember")!=null){
	%>
			<!-- 질문 추가 버튼 -->
			<form action="<%=request.getContextPath() %>/insertQnaForm.jsp" id="insertQnaForm" method="post">
				<button class="btn btn-secondary" type="button" id="insertBtn">새질문</button>
			</form>
	<%
		}
	%>
	
	<br><br>
	
	<!-- 페이지 -->
   <%	
   	   // 페이징을 위해 구해야 할 마지막 페이지 연산
       int lastPage;
   	   int currentnumPage=0; // 현재 페이지가 몇번째 묶음인지(이전,다음 구현을 위함)
   	   int lastnumPage=0; // 마지막 페이지가 몇번째 묶음인지(마지막 페이지에서 다음이 나오지 않도록 하기 위함)
   	   
   	   lastPage = qnaDao.selectQnaListLastPage(ROW_PER_PAGE);
	   
   %>
    <ul class="pagination body-back-color">
    <%
    	if(currentPage!=1){
    %>
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectQnaList.jsp?currentPage=<%=1 %>"><<</a></li>
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
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectQnaList.jsp?currentPage=<%=ROW_PER_PAGE*(currentnumPage-1)+1 %>"><</a></li>
    <%
    	}
    
	    for(int i=0;i<ROW_PER_PAGE;i++){ // 중간 번호들
			if(lastPage>=(ROW_PER_PAGE*currentnumPage)+i+1){
				if(currentPage == (ROW_PER_PAGE*currentnumPage)+i+1){
					%>
						<li class="page-item active"><a class="page-link" href="<%=request.getContextPath() %>/selectQnaList.jsp?currentPage=<%=(ROW_PER_PAGE*currentnumPage)+i+1 %>"><%=(ROW_PER_PAGE*currentnumPage)+i+1 %></a></li>
					<%
				} else{
					%>
			   		  	<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectQnaList.jsp?currentPage=<%=(ROW_PER_PAGE*currentnumPage)+i+1 %>"><%=(ROW_PER_PAGE*currentnumPage)+i+1 %></a></li>
			   		<%	
				}
			}
		}
	    
    	if(lastPage%ROW_PER_PAGE==0){ // 마지막 페이지가 몇번째 묶음인지
    		lastnumPage =(lastPage/ROW_PER_PAGE)-1;
    	} else{
    		lastnumPage = lastPage/ROW_PER_PAGE;
    	}
    	
    	if(lastnumPage>currentnumPage){
    %>
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectQnaList.jsp?currentPage=<%=ROW_PER_PAGE*(currentnumPage+1)+1 %>">></a></li>
    <%
    	}
    	if(currentPage!=lastPage && lastPage!=0){
    %>
    		<li class="page-item"><a class="page-link" href="<%=request.getContextPath() %>/selectQnaList.jsp?currentPage=<%=lastPage %>">>></a></li>
    <%
    	}
    %>
	</ul>
	</div>
	
	<!-- footer -->
	<div>
      <jsp:include page="/partial/footer.jsp"></jsp:include>
   </div>
   
	<script>
		$('#insertBtn').click(function(){
			// 버튼을 클릭하면 질문 생성폼으로 이동
			$('#insertQnaForm').submit();
		});
	</script>
</body>
</html>