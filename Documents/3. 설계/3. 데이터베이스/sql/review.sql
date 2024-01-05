use allkeyboard;


create table review
(
 rno int unsigned not null primary key auto_increment comment  '댓글번호',
 rnote text not null comment '내용',
 rwritedate timestamp comment '작성일',
 mno int  unsigned not null comment '회원번호',
 foreign key(mno) references member(mno),
 pno int unsigned not null comment '상품번호',
 foreign key(pno) references member(pno)
);