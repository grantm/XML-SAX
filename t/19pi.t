#!/usr/bin/perl -w

use Test::More tests => 2;
use XML::SAX::PurePerl;
use XML::SAX::PurePerl::DebugHandler;

my $value = do { local $/ = undef; my $data = <DATA>; };

my $parser = XML::SAX::PurePerl->new(Handler =>  My::SAXFilter->new());
$parser->parse_string($value);

package My::SAXFilter;

use base qw(XML::SAX::Base);

sub processing_instruction {
    my $this = shift;
    my $data = shift;

    main::is($data->{Target}, "xml-stylesheet");
    main::is($data->{Data}, "type=\"text/xsl\" href=\"processorinxml/base.xsl\"");
}

__END__
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="processorinxml/base.xsl"?>
<body/>
