#!/usr/bin/perl -w

use Test::More tests => 9;
use XML::SAX::PurePerl;
use XML::SAX::PurePerl::DebugHandler;
use IO::File;

my $handler = XML::SAX::PurePerl::DebugHandler->new();
isa_ok($handler, 'XML::SAX::PurePerl::DebugHandler');

my $parser = XML::SAX::PurePerl->new(Handler => $handler);
isa_ok($parser, 'XML::SAX::PurePerl');

my $file = IO::File->new("testfiles/02a.xml");
isa_ok($file, 'IO::File');

# check invalid characters
eval {
$parser->parse_file($file);
};

is($@->{Message}, 'XML Declaration lacks required version attribute, or version attribute does not match XML specification', 'Correctly identified sample file error,');
is($@->{LineNumber}, 1, 'in the right line,');
is($@->{ColumnNumber}, 6, 'and the right cloumn.');

# check invalid version number
eval {
$parser->parse_uri("file:testfiles/02b.xml");
};

is($@->{Message}, "Only XML version 1.0 supported. Saw: '2.0'", 'Correctly identified sample file error,');
is($@->{LineNumber}, 1, 'in the right line,');
is($@->{ColumnNumber}, 19, 'and the right column.');
