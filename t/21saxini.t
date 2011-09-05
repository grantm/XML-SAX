#!/usr/bin/perl -w

use strict;
use Test::More tests => 8;

use File::Basename qw(dirname);
use File::Spec;
use File::Path;
use Fatal qw(open close chdir mkpath);
use XML::SAX;
use vars qw(*FILE);

my $temp_lib = File::Spec->catdir(dirname($0), 'temp_lib');
my $ini_file = File::Spec->catfile($temp_lib, 'SAX.ini');

is(@{XML::SAX->parsers}, 0, 'No Parser present');
eval{XML::SAX->add_parser(q(XML::SAX::PurePerl));};
is($@, '', 'Added parser XML::SAX::PurePerl');
is(@{XML::SAX->parsers}, 1, 'One parser present');

rmtree($temp_lib, 0, 0);
mkpath($temp_lib, 0, 0777);

push @INC, $temp_lib;
write_file(File::Spec->catfile($temp_lib, 'TestParserPackage.pm'), <<EOT);
package TestParserPackage;
use XML::SAX::Base;
\@ISA = qw(XML::SAX::Base);
sub new { 
    return bless {}, shift
}
sub supported_features {
    return ('http://axkit.org/sax/frobnosticating');
}
1;
EOT

my $parser;

# Test we can get TestParserPackage out
write_file($ini_file, 'ParserPackage = TestParserPackage');
$parser = XML::SAX::ParserFactory->parser();
isa_ok($parser, "TestParserPackage");

# Test we can get XML::SAX::PurePerl out
write_file($ini_file, 'ParserPackage = XML::SAX::PurePerl');
$parser = XML::SAX::ParserFactory->parser();
isa_ok($parser, "XML::SAX::PurePerl");

# Test we can ask for a frobnosticating parser, but not get it
write_file($ini_file, 'http://axkit.org/sax/frobnosticating = 1');
$parser = XML::SAX::ParserFactory->parser();
isa_ok($parser, "XML::SAX::PurePerl");

# Test we can ask for a frobnosticating parser, and get it
XML::SAX->add_parser('TestParserPackage');
$parser = XML::SAX::ParserFactory->parser();
isa_ok($parser, "TestParserPackage");

# Test we can get a namespaces parser
write_file($ini_file, 'http://xml.org/sax/features/namespaces = 1');
$parser = XML::SAX::ParserFactory->parser();
isa_ok($parser, "XML::SAX::PurePerl");

sub write_file {
    my ($file, $data) = @_;
    open(FILE, ">$file");
    print FILE $data, "\n";
    close FILE;
}
