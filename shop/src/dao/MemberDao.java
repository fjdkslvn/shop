package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import commons.*;
import vo.*;

public class MemberDao {
	public void insertMember(Member member) throws ClassNotFoundException, SQLException {
		// DB 연동 및 쿼리실행
		DBUtil dbUilt = new DBUtil();
		Connection conn = dbUilt.getConnection();
		String sql = "insert into member(member_id, member_pw, member_level, member_name, member_age, member_gender, update_date, create_date) VALUES (?,?,0,?,?,?,now(),NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, member.getMemberId());
		stmt.setString(2, member.getMemberPw());
		stmt.setString(3, member.getMemberName());
		stmt.setInt(4, member.getMemberAge());
		stmt.setString(5, member.getMemberGender());
		System.out.println("회원가입 stmt : "+stmt);
		stmt.executeUpdate(); // 쿼리 실행
		
		stmt.close();
		conn.close();
	}
	
	// 로그인 후 회원정보 가져오기
	public Member login(Member member) throws ClassNotFoundException, SQLException {
		Member returnMember = new Member();
		
		// DB 연동 및 쿼리 실행
		DBUtil dbUilt = new DBUtil();
		Connection conn = dbUilt.getConnection();
		String sql = "select member_no memberNo, member_id memberId, member_level memberLevel FROM member WHERE member_id=? AND member_pw=PASSWORD(?)";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, member.getMemberId());
		stmt.setString(2, member.getMemberPw());
		System.out.println("로그인 stmt :"+stmt);
		ResultSet rs = stmt.executeQuery();
		
		// 로그인 성공시 아이디와 이름을 return
		if(rs.next()) {
			System.out.println("로그인 유저 멤버번호 :"+Integer.parseInt(rs.getString("memberNo")));
			System.out.println("로그인 유저 아이디 :"+rs.getString("memberId"));
			System.out.println("로그인 유저 등급 :"+Integer.parseInt(rs.getString("memberLevel")));
			returnMember.setMemberNo(Integer.parseInt(rs.getString("memberNo")));
			returnMember.setMemberId(rs.getString("memberId"));
			returnMember.setMemberLevel(Integer.parseInt(rs.getString("memberLevel")));
			
			rs.close();
			stmt.close();
			conn.close();
			
			return returnMember;
		}
		
		// 로그인 실패시 리턴값 null
		rs.close();
		stmt.close();
		conn.close();
		
		return returnMember;
	}

}
