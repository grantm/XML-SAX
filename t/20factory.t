use Test::More;

use strict;
use warnings;

use XML::SAX::ParserFactory;

# load SAX parsers (no ParserDetails.ini available at first in blib)
use XML::SAX qw(Namespaces Validation);
is(scalar(@{XML::SAX->parsers}), 0, 'no known parsers');
ok(XML::SAX->add_parser(q(XML::SAX::PurePerl)), 'added XML::SAX::PurePerl');
is(scalar(@{XML::SAX->parsers}), 1, 'one known parser');

# Call as class method
isa_ok(XML::SAX::ParserFactory->parser => 'XML::SAX::PurePerl');

# Call via factory object
my $factory = XML::SAX::ParserFactory->new();
isa_ok($factory => 'XML::SAX::ParserFactory');
isa_ok($factory->parser => 'XML::SAX::PurePerl');

ok($factory->require_feature(Namespaces), 'require Namespaces');
isa_ok($factory->parser => 'XML::SAX::PurePerl');

ok($factory->require_feature(Validation), 'require Validation');
eval {
    my $parser = $factory->parser;
    ok(0, 'PurePerl unexpectedly started providing validation');
};
isa_ok($@ => 'XML::SAX::Exception');

$factory = XML::SAX::ParserFactory->new();
my $parser = $factory->parser;
ok($parser, 'default parser');
eval {
    $parser->parse_string('<widget/>');
    ok(1, 'parse completed ok');
};
ok(!$@, 'parsed without exception');

local $XML::SAX::ParserPackage = 'XML::SAX::PurePerl';
isa_ok(XML::SAX::ParserFactory->parser => 'XML::SAX::PurePerl');

local $XML::SAX::ParserPackage = 'XML::SAX::PurePerl (0.01)';
isa_ok(XML::SAX::ParserFactory->parser => 'XML::SAX::PurePerl');

done_testing();

