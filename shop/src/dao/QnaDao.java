package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import commons.DBUtil;
import vo.*;

public class QnaDao {
	
	// 질문 삭제
	public void deleteQna(int qnaNo) throws ClassNotFoundException, SQLException {
		DBUtil dbUilt = new DBUtil();
		Connection conn = dbUilt.getConnection();
		
		// 질문의 답변 삭제
		String sql1 = "delete from qna_comment where qna_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql1);
		stmt.setInt(1, qnaNo);
		stmt.executeUpdate();
		
		// 주문 삭제
		String sql2 = "delete from qna where qna_no=?";
		stmt = conn.prepareStatement(sql2);
		stmt.setInt(1, qnaNo);
		stmt.executeUpdate();
		
		stmt.close();
		conn.close();
	}
	
	// 질문 생성하기
	public void updateQna(Qna qna) throws ClassNotFoundException, SQLException {
		// DB 연동 및 쿼리실행
		DBUtil dbUilt = new DBUtil();
		Connection conn = dbUilt.getConnection();
		String sql = "UPDATE qna SET qna_category=?, qna_title=?, qna_content=?, qna_secret=?, member_no=? ,update_date=now() WHERE qna_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, qna.getQnaCategory());
		stmt.setString(2, qna.getQnaTitle());
		stmt.setString(3, qna.getQnaContent().replace("\r\n","<br>"));
		stmt.setString(4, qna.getQnaSecret());
		stmt.setInt(5, qna.getMemberNo());
		stmt.setInt(6, qna.getQnaNo());
		System.out.println("질문 수정 stmt : "+stmt);
		stmt.executeUpdate(); // 쿼리 실행
		
		stmt.close();
		conn.close();
	}
	
	// [관리자] 답변이 달리지 않은 질문목록 마지막 페이지 연산
    public int selectQnaListByNoCommentLastPage(int rowPerPage) throws ClassNotFoundException, SQLException {
      DBUtil dbUtil = new DBUtil();
      Connection conn = dbUtil.getConnection();
    
      // 전체 페이지수 구하기
      PreparedStatement stmt;
      String sql = "SELECT COUNT(*)FROM qna q LEFT JOIN qna_comment qc ON q.qna_no = qc.qna_no WHERE qc.qna_no IS NULL";
      stmt = conn.prepareStatement(sql);
      System.out.println("답변이 달리지 않은 질문목록 수 stmt : "+stmt);
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
	
	//[관리자] 답변이 달리지 않은 질문 목록 추출
	public ArrayList<Qna> selectQnaListByNoComment(int beginRow, int rowPerPage) throws ClassNotFoundException, SQLException {
		ArrayList<Qna> list = new ArrayList<>();
		Qna qna = null;
		
		// DB 연동 및 쿼리실행
		DBUtil dbUilt = new DBUtil();
		Connection conn = dbUilt.getConnection();
		String sql = "SELECT q.* FROM (SELECT q.*, m.member_id FROM (SELECT * FROM qna) q INNER JOIN member m ON q.member_no = m.member_no) q LEFT JOIN qna_comment qc ON q.qna_no = qc.qna_no WHERE qc.qna_no IS NULL ORDER BY create_date ASC LIMIT ?,?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		ResultSet rs = stmt.executeQuery();
		System.out.println("답변이 달리지 않은 질문 목록 추출 stmt : "+stmt);
		
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
			qna.setMemberId(rs.getNString("q.member_id"));
			
			list.add(qna);
		}
		
		rs.close();
		stmt.close();
		conn.close();
		
		return list;
	}

	// [관리자] 특정 질문에 답변이 있는지 확인
    public boolean IsQnaComment (int qnaNo) throws ClassNotFoundException, SQLException {
    	boolean is = true;
    	DBUtil dbUtil = new DBUtil();
    	Connection conn = dbUtil.getConnection();
    	PreparedStatement stmt;
    	String sql = "SELECT COUNT(*) FROM (SELECT qna_no FROM qna WHERE qna_no=?)q INNER JOIN qna_comment qc ON q.qna_no = qc.qna_no";
    	stmt = conn.prepareStatement(sql);
    	stmt.setInt(1, qnaNo);
    	System.out.println("질문 답변 유무 확인 stmt : "+stmt);
    	ResultSet rs = stmt.executeQuery();
    	
    	// default는 답변이 이미 달려있는채로 설정(중복 입력 방지)
    	int num=1;
    	if(rs.next()) {
    		num = rs.getInt("count(*)");
    	}
    	
    	// 만약 답변이 존재하지 않는다면 false로 변경
    	if(num==0) {
    		is=false;
    	}
      
    	rs.close();
    	stmt.close();
    	conn.close();
      
    	return is;
   }
	
	// 질문 생성하기
	public void insertQna(Qna qna) throws ClassNotFoundException, SQLException {
		// DB 연동 및 쿼리실행
		DBUtil dbUilt = new DBUtil();
		Connection conn = dbUilt.getConnection();
		String sql = "INSERT INTO qna(qna_category, qna_title, qna_content, qna_secret, member_no, create_date, update_date) VALUE(?,?,?,?,?,NOW(),NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, qna.getQnaCategory());
		stmt.setString(2, qna.getQnaTitle());
		stmt.setString(3, qna.getQnaContent().replace("\r\n","<br>"));
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
    
	// [관리자&고객] 질문 목록 추출
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
	
	// [관리자&고객] 질문과 답변 목록 추출
	public Map<String, Object> selectQnaJoinCommentList(int beginRow, int rowPerPage) throws ClassNotFoundException, SQLException {
		Map<String, Object> result = new HashMap<String, Object>();
		
		ArrayList<Qna> qnaList = new ArrayList<Qna>();
		ArrayList<QnaComment> qnaCommentList = new ArrayList<QnaComment>();
		
		Qna qna = null;
		QnaComment qnaComment = null;
		
		
		// DB 연동 및 쿼리실행
		DBUtil dbUilt = new DBUtil();
		Connection conn = dbUilt.getConnection();
		String sql = "SELECT q.*, m.member_id, qa.qna_comment_content, qa.create_date from (SELECT * FROM qna ORDER BY update_date DESC LIMIT ?,?) q INNER JOIN member m ON q.member_no = m.member_no LEFT JOIN  qna_comment qa ON q.qna_no=qa.qna_no";
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
			
			qnaComment = new QnaComment();
			qnaComment.setQnaCommentContent(rs.getString("qa.qna_comment_content"));
			qnaComment.setCreateDate(rs.getString("qa.create_date"));
			
			qnaList.add(qna);
			qnaCommentList.add(qnaComment);
		}
		
		result.put("qnaList", qnaList);
		result.put("qnaCommentList", qnaCommentList);
		
		rs.close();
		stmt.close();
		conn.close();
		
		return result;
	}
}
