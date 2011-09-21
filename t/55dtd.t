#!/usr/bin/perl -w

use Test::More tests => 13;
use Data::Dumper;
use feature qw(switch);

BEGIN{
	use_ok('XML::SAX');
	use_ok('XML::SAX::PurePerl::DebugHandler');
	use_ok('XML::SAX::ParserFactory');}

my @errors = (
    { file => 'testfiles/doctype_0.xml', message => '' },
    { file => 'testfiles/doctype_1.xml', message => 'No whitespace after doctype declaration [Ln: 2, Col: 10]' },
    { file => 'testfiles/doctype_2.xml', message => 'Invalid element name [Ln: 2, Col: 2]' },
    { file => 'testfiles/doctype_3.xml', message => 'Doctype not closed [Ln: 2, Col: 18]' },
    { file => 'testfiles/doctype_4.xml', message => 'Doctype not closed [Ln: 2, Col: 15]' },
    { file => 'testfiles/doctype_5.xml', message => 'Name <"-> does not match NameChar production [Ln: 2, Col: 13]' },
    { file => 'testfiles/doctype_6.xml', message => 'Not whitespace after PUBLIC ID in DOCTYPE [Ln: 3, Col: 65]' },
    { file => 'testfiles/doctype_7.xml', message => 'No whitespace after PUBLIC identifier [Ln: 2, Col: 21]' },
    { file => 'testfiles/doctype_8.xml', message => 'Invalid element name [Ln: 2, Col: 2]' },
    { file => 'testfiles/doctype_9.xml', message => 'No whitespace after doctype declaration [Ln: 2, Col: 10]' }
);

foreach my $error ( @errors ) {
    my $file = $error->{file};
    my $message = $error->{message};
    
	my $parser = XML::SAX::ParserFactory->parser(
		Handler => XML::SAX::PurePerl::DebugHandler->new
	);

	eval {
		$parser->parse_uri($file);
	};
	chomp $@ if $@;
	is($@,$message,'Correct error message');
		
    #print "file: $file \n";
    #print "message: $message \n\n";
}
