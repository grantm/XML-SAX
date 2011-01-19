#!/usr/bin/perl -w

use Test::More tests => 14;
use XML::SAX::ParserFactory;

# load SAX parsers (no ParserDetails.ini available at first in blib)
use XML::SAX qw(Namespaces Validation);
is(@{XML::SAX->parsers}, 0, 'No parsers loaded');
ok(XML::SAX->add_parser(q(XML::SAX::PurePerl)), 'Can load PuerPerl parser');
is(@{XML::SAX->parsers}, 1, 'One parser loaded');

isa_ok(XML::SAX::ParserFactory->parser, 'XML::SAX::PurePerl'); # test class method
my $factory = XML::SAX::ParserFactory->new();
isa_ok($factory, 'XML::SAX::ParserFactory');
isa_ok($factory->parser, 'XML::SAX::PurePerl');

eval {$factory->require_feature(Namespaces)};
is($@, '', 'Successfully required feature: Namespaces');
isa_ok($factory->parser, 'XML::SAX::PurePerl');
eval{$factory->require_feature(Validation)};
is($@, '', 'Successfully required feature: Validation');

eval {
    my $parser = $factory->parser;
    # should never get here unless PurePerl starts providing validation
    ok(!$parser);
};
isa_ok($@, 'XML::SAX::Exception');

$factory = XML::SAX::ParserFactory->new();
my $parser = $factory->parser;
isa_ok($parser, 'XML::SAX::PurePerl');

eval {
    $parser->parse_string('<widget/>');
};
is($@, '', 'Parsed string "<widget/>"');

local $XML::SAX::ParserPackage = 'XML::SAX::PurePerl';
isa_ok(XML::SAX::ParserFactory->parser, 'XML::SAX::PurePerl');
local $XML::SAX::ParserPackage = 'XML::SAX::PurePerl (0.01)';
isa_ok(XML::SAX::ParserFactory->parser, 'XML::SAX::PurePerl');
