<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.io.File" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %> <!-- request 대신 -->
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %> <!-- 파일이름 중복을 피할 수 있도록 -->

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
	// 수정된 공지사항 가져오기(이전사진 포함)
	int noticeNo = Integer.parseInt(mr.getParameter("noticeNo"));
	String beforeImg = mr.getParameter("beforeImg");
	String title = mr.getParameter("title");
	String content = mr.getParameter("content");
	
	String image;
	// 만약 선택한 사진이 없다면 공백을 넣고, 사진이 있다면 그것을 사용한다.
	if(mr.getFilesystemName("image")==null || mr.getFilesystemName("image")==""){
		image = "";
	} else{
		image = mr.getFilesystemName("image");
		
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
	
	// Notice vo에 공지 관련 내용 담기
	Notice notice = new Notice();
	notice.setNotice_title(title);
	notice.setNotice_content(content);
	notice.setMember_no(memberNo);
	notice.setNotice_no(noticeNo);
	notice.setImage(image);
	
	// 공지 DB에 저장
	NoticeDao noticeDao = new NoticeDao();
	noticeDao.updateNotice(notice);
	
	// 수정 후 상세보기로 이동
	response.sendRedirect(request.getContextPath()+"/admin/selectNoticeOne.jsp?noticeNo="+noticeNo);
	return;
%>