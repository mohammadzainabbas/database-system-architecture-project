----------------------------------------------------------------
----------------------- Helper Functions -----------------------
----------------------------------------------------------------
-- Function to generate random intgers b/w low and high
CREATE OR REPLACE FUNCTION random_int(low INT ,high INT) 
   RETURNS INT AS
$$
BEGIN
   RETURN floor(random() * (high - low + 1) + low);
END;
$$ language 'plpgsql' STRICT;

-- Function to generate random floats b/w low and high
CREATE OR REPLACE FUNCTION random_float(low INT ,high INT) 
   RETURNS FLOAT AS
$$
BEGIN
   RETURN random() * (( high - low + 1) + low);
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

----------------------------------------------------------------
-------------- Helper Range Generating Functions ---------------
----------------------------------------------------------------

-- Function to generate random intrange
CREATE OR REPLACE FUNCTION random_intrange(m INT) 
   RETURNS int4range AS
$$
DECLARE
   low int := random_int( random_int( 1, m * 100) , random_int( 1, m * 100) );
   high int := random_int( random_int( 1, m * 100) , random_int( 1, m * 100) );
BEGIN
   if (low > high) then 
      return int4range(high, low); 
   else 
      return int4range(low, high); 
   end if;
END;
$$ language 'plpgsql' STRICT;

-- Function to generate random numeric_range
CREATE OR REPLACE FUNCTION random_numeric(m INT) 
   RETURNS numrange AS
$$
DECLARE
   low numeric := random_float( random_int( 1, m * 100) , random_int( 1, m * 100) );
   high numeric := random_float( random_int( 1, m * 100) , random_int( 1, m * 100) );
BEGIN
   if (low > high) then 
      return numrange(high, low); 
   else 
      return numrange(low, high); 
   end if;
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

----------------------------------------------------------------
--------------------- Create/Drop Table(s) ---------------------
----------------------------------------------------------------

-- Drop tables
drop table if exists table_int_small_1;
drop table if exists table_int_small_2;
drop table if exists table_int_big_1;
drop table if exists table_int_big_2;

-- Create tables
create table table_int_small_1 (id int, column_1 int4range);
create table table_int_small_2 (id int, column_2 int4range);
create table table_int_big_1 (id int, column_1 int4range);
create table table_int_big_2 (id int, column_2 int4range);

-- Drop tables
drop table if exists table_float_small_1;
drop table if exists table_float_small_2;
drop table if exists table_float_big_1;
drop table if exists table_float_big_2;

-- Create tables
create table table_float_small_1 (id int, column_1 numrange);
create table table_float_small_2 (id int, column_2 numrange);
create table table_float_big_1 (id int, column_1 numrange);
create table table_float_big_2 (id int, column_2 numrange);

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

----------------------------------------------------------------
------------------------- Insert Data  -------------------------
----------------------------------------------------------------

-- int4range 
-- Insert 100 values in small tables
insert into table_int_small_1 select i, random_intrange(100) from generate_series(1, 100) as i;
insert into table_int_small_2 select i, random_intrange(100) from generate_series(1, 100) as i;

-- Insert 10000 values in big tables
insert into table_int_big_1 select i, random_intrange(10000) from generate_series(1, 10000) as i;
insert into table_int_big_2 select i, random_intrange(10000) from generate_series(1, 10000) as i;

-- numrange 
-- Insert 100 values in small tables
insert into table_float_small_1 select i, random_numeric(100) from generate_series(1, 100) as i;
insert into table_float_small_2 select i, random_numeric(100) from generate_series(1, 100) as i;

-- Insert 10000 values in big tables
insert into table_float_big_1 select i, random_numeric(10000) from generate_series(1, 10000) as i;
insert into table_float_big_2 select i, random_numeric(10000) from generate_series(1, 10000) as i;

-- tsrange
-- Insert 100 values in small tables
insert into table_tsrange_small_1 select i, random_timestamp(i) from generate_series(1, 100) as i;
insert into table_tsrange_small_2 select i, random_timestamp(i) from generate_series(1, 100) as i;

-- Insert 10000 values in big tables
insert into table_tsrange_big_1 select i, random_timestamp(i) from generate_series(1, 10000) as i;
insert into table_tsrange_big_2 select i, random_timestamp(i) from generate_series(1, 10000) as i;
-- daterange
-- Insert 100 values in small tables
insert into table_daterange_small_1 select i, random_date(i) from generate_series(1, 100) as i;
insert into table_daterange_small_2 select i, random_date(i) from generate_series(1, 100) as i;

-- Insert 10000 values in big tables
insert into table_daterange_big_1 select i, random_date(i) from generate_series(1, 10000) as i;
insert into table_daterange_big_2 select i, random_date(i) from generate_series(1, 10000) as i;
