#!/bin/sh
sqlite3 test.db <<EOF
-- create table n (id INTEGER PRIMARY KEY,f TEXT,l TEXT);
-- insert into n (f,l) values ('joe','potatonose');
select json_object('id', id, 'f', f, 'l', l) from n where id=$1;
-- select json_array('f', f, 'l', l) from n;
EOF
