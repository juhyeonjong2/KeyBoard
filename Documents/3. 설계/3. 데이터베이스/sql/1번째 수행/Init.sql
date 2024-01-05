# 1. 관리자로 접속한다.
# 2. 데이터베이스를 먼저 만든다
CREATE database allkeyboard;
# 3. 해당 디비에 접속할 계정을 만든다.
CREATE USER 'keytester'@'%' IDENTIFIED BY '1234';
GRANT ALL privileges on allkeyboard.* to 'keytester'@'%';