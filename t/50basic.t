#!/usr/bin/perl -w

use Test::More tests => 2;
BEGIN{use_ok('XML::SAX');}

my $parser = XML::SAX::ParserFactory->parser();
ok(defined $parser);
