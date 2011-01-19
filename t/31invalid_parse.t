#!/usr/bin/perl -w

use Test::More tests => 4;
use XML::SAX::PurePerl;
use XML::SAX::PurePerl::DebugHandler;
use IO::File;

my $handler = XML::SAX::PurePerl::DebugHandler->new();
isa_ok($handler, 'XML::SAX::PurePerl::DebugHandler');

my $parser = XML::SAX::PurePerl->new(Handler => $handler);
isa_ok($parser, 'XML::SAX::PurePerl');

#try to parse non existant file
my $file = undef;

eval {
$parser->parse_file($file);
};
is(substr($@,0,42), 'No _parse_* routine defined on this driver', 'Recognised non-existant file');

#again, but directly instead of through an object
eval {
$parser->parse_uri("file:testfiles/11.xml");
};
is(substr($@, 0, 18), 'LWP Request Failed', 'Recognised non-existant file');
