package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import commons.DBUtil;
import vo.*;

public class QnaDao {
	
	// [관리자] 공지 생성하기
	public void insertQna(Qna qna) throws ClassNotFoundException, SQLException {
		// DB 연동 및 쿼리실행
		DBUtil dbUilt = new DBUtil();
		Connection conn = dbUilt.getConnection();
		String sql = "INSERT INTO qna(qna_category, qna_title, qna_content, qna_secret, member_no, create_date, update_date) VALUE(?,?,?,?,?,NOW(),NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, qna.getQnaCategory());
		stmt.setString(2, qna.getQnaTitle());
		stmt.setString(3, qna.getQnaContent());
		stmt.setString(4, qna.getQnaSecret());
		stmt.setInt(5, qna.getMemberNo());
		System.out.println("질문생성 stmt : "+stmt);
		stmt.executeUpdate(); // 쿼리 실행
		
		stmt.close();
		conn.close();
	}
	
	//[관리자&회원] 질문 상세보기
	public Qna selectQnaOne(int qnaNo) throws ClassNotFoundException, SQLException {
		Qna qna = new Qna();
		
		DBUtil dbUilt = new DBUtil();
		Connection conn = dbUilt.getConnection();
		String sql = "SELECT q.*, m.member_id FROM (SELECT * FROM qna WHERE qna_no=?) q INNER JOIN member m ON q.member_no = m.member_no";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, qnaNo);
		System.out.println("질문 상세보기 stmt : "+stmt);
		ResultSet rs = stmt.executeQuery(); // 쿼리 실행
		if(rs.next()) {
			qna.setQnaNo(rs.getInt("q.qna_no"));
			qna.setQnaTitle(rs.getString("q.qna_title"));
			qna.setQnaContent(rs.getString("q.qna_content"));
			qna.setQnaCategory(rs.getString("q.qna_category"));
			qna.setQnaSecret(rs.getString("q.qna_secret"));
			qna.setMemberNo(rs.getInt("q.member_no"));
			qna.setCreateDate(rs.getString("q.create_date"));
			qna.setUpdateDate(rs.getString("q.update_date"));
			qna.setMemberId(rs.getNString("m.member_id"));
		}
		
		rs.close();
		stmt.close();
		conn.close();
		
		return qna;
	}
	
	// [관리자&고객] 질문목록 마지막 페이지 연산
    public int selectQnaListLastPage(int rowPerPage) throws ClassNotFoundException, SQLException {
      DBUtil dbUtil = new DBUtil();
      Connection conn = dbUtil.getConnection();
    
      // 전체 페이지수 구하기
      PreparedStatement stmt;
      String sql = "select count(*) from qna";
      stmt = conn.prepareStatement(sql);
      System.out.println("전체 질문목록 수 stmt : "+stmt);
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
	public ArrayList<Qna> selectQnaList(int beginRow, int rowPerPage) throws ClassNotFoundException, SQLException {
		ArrayList<Qna> list = new ArrayList<>();
		Qna qna = null;
		
		// DB 연동 및 쿼리실행
		DBUtil dbUilt = new DBUtil();
		Connection conn = dbUilt.getConnection();
		String sql = "SELECT q.*, m.member_id FROM qna q INNER JOIN member m ON q.member_no = m.member_no  ORDER BY q.update_date DESC limit ?,?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		System.out.println("질문 목록 추출 stmt : "+stmt);
		
		while(rs.next()) {
			qna = new Qna();
			qna.setQnaNo(rs.getInt("q.qna_no"));
			qna.setQnaTitle(rs.getString("q.qna_title"));
			qna.setQnaContent(rs.getString("q.qna_content"));
			qna.setQnaCategory(rs.getString("q.qna_category"));
			qna.setQnaSecret(rs.getString("q.qna_secret"));
			qna.setMemberNo(rs.getInt("q.member_no"));
			qna.setCreateDate(rs.getString("q.create_date"));
			qna.setUpdateDate(rs.getString("q.update_date"));
			qna.setMemberId(rs.getNString("m.member_id"));
			
			list.add(qna);
		}
		
		rs.close();
		stmt.close();
		conn.close();
		
		return list;
	}
}
