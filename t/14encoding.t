use Test::More;

use strict;
use warnings;

use XML::SAX::PurePerl;

my $handler = TestHandler->new(); # see below for the TestHandler class
ok($handler, 'debug handler');

my $parser = XML::SAX::PurePerl->new(Handler => $handler);
ok($parser, 'PurePerl parser');

# verify that the first element is correctly decoded
$handler->test_elements( "\x{9031}\x{5831}" );
$parser->parse_uri("testfiles/utf-16.xml");
is($handler->elements_matched, 1, 'elements matched');

$handler->test_elements( "foo" );
$parser->parse_uri("testfiles/utf-16le.xml");
is($handler->elements_matched, 1, 'elements matched');

$handler->test_elements(
    "\x{0434}\x{043E}\x{043A}\x{0443}\x{043C}\x{0435}\x{043D}\x{0442}"
);
$parser->parse_uri("testfiles/koi8_r.xml");
is($handler->elements_matched, 1, 'elements matched');

$handler->test_elements( "foo" );
$parser->parse_uri("testfiles/iso8859_1.xml");
is($handler->elements_matched, 1, 'elements matched');

$handler->test_elements( "foo" );
$parser->parse_uri("testfiles/iso8859_2.xml");
is($handler->elements_matched, 1, 'elements matched');

done_testing;
exit;

package TestHandler;

use base qw(XML::SAX::PurePerl::DebugHandler);

sub test_elements {
    my $self = shift;
    $self->{test_elements} = [ @_ ];
    $self->{elements_matched} = 0;
}

sub elements_matched {
    return shift->{elements_matched};
}

sub start_element {
    my $self = shift;
    if ($self->{test_elements} and
        my $value = pop @{$self->{test_elements}}) {
        main::is($_[0]->{Name} => $value, 'element name')
            && $self->{elements_matched}++;
    }
    $self->SUPER::start_element(@_);
}

1;
