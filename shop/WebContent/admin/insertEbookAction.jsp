<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="vo.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %> <!-- request 대신 -->
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
    
<%
	request.setCharacterEncoding("utf-8");
	
	//로그인이 되어있지 않거나 일반 회원이라면 메인화면으로 넘기기
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember==null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// multipart/form-data로 넘겼기 때문에 request.getParameter()형태 사용불가능
	MultipartRequest mr = new MultipartRequest(request, "C:/Users/fjdks/Desktop/goodee/git-shop/shop/WebContent/image", 1024*1024*1024, "utf-8", new DefaultFileRenamePolicy());
	// 값 받아오기
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
	// 만약 선택한 사진이 없다면 noimage.png를 넣고, 사진이 있다면 그것을 사용한다.
	if(mr.getFilesystemName("image")==null || mr.getFilesystemName("image")==""){
		ebookImg = "noimage.png";
	} else{
		ebookImg = mr.getFilesystemName("image");
	}
	
	Ebook ebook = new Ebook();
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
	
	
	EbookDao ebookDao = new EbookDao();
	ebookDao.insertEbook(ebook);
	
	// 전자책 생성 후 전자책 목록으로 이동
	response.sendRedirect(request.getContextPath()+"/admin/selectEbookList.jsp");
	return;
	

%>