<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.io.File" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %> <!-- request 대신 -->
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %> <!-- 파일이름 중복을 피할 수 있도록 -->

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>전자책 수정</title>
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
	
	// multipart/form-data로 넘겼기 때문에 request.getParameter()형태 사용불가능
	MultipartRequest mr = new MultipartRequest(request, "C:/Users/fjdks/Desktop/goodee/git-shop/shop/WebContent/image", 1024*1024*1024, "utf-8", new DefaultFileRenamePolicy());
	int ebookNo = Integer.parseInt(mr.getParameter("ebookNo"));
	String beforeImg = mr.getParameter("beforeImg");
	String ebookISBN = mr.getParameter("isbn");
	String ebookCategory = mr.getParameter("category");
	String ebookAuthor = mr.getParameter("author");
	String ebookCompany = mr.getParameter("company");
	int ebookPage = Integer.parseInt(mr.getParameter("page"));
	int ebookPrice = Integer.parseInt(mr.getParameter("price"));
	String ebookSummary = mr.getParameter("content");
	String ebookState = mr.getParameter("state");
	String ebookTitle = mr.getParameter("title");
	
	String ebookImg;
	// 만약 선택한 사진이 없다면 공백을 넣고, 사진이 있다면 그것을 사용한다.
	if(mr.getFilesystemName("image")==null || mr.getFilesystemName("image")==""){
		ebookImg = "";
	} else{
		ebookImg = mr.getFilesystemName("image");
		
		if(!beforeImg.equals("noimage.png")){
			// 이전 사진 삭제
			System.out.println("삭제할 사진 : "+beforeImg);
	        String deleteImgName = "C:/Users/fjdks/Desktop/goodee/git-shop/shop/WebContent/image" +"/"+ beforeImg;
	        File deleteImg = new File (deleteImgName);
	        if (deleteImg.exists() && deleteImg.isFile()){
	        	deleteImg.delete();// 사진 삭제
	        	System.out.println("이전 사진을 삭제함");
	        }
		}
	}
	
	Ebook ebook = new Ebook();
	ebook.setEbookNo(ebookNo);
	ebook.setEbookImg(ebookImg);
	ebook.setEbookISBN(ebookISBN);
	ebook.setEbookTitle(ebookTitle);
	ebook.setEbookAuthor(ebookAuthor);
	ebook.setEbookCompany(ebookCompany);
	ebook.setCategoryName(ebookCategory);
	ebook.setEbookPageCount(ebookPage);
	ebook.setEbookPrice(ebookPrice);
	ebook.setEbookState(ebookState);
	ebook.setEbookSummary(ebookSummary);
	
	// 전자책 수정 업데이트
	EbookDao ebookDao = new EbookDao();
    ebookDao.updateEbook(ebook);
    response.sendRedirect(request.getContextPath()+"/admin/selectEbookOne.jsp?ebookNo="+ebookNo);

	
%>
</body>
</html>