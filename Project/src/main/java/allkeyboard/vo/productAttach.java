package allkeyboard.vo;

public class productAttach {

	private int pfno;
	private int pfidx; // 파일 관리 번호 0 - 썸네일 1-5 상세설명 이미지;
	private int pno;
	private String pfrealname;
	private String pforeignname;
	private String rdate;
	
	
	public productAttach() {
		super();
	}
	
	public int getPfno() {
		return pfno;
	}
	public void setPfno(int pfno) {
		this.pfno = pfno;
	}
	public int getPno() {
		return pno;
	}
	public void setPno(int pno) {
		this.pno = pno;
	}
	public String getPfrealname() {
		return pfrealname;
	}
	public void setPfrealname(String pfrealname) {
		this.pfrealname = pfrealname;
	}
	public String getPforeignname() {
		return pforeignname;
	}
	public void setPforeignname(String pforeignname) {
		this.pforeignname = pforeignname;
	}
	public String getRdate() {
		return rdate;
	}
	public void setRdate(String rdate) {
		this.rdate = rdate;
	}
	public int getPfidx() {
		return pfidx;
	}
	public void setPfidx(int pfidx) {
		this.pfidx = pfidx;
	}
	
	
}
