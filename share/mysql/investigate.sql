select table_schema, sum(data_length+index_length) /1024 /1024 as MB from information_schema.tables  group by table_schema order by sum(data_length+index_length) desc;

select table_schema, sum(data_length+index_length) /1024 /1024/1024 as GB from information_schema.tables  group by table_schema order by sum(data_length+index_length) desc;

select table_schema, sum(data_length+index_length) /1024 /1024 as MB from information_schema.tables where table_schema = database();

select  
table_name, engine, table_rows as tbl_rows, avg_row_length as rlen,  
floor((data_length+index_length)/1024/1024) as allMB,  #総容量
floor((data_length)/1024/1024) as dMB,  #データ容量
floor((index_length)/1024/1024) as iMB   #インデックス容量
from information_schema.tables  
where table_schema=database()  
order by (data_length+index_length) desc; 
