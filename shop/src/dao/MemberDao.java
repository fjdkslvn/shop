package dao;

import java.sql.Connection;
import java.util.*;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import commons.*;
import vo.*;

public class MemberDao {
	
	// [관리자] 회원목록출력 마지막 페이지 연산(특정회원)
		public int selectMemberListSearchLastPage(int rowPerPage, String searchMemberId) throws ClassNotFoundException, SQLException {
			DBUtil dbUtil = new DBUtil();
		    Connection conn = dbUtil.getConnection();
	    
		   // 전체 페이지수 구하기
	       PreparedStatement stmt;
	   	   String sql = "select count(*) from member where member_id like ?";
	  	   stmt = conn.prepareStatement(sql);
	  	   stmt.setString(1, "%"+searchMemberId+"%");
	  	   System.out.println("특정 회원수 stmt : "+stmt);
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
	
	// [관리자] 회원목록출력 마지막 페이지 연산
	public int selectMemberListLastPage(int rowPerPage) throws ClassNotFoundException, SQLException {
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
    
	   // 전체 페이지수 구하기
       PreparedStatement stmt;
   	   String sql = "select count(*) from member";
  	   stmt = conn.prepareStatement(sql);
  	   System.out.println("전체 회원수 stmt : "+stmt);
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
	
	// [관리자] 회원목록출력(특정 회원)
	public ArrayList<Member> selectMemberListAllBySearchMemberId(int beginRow, int rowPerPage, String searchMemberId) throws ClassNotFoundException, SQLException {
		ArrayList<Member> list = new ArrayList<Member>();
		
		// mariaDB 연동
		DBUtil dbUilt = new DBUtil();
		Connection conn = dbUilt.getConnection();
		String sql = "select member_no memberNo, member_id memberId, member_level memberLevel, member_name memberName, member_age memberAge, member_gender memberGender, update_date updateDate, create_date createDate from member where member_id like ? order by member_level desc limit ?,?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+searchMemberId+"%");
		stmt.setInt(2, beginRow);
		stmt.setInt(3, rowPerPage);
		System.out.println("회원목록 출력 stmt : "+stmt);
		ResultSet rs = stmt.executeQuery();
		
		// 각 멤버의 정보를 리스트에 담는다
		while(rs.next()) {
			Member member = new Member();
			member.setMemberNo(Integer.parseInt(rs.getString("memberNo")));
			member.setMemberId(rs.getString("memberId"));
			member.setMemberLevel(Integer.parseInt(rs.getString("memberLevel")));
			member.setMemberName(rs.getString("memberName"));
			member.setMemberAge(Integer.parseInt(rs.getString("memberAge")));
			member.setMemberGender(rs.getString("memberGender"));
			member.setUpdateDate(rs.getString("updateDate"));
			member.setCreateDate(rs.getString("createDate"));
			
			list.add(member);
		}
		rs.close();
		stmt.close();
		conn.close();
				
		return list;
	}
	
	// [관리자] 회원목록출력
	public ArrayList<Member> selectMemberListAllByPage(int beginRow, int rowPerPage) throws ClassNotFoundException, SQLException {
		ArrayList<Member> list = new ArrayList<Member>();
		
		// mariaDB 연동
		DBUtil dbUilt = new DBUtil();
		Connection conn = dbUilt.getConnection();
		String sql = "select member_no memberNo, member_id memberId, member_level memberLevel, member_name memberName, member_age memberAge, member_gender memberGender, update_date updateDate, create_date createDate from member order by member_level desc limit ?,?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		System.out.println("회원목록 출력 stmt : "+stmt);
		ResultSet rs = stmt.executeQuery();
		
		// 각 멤버의 정보를 리스트에 담는다
		while(rs.next()) {
			Member member = new Member();
			member.setMemberNo(Integer.parseInt(rs.getString("memberNo")));
			member.setMemberId(rs.getString("memberId"));
			member.setMemberLevel(Integer.parseInt(rs.getString("memberLevel")));
			member.setMemberName(rs.getString("memberName"));
			member.setMemberAge(Integer.parseInt(rs.getString("memberAge")));
			member.setMemberGender(rs.getString("memberGender"));
			member.setUpdateDate(rs.getString("updateDate"));
			member.setCreateDate(rs.getString("createDate"));
			
			list.add(member);
		}
		rs.close();
		stmt.close();
		conn.close();
				
		return list;
	}
	
	// 회원가입
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
		
		// 로그인 성공시 유저정보를 return
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
		
		return null;
	}

}
