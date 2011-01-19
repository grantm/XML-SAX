#!/usr/bin/perl -w

use Test::More tests => 6;
use XML::SAX::PurePerl;
use XML::SAX::PurePerl::DebugHandler;

my $handler = XML::SAX::PurePerl::DebugHandler->new();
isa_ok($handler, 'XML::SAX::PurePerl::DebugHandler');

my $parser = XML::SAX::PurePerl->new(Handler => $handler);
isa_ok($parser, 'XML::SAX::PurePerl');

# check PIs and comments before document element parse ok
$parser->parse_uri("testfiles/03a.xml");
is($handler->{seen}{processing_instruction}, 2, 'Seen processing instruction');
ok($handler->{seen}{comment}, 'Seen comment');

# check invalid version number
eval {
$parser->parse_uri("testfiles/03b.xml");
};

is($@->{Message}, 'Invalid comment (dash)', 'Correctly identified invalid version number,');
is($@->{LineNumber}, 4, 'in correct line.');
