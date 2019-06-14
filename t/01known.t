use Test::More;

use strict;
use warnings;

use XML::SAX;
ok(XML::SAX->save_parsers, 'create ParserDetails.ini file');
ok(XML::SAX->load_parsers, 'parse ParserDetails.ini file');
is(scalar(@{XML::SAX->parsers}), 0, 'no known parsers in config file');

done_testing();
