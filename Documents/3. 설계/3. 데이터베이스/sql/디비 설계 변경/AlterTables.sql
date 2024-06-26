use allkeyboard;
# member에 allowemail, allowphone 추가
ALTER TABLE member ADD COLUMN allowemail char(1) NOT NULL comment '이메일수신동의';
ALTER TABLE member ADD COLUMN allowphone char(1) NOT NULL comment '연락처수신동의';

# 모든 멤버에 수신 비동의 처리
UPDATE member SET allowemail='n', allowphone='n';

# 공지 이미지 파일에 관리 인덱스 부여
ALTER TABLE notificationattach ADD COLUMN nfidx int unsigned NOT NULL comment '관리번호';

# 상품 이미지 파일에 관리 인덱스 부여
ALTER TABLE productattach ADD COLUMN pfidx int unsigned NOT NULL comment '관리번호';

# 공지 이미지 파일에 검증용 해시 부여
#ALTER TABLE notificationattach ADD COLUMN nfhash char(32) NOT NULL comment '검증해시';
# 공지 이미지 파일에 검증용 해시 제거
ALTER TABLE notificationattach DROP COLUMN nfhash;

# orders에 입금자 추가 - 따로 테이블로 빼야하지만 시간이 없으므로 orders에 추가됨.
ALTER TABLE orders ADD COLUMN depositor char(20) NOT NULL comment '입금자';

# product에 중분류 용 type 추가
ALTER TABLE product ADD COLUMN type varchar(20) comment '타입';