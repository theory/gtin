--
--	PostgreSQL code for GTINs.
--

-- Adjust this setting to control where the objects get created.
SET search_path = public;
SET client_min_messages = warning;

--
--	Input function and the type itself.
--

CREATE OR REPLACE FUNCTION gtin_in(cstring)
RETURNS gtin
AS 'gtin'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION gtin_out(gtin)
RETURNS cstring
AS 'gtin'
LANGUAGE C IMMUTABLE STRICT;

CREATE TYPE gtin (
	INTERNALLENGTH = 19,
	INPUT          = gtin_in,
	OUTPUT         = gtin_out
);

COMMENT ON TYPE gtin IS 'Global Trade Item Number';

--
-- Conversion to and from TEXT.
--

CREATE OR REPLACE FUNCTION TEXT(gtin)
RETURNS text
AS 'gtin', 'gtin_to_text'
LANGUAGE C IMMUTABLE STRICT;

CREATE CAST( GTIN AS TEXT ) WITH FUNCTION TEXT( GTIN ) AS IMPLICIT;

CREATE OR REPLACE FUNCTION GTIN(text)
RETURNS gtin
AS 'gtin', 'text_to_gtin'
LANGUAGE C IMMUTABLE STRICT;

CREATE CAST( TEXT AS GTIN ) WITH FUNCTION GTIN( TEXT ) AS IMPLICIT;

--
-- Operator Functions.
--

CREATE OR REPLACE FUNCTION gtin_eq( gtin, gtin )
RETURNS bool
AS 'gtin'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION gtin_ne( gtin, gtin )
RETURNS bool
AS 'gtin'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION gtin_lt( gtin, gtin )
RETURNS bool
AS 'gtin'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION gtin_le( gtin, gtin )
RETURNS bool
AS 'gtin'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION gtin_gt( gtin, gtin )
RETURNS bool
AS 'gtin'
LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION gtin_ge( gtin, gtin )
RETURNS bool
AS 'gtin'
LANGUAGE C IMMUTABLE STRICT;

--
-- Operators.
--

CREATE OPERATOR = (
    LEFTARG    = GTIN,
    RIGHTARG   = GTIN,
    COMMUTATOR = =,
--  NEGATOR    = <>,
    PROCEDURE  = gtin_eq
);

CREATE OPERATOR <> (
    LEFTARG   = GTIN,
    RIGHTARG  = GTIN,
    NEGATOR   = =,
    PROCEDURE = gtin_ne
);

CREATE OPERATOR < (
    LEFTARG   = GTIN,
    RIGHTARG  = GTIN,
--      NEGATOR   = >=,
    PROCEDURE = gtin_lt
);

CREATE OPERATOR <= (
    LEFTARG   = GTIN,
    RIGHTARG  = GTIN,
--      NEGATOR   = >,
    PROCEDURE = gtin_le
);

CREATE OPERATOR >= (
    LEFTARG   = GTIN,
    RIGHTARG  = GTIN,
    NEGATOR   = <,
    PROCEDURE = gtin_ge
);

CREATE OPERATOR > (
    LEFTARG   = GTIN,
    RIGHTARG  = GTIN,
    NEGATOR   = <=,
    PROCEDURE = gtin_gt
);

--
-- Indexing Function.
--

CREATE FUNCTION gtin_cmp(GTIN, GTIN)
RETURNS INT
AS 'gtin'
LANGUAGE C STRICT IMMUTABLE;

CREATE OPERATOR CLASS gtin_ops
DEFAULT FOR TYPE GTIN USING BTREE AS
    OPERATOR  1  <,
    OPERATOR  2  <=,
    OPERATOR  3  =,
    OPERATOR  4  >=,
    OPERATOR  5  >,
    FUNCTION  1  gtin_cmp(GTIN, GTIN);

--
-- Validation functions for potential GTINs.
--

CREATE OR REPLACE FUNCTION isa_gtin (text)
RETURNS boolean
AS 'gtin'
LANGUAGE 'C' IMMUTABLE STRICT;

--
-- Formatting function.
--

CREATE OR REPLACE FUNCTION to_char (gtin, text)
RETURNS text
AS 'gtin','gtin_to_char'
LANGUAGE 'C' IMMUTABLE STRICT;

