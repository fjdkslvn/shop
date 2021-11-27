package dao;

import vo.*;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

import commons.DBUtil;

public class OrderDao {
	
	// 주문 취소
	public void deleteOrder(int orderNo) throws ClassNotFoundException, SQLException {
		DBUtil dbUilt = new DBUtil();
		Connection conn = dbUilt.getConnection();
		
		// 주문의 후기 삭제
		String sql1 = "delete from order_comment where order_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql1);
		stmt.setInt(1, orderNo);
		stmt.executeUpdate();
		
		// 주문 삭제
		String sql2 = "delete from orders where order_no=?";
		stmt = conn.prepareStatement(sql2);
		stmt.setInt(1, orderNo);
		stmt.executeUpdate();
		
		stmt.close();
		conn.close();
	}
	
	// 주문 상세보기
	public OrderEbookMember selectOrderOne(int orderNo) throws ClassNotFoundException, SQLException {
		OrderEbookMember oem = new OrderEbookMember();
		DBUtil dbUilt = new DBUtil();
		Connection conn = dbUilt.getConnection();
		String sql = "select o.order_no orderNo, e.ebook_no ebookNo, e.ebook_title ebookTitle, m.member_no memberNo, m.member_id memberId, o.order_price orderPrice, o.create_date createDate, o.update_date updateDate FROM (SELECT * FROM orders WHERE order_no=?) o inner join ebook e inner join member m on o.ebook_no = e.ebook_no and o.member_no = m.member_no";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, orderNo);
		System.out.println("주문 상세보기 stmt : "+stmt);
		ResultSet rs = stmt.executeQuery(); // 쿼리 실행
		if(rs.next()) {
          Order o = new Order();
          o.setOrderNo(rs.getInt("orderNo"));
          o.setOrderPrice(rs.getInt("orderPrice"));
          o.setCreateDate(rs.getNString("createDate"));
          o.setUpdateDate(rs.getNString("updateDate"));
          oem.setOrder(o);
          
          Ebook e = new Ebook();
          e.setEbookNo(rs.getInt("ebookNo"));
          e.setEbookTitle(rs.getString("ebookTitle"));
          oem.setEbook(e);
          
          Member m = new Member();
          m.setMemberNo(rs.getInt("memberNo"));
          m.setMemberId(rs.getString("memberId"));
          oem.setMember(m);
		}
		
