use Test::More;

use XML::SAX;
use XML::SAX::ParserFactory;
use XML::SAX::PurePerl;

my $dist_version = $XML::SAX::VERSION;

ok(defined($dist_version), 'XML::SAX version');
is($XML::SAX::ParserFactory::VERSION, $dist_version, 'XML::SAX::ParserFactory version');
is($XML::SAX::PurePerl::VERSION, $dist_version, 'XML::SAX::PurePerl version');

done_testing();

