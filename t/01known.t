#!/usr/bin/perl -w

use Test::More tests => 3;

use XML::SAX;
eval{XML::SAX->save_parsers};
is($@, '', 'Parsers saved successfully');

eval{XML::SAX->load_parsers};
is($@, '', 'Parsers loaded successfully');

is(@{XML::SAX->parsers}, 0);
