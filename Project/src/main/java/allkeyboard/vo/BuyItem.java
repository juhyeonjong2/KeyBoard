package allkeyboard.vo;

public class BuyItem {
	
	private int pno;
	private int price;
	private int quantity;

	public BuyItem()
	{
		
	}
	
	public BuyItem(int pno, int quantity) {
		this.pno = pno;
		this.quantity = quantity;	
	}
	
	public int getPno() {
		return pno;
	}
	
	public void setPno(int pno) {
		this.pno = pno;
	}	
	
	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

	public int getQuantity() {
		return quantity;
	}
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	
	
	
}
