use Test::More;

use strict;
use warnings;

use XML::SAX::PurePerl;
use XML::SAX::PurePerl::DebugHandler;
use XML::SAX qw(Namespaces);

diag("This test should show just 1 warning about an entity already existing\n");

my $handler = XML::SAX::PurePerl::DebugHandler->new();
ok($handler, 'debug handler');

my $parser = XML::SAX::PurePerl->new(Handler => $handler);
ok($parser, 'PurePerl parser');

$parser->set_feature(Namespaces, 0);

for my $id (1..119) {
    if ($] < 5.007002) {
        skip("no Encode on this platform", 1), next if $id == 49;
        skip("no Encode on this platform", 1), next if $id == 50;
        skip("no Encode on this platform", 1), next if $id == 51;
    }
    my $file = sprintf("testfiles/jclark/%03d.xml", $id);
    eval {
        $parser->parse_uri($file);
    };
    if ($@) {
        is($@, undef, 'exception in $@');
    }
    else {
        ok('parsed with no exception');
    }
}

done_testing();
