#!/usr/bin/perl -w

use Test::More;

use XML::SAX;
use XML::SAX::PurePerl;

ok(1, 'successfully loaded XML::SAX and XML::SAX::PurePerl modules');

is(XML::SAX->VERSION, XML::SAX::PurePerl->VERSION, 'Version check: OK');

done_testing();
