package allkeyboard.vo;

public class product {
	
	private int pno;
	private String pname;
	private int price;
	private String brand;
	private String description;
	private int inventory;
	private char delyn;
	
	private int pfno;
	private String pfrealname;
	private String pforeigname;
	private String rdate;
	
	public product() {
		super();
	}
	
	
	public product(int pno, String pname, int price, String brand, int inventory) {
		this.pno = pno;
		this.pname = pname;
		this.price = price;
		this.brand = brand;
		this.inventory = inventory;
	}

	public int getPno() {
		return pno;
	}

	public void setPno(int pno) {
		this.pno = pno;
	}

	public String getPname() {
		return pname;
	}

	public void setPname(String pname) {
		this.pname = pname;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

	public String getBrand() {
		return brand;
	}

	public void setBrand(String brand) {
		this.brand = brand;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public int getInventory() {
		return inventory;
	}

	public void setInventory(int inventory) {
		this.inventory = inventory;
	}

	public char getDelyn() {
		return delyn;
	}

	public void setDelyn(char delyn) {
		this.delyn = delyn;
	}

	public int getPfno() {
		return pfno;
	}

	public void setPfno(int pfno) {
		this.pfno = pfno;
	}

	public String getPfrealname() {
		return pfrealname;
	}

	public void setPfrealname(String pfrealname) {
		this.pfrealname = pfrealname;
	}

	public String getPforeigname() {
		return pforeigname;
	}

	public void setPforeigname(String pforeigname) {
		this.pforeigname = pforeigname;
	}

	public String getRdate() {
		return rdate;
	}

	public void setRdate(String rdate) {
		this.rdate = rdate;
	}
	
}
	
	
