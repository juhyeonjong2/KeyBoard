# member에 allowemail, allowphone 추가
ALTER TABLE member ADD COLUMN allowemail char(1) NOT NULL comment '이메일수신동의';
ALTER TABLE member ADD COLUMN allowphone char(1) NOT NULL comment '연락처수신동의';

# 모든 멤버에 수신 비동의 처리
UPDATE member SET allowemail='n', allowphone='n';

# 공지 이미지 파일에 관리 인덱스 부여
ALTER TABLE notificationattach ADD COLUMN nfidx int unsigned NOT NULL comment '관리번호';

# 상품 이미지 파일에 관리 인덱스 부여
ALTER TABLE productattach ADD COLUMN pfidx int unsigned NOT NULL comment '관리번호';