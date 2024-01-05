use allkeyboard;

CREATE TABLE orders
(
	ono int unsigned not null primary key auto_increment comment '주문번호',
    mno int unsigned not null comment '회원번호',
    oname varchar(20) not null comment '주문자명',
    otell varchar(13) comment '주문자전화번호',
    ophone varchar(13) not null comment '주문자휴대폰번호',
    oemail varchar(100) not null comment '주문자이메일',
    rdate timestamp comment '주문날짜',
    recipient text not null comment '받으실분',
    arrivallocation text not null comment '받으실 곳',
    recipienttell varchar(13) comment '받는사람 전화번호',
    recipientphone varchar(13) not null comment '받는사람 휴대폰 번호',
    onote text comment '남길말', 
    paymenttype char(2) not null comment '결제타입',
    deliveryfee int unsigned not null comment '배송비',
    state varchar(10) comment '주문상태'
);

CREATE TABLE orderitem
(
	ino int unsigned not null primary key auto_increment comment '항목번호',
    ono int unsigned not null comment '주문번호',
    pno int unsigned not null comment '상품번호',
    price int unsigned not null comment'판매가',
    quantity int unsigned not null comment '수량',
    foreign key(ono) references orders(ono),
    foreign key(pno) references product(pno)
);
