use Test::More;

use strict;
use warnings;

use XML::SAX::PurePerl;
use XML::SAX::PurePerl::DebugHandler;

my $xml_string = do { local $/ = undef; my $data = <DATA>; };

my $parser = XML::SAX::PurePerl->new(Handler =>  My::SAXFilter->new());
$parser->parse_string($xml_string);

done_testing();
exit;


package My::SAXFilter;

use base qw(XML::SAX::Base);

sub processing_instruction {
    my $this = shift;
    my $data = shift;

    main::is(
        $data->{Target},
        "xml-stylesheet",
        '$data->{Target}'
    );
    main::is(
        $data->{Data},
        "type=\"text/xsl\" href=\"processorinxml/base.xsl\"",
        '$data->{Data}'
    );
}

__END__
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="processorinxml/base.xsl"?>
<body/>
