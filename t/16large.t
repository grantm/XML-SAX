#!/usr/bin/perl -w

use Test::More tests => 3;
use XML::SAX::PurePerl;
use XML::SAX::PurePerl::DebugHandler;

my $handler = XML::SAX::PurePerl::DebugHandler->new();
isa_ok($handler, 'XML::SAX::PurePerl::DebugHandler' );

my $parser = XML::SAX::PurePerl->new(Handler => $handler);
isa_ok($parser, 'XML::SAX::PurePerl');

my $time = time;
$parser->parse_uri("testfiles/16a.xml");
warn("parsed ", -s "testfiles/16a.xml", " bytes in ", time - $time, " seconds\n");
ok(1);
