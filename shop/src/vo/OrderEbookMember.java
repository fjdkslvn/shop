package vo;

public class OrderEbookMember {
   private Order order;
   private Ebook ebook;
   private Member member;
   
   public Order getOrder() {
      return order;
   }
   public void setOrder(Order order) {
      this.order = order;
   }
   public Ebook getEbook() {
      return ebook;
   }
   public void setEbook(Ebook ebook) {
      this.ebook = ebook;
   }
   public Member getMember() {
      return member;
   }
   public void setMember(Member member) {
      this.member = member;
   }
   

}