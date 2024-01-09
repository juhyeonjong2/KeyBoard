package allkeyboard.vo;

public class NotificationAttach {
	private int nfno;
	private int nfidx; // 파일 관리 번호
	private int nno; // 연결 공지 번호
	private String realFileName;    // 서버에 저장된 파일명
	private String foreignFileName; // 외부에서 온(클라에서) 파일명 
	private String rdate;
	public int getNfno() {
		return nfno;
	}
	public void setNfno(int nfno) {
		this.nfno = nfno;
	}
	public int getNfidx() {
		return nfidx;
	}
	public void setNfidx(int nfidx) {
		this.nfidx = nfidx;
	}
	public int getNno() {
		return nno;
	}
	public void setNno(int nno) {
		this.nno = nno;
	}
	public String getRealFileName() {
		return realFileName;
	}
	public void setRealFileName(String realFileName) {
		this.realFileName = realFileName;
	}
	public String getForeignFileName() {
		return foreignFileName;
	}
	public void setForeignFileName(String foreignFileName) {
		this.foreignFileName = foreignFileName;
	}
	public String getRdate() {
		return rdate;
	}
	public void setRdate(String rdate) {
		this.rdate = rdate;
	}	
	
	
}
