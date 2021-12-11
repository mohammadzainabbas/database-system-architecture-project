--------------------------
--- Start Benchmarking ---
--------------------------

-- Start Timer
\timing on

-- Analyze all tables
vacuum analyze table_tsrange_small_1;
vacuum analyze table_tsrange_small_2;
vacuum analyze table_tsrange_big_1;
vacuum analyze table_tsrange_big_2;

-- Run queries to explain analyze the join estimations

-- small * small
explain analyze select * from table_tsrange_small_1 t1, table_tsrange_small_2 t2 where t1.column_1 && t2.column_2;

-- small * big
explain analyze select * from table_tsrange_small_1 t1, table_tsrange_big_2 t2 where t1.column_1 && t2.column_2;

-- big * big
explain analyze select * from table_tsrange_big_1 t1, table_tsrange_big_2 t2 where t1.column_1 && t2.column_2;

-- Stop Timer
\timing off
