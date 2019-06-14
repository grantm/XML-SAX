use Test::More;

use strict;
use warnings;

use XML::SAX;
my $loaded++;

use XML::SAX::PurePerl;
$loaded++;

is($loaded, 2, 'loaded SAX and PurePerl modules');

my $dist_version = XML::SAX->VERSION;
ok(defined($dist_version), 'XML::SAX version');

is(XML::SAX::PurePerl->VERSION, $dist_version, 'XML::SAX::PurePerl version');
is(XML::SAX::ParserFactory->VERSION, $dist_version, 'XML::SAX::ParserFactory version');

done_testing();

