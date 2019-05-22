#!/bin/sh
sqlite3 test.db <<EOF
-- create table n (id INTEGER PRIMARY KEY,f TEXT,l TEXT);
insert into n (f,l) values ('john','smith');
select * from n;
EOF
