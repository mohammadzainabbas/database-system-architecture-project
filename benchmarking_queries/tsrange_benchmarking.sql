-- Function to generate random intgers b/w low and high
CREATE OR REPLACE FUNCTION random_int(low INT ,high INT) 
   RETURNS INT AS
$$
BEGIN
   RETURN floor(random() * ((high - low + 1) + low));
END;
$$ language 'plpgsql' STRICT;

-- Function to generate very random intgers for an integer and with a, b & c bounds
CREATE OR REPLACE FUNCTION tres_random_int(i INT, a INT, b INT, c INT)
   RETURNS INT AS
$$
BEGIN
   RETURN random() * random_int(random_int(i*a, i*b), random_int((i*b) + 1, i*c) );
END;
$$ language 'plpgsql' STRICT;

-- Function to generate very random interval for an integer and with a, b & c bounds
CREATE OR REPLACE FUNCTION tres_random_interval(i INT, a INT, b INT, c INT)
   RETURNS interval AS
$$
BEGIN
   RETURN 
   (
      trunc(tres_random_int(i, a, b, c) * random_int(1, 29)) * '1 day'::interval +
      trunc(tres_random_int(i, a, b, c) * random_int(1, 23)) * '1 hour'::interval + 
      trunc(tres_random_int(i, a, b, c) * random_int(1, 59)) * '1 min'::interval + 
      trunc(tres_random_int(i, a, b, c) * random_int(1, 59)) * '1 sec'::interval + 
      trunc(tres_random_int(i, a, b, c) * random_int(1, 999)) * '10 ms'::interval 
   );
END;
$$ language 'plpgsql' STRICT;

-- Function to generate random tsrange (timestamp range) b/w low and high timestamp
CREATE OR REPLACE FUNCTION random_timestamp(i INT) 
   RETURNS tsrange AS
$$
DECLARE
   low timestamp := (now()::timestamp + (random() * ((TIMESTAMP 'epoch' + (tres_random_interval(i, 4, 5, 6))) - (TIMESTAMP 'epoch' + (tres_random_interval(i, 1, 2, 3))) )));
   high timestamp := (now()::timestamp + (random() * ((TIMESTAMP 'epoch' + (tres_random_interval(i, 4, 5, 6))) - (TIMESTAMP 'epoch' + (tres_random_interval(i, 1, 2, 3))) )));
BEGIN
   if (low > high) then 
      return tsrange(high, low); 
   else 
      return tsrange(low, high); 
   end if;
END;
$$ language 'plpgsql' STRICT;

-- Drop tables
drop table if exists table_tsrange_small_1;
drop table if exists table_tsrange_small_2;
drop table if exists table_tsrange_big_1;
drop table if exists table_tsrange_big_2;

-- Create tables
create table table_tsrange_small_1 (id int, column_1 tsrange);
create table table_tsrange_small_2 (id int, column_2 tsrange);
create table table_tsrange_big_1 (id int, column_1 tsrange);
create table table_tsrange_big_2 (id int, column_2 tsrange);

-- Insert 100 values in small tables
insert into table_tsrange_small_1 select i, random_timestamp(i) from generate_series(1, 100) as i;
insert into table_tsrange_small_2 select i, random_timestamp(i) from generate_series(1, 100) as i;

-- Insert 10000 values in big tables
insert into table_tsrange_big_1 select i, random_timestamp(i) from generate_series(1, 10000) as i;
insert into table_tsrange_big_2 select i, random_timestamp(i) from generate_series(1, 10000) as i;

-- Analyze all tables
vacuum analyze table_tsrange_small_1;
vacuum analyze table_tsrange_small_2;
vacuum analyze table_tsrange_big_1;
vacuum analyze table_tsrange_big_2;

--------------------------
--- Start Benchmarking ---
--------------------------

-- Start Timer
\timing on

-- Run queries to explain analyze the join estimations

-- small * small
explain analyze select * from table_tsrange_small_1 t1, table_tsrange_small_2 t2 where t1.column_1 && t2.column_2;

-- small * big
explain analyze select * from table_tsrange_small_1 t1, table_tsrange_big_2 t2 where t1.column_1 && t2.column_2;

-- big * big
explain analyze select * from table_tsrange_big_1 t1, table_tsrange_big_2 t2 where t1.column_1 && t2.column_2;
