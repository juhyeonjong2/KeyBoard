create table product
(
	pno int unsigned not null primary key auto_increment comment '상품번호',
    pname text not null comment '상품명',
    price int not null comment '판매가',
    brand varchar(20) comment '브랜드',
    description varchar(200) comment '상세설명',
    inventory int comment '재고',
    delyn char(1) comment '삭제유무'
);


create table productAttach
(
	 pfno int unsigned primary key not null auto_increment comment '이미지파일번호',
     pno int unsigned not null comment '상품번호',
     pfrealname varchar(100) not null comment '실제이름',
     pforeignname varchar(100) not null comment '외부이름',
     rdate timestamp not null comment '등록일',
     foreign key(pno) references product(pno)
);




