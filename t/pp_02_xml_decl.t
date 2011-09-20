#!/usr/bin/perl -w

use lib 'testlib';
use SAXTestHelper;  # imports Test::More, strict etc

my $temp_xml_file = File::Spec->catfile('t', 'xml_decl.xml');
END { unlink($temp_xml_file); }

my $parse_exception = 'XML::SAX::Exception::Parse';

my $handler = make_handler({
    start_document => sub { $_[0]->{char_data} = '';             },
    characters     => sub { $_[0]->{char_data} .= $_[1]->{Data}; },
    end_document   => sub { $_[0]->{char_data};                  },
});

my $parser = make_parser(Handler => $handler);

try_parse(
    'incomplete xml decl => parse error',
    '<?xml',
    $parse_exception,
);

try_parse(
    'empty xml decl => parse error',
    qq{<?xml ?>\n<a />},
    $parse_exception,
    sub {
        like("$_[0]", qr{version}i, '  error refers to version');
        is($_[0]->{LineNumber}, 1, '  exception notes expected line number');
        is($_[0]->{ColumnNumber}, 6, '  exception notes expected col number');
    }
);

try_parse(
    'bad version => parse error',
    qq{<?xml version="2.0"?>\n<a />},
    $parse_exception,
    sub {
        like("$_[0]", qr{version}i, '  error refers to version');
        is($_[0]->{LineNumber}, 1, '  exception notes expected line number');
        is($_[0]->{ColumnNumber}, 6, '  exception notes expected col number');
    }
);

try_parse(
    'good version => no parse error',
    qq{<?xml version="1.0"?>\n<a />},
    '',
);

try_parse(
    'single quotes around version => no parse error',
    qq{<?xml version='1.0'?>\n<a />},
    '',
);

try_parse(
    'good version extra whitespace => no parse error',
    qq{<?xml version="1.0" ?>\n<a />},
    ''
);

try_parse(
    'no encoding decl + utf8 => no parse error',
    qq{<?xml version="1.0" ?>\n<a>\xE2\x82\xAC</a>},
    ''
);

try_parse(
    'no space before encoding => parse error',
    qq{<?xml version="1.0"encoding="UTF-8"?>\n<a>\xE2\x82\xAC</a>},
    $parse_exception,
);

try_parse(
    'space before encoding decl + utf8 => no parse error',
    qq{<?xml version="1.0" encoding="UTF-8"?>\n<a>\xE2\x82\xAC</a>},
    ''
);

try_parse(
    'same again with single quotes => no parse error',
    qq{<?xml version='1.0' encoding='UTF-8'?>\n<a>\xE2\x82\xAC</a>},
    ''
);

try_parse(
    'same again with trailing space => no parse error',
    qq{<?xml version='1.0' encoding='UTF-8' ?>\n<a>\xE2\x82\xAC</a>},
    ''
);

try_parse(
    'no encoding decl + latin1 => parse error',
    qq{<?xml version="1.0" ?>\n<a>\xE9</a>},
    $parse_exception,
    sub {
        like("$_[0]", qr{\b(en|de|uni)cod}i, 'error refers to encoding');
    }
);

try_parse(
    'latin1 + encoding decl => no parse error',
    qq{<?xml version="1.0" encoding="iso8859-1"?>\n<a>\xE9</a>},
    ''
);

try_parse(
    'version + standalone-Y => no parse error',
    qq{<?xml version="1.0" standalone="yes"?>\n<a />},
    ''
);

try_parse(
    'no space before standalone => parse error',
    qq{<?xml version="1.0"standalone="yes"?>\n<a />},
    $parse_exception,
);

try_parse(
    'version + standalone-Y + extra whitespace => no parse error',
    qq{<?xml version="1.0" standalone="yes" ?>\n<a />},
    ''
);

try_parse(
    'version + standalone-N => no parse error',
    qq{<?xml version="1.0" standalone="no" ?>\n<a />},
    ''
);

try_parse(
    'invalid standalone value => parse error',
    qq{<?xml version="1.0" standalone="maybe" ?>\n<a />},
    $parse_exception
);

try_parse(
    'no space after encoding => parse error',
    qq{<?xml version="1.0" encoding="UTF-8"standalone="yes"?>\n<a />},
    $parse_exception
);

try_parse(
    'broken PI close => parse error',
    qq{<?xml version="1.0">\n<a />},
    $parse_exception
);


# TODO: Use an external entity (supported?) to test TextDecl

done_testing();
exit;


sub try_parse {
    my($desc, $bytes, $expected, $coderef) = @_;
    my $line = (caller())[2];

    # Save the bytes to a temp file

    open my $fh, '>', $temp_xml_file or die "open($temp_xml_file): $!";
    print $fh $bytes;
    close($fh);

    # Try parsing from the byte string

    ok(1, "Line $line: $desc");
    eval { $parser->parse_string($bytes) };
    my $exception = $@;
    if($expected) {
        isa_ok($exception, $expected, '  parse from string exception');
    }
    else {
        is($exception, '', '  no error parsing from string');
    }
    $coderef->($exception) if $coderef;

    # And parse again from a named file

    eval { $parser->parse_uri($temp_xml_file) };
    $exception = $@;
    if($expected) {
        isa_ok($exception, $expected, '  parse from file exception');
    }
    else {
        is($exception, '', '  no error parsing from file');
    }
    $coderef->($exception) if $coderef;

    # And again from a filehandle

    open $fh, '<', $temp_xml_file or die "open($temp_xml_file): $!";
    eval { $parser->parse_file($fh) };
    $exception = $@;
    if($expected) {
        isa_ok($exception, $expected, '  parse from filehandle exception');
    }
    else {
        is($exception, '', '  no error parsing from filehandle');
    }
    $coderef->($exception) if $coderef;

}

