#!/usr/bin/perl -w

use strict;
use warnings;

use Test::More tests => 4;

use XML::SAX::PurePerl;

my $handler = AttrHandler->new();
isa_ok($handler, 'AttrHandler');

my $parser = XML::SAX::PurePerl->new(Handler => $handler);
isa_ok($parser, 'XML::SAX::PurePerl');

eval{$parser->parse_string('<code amp="&amp;" x3E="&#x3E;" num="&#65;" />');};
is($@, '', 'Parsed string');

is($handler->attributes, 'amp=& num=A x3E=> ', 'handler->attributes returned correct string');

exit;


package AttrHandler;

use base 'XML::SAX::Base';

sub start_document { shift->{_buf} = '';             }
sub attributes     { shift->{_buf};                  }

sub start_element {
    my($self, $data) = @_;
    my $attr = $data->{Attributes};
    foreach (sort keys %$attr) {
        $self->{_buf} .= "$attr->{$_}->{LocalName}=$attr->{$_}->{Value} ";
    }
}
