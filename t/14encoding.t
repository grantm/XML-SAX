#!/usr/bin/perl -w

use Test::More;
BEGIN { $tests = 0;
    if ($] >= 5.007002) { $tests = 9 }
    plan tests => $tests;
}
if ($tests) {
use XML::SAX::PurePerl;

my $handler = TestHandler->new(); # see below for the TestHandler class
isa_ok($handler, 'TestHandler');

my $parser = XML::SAX::PurePerl->new(Handler => $handler);
isa_ok($parser, 'XML::SAX::PurePerl');

# warn("utf-16\n");
# verify that the first element is correctly decoded
eval{
	$handler->{test_elements} = [ "\x{9031}\x{5831}" ];
	$parser->parse_uri("testfiles/utf-16.xml");
};
is($@, '');

# warn("utf-16le\n");
eval{
	$handler->{test_elements} = [ "foo" ];
	$parser->parse_uri("testfiles/utf-16le.xml");
};
is($@, '');

# warn("koi8_r\n");
eval{$parser->parse_uri("testfiles/koi8_r.xml");};
is($@, '');

# warn("8859-1\n");
eval{$parser->parse_uri("testfiles/iso8859_1.xml");};
is($@, '');

# warn("8859-2\n");
eval{$parser->parse_uri("testfiles/iso8859_2.xml");};
is($@, '');
}

package TestHandler;
use XML::SAX::PurePerl::DebugHandler;
use base qw(XML::SAX::PurePerl::DebugHandler);
use Test::More;

sub start_element {
    my $self = shift;
    if ($self->{test_elements} and
        my $value = pop @{$self->{test_elements}}) {
        is($_[0]->{Name}, $value);
    }
    $self->SUPER::start_element(@_);
}

1;
