use Test::More;

use strict;
use warnings;

BEGIN { plan tests => 3 }
use XML::SAX::PurePerl;
use XML::SAX::PurePerl::DebugHandler;

my $handler = XML::SAX::PurePerl::DebugHandler->new();
ok($handler, 'debug handler');

my $parser = XML::SAX::PurePerl->new(Handler => $handler);
ok($parser, 'PurePerl parser');

$parser->parse_uri("testfiles/04a.xml");
ok(1, 'parsed file with &amp;');

done_testing();
