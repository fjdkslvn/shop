package dao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import commons.DBUtil;
import vo.*;

public class CategoryDao {
	
	// [관리자] 카테고리 상태 수정
	public void updateCategoryState(String categoryName, String categoryState) throws ClassNotFoundException, SQLException {
		// mariaDB 연동
		DBUtil dbUilt = new DBUtil();
		Connection conn = dbUilt.getConnection();
		String sql = "update category set category_state=?, update_date=now() where category_name=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		if(categoryState.equals("Y")) {
			stmt.setString(1, "N");
		} else {
			stmt.setString(1, "Y");
		}
		stmt.setString(2, categoryName);
		System.out.println("카테고리 상태 수정 stmt : "+stmt);
		stmt.executeUpdate();
		
		// mariaDB관련 모두 닫기
		stmt.close();
		conn.close();
	}
	
	
	// [관리자] 카테고리 목록 가져오기
	public ArrayList<Category> selectCategoryList() throws ClassNotFoundException, SQLException {
		ArrayList<Category> list = new ArrayList<>();
		
		// mariaDB 연동
		DBUtil dbUilt = new DBUtil();
		Connection conn = dbUilt.getConnection();
		String sql = "select category_name categoryName, update_date updateDate, create_date createDate, category_state categoryState from category";
		PreparedStatement stmt = conn.prepareStatement(sql);
		System.out.println("카테고리 목록 출력 stmt : "+stmt);
		ResultSet rs = stmt.executeQuery();
		
		// 각 카테고리의 정보를 리스트에 담는다
		while(rs.next()) {
			Category category = new Category();
			category.setCategoryName(rs.getString("categoryName"));
			category.setUpdateDate(rs.getString("updateDate"));
			category.setCreateDate(rs.getString("createDate"));
			category.setCategoryState(rs.getString("categoryState"));
			
			list.add(category);
		}
		rs.close();
		stmt.close();
		conn.close();
				
		return list;
	}
}
