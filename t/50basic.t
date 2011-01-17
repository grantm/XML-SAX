#!/usr/bin/perl -w

use Test::More tests => 1;
use XML::SAX;

my $parser = XML::SAX::ParserFactory->parser();
ok(defined $parser);
