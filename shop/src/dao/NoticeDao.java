package dao;

import java.sql.*;
import commons.DBUtil;
import vo.*;
import java.util.*;

public class NoticeDao {
	
	// [관리자&고객]최근 공지 5개 보이기
	public ArrayList<Notice> selectRecentNoticeList() throws ClassNotFoundException, SQLException {
		ArrayList<Notice> list = new ArrayList<>();
		Notice notice = null;
		
		// DB 연동 및 쿼리실행
		DBUtil dbUilt = new DBUtil();
		Connection conn = dbUilt.getConnection();
		String sql = "SELECT n.*, m.member_name FROM notice n INNER JOIN member m ON n.member_no = m.member_no  ORDER BY n.update_date DESC limit 0,5";
		PreparedStatement stmt = conn.prepareStatement(sql);
		ResultSet rs = stmt.executeQuery();
		System.out.println("최근 공지 목록 추출 stmt : "+stmt);
		
		while(rs.next()) {
			notice = new Notice();
			notice.setNotice_no(rs.getInt("n.notice_no"));
			notice.setNotice_title(rs.getString("n.notice_title"));
			notice.setMember_no(rs.getInt("n.member_no"));
			notice.setNotice_content(rs.getString("n.notice_content"));
			notice.setCreate_date(rs.getString("n.create_date"));
			notice.setUpdate_date(rs.getString("n.update_date"));
			notice.setMember_name(rs.getString("m.member_name"));
			list.add(notice);
		}
		
		rs.close();
		stmt.close();
		conn.close();
		
		return list;
	}
	
	//[관리자] 공지 삭제하기
	public void deleteNotice(int noticeNo) throws ClassNotFoundException, SQLException {
		// DB 연동 및 쿼리실행
		DBUtil dbUilt = new DBUtil();
		Connection conn = dbUilt.getConnection();
		String sql = "DELETE FROM notice WHERE notice_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, noticeNo);
		System.out.println("공지삭제 stmt : "+stmt);
		stmt.executeUpdate(); // 쿼리 실행
		
		stmt.close();
		conn.close();
	}
	
	//[관리자] 공지 수정하기
	public void updateNotice(Notice notice) throws ClassNotFoundException, SQLException {
		// DB 연동 및 쿼리실행
		DBUtil dbUilt = new DBUtil();
		Connection conn = dbUilt.getConnection();
		String sql = "UPDATE notice SET notice_title=?, notice_content=?, member_no=?, update_date=now() WHERE notice_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, notice.getNotice_title());
		stmt.setString(2, notice.getNotice_content().replace("\r\n","<br>"));
		stmt.setInt(3, notice.getMember_no());
		stmt.setInt(4, notice.getNotice_no());
		System.out.println("공지수정 stmt : "+stmt);
		stmt.executeUpdate(); // 쿼리 실행
		
		stmt.close();
		conn.close();
	}
	
	//[관리자] 공지 상세보기
	public Notice selectNoticeOne(int noticeNo) throws ClassNotFoundException, SQLException {
		Notice notice = new Notice();
		
		DBUtil dbUilt = new DBUtil();
		Connection conn = dbUilt.getConnection();
		String sql = "SELECT n.*, m.member_name FROM (SELECT * FROM notice WHERE notice_no=?) n INNER JOIN member m ON n.member_no = m.member_no";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, noticeNo);
		System.out.println("공지 상세보기 stmt : "+stmt);
		ResultSet rs = stmt.executeQuery(); // 쿼리 실행
		if(rs.next()) {
			notice.setNotice_no(rs.getInt("n.notice_no"));
			notice.setNotice_title(rs.getString("n.notice_title"));
			notice.setNotice_content(rs.getString("n.notice_content"));
			notice.setMember_name(rs.getString("m.member_name"));
			notice.setMember_no(rs.getInt("n.member_no"));
			notice.setCreate_date(rs.getString("n.create_date"));
			notice.setUpdate_date(rs.getString("n.update_date"));
		}
		
		rs.close();
		stmt.close();
		conn.close();
		
		return notice;
	}
	
	// [관리자] 공지 생성하기
	public void insertNotice(Notice notice) throws ClassNotFoundException, SQLException {
		// DB 연동 및 쿼리실행
		DBUtil dbUilt = new DBUtil();
		Connection conn = dbUilt.getConnection();
		String sql = "INSERT INTO notice(notice_title, notice_content, member_no, create_date, update_date) VALUE(?,?,?,NOW(),NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, notice.getNotice_title());
		stmt.setString(2, notice.getNotice_content().replace("\r\n","<br>"));
		stmt.setInt(3, notice.getMember_no());
		System.out.println("공지생성 stmt : "+stmt);
		stmt.executeUpdate(); // 쿼리 실행
		
		stmt.close();
		conn.close();
	}
	
	// [관리자&고객] 공지사항 마지막 페이지 연산
    public int selectNoticeListLastPage(int rowPerPage) throws ClassNotFoundException, SQLException {
      DBUtil dbUtil = new DBUtil();
      Connection conn = dbUtil.getConnection();
    
      // 전체 페이지수 구하기
      PreparedStatement stmt;
      String sql = "select count(*) from notice";
      stmt = conn.prepareStatement(sql);
      System.out.println("전체 공지사항 수 stmt : "+stmt);
      ResultSet rs = stmt.executeQuery();
      rs.next();
      int totalData = rs.getInt("count(*)");
      int lastPage= totalData/rowPerPage; // 마지막 페이지 번호
      if(totalData%rowPerPage!=0){
         lastPage +=1;
      }
      
      rs.close();
      stmt.close();
      conn.close();
      
      return lastPage;
   }
	
	// [관리자&고객] 공지사항 목록 추출
	public ArrayList<Notice> selectNoticeList(int beginRow, int rowPerPage) throws ClassNotFoundException, SQLException {
		ArrayList<Notice> list = new ArrayList<>();
		Notice notice = null;
		
		// DB 연동 및 쿼리실행
		DBUtil dbUilt = new DBUtil();
		Connection conn = dbUilt.getConnection();
		String sql = "SELECT n.*, m.member_name FROM notice n INNER JOIN member m ON n.member_no = m.member_no  ORDER BY n.update_date DESC limit ?,?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		System.out.println("공지 목록 추출 stmt : "+stmt);
		
		while(rs.next()) {
			notice = new Notice();
			notice.setNotice_no(rs.getInt("n.notice_no"));
			notice.setNotice_title(rs.getString("n.notice_title"));
			notice.setMember_no(rs.getInt("n.member_no"));
			notice.setNotice_content(rs.getString("n.notice_content"));
			notice.setCreate_date(rs.getString("n.create_date"));
			notice.setUpdate_date(rs.getString("n.update_date"));
			notice.setMember_name(rs.getString("m.member_name"));
			list.add(notice);
		}
		
		rs.close();
		stmt.close();
		conn.close();
		
		return list;
	}

}
