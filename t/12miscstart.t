use Test::More;

use strict;
use warnings;

use XML::SAX::PurePerl;
use XML::SAX::PurePerl::DebugHandler;

my $handler = XML::SAX::PurePerl::DebugHandler->new();
ok($handler, 'debug handler');

my $parser = XML::SAX::PurePerl->new(
    Handler => $handler,
    'http://xml.org/sax/handlers/LexicalHandler' => $handler
);
ok($parser, 'PurePerl parser');

# check PIs and comments before document element parse ok
$parser->parse_uri("testfiles/03a.xml");
ok($handler->{seen}{processing_instruction}, 'processing_instruction');
ok($handler->{seen}{comment}, 'comment');

# check invalid version number
eval {
    $parser->parse_uri("testfiles/03b.xml");
};
ok($@, 'parser threw exception');

is(
    $@->{Message},
    'Invalid comment (dash)',
    'parser error message'
);
is(
    $@->{LineNumber},
    4,
    'line number'
);
is(
    $@->{ColumnNumber},
    '4',
    'column number'
);

done_testing();
