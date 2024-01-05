use allkeyboard;


create table cert
(
 hash char(64) not null comment  '해쉬값',
 expiretime timestamp comment '만료기간',
 mno int  unsigned not null unique comment '회원번호',
 foreign key(mno) references member(mno)
);