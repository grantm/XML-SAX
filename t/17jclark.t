use Test;
BEGIN { plan tests => 119 }
use XML::SAX::PurePerl;
use XML::SAX::PurePerl::DebugHandler;
use XML::SAX qw(Namespaces);

my $handler = XML::SAX::PurePerl::DebugHandler->new();
my $parser = XML::SAX::PurePerl->new(Handler => $handler);

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
        ok(0, 1, $@);
    }
    else {
        ok(1);
    }
}
    
