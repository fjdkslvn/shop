package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

import commons.DBUtil;
import vo.Category;
import vo.Ebook;

public class EbookDao {
	
	// [관리자] 전자책 생성
	public void insertEbook(Ebook ebook) throws ClassNotFoundException, SQLException {
		DBUtil dbUtil = new DBUtil();
        Connection conn = dbUtil.getConnection();
        String sql = "insert into ebook(ebook_ISBN, category_name, ebook_title, ebook_author, ebook_company, ebook_page_count, ebook_price, ebook_img, ebook_summary, ebook_state, update_date, create_date) VALUES (?,?,?,?,?,?,?,?,?,?,now(),NOW())";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, ebook.getEbookISBN());
        stmt.setString(2, ebook.getCategoryName());
        stmt.setString(3, ebook.getEbookTitle());
        stmt.setString(4, ebook.getEbookAuthor());
        stmt.setString(5, ebook.getEbookCompany());
        stmt.setInt(6, ebook.getEbookPageCount());
        stmt.setInt(7, ebook.getEbookPrice());
        stmt.setString(8, ebook.getEbookImg());
        stmt.setString(9, ebook.getEbookSummary());
        stmt.setString(10, ebook.getEbookState());
        System.out.println("전자책 생성 stmt:"+stmt);
        stmt.executeUpdate();
       
