gtin 0.2.0
==========

This distribution creates a custom PostgreSQL data type, the GTIN. GTINs are
bar codes used to identify products. The GTIN specification is a superset of
the UPC and EAN bar code formats with which you may already be familiar, and
which will just work with the GTIN data type.

This module was written for PostgreSQL 8.2, but was abandoned once the
[isn](http://www.postgresql.org/docs/current/static/isn.html) conttrib module
was modernized in PostgreSQL 8.3. As such, the code compiles against 8.3 but
the tests do not provide the expected output. Pull requests welcome from
anyone who might want to fix things up. But it's mostly provided here for
informational purposes.

For context, check out the [blog post announcing
GTIN](http://www.justatheory.com/computers/databases/postgresql/gtin-0.01.html).

Dependencies
------------
The GTIN data type has no dependencies other than PostgreSQL.

Copyright and License
---------------------

Copyright (c) 2006-2011 David E. Wheeler.

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
