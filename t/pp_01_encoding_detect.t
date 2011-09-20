#!/usr/bin/perl -w

use lib 'testlib';
use SAXTestHelper;  # imports Test::More, strict etc

my $temp_xml_file = File::Spec->catfile('t', 'enc_det.xml');
END { unlink($temp_xml_file); }

my $handler = make_handler({
    start_document => sub { $_[0]->{char_data} = '';             },
    characters     => sub { $_[0]->{char_data} .= $_[1]->{Data}; },
    end_document   => sub { $_[0]->{char_data};                  },
});
isa_ok($handler, 'XML::SAX::Base');

my $parser = make_parser(Handler => $handler);
can_ok($parser, 'parse_string');

test_parse_xml_string(
    encoding => "ASCII",
    document => "<a>ASCII Text</a>",
    expected => "ASCII Text",
);

SKIP: {
    skip "can't handle non-ASCII data on Perl version $]", 1 if $] < 5.007002;

    test_parse_xml_string(
        encoding => "UCS-4BE",
        document => [qw(
                        00 00 fe ff 00 00 00 3c 00 00 00 61 00 00 00 3e
                        00 00 00 55 00 00 00 43 00 00 00 53 00 00 00 2d
                        00 00 00 34 00 00 00 42 00 00 00 45 00 00 00 3a
                        00 00 00 20 00 00 00 43 00 00 01 01 00 00 00 66
                        00 00 00 e9 00 00 20 ac 00 00 00 3c 00 00 00 2f
                        00 00 00 61 00 00 00 3e 00 00 00 0a
                    )],
        expected => "UCS-4BE: C\x{101}f\x{e9}\x{20ac}",
    );

    test_parse_xml_string(
        encoding => "UCS-4LE",
        document => [qw(
                        ff fe 00 00 3c 00 00 00 61 00 00 00 3e 00 00 00
                        55 00 00 00 43 00 00 00 53 00 00 00 2d 00 00 00
                        34 00 00 00 4c 00 00 00 45 00 00 00 3a 00 00 00
                        20 00 00 00 43 00 00 00 01 01 00 00 66 00 00 00
                        e9 00 00 00 ac 20 00 00 3c 00 00 00 2f 00 00 00
                        61 00 00 00 3e 00 00 00 0a 00 00 00
                    )],
        expected => "UCS-4LE: C\x{101}f\x{e9}\x{20ac}",
    );

    test_parse_xml_string(
        encoding => "UCS-4BE (No BOM)",
        document => [qw(
                        00 00 00 3c 00 00 00 61 00 00 00 3e 00 00 00 55
                        00 00 00 43 00 00 00 53 00 00 00 2d 00 00 00 34
                        00 00 00 42 00 00 00 45 00 00 00 3a 00 00 00 20
                        00 00 00 43 00 00 01 01 00 00 00 66 00 00 00 e9
                        00 00 20 ac 00 00 00 3c 00 00 00 2f 00 00 00 61
                        00 00 00 3e 00 00 00 0a
                    )],
        expected => "UCS-4BE: C\x{101}f\x{e9}\x{20ac}",
    );

    test_parse_xml_string(
        encoding => "UCS-4LE (No BOM)",
        document => [qw(
                        3c 00 00 00 61 00 00 00 3e 00 00 00 55 00 00 00
                        43 00 00 00 53 00 00 00 2d 00 00 00 34 00 00 00
                        4c 00 00 00 45 00 00 00 3a 00 00 00 20 00 00 00
                        43 00 00 00 01 01 00 00 66 00 00 00 e9 00 00 00
                        ac 20 00 00 3c 00 00 00 2f 00 00 00 61 00 00 00
                        3e 00 00 00 0a 00 00 00
                    )],
        expected => "UCS-4LE: C\x{101}f\x{e9}\x{20ac}",
    );

    test_parse_xml_string(
        encoding => "UCS-2BE",
        document => [qw(
                        fe ff 00 3c 00 61 00 3e 00 55 00 43 00 53 00 2d
                        00 32 00 42 00 45 00 3a 00 20 00 43 01 01 00 66
                        00 e9 20 ac 00 3c 00 2f 00 61 00 3e 00 0a
                    )],
        expected => "UCS-2BE: C\x{101}f\x{e9}\x{20ac}",
    );

    test_parse_xml_string(
        encoding => "UCS-2LE",
        document => [qw(
                        ff fe 3c 00 61 00 3e 00 55 00 43 00 53 00 2d 00
                        32 00 4c 00 45 00 3a 00 20 00 43 00 01 01 66 00
                        e9 00 ac 20 3c 00 2f 00 61 00 3e 00 0a 00
                    )],
        expected => "UCS-2LE: C\x{101}f\x{e9}\x{20ac}",
    );

    test_parse_xml_string(
        encoding => "UCS-2BE (No BOM)",
        document => [qw(
                        00 3c 00 3f 00 78 00 6d 00 6c 00 20 00 76 00 65
                        00 72 00 73 00 69 00 6f 00 6e 00 3d 00 22 00 31
                        00 2e 00 30 00 22 00 3f 00 3e 00 0a 00 3c 00 61
                        00 3e 00 55 00 43 00 53 00 2d 00 32 00 42 00 45
                        00 3a 00 20 00 43 01 01 00 66 00 e9 20 ac 00 3c
                        00 2f 00 61 00 3e 00 0a
                    )],
        expected => "UCS-2BE: C\x{101}f\x{e9}\x{20ac}",
    );

    test_parse_xml_string(
        encoding => "UCS-2LE (No BOM)",
        document => [qw(
                        3c 00 3f 00 78 00 6d 00 6c 00 20 00 76 00 65 00
                        72 00 73 00 69 00 6f 00 6e 00 3d 00 22 00 31 00
                        2e 00 30 00 22 00 3f 00 3e 00 0a 00 3c 00 61 00
                        3e 00 55 00 43 00 53 00 2d 00 32 00 4c 00 45 00
                        3a 00 20 00 43 00 01 01 66 00 e9 00 ac 20 3c 00
                        2f 00 61 00 3e 00 0a 00
                    )],
        expected => "UCS-2LE: C\x{101}f\x{e9}\x{20ac}",
    );

    test_parse_xml_string(
        encoding => "UTF-8",
        document => [qw(
                        ef bb bf 3c 61 3e 55 54 46 2d 38 3a 20 43 c4 81
                        66 c3 a9 e2 82 ac 3c 2f 61 3e 0a
                    )],
        expected => "UTF-8: C\x{101}f\x{e9}\x{20ac}",
    );

    test_parse_xml_string(
        encoding => "UTF-8 (No BOM)",
        document => [qw(
                        3c 3f 78 6d 6c 20 76 65 72 73 69 6f 6e 3d 22 31
                        2e 30 22 3f 3e 0a 3c 61 3e 55 54 46 2d 38 3a 20
                        43 c4 81 66 c3 a9 e2 82 ac 3c 2f 61 3e 0a
                    )],
        expected => "UTF-8: C\x{101}f\x{e9}\x{20ac}",
    );

    test_parse_xml_string(
        encoding => "UTF-8 (prolog but no encoding decl)",
        document => [qw(
                        3c 3f 78 6d 6c 20 76 65 72 73 69 6f 6e 3d 22 31
                        2e 30 22 3f 3e 0a 3c 61 3e 55 54 46 2d 38 3a 20
                        43 c4 81 66 c3 a9 e2 82 ac 3c 2f 61 3e 0a
                    )],
        expected => "UTF-8: C\x{101}f\x{e9}\x{20ac}",
    );

    test_parse_xml_string(
        encoding => "UTF-8 (prolog with encoding decl)",
        document => [qw(
                        3c 3f 78 6d 6c 20 76 65 72 73 69 6f 6e 3d 22 31
                        2e 30 22 20 65 6e 63 6f 64 69 6e 67 3d 22 55 54
                        46 2d 38 22 3f 3e 0a 3c 61 3e 55 54 46 2d 38 3a
                        20 43 c4 81 66 c3 a9 e2 82 ac 3c 2f 61 3e 0a
                    )],
        expected => "UTF-8: C\x{101}f\x{e9}\x{20ac}",
    );

    test_parse_xml_string(
        encoding => "UTF-8 (no prolog with leading whitespace)",
        document => [qw(
                        0a 20 0a 09 3c 61 3e 55 54 46 2d 38 3a 20 43 c4
                        81 66 c3 a9 e2 82 ac 3c 2f 61 3e 0a
                    )],
        expected => "UTF-8: C\x{101}f\x{e9}\x{20ac}",
    );

    test_parse_xml_string(
        encoding => "ISO8859-1",
        document => [qw(
                        3c 3f 78 6d 6c 20 76 65 72 73 69 6f 6e 3d 22 31
                        2e 30 22 20 65 6e 63 6f 64 69 6e 67 3d 22 49 53
                        4f 38 38 35 39 2d 31 22 3f 3e 0a 3c 61 3e 49 53
                        4f 38 38 35 39 2d 31 3a 20 43 e1 66 e9 3c 2f 61
                        3e 0a
                    )],
        expected => "ISO8859-1: C\x{e1}f\x{e9}",
    );

