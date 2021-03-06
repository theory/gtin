GTIN Data Type 0.0.2
====================

This distribution creates a custom PostgreSQL data type, the GTIN. GTINs are
bar codes used to identify products. The GTIN specification is a superset of
the UPC and EAN bar code formats with which you may already be familiar, and
which will just work with the GTIN data type.

Usage
-----

Once you've installed the GTIN data type, you can start using it in your
database.

    CREATE TABLE product (
        id    SERIAL PRIMARY KEY,
        gtin  GTIN,
        name  TEXT
    );

    INSERT INTO product VALUES ('0061414000024',  'Arthur Dent');
    INSERT INTO product VALUES ('0012345-000065', 'Ford Prefect');
    INSERT INTO product VALUES ('614141 000418',  'Zaphod Beeblebrox');
    INSERT INTO product VALUES ('10614141000415', 'Trillian');
    INSERT INTO product VALUES ('10614141450005', 'Slartibartfast');
    INSERT INTO product VALUES ('10614141777775', 'Zarniwoop');
    INSERT INTO product VALUES ('123',            'Milliways');

A GTIN is specifed in PostgreSQL as a string of digits. Spaces, dashes, and
leading 0s are allowed by the GTIN data type, but they will be stripped out
before storage (see to_char() below for how to get them back). Othwerwise,
only digits are allowed. Any other character will trigger an error.
Furthermore, GTINs can be no more than 18 characters long (excluding leading
0s, commas, and spaces), and cannot be empty strings, or else errors will
result. And finally, the GTIN checksum must be correct in order for it to be
considered valid by PostgreSQL.

For more example usage, consult 'test.sql'.

If you ever need to install the data type into another database, you'll find
'gtin.sql' in the 'share/contrib' subdirectory of your PostgreSQL server
directory. This 'README.gtin' file will be in the 'doc/contrib' subdirectory.

Utility Functions
-----------------

### isa_gtin(text) ###

    try=% select isa_gtin('123'), isa_gtin('122');;
     isa_gtin | isa_gtin 
    ----------+----------
     t        | f
    (1 row)

This function returns a boolean value if its argument is a valid GTIN and
false if it does not. It expects a text argument, but other arguments, such as
bigints, are also supported via implicit casting.

### to_char(gtin, text) ###

    try=% select to_char('0012345678905'::gtin, '0 00000 00000 0') as upc_12;
         upc_12      
    -----------------
     0 12345 67890 5
    (1 row)

    try=% select to_char('00123456789104'::gtin, '0 000000 000000') as ean_13;
         ean_13      
    -----------------
     0 123456 789104
    (1 row)

    try=% select to_char('00000001234565'::gtin, '0000 0000') as ean_8;
       ean_8   
    -----------
     0123 4565
    (1 row)

    try=% select to_char('10012345123457'::gtin, '0 00 00000 00000 0') as gtin_14;
          gtin_14       
    --------------------
     1 00 12345 12345 7
    (1 row)
  
This function formats a GTIN into a text string. The only characters
recognized in the format string, which is the second argument, are "0" and
"9". Any other characters are output literally from the format string.

The format is evaluated from right to left, similar to how to_char(int, text)
works. This is so that you can properly left-pad a GTIN to create typical
formats for UPCs, EANs, and GTINs that are still formally GTINs. The trick is
that if you have a UPC 8 GTIN, such as "1234565", and you need to display it
in GTIN 14 format, the left extra places on the left must be 0-padded. The "0"
format character does just that:

    try=% select to_char('1234565'::gtin, '0 00 00000 00000 0') as gtin_14;
          gtin_14       
    --------------------
     0 00 00001 23456 5
    (1 row)

The "9" format is provided for compatibility with PostgreSQL numeric
formatting functions. It stands in for the digit in its place, but pads with a
space rather than a 0:

    try=% select to_char('1234565'::gtin, '9 99 99999 99999 9');
          to_char
    --------------------
              1 23456 5
    (1 row)

Although I wouldn't actually expect it to be used all that often. :-). You can
also use the to_char() function to extract parts of your GTIN, such as the
prefix:

    try=% select substring(
    try(%     to_char('12345678905'::gtin, '00000000000000')
    try(%      from 1 for 4
    try(% );
     substring 
    -----------
     0001
    (1 row)

To Do
-----

* Write conversion functions for ISSN and ISBN.

Author
------
David E. Wheeler <david@justatheory.com>

Copyright and License
---------------------

Copyright (c) 2006-2011 David E. Wheeler. Some Rights Reserved.

This module is free software; you can redistribute it and/or modify it under
the [PostgreSQL License](http://www.opensource.org/licenses/postgresql).

Permission to use, copy, modify, and distribute this software and its
documentation for any purpose, without fee, and without a written agreement is
hereby granted, provided that the above copyright notice and this paragraph
and the following two paragraphs appear in all copies.

In no event shall David E. Wheeler be liable to any party for direct,
indirect, special, incidental, or consequential damages, including lost
profits, arising out of the use of this software and its documentation, even
if David E. Wheeler has been advised of the possibility of such damage.

David E. Wheeler specifically disclaim any warranties, including, but not
limited to, the implied warranties of merchantability and fitness for a
particular purpose. The software provided hereunder is on an "as is" basis,
and David E. Wheeler have no obligations to provide maintenance, support,
updates, enhancements, or modifications.
