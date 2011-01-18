#!/usr/bin/perl -w

use Test::More tests => 9;
BEGIN{use_ok('XML::SAX');
	  use_ok('XML::SAX::PurePerl');
	  use_ok('XML::SAX::PurePerl::DebugHandler');
	  use_ok('IO::File');}

my $handler = XML::SAX::PurePerl::DebugHandler->new();
ok($handler);

my $parser = XML::SAX::PurePerl->new(Handler => $handler);
ok($parser);

my $file1 = IO::File->new("testfiles/parse.xml");
ok($file1);

eval {
$parser->parse_file($file1);
};
print $@;
ok(!$@);

my $file2 = "testfiles/parse.xml";

eval {
$parser->parse_file($file2);
};
print $@;
ok(!$@);
