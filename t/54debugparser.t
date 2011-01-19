#!/usr/bin/perl -w

use Test::More;
use Data::Dumper;
use Data::Dump qw(dump);
use feature qw(switch);

BEGIN{
	use_ok('XML::SAX');
	use_ok('XML::SAX::PurePerl::DebugHandler');
	use_ok('XML::SAX::ParserFactory');}

my @files = ("54parse","50");

foreach $file(@files) {
	my $parser = XML::SAX::ParserFactory->parser(
		Handler => XML::SAX::PurePerl::DebugHandler->new
	);

	$parser->parse_uri("testfiles/$file.xml");
	my $handler = $parser->{Handler};

	my $parsed = Dumper(($parser->{Handler}));

	if (1) { # 0 to test, 1 to re-write
		open (MYFILE, ">$file.txt") or die $!;
		print MYFILE $parsed;
		close (MYFILE);
	}

	isa_ok($handler, 'XML::SAX::PurePerl::DebugHandler');
	is($handler->{seen}{start_document}, 1, 'Started doucment only once');
	is($handler->{seen}{end_document}, 1, 'Ended doucment only once');
	is($handler->{seen}{start_element}, $handler->{seen}{end_element}, 'Same number of start elements and end elements');

	open (MYFILE, "<$file.txt") or die $!;
	my @lines = <MYFILE>;
	chomp @lines;
	my @split = split(/\n/,$parsed);
	is("@split","@lines", "Successfully parsed");
	close (MYFILE);


	for (my $count = 0; $count < @lines; $count++) {
		if ($split[$count] ne $lines[$count]) {
			print "ERROR! $count:  |$split[$count]| ne |$lines[$count]|\n";
		}
	}
}

done_testing(3 + @files*5);
