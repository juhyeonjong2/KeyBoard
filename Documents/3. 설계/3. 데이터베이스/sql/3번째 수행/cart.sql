use allkeyboard;

CREATE TABLE cart (
	mno int unsigned not null,
    pno int unsigned not null,
    quantity int unsigned not null,
    foreign key(mno) references member(mno),
    foreign key(pno) references product(pno)
);