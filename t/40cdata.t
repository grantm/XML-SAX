use Test::More;

use strict;
use warnings;


use XML::SAX::PurePerl;

my $handler = CDataHandler->new();
ok($handler, 'cdata handler');

my $parser = XML::SAX::PurePerl->new(Handler => $handler);
ok($parser, 'PurePerl parser');

$parser->parse_string('<code><![CDATA[<crackers & cheese>]]></code>');
ok(1, 'parsed without an exception');

my $expected = '<crackers & cheese>';
is($handler->cbuffer, $expected, 'expected character output');

done_testing();
exit;


package CDataHandler;

use base 'XML::SAX::Base';

sub start_document { shift->{_buf} = '';             }
sub characters     { shift->{_buf} .= shift->{Data}; }
sub cbuffer        { shift->{_buf};                  }

