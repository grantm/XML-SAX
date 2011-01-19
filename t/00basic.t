#!/usr/bin/perl -w

use Test::More tests => 3;

use_ok('XML::SAX'); 

use_ok('XML::SAX::PurePerl');

is(XML::SAX->VERSION, XML::SAX::PurePerl->VERSION, 'Version check: OK');
