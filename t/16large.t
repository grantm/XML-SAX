use Test::More;

use strict;
use warnings;

use XML::SAX::PurePerl;
use XML::SAX::PurePerl::DebugHandler;

my $handler = XML::SAX::PurePerl::DebugHandler->new();
ok($handler, 'debug handler');

my $parser = XML::SAX::PurePerl->new(Handler => $handler);
ok($parser, 'PurePerl parser');

my $time = time;
$parser->parse_uri("testfiles/xmltest.xml");
my $secs = time - $time;
ok(1, "parsed testfiles/xmltest.xml without exceptions in $secs seconds");

done_testing();