# warn("koi8_r\n");
eval{$parser->parse_uri("testfiles/14c_koi8_r.xml");};
is($@, '', 'no errors parsing: testfiles/14c_koi8_r.xml');

# warn("8859-2\n");
eval{$parser->parse_uri("testfiles/14e_iso8859.xml");};
is($@, '', 'no errors parsing: testfiles/14e_iso8859.xml');

}

done_testing();
exit;

sub test_parse_xml_string {
    my %arg = @_;

    # Get XML document as a byte string

    my $xml = $arg{document};
    if(ref($xml)) {
        $xml = pack 'C*', map { hex } @$xml;
    }

    # Save the bytes to a temp file

    open my $fh, '>', $temp_xml_file or die "open($temp_xml_file): $!";
    print $fh $xml;
    close($fh);

    # Try parsing from the byte string

    my $result = eval{ $parser->parse_string($xml); };
    is($@, '', "parsed $arg{encoding} string without error");
    is($result, $arg{expected}, 'got the expected data');

    # And parse again from a named file

    $result = eval{ $parser->parse_uri($temp_xml_file); };
    is($@, '', "parsed $arg{encoding} file without error");
    is($result, $arg{expected}, 'got the expected data');

    # And again from a file handle

    open $fh, '<', $temp_xml_file or die "open($temp_xml_file): $!";
    $result = eval{ $parser->parse_file($fh); };
    is($@, '', "parsed $arg{encoding} file without error");
    is($result, $arg{expected}, 'got the expected data');
    close($fh);
}

