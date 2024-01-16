use allkeyboard;

# 관리자 아이디생성
INSERT INTO member (mid, mpw, mname, mphone, memail, maddr, rdate,  mlevel,delyn)
 VALUES('admin',  md5('1234') ,'관리자', '000-0000-0000', 'admin@allkeyboard.com', '전주시 덕진구', now(), 2, 'n');