package vo;

public class Order {
   private int orderNo;
   private int ebookNo; // private Ebook ebook;
   private int memberNo; // private Member member;
   private int orderPrice;
   private String createDate;
   private String updateDate;
   
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
   public int getMemberNo() {
      return memberNo;
   }
   public void setMemberNo(int memberNo) {
      this.memberNo = memberNo;
   }
   public int getOrderPrice() {
      return orderPrice;
   }
   public void setOrderPrice(int orderPrice) {
      this.orderPrice = orderPrice;
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
   
   
}