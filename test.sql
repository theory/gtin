--
-- Tests for the GTIN data type.
--
--

SET client_min_messages = warning;
CREATE TEMP TABLE product (
    gtin    gtin UNIQUE PRIMARY KEY,
    name    text
);

\echo ##############################################################################
\echo expect gtin ERROR
insert into product values ('4007630000117', 'Bad');
\echo ##############################################################################
\echo
\echo ##############################################################################
\echo expect PK ERROR
insert into product values ('4007630000116', 'PK');
insert into product values ('4007630000116', 'PK');
\echo ##############################################################################
\echo
\echo No errors
insert into product values ('0061414000024',  'Arthur Dent');
insert into product values ('0012345000065',  'Ford Prefect');
insert into product values ('614141000418',   'Zaphod Beeblebrox');
insert into product values ('10614141000415', 'Trillian');
insert into product values ('10614141450005', 'Slartibartfast');
insert into product values ('10614141777775', 'Zarniwoop');
insert into product values ('123',            'Milliways');

\echo Accessor functions
select gtin, isa_gtin(gtin) from product;
\echo Expect true
select isa_gtin('0061414000024');
\echo Expect false
select isa_gtin('0061414000025');
\echo

\echo Equality tests
select '0061414000024'::gtin = '61414000024'::gtin AS is_same_gtin;
select name, gtin from product where gtin = '0061414000024';
select a.gtin, a2.name from product a JOIN product a2 USING (gtin);
select a.gtin, a2.name from product a JOIN product a2 ON (UPPER(a.gtin)::gtin = a2.gtin);

\echo Comparison Operators 
\echo Casting is implicit.
select '123'::gtin   <  '130' AS lt;
select '123'::gtin   <= '130' AS le1;
select '123'::gtin   <= '123' AS le2;
select '00123'::gtin <= '130' AS le3;
select '130'::gtin   >  '123' AS gt;
select '130'::gtin   >= '123' AS ge1;
select '130'::gtin   >= '130' AS ge2;
select '00130'::gtin >= '130' AS ge3;

select gtin from product where gtin <= '61414000024';
select gtin from product where gtin >= '0061414000024';

\echo LIKE 
\echo Implicitly casts values
select name, gtin from product where gtin like '106%'; 
select name, gtin from product where gtin ilike '106%'; 
select name, gtin from product where gtin ~~ '106%';

\echo select true where constant like constant works
select true where '0061414000024'::gtin like '614%';
select true where '0061414000024'::gtin ilike '614%';
select true where '0061414000024'::gtin ~~ '614%';

\echo Regular Expressions.
\echo Implicitly casts values
select name, gtin from product where gtin ~ '^106'; 
select name, gtin from product where gtin ~* '^106'; 

\echo select true where constant ~ constant works
select true where '0061414000024'::gtin ~ '^614';
select true where '0061414000024'::gtin ~* '^614';

\echo 
\echo ORDER BY ASC:
select * from product order by gtin;
select * from product order by gtin ASC;

\echo ORDER BY DESC:
select * from product order by gtin DESC;
\echo
