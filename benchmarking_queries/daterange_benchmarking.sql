-- Function to generate random intgers b/w low and high
CREATE OR REPLACE FUNCTION random_int(low INT ,high INT) 
   RETURNS INT AS
$$
BEGIN
   RETURN floor(random() * ((high - low + 1) + low));
END;
$$ language 'plpgsql' STRICT;

-- Function to generate random date range b/w low and high date
CREATE OR REPLACE FUNCTION random_date(i INT) 
   RETURNS daterange AS
$$
DECLARE
   low date := (now()::timestamp + (random_int( random_int(0, i), random_int(i + 1, i*2) )::text || ' days')::interval)::date;
   high date := (now()::timestamp + (random_int( random_int(i*3, i*4), random_int((i*4) + 1, i*8) )::text || ' days')::interval)::date;
BEGIN
   if (low > high) then 
      return daterange(high, low); 
   else 
      return daterange(low, high); 
   end if;
END;
$$ language 'plpgsql' STRICT;

-- Drop tables
drop table if exists table_daterange_small_1;
drop table if exists table_daterange_small_2;
drop table if exists table_daterange_big_1;
drop table if exists table_daterange_big_2;

-- Create tables
create table table_daterange_small_1 (id int, column_1 daterange);
create table table_daterange_small_2 (id int, column_2 daterange);
create table table_daterange_big_1 (id int, column_1 daterange);
create table table_daterange_big_2 (id int, column_2 daterange);

-- Insert 100 values in small tables
insert into table_daterange_small_1 select i, random_date(i) from generate_series(1, 100) as i;
insert into table_daterange_small_2 select i, random_date(i) from generate_series(1, 100) as i;

-- Insert 10000 values in big tables
insert into table_daterange_big_1 select i, random_date(i) from generate_series(1, 10000) as i;
insert into table_daterange_big_2 select i, random_date(i) from generate_series(1, 10000) as i;

-- Analyze all tables
vacuum analyze table_daterange_small_1;
vacuum analyze table_daterange_small_2;
vacuum analyze table_daterange_big_1;
vacuum analyze table_daterange_big_2;

--------------------------
--- Start Benchmarking ---
--------------------------

-- Start Timer
\timing on

-- Run queries to explain analyze the join estimations

-- small * small
explain analyze select * from table_daterange_small_1 t1, table_daterange_small_2 t2 where t1.column_1 && t2.column_2;

-- small * big
explain analyze select * from table_daterange_small_1 t1, table_daterange_big_2 t2 where t1.column_1 && t2.column_2;

-- big * big
explain analyze select * from table_daterange_big_1 t1, table_daterange_big_2 t2 where t1.column_1 && t2.column_2;
