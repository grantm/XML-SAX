#!/usr/bin/perl -w

use Test::More tests => 5;
use XML::SAX::PurePerl;
use XML::SAX::PurePerl::DebugHandler;
use IO::File;

my $handler = XML::SAX::PurePerl::DebugHandler->new();
isa_ok($handler, 'XML::SAX::PurePerl::DebugHandler');

my $parser = XML::SAX::PurePerl->new(Handler => $handler);
isa_ok($parser, 'XML::SAX::PurePerl');

my $file = IO::File->new("testfiles/01.xml") || die $!;
isa_ok($file, IO::File);

$parser->parse_file($file);
is($handler->{seen}{start_document}, 1, 'Parser passed start of document');
is($handler->{seen}{end_document}, 1, 'Parser passed end of document');

