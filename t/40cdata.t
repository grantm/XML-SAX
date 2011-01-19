#!/usr/bin/perl -w

use strict;
use warnings;

use Test::More tests => 4;

use XML::SAX::PurePerl;

my $handler = CDataHandler->new();
isa_ok($handler, 'CDataHandler');

my $parser = XML::SAX::PurePerl->new(Handler => $handler);
isa_ok($parser, 'XML::SAX::PurePerl');

eval{$parser->parse_string('<code><![CDATA[<crackers & cheese>]]></code>');};
is($@, '', 'Parsed String');

is($handler->cbuffer, '<crackers & cheese>', "Handler's cbuffer returns correct string");

exit;


package CDataHandler;

use base 'XML::SAX::Base';

sub start_document { shift->{_buf} = '';             }
sub characters     { shift->{_buf} .= shift->{Data}; }
sub cbuffer        { shift->{_buf};                  }

