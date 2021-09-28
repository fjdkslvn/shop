package dao;

import vo.*;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

import commons.DBUtil;

public class OrderDao {
	
	// 나의 주문 리스트 출력
    public ArrayList<OrderEbookMember> selectOrderListByMember(int memberNo) throws ClassNotFoundException, SQLException{
      ArrayList<OrderEbookMember> list = new ArrayList<>();
      DBUtil dbUtil = new DBUtil();
       Connection conn = dbUtil.getConnection();
       String sql = "select o.order_no orderNo, e.ebook_no ebookNo, e.ebook_title ebookTitle, m.member_no memberNo, m.member_id memberId, o.order_price orderPrice, o.create_date createDate from orders o inner join ebook e inner join member m on o.ebook_no = e.ebook_no and o.member_no = m.member_no where m.member_no=? order by o.create_date DESC";
       PreparedStatement stmt = conn.prepareStatement(sql);
       stmt.setInt(1, memberNo);
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