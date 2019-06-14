use Test::More;

use strict;
use warnings;


use XML::SAX::PurePerl;

my $handler = AttrHandler->new();
ok($handler, 'attr handler');

my $parser = XML::SAX::PurePerl->new(Handler => $handler);
ok($parser, 'PurePerl parser');

$parser->parse_string('<code amp="&amp;" x3E="&#x3E;" num="&#65;" />');
ok(1, 'parsed without exception');

my $expected = "amp=& num=A x3E=> ";
is($handler->attributes => $expected, 'expected attribute content');

done_testing();
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
