package allkeyboard.vo;

public class ProductView extends Product {

		// 썸네일 추가.
	private String realFileName;    // 서버에 저장된 파일명
	private String foreignFileName; // 외부에서 온(클라에서) 파일명 
	
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
	
	
}
