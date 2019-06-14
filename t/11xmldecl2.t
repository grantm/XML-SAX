use Test::More;

use strict;
use warnings;

use XML::SAX::PurePerl;
use XML::SAX::PurePerl::DebugHandler;
use IO::File;

my $handler = XML::SAX::PurePerl::DebugHandler->new();
ok($handler, 'debug handler');

my $parser = XML::SAX::PurePerl->new(Handler => $handler);
ok($parser, 'PurePerl parser');

my $file = IO::File->new("testfiles/02a.xml");
ok($file, 'test file');

# check invalid characters
eval {
    $parser->parse_file($file);
};
ok($@, 'parser threw exception');

is(
    $@->{Message},
    'XML Declaration lacks required version attribute, or version attribute '
    . 'does not match XML specification',
    'parser error message'
);
is(
    $@->{LineNumber},
    1,
    'line number'
);
is(
    $@->{ColumnNumber},
    '6',
    'column number'
);

# check invalid version number
eval {
    $parser->parse_uri("file:testfiles/02b.xml");
};
ok($@, 'parser threw exception');

is(
    $@,
    qq{Only XML version 1.0 supported. Saw: '2.0' [Ln: 1, Col: 19]\n},
    'parser error message'
);

is(
    $@->{LineNumber},
    1,
    'line number'
);
is(
    $@->{ColumnNumber},
    19,
    'column number'
);

done_testing();
