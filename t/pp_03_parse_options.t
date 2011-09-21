#!/usr/bin/perl -w

use lib 'testlib';
use SAXTestHelper;  # imports Test::More, strict etc

my $parse_exception = 'XML::SAX::Exception::Parse';


# Try specifying encoding using the 'Source' options to parser

my $handler = make_handler({
    start_document => sub { $_[0]->{char_data} = '';             },
    characters     => sub { $_[0]->{char_data} .= $_[1]->{Data}; },
    end_document   => sub { $_[0]->{char_data};                  },
});

my $parser = make_parser(Handler => $handler);

my $latin1_bytes = qq{<a>\xE9</a>};

my $result = eval { $parser->parse_string($latin1_bytes) };
isa_ok($@, $parse_exception, 'latin1 bytes without decl => error');
is($result, undef, 'no data was returned');

$parser = make_parser(
    Handler => $handler,
    Source => { Encoding => 'ISO8859-1' },
);

$result = eval { $parser->parse_string($latin1_bytes) };
is($@, '','same bytes with encoding set via parser option => no parse error');
is($result, "\x{E9}", 'data decoded correctly');


# Pass identifiers in Source options and retrieve via document locator

$handler = make_handler({
    set_document_locator => sub { $_[0]->{locator} = $_[1]; },
    start_element => sub {
        $_[0]->{loc}{XMLVersion}   = $_[0]->{locator}{XMLVersion};
        $_[0]->{loc}{PublicId}     = $_[0]->{locator}{PublicId};
        $_[0]->{loc}{SystemId}     = $_[0]->{locator}{SystemId};
        $_[0]->{loc}{Encoding}     = $_[0]->{locator}{Encoding};
        $_[0]->{loc}{LineNumber}   = $_[0]->{locator}{LineNumber};
        $_[0]->{loc}{ColumnNumber} = $_[0]->{locator}{ColumnNumber};
    },
    end_document => sub { $_[0]->{loc}; },
});

$latin1_bytes = qq{<?xml version="1.0"?>\n<a>\xE9</a>};
$parser = make_parser(
    Handler => $handler,
    Source => {
        PublicId => '-//ORG//DTD APP 1.0 Component//EN',
        SystemId => 'http://org.org/app-1.0-component.dtd',
        Encoding => 'ISO8859-1',
    },
);

my $locator = eval { $parser->parse_string($latin1_bytes) };
is($@, '', 'parsed again with no errors');
ok($locator, "got a locator 'object'");
is($locator->{XMLVersion}, '1.0', 'XMLVersion looks good');
is($locator->{PublicId}, '-//ORG//DTD APP 1.0 Component//EN', 'PublicId looks good');
is($locator->{SystemId}, 'http://org.org/app-1.0-component.dtd', 'SystemId looks good');
is($locator->{Encoding}, 'ISO8859-1', 'Encoding looks good');
is($locator->{LineNumber}, 2, 'LineNumber of first element looks good');
is($locator->{ColumnNumber}, 4, 'ColumnNumber of first element looks good');
is($locator->{bogus}, undef, 'non-standard key returns undef');
ok(!exists($locator->{bogus}), 'non-standard key does not exist');
ok(scalar(keys %$locator) >= 6, 'expected number of keys present');

done_testing();
exit;


