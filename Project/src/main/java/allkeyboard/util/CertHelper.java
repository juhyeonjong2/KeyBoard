package allkeyboard.util;
import ateam.db.DBManager;
import ateam.util.HashMaker;
import allkeyboard.vo.Cert;

// 자바 8이전
//import java.text.SimpleDateFormat;
//import java.util.Date;
// 자바 8이후
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class CertHelper {
	// mno 회원의 토큰을 반환 (없다면 생성, 있다면 갱신해서 반환)
	public static String createToken(int mno) throws Exception {
		// 1. 해당 회원의 토큰이 이미 있는지 확인.
		Cert cert = getCert(mno);
		String hash = makeHash(mno);
		if(cert!= null) {
			// 1-1. 이미 있다면 새로운 토큰으로 업데이트 및 expiereTime 갱신
			if( updateCert(mno, hash) == false) {
				throw new Exception("update cert fail");
			}
		}
		else {
			// 1-2. 없다면 생성후 리턴
			if(insertCert(mno, hash) ==false) {
				throw new Exception("insert cert fail");
			}
		}
		return hash;
	}
	// 외부에서 사용 (회원번호와 토큰이 일치해야 반환됨)
	public static Cert getCert(int mno, String token) {
		Cert cert = null;
		DBManager db = new DBManager();
		if(db.connect())
		{
			 String sql = "SELECT mno, hash, expiretime FROM cert WHERE mno=? AND hash=?";	 
			 if( db.prepare(sql).setInt(mno).setString(token).read())
			 {
				 if(db.getNext())
				 {
					System.out.println("getCert(int mno, String token)");
					cert = new Cert();
					cert.setMno(db.getInt("mno"));
					cert.setHash(db.getString("hash"));
					cert.setExpiretime(db.getString("expiretime"));
				 }
			 }
			 
			 db.disconnect();
		}
		
		return cert;
	}
	
	// 해당 멤버의 권한 레벨을 반환. (0:비회원, 1:회원, 2:관리자)
	public static int getLevel(Cert cert) {
		int level = 0;
		if(cert != null)
		{
			DBManager db = new DBManager();
			if(db.connect())
			{
				 String sql = "SELECT M.mlevel as level "
				 		+ "FROM member M "
				 		+ "INNER JOIN cert C "
				 		+ "ON M.mno = C.mno "
				 		+ "WHERE M.mno = ?";	 
				 
				 if( db.prepare(sql).setInt(cert.getMno()).read())
				 {
					 if(db.getNext())
					 {
						System.out.println("getlevel");
						level = db.getInt("level");
					 }
				 }
				 
				 db.disconnect();
			}
		}
		return level;
	}
	
	public static boolean isAdmin(int mno, String token) {
		Cert cert = CertHelper.getCert(mno, token);
		if(cert != null) {
			if(getLevel(cert) == 2) {
				return true;
			}
		}
		return false;
	}
	
	// token, mno는 그대로 두고 expiretime만 갱신한다.
	public static boolean refreshToken(Cert cert) {
		
		if(cert == null)
			return false;
		
		boolean isSuccess = false;
		
		DBManager db = new DBManager();
		if(db.connect()) {
			String sql = "UPDATE cert SET expiretime=DATE_ADD(NOW(), INTERVAL 2 HOUR) WHERE mno=?";
			if(db.prepare(sql).setInt(cert.getMno()).update() > 0)
			{
				System.out.println("refreshToken");
				isSuccess = true;
			}
			db.disconnect();
		}
		
		return isSuccess;
	}
	
	// 권한 인증 시간을 검사한다.
	public static boolean isExpiredTime(Cert cert) throws Exception{
		if(cert == null) {
			throw new Exception("cert is null");
		}
		boolean isExpired = false;
		
		DBManager db = new DBManager();
		if(db.connect())
		{
			 String sql = "SELECT TIMESTAMPDIFF(SECOND, expiretime, now()) as result FROM cert WHERE mno=?";	 
			 if( db.prepare(sql).setInt(cert.getMno()).read())
			 {
				 if(db.getNext())
				 {
					System.out.println("isExpiredTime");
					int result = db.getInt("result");
					System.out.println(result);
					if(result > 0) {
						isExpired = true;
					}
				 }
				 else {
					 // 없는경우는 문제가 있는경우라 예외를 던진다.
					 db.disconnect();
					 throw new Exception("cert does not exist");
				 }
			 }
			 
			 db.disconnect();
		}
		
		return isExpired; // 
	}
	
	
	private static String makeHash(int mno) throws Exception{
		//현재시간 + mno를 가지고 해시를 생성.
		// java 8이전
		//Date today = new Date();
		//SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		//return HashMaker.sha256(dateFormat.format(today) +" "+ Integer.toString(mno));
		LocalDateTime today = LocalDateTime.now();
		DateTimeFormatter dateFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
		return HashMaker.sha256(dateFormat.format(today) +" "+ Integer.toString(mno));
	}
	
	// 내부처리용.
	private static Cert getCert(int mno) {
		// 
		Cert cert = null;
		DBManager db = new DBManager();
		if(db.connect())
		{
			 String sql = "SELECT mno, hash, expiretime FROM cert WHERE mno=?";	 
			 if( db.prepare(sql).setInt(mno).read())
			 {
				 if(db.getNext())
				 {
					System.out.println("getCert(int mno)");
					cert = new Cert();
					cert.setMno(db.getInt("mno"));
					cert.setHash(db.getString("hash"));
					cert.setExpiretime(db.getString("expiretime"));
				 }
			 }
			 
			 db.disconnect();
		}
		
		return cert;
	}
	
	// mno 회원의 토큰을 갱신 
	private static boolean updateCert(int mno, String hash) {
		
		boolean isSuccess = false;
		DBManager db = new DBManager();
		if(db.connect()) {
			String sql = "UPDATE cert SET hash=?, expiretime=DATE_ADD(NOW(), INTERVAL 2 HOUR) WHERE mno=?";
			if(db.prepare(sql).setString(hash).setInt(mno).update() > 0)
			{
				System.out.println("updateCert");
				isSuccess = true;
			}
			db.disconnect();
		}
		
		return isSuccess;
	}
	
	private static boolean insertCert(int mno, String hash) {
		
		boolean isSuccess = false;
		DBManager db = new DBManager();
		if(db.connect()) {
			String sql = "INSERT INTO cert (hash, mno, expiretime) VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 2 HOUR))";
			
			if(db.prepare(sql).setString(hash).setInt(mno).update() > 0)
			{
				System.out.println("insertCert");
				isSuccess = true;
			}
			db.disconnect();
		}
		
		return isSuccess;
	}
	
	
	
}
