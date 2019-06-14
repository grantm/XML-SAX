use Test::More;

use strict;
use warnings;

use File::Spec;

unlink( File::Spec->catdir(qw(blib lib XML SAX ParserDetails.ini)) ),
ok(1, 'delete ParserDetails.ini');

done_testing();

