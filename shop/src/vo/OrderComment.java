package vo;

public class OrderComment {
	private int orderNo;
	private int ebookNo;
	private int orderScore;
	private String orderCommentContent;
	private String createDate;
	private String updateDate;
	private String ebookTitle; // DB 스키마와 다르지만 편의성을 위해 추가
	
	public String getEbookTitle() {
		return ebookTitle;
	}
	public void setEbookTitle(String ebookTitle) {
		this.ebookTitle = ebookTitle;
	}
	public int getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(int orderNo) {
		this.orderNo = orderNo;
	}
	public int getEbookNo() {
		return ebookNo;
	}
	public void setEbookNo(int ebookNo) {
		this.ebookNo = ebookNo;
	}
	public int getOrderScore() {
		return orderScore;
	}
	public void setOrderScore(int orderScore) {
		this.orderScore = orderScore;
	}
	public String getOrderCommentContent() {
		return orderCommentContent;
	}
	public void setOrderCommentContent(String orderCommentContent) {
		this.orderCommentContent = orderCommentContent;
	}
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	public String getUpdateDate() {
		return updateDate;
	}
	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}
	
	@Override
	public String toString() {
		return "OrderComment [orderNo=" + orderNo + ", ebookNo=" + ebookNo + ", orderScore=" + orderScore
				+ ", orderCommentContent=" + orderCommentContent + ", createDate=" + createDate + ", updateDate="
				+ updateDate + "]";
	}
	
	
}
