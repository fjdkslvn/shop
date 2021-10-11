package dao;

import java.sql.Connection;
import java.util.*;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import commons.*;
import vo.*;

public class MemberDao {
	
	// [회원] 내정보 수정
	public void updateMyImfo(Member member) throws ClassNotFoundException, SQLException {
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
    
	   // 업데이트하기
       PreparedStatement stmt;
   	   String sql = "update member set member_id=?, member_name=?, member_gender=?, member_age=? where member_no=?";
  	   stmt = conn.prepareStatement(sql);
  	   stmt.setString(1, member.getMemberId());
  	   stmt.setString(2, member.getMemberName());
  	   stmt.setString(3, member.getMemberGender());
  	   stmt.setInt(4, member.getMemberAge());
  	   stmt.setInt(5, member.getMemberNo());
  	   System.out.println("내 정보 수정 stmt : "+stmt);
	   stmt.executeUpdate();
	   
	   stmt.close();
	   conn.close();
	}
	
	// [회원] 멤버 아이디 중복 검사
	public String selectMemberId(String memberIdCheck) throws ClassNotFoundException, SQLException {
		String memberId = null;
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
	    String sql = "select member_id memberId from member where member_id=?";
	    PreparedStatement stmt = conn.prepareStatement(sql);
	    stmt.setString(1, memberIdCheck);
	    ResultSet rs = stmt.executeQuery();
	    if(rs.next()) {
	    	memberId = rs.getString("memberId");
	    }
	    rs.close();
	    stmt.close();
	    conn.close();
	    // null이면 존재하지 않으니 사용가능한 아이디, 반대는 불가능
	    return memberId;
	}
	
	// [관리자] 특정 회원의 회원등급을 수정 , no, 수정된 level
	public void updateMemberLevelByAdmin(Member member) throws ClassNotFoundException, SQLException {
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
    
	   // 업데이트하기
       PreparedStatement stmt;
   	   String sql = "update member set member_level=? where member_no=?";
  	   stmt = conn.prepareStatement(sql);
  	   stmt.setInt(1, member.getMemberLevel());
  	   stmt.setInt(2, member.getMemberNo());
  	   System.out.println("특정 멤버 등급 수정 stmt : "+stmt);
	   stmt.executeUpdate();
	   
	   stmt.close();
	   conn.close();
	}
	
	// [관리자] 특정 회원의 비밀번호를 수정 ,no, 수정된pw
	public void updateMemberPwByAdmin(Member member) throws ClassNotFoundException, SQLException {
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
    
	   // 업데이트하기
       PreparedStatement stmt;
   	   String sql = "update member set member_pw=PASSWORD(?) where member_no=?";
  	   stmt = conn.prepareStatement(sql);
  	   stmt.setString(1, member.getMemberPw());
  	   stmt.setInt(2, member.getMemberNo());
  	   System.out.println("특정 멤버 비밀번호 수정 stmt : "+stmt);
	   stmt.executeUpdate();
	   
	   stmt.close();
	   conn.close();
	}
	
	// [관리자&회원] 특정 회원 탈퇴
	public void deleteMemberByAdmin(int memberNo) throws ClassNotFoundException, SQLException {
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
    
	   // 회원을 삭제하기
       PreparedStatement stmt;
       String sql1 = "delete oc from orders o INNER JOIN order_comment oc on o.order_no=oc.order_no WHERE o.member_no=?";
       stmt = conn.prepareStatement(sql1);
  	   stmt.setInt(1, memberNo);
  	   System.out.println("특정 멤버의 주문 후기 삭제 stmt : "+stmt);
	   stmt.executeUpdate();
	   
	   String sql2 = "delete qc FROM qna q INNER JOIN qna_comment qc on q.qna_no=qc.qna_no WHERE q.member_no=?";
       stmt = conn.prepareStatement(sql2);
  	   stmt.setInt(1, memberNo);
  	   System.out.println("특정 멤버의 질문 답변 삭제 stmt : "+stmt);
	   stmt.executeUpdate();
	   
	   String sql3 = "delete FROM qna WHERE member_no=?";
       stmt = conn.prepareStatement(sql3);
  	   stmt.setInt(1, memberNo);
  	   System.out.println("특정 멤버의 질문 삭제 stmt : "+stmt);
	   stmt.executeUpdate();
	   
       String sql4 = "delete from member where member_no=?";
  	   stmt = conn.prepareStatement(sql4);
  	   stmt.setInt(1, memberNo);
  	   System.out.println("특정 멤버 삭제 stmt : "+stmt);
	   stmt.executeUpdate();
	   
	   stmt.close();
	   conn.close();
	}
	
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
	
	// 특정회원 1명 값 받아오기
	public Member selectMemberOne(int memberNo) throws ClassNotFoundException, SQLException {
		Member returnMember = new Member();
		
		// mariaDB 연동
		DBUtil dbUilt = new DBUtil();
		Connection conn = dbUilt.getConnection();
		String sql = "select member_no memberNo, member_id memberId, member_level memberLevel, member_name memberName, member_age memberAge, member_gender memberGender, update_date updateDate, create_date createDate from member where member_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, memberNo);
		System.out.println("특정회원 정보 조회 stmt : "+stmt);
		ResultSet rs = stmt.executeQuery();
		
		// 각 멤버의 정보를 리스트에 담는다
		while(rs.next()) {
			returnMember.setMemberNo(Integer.parseInt(rs.getString("memberNo")));
			returnMember.setMemberId(rs.getString("memberId"));
			returnMember.setMemberLevel(Integer.parseInt(rs.getString("memberLevel")));
			returnMember.setMemberName(rs.getString("memberName"));
			returnMember.setMemberAge(Integer.parseInt(rs.getString("memberAge")));
			returnMember.setMemberGender(rs.getString("memberGender"));
			returnMember.setUpdateDate(rs.getString("updateDate"));
			returnMember.setCreateDate(rs.getString("createDate"));
		}
		
		rs.close();
		stmt.close();
		conn.close();
				
		return returnMember;
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
		String sql = "insert into member(member_id, member_pw, member_level, member_name, member_age, member_gender, update_date, create_date) VALUES (?,PASSWORD(?),0,?,?,?,now(),NOW())";
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
			System.out.println("로그인 유저 비밀번호 :"+member.getMemberPw());
			System.out.println("로그인 유저 등급 :"+Integer.parseInt(rs.getString("memberLevel")));
			returnMember.setMemberNo(Integer.parseInt(rs.getString("memberNo")));
			returnMember.setMemberId(rs.getString("memberId"));
			returnMember.setMemberLevel(Integer.parseInt(rs.getString("memberLevel")));
			returnMember.setMemberPw(member.getMemberPw());
			
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
