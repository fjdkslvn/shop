<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
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
	// 현재 로그인된 관리자 번호
	int memberNo = loginMember.getMemberNo();
	
	// multipart/form-data로 넘겼기 때문에 request.getParameter()형태 사용불가능
	MultipartRequest mr = new MultipartRequest(request, "C:/Users/fjdks/Desktop/goodee/git-shop/shop/WebContent/image", 1024*1024*1024, "utf-8", new DefaultFileRenamePolicy());
	// 공지 값 받아오기
	String title = mr.getParameter("title");
	String content = mr.getParameter("content");
	String image;
	// 만약 선택한 사진이 없다면 noimage.png를 넣고, 사진이 있다면 그것을 사용한다.
	if(mr.getFilesystemName("image")==null || mr.getFilesystemName("image")==""){
		image = "noimage.png";
	} else{
		image = mr.getFilesystemName("image");
	}
	
	// Notice vo에 공지 관련 내용 담기
	Notice notice = new Notice();
	notice.setNotice_title(title);
	notice.setNotice_content(content);
	notice.setImage(image);
	notice.setMember_no(memberNo);
	
	// 공지 DB에 저장
	NoticeDao noticeDao = new NoticeDao();
	noticeDao.insertNotice(notice);
	
	response.sendRedirect(request.getContextPath()+"/admin/selectNoticeList.jsp");
	return;
%>