        stmt.close();
        conn.close();
		
	}
	
	// 전자책 구매 가능 여부 확인
	public boolean ebookSaleCheck(int ebookNo) throws ClassNotFoundException, SQLException{
		boolean check = false;
		
		DBUtil dbUtil = new DBUtil();
        Connection conn = dbUtil.getConnection();
        String sql = "SELECT ebook_state from ebook where ebook_no=?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, ebookNo);
        System.out.println("전자책 구매 가능 여부 stmt:"+stmt);
        ResultSet rs = stmt.executeQuery();
        
        if(rs.next()) {
        	// 전자책 상태 확인
        	if(rs.getString("ebook_state").equals("판매중")) {
        		check = true;
        	}
        }
       
        rs.close();
        stmt.close();
        conn.close();
        
        return check;
	}
	
	// 신상품 5개 목록 출력
	public ArrayList<Ebook> selectNewEbookList() throws ClassNotFoundException, SQLException{
		ArrayList<Ebook> list = new ArrayList<>();
		
	      // mariaDB 연동
	      DBUtil dbUilt = new DBUtil();
	      Connection conn = dbUilt.getConnection();
	      String sql = "SELECT ebook_no ebookNo, ebook_title ebookTitle, ebook_img ebookImg, ebook_price ebookPrice FROM ebook ORDER BY create_date DESC LIMIT 0,5";
	      PreparedStatement stmt = conn.prepareStatement(sql);
	      System.out.println("ebook 목록 출력 stmt : "+stmt);
	      ResultSet rs = stmt.executeQuery();
	      
	      // 각 전자책의 정보를 리스트에 담는다
	      while(rs.next()) {
	         Ebook ebook = new Ebook();
	         ebook.setEbookNo(Integer.parseInt(rs.getString("ebookNo")));
	         ebook.setEbookTitle(rs.getString("ebookTitle"));
	         ebook.setEbookImg(rs.getString("ebookImg"));
	         ebook.setEbookPrice(rs.getInt("ebookPrice"));
	         list.add(ebook);
	      }
	      rs.close();
	      stmt.close();
	      conn.close();
	      return list;
	}
	
	// 인기 상품 5개 목록 출력
	public ArrayList<Ebook> selectPopularEbookList() throws ClassNotFoundException, SQLException{
		ArrayList<Ebook> list = new ArrayList<>();
		
	      // mariaDB 연동
	      DBUtil dbUilt = new DBUtil();
	      Connection conn = dbUilt.getConnection();
	      String sql = "SELECT t.ebook_no ebookNo, e.ebook_title ebookTitle, e.ebook_img ebookImg, e.ebook_price ebookPrice from ebook e INNER join (select ebook_no, count(ebook_no) cnt from orders GROUP BY ebook_no ORDER BY COUNT(ebook_no) DESC LIMIT 0,5) t ON e.ebook_no=t.ebook_no";
	      PreparedStatement stmt = conn.prepareStatement(sql);
	      System.out.println("ebook 목록 출력 stmt : "+stmt);
	      ResultSet rs = stmt.executeQuery();
	      
	      // 각 전자책의 정보를 리스트에 담는다
	      while(rs.next()) {
	         Ebook ebook = new Ebook();
	         ebook.setEbookNo(Integer.parseInt(rs.getString("ebookNo")));
	         ebook.setEbookTitle(rs.getString("ebookTitle"));
	         ebook.setEbookImg(rs.getString("ebookImg"));
	         ebook.setEbookPrice(rs.getInt("ebookPrice"));
	         list.add(ebook);
	      }
	      rs.close();
	      stmt.close();
	      conn.close();
	      return list;
	}
   
   // 전자책 이미지 변경하기
   public void updateEbookImg(Ebook ebook) throws ClassNotFoundException, SQLException {
      DBUtil dbUtil = new DBUtil();
       Connection conn = dbUtil.getConnection();
       String sql ="update ebook set ebook_img=? where ebook_no=?";
       PreparedStatement stmt = conn.prepareStatement(sql);
       stmt.setString(1, ebook.getEbookImg());
       stmt.setInt(2, ebook.getEbookNo());
       stmt.executeUpdate();
       
       stmt.close();
       conn.close();
   }
   
   
   // 전자책 내용 추출
   public Ebook selectEbookOne(int ebookNo) throws ClassNotFoundException, SQLException {
      Ebook ebook = null;
      DBUtil dbUtil = new DBUtil();
       Connection conn = dbUtil.getConnection();
       String sql = "select * from ebook where ebook_no=?";
       PreparedStatement stmt = conn.prepareStatement(sql);
       stmt.setInt(1, ebookNo);
       ResultSet rs = stmt.executeQuery();
       if(rs.next()) {
          ebook = new Ebook();
          ebook.setEbookNo(rs.getInt("ebook_no"));
          ebook.setEbookImg(rs.getString("ebook_img"));
          ebook.setEbookPrice(rs.getInt("ebook_price"));
          ebook.setEbookTitle(rs.getString("ebook_title"));
          ebook.setCategoryName(rs.getString("category_name"));
          ebook.setEbookSummary(rs.getString("ebook_summary"));
          ebook.setEbookPageCount(rs.getInt("ebook_page_count"));
          ebook.setEbookAuthor(rs.getString("ebook_author"));
          ebook.setCreateDate(rs.getString("create_date"));
          ebook.setUpdateDate(rs.getString("update_date"));
          ebook.setEbookISBN(rs.getString("ebook_ISBN"));
          ebook.setEbookCompany(rs.getString("ebook_company"));
          ebook.setEbookState(rs.getString("ebook_state"));
       }
       
       rs.close();
       stmt.close();
       conn.close();
       
       return ebook;
   }
   
   // [관리자] 전자책 마지막 페이지 연산 (카테고리 별)
   public int selectEbookListLastPageByCategory(int rowPerPage, String categoryName) throws ClassNotFoundException, SQLException {
      DBUtil dbUtil = new DBUtil();
       Connection conn = dbUtil.getConnection();
    
      // 카테고리별 전체 페이지수 구하기
       PreparedStatement stmt;
         String sql = "select count(*) from ebook where category_name=?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, categoryName);
        System.out.println("전체 전자책 수 stmt : "+stmt);
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
   
   // [관리자] 전자책 마지막 페이지 연산
   public int selectEbookListLastPage(int rowPerPage) throws ClassNotFoundException, SQLException {
      DBUtil dbUtil = new DBUtil();
       Connection conn = dbUtil.getConnection();
    
      // 전체 페이지수 구하기
       PreparedStatement stmt;
         String sql = "select count(*) from ebook";
        stmt = conn.prepareStatement(sql);
        System.out.println("전체 전자책 수 stmt : "+stmt);
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

   // [관리자 & 고객] 전자책 목록 전체 출력
   public ArrayList<Ebook> selectEbookList(int beginRow, int rowPerPage) throws ClassNotFoundException, SQLException{
      ArrayList<Ebook> list = new ArrayList<>();
      
      // mariaDB 연동
      DBUtil dbUilt = new DBUtil();
      Connection conn = dbUilt.getConnection();
      String sql = "select ebook_no ebookNo, category_name categoryName, ebook_title ebookTitle, ebook_img ebookImg, ebook_price ebookPrice, ebook_state ebookState from ebook order by create_date desc limit ?,?";
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setInt(1, beginRow);
      stmt.setInt(2, rowPerPage);
      System.out.println("ebook 목록 출력 stmt : "+stmt);
      ResultSet rs = stmt.executeQuery();
      
      // 각 전자책의 정보를 리스트에 담는다
      while(rs.next()) {
         Ebook ebook = new Ebook();
         ebook.setEbookNo(Integer.parseInt(rs.getString("ebookNo")));
         ebook.setCategoryName(rs.getString("categoryName"));
         ebook.setEbookTitle(rs.getString("ebookTitle"));
         ebook.setEbookImg(rs.getString("ebookImg"));
         ebook.setEbookPrice(rs.getInt("ebookPrice"));
         ebook.setEbookState(rs.getString("ebookState"));
         list.add(ebook);
      }
      rs.close();
      stmt.close();
      conn.close();
      return list;
   }
   
   // 전자책 목록 카테고리 별로 출력
   public ArrayList<Ebook> selectEbookListByCategory(int beginRow, int rowPerPage, String categoryName) throws ClassNotFoundException, SQLException{
      ArrayList<Ebook> list = new ArrayList<>();
      
      // mariaDB 연동
      DBUtil dbUilt = new DBUtil();
      Connection conn = dbUilt.getConnection();
      String sql = "select ebook_no ebookNo, category_name categoryName, ebook_title ebookTitle, ebook_state ebookState from ebook where category_name=? order by create_date desc limit ?,?";
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setString(1, categoryName);
      stmt.setInt(2, beginRow);
      stmt.setInt(3, rowPerPage);
      System.out.println("ebook 목록 출력 stmt : "+stmt);
      ResultSet rs = stmt.executeQuery();
      
      // 각 전자책의 정보를 리스트에 담는다
      while(rs.next()) {
         Ebook ebook = new Ebook();
         ebook.setEbookNo(Integer.parseInt(rs.getString("ebookNo")));
         ebook.setCategoryName(rs.getString("categoryName"));
         ebook.setEbookTitle(rs.getString("ebookTitle"));
         ebook.setEbookState(rs.getString("ebookState"));
         list.add(ebook);
      }
      rs.close();
      stmt.close();
      conn.close();
      return list;
   }
   
}