		rs.close();
		stmt.close();
		conn.close();
		return oem;
	}
	
	// [관리자] 주문목록 마지막 페이지 구하기
	public int selectOrderListLastPage(int rowPerPage) throws ClassNotFoundException, SQLException {
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
    
	   // 전체 페이지수 구하기
       PreparedStatement stmt;
   	   String sql = "select COUNT(*) from orders o inner join ebook e inner join member m on o.ebook_no = e.ebook_no and o.member_no = m.member_no";
  	   stmt = conn.prepareStatement(sql);
  	   System.out.println("전체 주문수 stmt : "+stmt);
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
	   System.out.println("주문목록 개수"+totalData);
	   System.out.println("마지막페이지"+lastPage);
	   
	   return lastPage;
	}
	
	// 전자책 주문 존재 여부
	public boolean orderExistence(int memberNo, int ebookNo) throws ClassNotFoundException, SQLException {
		boolean existence = true;
		DBUtil dbUtil = new DBUtil();
        Connection conn = dbUtil.getConnection();
        String sql = "SELECT order_no from orders where member_no=? and ebook_no=?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, memberNo);
        stmt.setInt(2, ebookNo);
        System.out.println("전자책 보유 여부 stmt:"+stmt);
        ResultSet rs = stmt.executeQuery();
        
        if(!rs.next()) {
        	// 만약 해당 전자책을 주문한적이 없다면 존재여부를 false로 한다.
        	existence = false;
        }
       
        rs.close();
        stmt.close();
        conn.close();
        
		return existence;
	}
	
	// 주문 하기(테이블에 삽입)
	public void insertOrder(Order order) throws ClassNotFoundException, SQLException {
		DBUtil dbUtil = new DBUtil();
        Connection conn = dbUtil.getConnection();
        String sql = "insert into orders(ebook_no, member_no, order_price, create_date, update_date) VALUE(?,?,?,now(),NOW())";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, order.getEbookNo());
        stmt.setInt(2, order.getMemberNo());
        stmt.setInt(3, order.getOrderPrice());
        stmt.executeUpdate();
       
        stmt.close();
        conn.close();
	}
	
	// 본인의 주문목록 마지막 페이지 구하기
	public int selectOrderListByMemberLastPage(int rowPerPage, int memberNo) throws ClassNotFoundException, SQLException {
		DBUtil dbUtil = new DBUtil();
	    Connection conn = dbUtil.getConnection();
    
	   // 전체 페이지수 구하기
       PreparedStatement stmt;
   	   String sql = "select COUNT(*) from orders o inner join ebook e inner join member m on o.ebook_no = e.ebook_no and o.member_no = m.member_no where m.member_no=?";
  	   stmt = conn.prepareStatement(sql);
  	   stmt.setInt(1, memberNo);
  	   System.out.println("나의 전체 주문수 stmt : "+stmt);
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
	   System.out.println("주문목록 개수"+totalData);
	   System.out.println("마지막페이지"+lastPage);
	   
	   return lastPage;
	}
	
	// 나의 주문 리스트 출력
    public ArrayList<OrderEbookMember> selectOrderListByMember(int memberNo, int beginRow, int rowPerPage) throws ClassNotFoundException, SQLException{
      ArrayList<OrderEbookMember> list = new ArrayList<>();
      DBUtil dbUtil = new DBUtil();
       Connection conn = dbUtil.getConnection();
       String sql = "select o.order_no orderNo, e.ebook_no ebookNo, e.ebook_title ebookTitle, o.order_price orderPrice, o.create_date createDate from orders o inner join ebook e inner join member m on o.ebook_no = e.ebook_no and o.member_no = m.member_no where m.member_no=? order by o.create_date DESC LIMIT ?,?";
       PreparedStatement stmt = conn.prepareStatement(sql);
       stmt.setInt(1, memberNo);
       stmt.setInt(2, beginRow);
       stmt.setInt(3, rowPerPage);
       ResultSet rs = stmt.executeQuery();
       while(rs.next()) {
          OrderEbookMember oem = new OrderEbookMember();
          Order o = new Order();
          o.setOrderNo(rs.getInt("orderNo"));
          o.setOrderPrice(rs.getInt("orderPrice"));
          o.setCreateDate(rs.getNString("createDate"));
          oem.setOrder(o);
          
          Ebook e = new Ebook();
          e.setEbookNo(rs.getInt("ebookNo"));
          e.setEbookTitle(rs.getString("ebookTitle"));
          oem.setEbook(e);
          
          list.add(oem);
       }
       
       rs.close();
       stmt.close();
       conn.close();
       
       return list;
   }
   
    // 주문 리스트 출력
   public ArrayList<OrderEbookMember> selectOrderList(int beginRow, int rowPerPage) throws ClassNotFoundException, SQLException{
       ArrayList<OrderEbookMember> list = new ArrayList<>();
       String memberId = null;
       DBUtil dbUtil = new DBUtil();
       Connection conn = dbUtil.getConnection();
       String sql = "select o.order_no orderNo, e.ebook_no ebookNo, e.ebook_title ebookTitle, m.member_no memberNo, m.member_id memberId, o.order_price orderPrice, o.create_date createDate from orders o inner join ebook e inner join member m on o.ebook_no = e.ebook_no and o.member_no = m.member_no order by o.create_date DESC limit ?,?";
       PreparedStatement stmt = conn.prepareStatement(sql);
       stmt.setInt(1, beginRow);
       stmt.setInt(2,rowPerPage);
       ResultSet rs = stmt.executeQuery();
       while(rs.next()) {
          OrderEbookMember oem = new OrderEbookMember();
          Order o = new Order();
          o.setOrderNo(rs.getInt("orderNo"));
          o.setOrderPrice(rs.getInt("orderPrice"));
          o.setCreateDate(rs.getNString("createDate"));
          oem.setOrder(o);
          
          Ebook e = new Ebook();
          e.setEbookNo(rs.getInt("ebookNo"));
          e.setEbookTitle(rs.getString("ebookTitle"));
          oem.setEbook(e);
          
          Member m = new Member();
          m.setMemberNo(rs.getInt("memberNo"));
          m.setMemberId(rs.getString("memberId"));
          oem.setMember(m);
          
          list.add(oem);
       }
       
       rs.close();
       stmt.close();
       conn.close();
       
       return list;
   }

}