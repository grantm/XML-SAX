use Test;
BEGIN { plan tests => 119 }
use XML::SAX::PurePerl;
use XML::SAX::PurePerl::DebugHandler;

my $handler = XML::SAX::PurePerl::DebugHandler->new();
my $parser = XML::SAX::PurePerl->new(Handler => $handler);

for my $id (1..119) {
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
    
