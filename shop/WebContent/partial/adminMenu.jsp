<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 부트스트랩 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
   
<div>
   <nav class="navbar navbar-expand-sm bg-light">
      <ul class="navbar-nav">
      	<li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/admin/adminindex.jsp">[관리자 메인]</a></li>
         <!-- 회원 관리 : 목록, 수정(등급,비밀번호), 강제탈퇴 -->
         <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/admin/selectMemberList.jsp">[회원 관리]</a></li>
         <!--
            전자책 카테고리 관리 : 목록, 추가, 사용유무 수정
            0) Category.Class (완료)
            1) CategoryDao.class (완료)
            2) selectCategoryList.jsp (완료)
            3) insertCategoryForm.jsp
            4) insertCategoryAction.jsp
            5) selectCategoryNameCheckAction.jsp
            6) updateCategoryStateAction.jsp (완료)
         -->
         <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/admin/selectCategoryList.jsp">[전자책 카테고리 관리]</a></li>
         <!-- 전자책 관리 : 목록, 추가(이미지 추가), 수정, 삭제 -->
         <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/admin/selectEbookList.jsp">[전자책 관리]</a></li>
         <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/admin/selectOrderList.jsp">[주문 관리]</a></li>
         <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/admin/">[상품평 관리]</a></li>
         <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/admin/">[공지게시판 관리]</a></li>
         <li class="nav-item"><a class="nav-link" href="<%=request.getContextPath() %>/admin/">[QnA게시판 관리]</a></li>
      </ul>
   </nav>
</div>