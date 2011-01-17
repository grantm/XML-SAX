#!/usr/bin/perl -w

use Test::More tests => 3;

use_ok( 'XML::SAX' ); 

use_ok('XML::SAX::PurePerl');

ok(XML::SAX->VERSION eq XML::SAX::PurePerl->VERSION);
