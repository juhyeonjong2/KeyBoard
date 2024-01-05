use allkeyboard;


create table member
(
	mno int unsigned not null primary key unique auto_increment comment '회원번호', 
    mid varchar(255) not null comment '아이디', 
	mname text not null comment '이름', 
    mphone varchar(13) not null comment '연락처',
    memail varchar(100) comment '이메일', 
    maddr text comment '주소',
	rdate timestamp comment '가입일', 
	mpw char(32) not null comment '비밀번호',
    mlevel int comment '권한',
	delyn char(1) comment '탈퇴여부' 
);

create table cert
(
 hash char(64) not null comment  '해쉬값',
 expiretime timestamp comment '만료기간',
 mno int  unsigned not null unique comment '회원번호',
 foreign key(mno) references member(mno)
);