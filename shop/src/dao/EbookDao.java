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
   
   
   // 전자책 내용 일부만 추출
   public Ebook selectEbookOne(int ebookNo) throws ClassNotFoundException, SQLException {
      Ebook ebook = null;
      DBUtil dbUtil = new DBUtil();
       Connection conn = dbUtil.getConnection();
       String sql = "select ebook_no ebookNo, ebook_img ebookImg from ebook where ebook_no=?";
       PreparedStatement stmt = conn.prepareStatement(sql);
       stmt.setInt(1, ebookNo);
       ResultSet rs = stmt.executeQuery();
       if(rs.next()) {
          ebook = new Ebook();
          ebook.setEbookNo(rs.getInt("ebookNo"));
          ebook.setEbookImg(rs.getString("ebookImg"));
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