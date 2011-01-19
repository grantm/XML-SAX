#!/usr/bin/perl -w

use Test::More tests => 5;
use XML::SAX::PurePerl;
use XML::SAX::PurePerl::DebugHandler;
use IO::File;

my $handler = XML::SAX::PurePerl::DebugHandler->new();
isa_ok($handler, 'XML::SAX::PurePerl::DebugHandler');

my $parser = XML::SAX::PurePerl->new(Handler => $handler);
isa_ok($parser, 'XML::SAX::PurePerl');

my $file1 = IO::File->new("testfiles/30a.xml");
isa_ok($file1, 'IO::File');

eval {
$parser->parse_file($file1);
};
if ($@){warn($@);}
is($@, '', 'Parsed file file1');

my $file2 = "testfiles/30a.xml";

eval {
$parser->parse_file($file2);
};
if($@){warn($@);}
is($@, '', 'Parsed file file2' );
