package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import commons.DBUtil;
import vo.*;

public class QnaCommentDao {
	
	// 질문 답변 삭제
	public void deleteQnaComment(int qnaNo) throws ClassNotFoundException, SQLException {
		DBUtil dbUilt = new DBUtil();
		Connection conn = dbUilt.getConnection();
		
		// 질문의 답변 삭제
		String sql = "delete from qna_comment where qna_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, qnaNo);
		stmt.executeUpdate();
		
		stmt.close();
		conn.close();
	}
	
	// 질문 답변 생성하기
		public void updateqnaComment(QnaComment qnaComment) throws ClassNotFoundException, SQLException {
			// DB 연동 및 쿼리실행
			DBUtil dbUilt = new DBUtil();
			Connection conn = dbUilt.getConnection();
			String sql = "UPDATE qna_comment SET qna_comment_content=?, member_no=? ,update_date=now() WHERE qna_no=?";
			PreparedStatement stmt = conn.prepareStatement(sql);
			stmt.setString(1, qnaComment.getQnaCommentContent().replace("\r\n","<br>"));
			stmt.setInt(2, qnaComment.getMemberNo());
			stmt.setInt(3, qnaComment.getQnaNo());
			System.out.println("질문 답변 수정 stmt : "+stmt);
			stmt.executeUpdate(); // 쿼리 실행
			
			stmt.close();
			conn.close();
		}
	
	// 질문 답변 생성하기
	public void insertqnaComment(QnaComment qnaComment) throws ClassNotFoundException, SQLException {
		// DB 연동 및 쿼리실행
		DBUtil dbUilt = new DBUtil();
		Connection conn = dbUilt.getConnection();
		String sql = "INSERT INTO qna_comment VALUE(?,?,?,now(),now())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, qnaComment.getQnaNo());
		stmt.setString(2, qnaComment.getQnaCommentContent().replace("\r\n","<br>"));
		stmt.setInt(3, qnaComment.getMemberNo());
		System.out.println("질문 답변 생성 stmt : "+stmt);
		stmt.executeUpdate(); // 쿼리 실행
		
		stmt.close();
		conn.close();
	}

	//[관리자&회원] 질문 답변 상세보기
	public QnaComment selectQnaCommentOne(int qnaNo) throws ClassNotFoundException, SQLException {
		QnaComment qc = new QnaComment();
		
		DBUtil dbUilt = new DBUtil();
		Connection conn = dbUilt.getConnection();
		String sql = "SELECT * FROM qna_comment WHERE qna_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, qnaNo);
		System.out.println("질문 상세보기 stmt : "+stmt);
		ResultSet rs = stmt.executeQuery(); // 쿼리 실행
		if(rs.next()) {
			qc.setQnaCommentContent(rs.getString("qna_comment_content"));
			qc.setMemberNo(rs.getInt("member_no"));
			qc.setCreateDate(rs.getString("create_date"));
			qc.setUpdateDate(rs.getString("update_date"));
		}
		
		rs.close();
		stmt.close();
		conn.close();
		
		return qc;
	}
}
