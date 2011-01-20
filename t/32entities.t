#!/usr/bin/perl -w

use Test::More;
use XML::SAX::PurePerl;
use XML::SAX::PurePerl::DebugHandler;
use IO::File;

my $handler = XML::SAX::PurePerl::DebugHandler->new();
isa_ok($handler, 'XML::SAX::PurePerl::DebugHandler');

my $parser = XML::SAX::PurePerl->new(Handler => $handler);
isa_ok($parser, 'XML::SAX::PurePerl');

my @errs = (
	qr/^$/,
	qr/^Invalid name in entity \[Ln: 8, Col: 33\]\n$/,
	qr/^Invalid name in entity \[Ln: 19, Col: 28\]\n$/, 
	qr/^Malformed UTF-8 character \(fatal\) at .*\/PurePerl\.pm line \d+\.\n$/,
	qr/^Malformed UTF-8 character \(fatal\) at .*\/PurePerl\.pm line \d+\.\n$/,
	qr/^$/
);

for($i = 0; $i < @errs; $i++){
	eval { $parser->parse_file("testfiles/32_$i.xml" ); };
	like($@, $errs[$i], "Parsed file 32_$i.xml and found it's error");
	
}
diag(@errs + 2);
done_testing(@errs + 2);
