package dao;

import java.sql.*;
import java.util.*;

import commons.DBUtil;
import vo.*;

public class OrderCommentDao {
	
	public void updateOrderComment(OrderComment orderComment) throws ClassNotFoundException, SQLException {
		// DB 연동 및 쿼리실행
		DBUtil dbUilt = new DBUtil();
		Connection conn = dbUilt.getConnection();
		String sql = "UPDATE order_comment SET order_comment_content=?, order_score=?, update_date=now() WHERE order_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, orderComment.getOrderCommentContent());
		stmt.setInt(2, orderComment.getOrderScore());
		stmt.setInt(3, orderComment.getOrderNo());
		System.out.println("후기수정 stmt : "+stmt);
		stmt.executeUpdate(); // 쿼리 실행
		
		stmt.close();
		conn.close();
	}
	
	// 후기 불러오기
	public OrderComment selectOrderCommentOne(int orderNo) throws ClassNotFoundException, SQLException {
		OrderComment orderComment = new OrderComment();
		DBUtil dbUtil = new DBUtil();
        Connection conn = dbUtil.getConnection();
        String sql = "select order_score, order_comment_content from order_comment where order_no=?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, orderNo);
        ResultSet rs = stmt.executeQuery();
        if(rs.next()) {
    	    orderComment.setOrderScore(rs.getInt("order_score"));
    	    orderComment.setOrderCommentContent(rs.getString("order_comment_content"));
        }
       
        rs.close();
        stmt.close();
        conn.close();
		return orderComment;
	}
	
	// 주문의 후기를 작성했는지의 여부
	public boolean selectOrderCommentExistence(int orderNo) throws ClassNotFoundException, SQLException{
		boolean existence=true;
		DBUtil dbUtil = new DBUtil();
	     Connection conn = dbUtil.getConnection();
	     PreparedStatement stmt;
		 String sql = "SELECT oc.order_no orderNo FROM (SELECT order_no FROM orders WHERE order_no=?) o left JOIN order_comment oc ON o.order_no=oc.order_no";
		 stmt = conn.prepareStatement(sql);
		 stmt.setInt(1, orderNo);
		 ResultSet rs = stmt.executeQuery();
		 if(rs.next()) {
			 if(rs.getInt("orderNo")==0) {
				 existence=false;
			 }
		 }
	      
	     rs.close();
	     stmt.close();
	     conn.close();
		
		return existence;
	}
	
   // 후기 목록 마지막 페이지 구하기
   public int selectOrderCommentListLastPage(int rowPerPage, int ebookNo) throws ClassNotFoundException, SQLException {
      DBUtil dbUtil = new DBUtil();
      Connection conn = dbUtil.getConnection();
    
      // 전체 페이지수 구하기
      PreparedStatement stmt;
	  String sql = "select count(*) from order_comment WHERE ebook_no=?";
	  stmt = conn.prepareStatement(sql);
	  stmt.setInt(1, ebookNo);
	  System.out.println("전체 후기 수 stmt : "+stmt);
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
	
	// 상품 평점
	public ArrayList<OrderComment> selectOrderComment(int ebookNo, int beginRow, int rowPerPage) throws ClassNotFoundException, SQLException {
		ArrayList<OrderComment> list = new ArrayList<>();
		OrderComment orderComment = new OrderComment();
		DBUtil dbUtil = new DBUtil();
       Connection conn = dbUtil.getConnection();
       String sql = "SELECT order_score, order_comment_content, create_date FROM order_comment WHERE ebook_no=? limit ?,?";
       PreparedStatement stmt = conn.prepareStatement(sql);
       stmt.setInt(1, ebookNo);
       stmt.setInt(2, beginRow);
       stmt.setInt(3, rowPerPage);
       ResultSet rs = stmt.executeQuery();
       if(rs.next()) {
    	   orderComment.setOrderScore(rs.getInt("order_score"));
    	   orderComment.setOrderCommentContent(rs.getString("order_comment_content"));
    	   orderComment.setCreateDate(rs.getString("create_date"));
    	   list.add(orderComment);
       }
       
       rs.close();
       stmt.close();
       conn.close();
		
		return list;
	}
	
	// 상품 평점
	public double selectOrderScoreAvg(int ebookNo) throws ClassNotFoundException, SQLException {
		double avgScore = 0;
		DBUtil dbUtil = new DBUtil();
       Connection conn = dbUtil.getConnection();
       String sql = "SELECT AVG(order_score) FROM order_comment WHERE ebook_no=? GROUP BY ebook_no";
       PreparedStatement stmt = conn.prepareStatement(sql);
       stmt.setInt(1, ebookNo);
       ResultSet rs = stmt.executeQuery();
       if(rs.next()) {
    	   avgScore = rs.getDouble("AVG(order_score)");
       }
       
       rs.close();
       stmt.close();
       conn.close();
		
		return avgScore;
	}
	
	// 주문 후기 작성(테이블에 삽입)
	public void insertOrderComment(OrderComment orderComment) throws ClassNotFoundException, SQLException {
		DBUtil dbUtil = new DBUtil();
       Connection conn = dbUtil.getConnection();
       String sql = "insert into order_comment value(?,?,?,?,now(),now())";
       PreparedStatement stmt = conn.prepareStatement(sql);
       stmt.setInt(1, orderComment.getOrderNo());
       stmt.setInt(2, orderComment.getEbookNo());
       stmt.setInt(3, orderComment.getOrderScore());
       stmt.setString(4, orderComment.getOrderCommentContent());
       stmt.executeUpdate();
       
       stmt.close();
       conn.close();
	}
}
