CREATE TABLE notification (
	nno int unsigned not null auto_increment primary key ,
    ntitle text not null,
    ncontent text,
    rdate timestamp,
    nhit int unsigned,
    delyn char(1)
 );
 
 CREATE TABLE notificationAttach(
	nfno int unsigned not null auto_increment primary key,
    nno int unsigned not null,
    nfrealname varchar(100) not null,
    nforeignname varchar(100) not null,
    rdate timestamp not null,
    foreign key(nno) references notification(nno)
 );