#!/usr/bin/perl -w

use Test::More tests => 3;
use XML::SAX::PurePerl;
use XML::SAX::PurePerl::DebugHandler;

my $handler = XML::SAX::PurePerl::DebugHandler->new();
isa_ok($handler, 'XML::SAX::PurePerl::DebugHandler');

my $parser = XML::SAX::PurePerl->new(Handler => $handler);
isa_ok($parser, 'XML::SAX::PurePerl');

eval{$parser->parse_uri("testfiles/13a.xml");};
is($@, '');
