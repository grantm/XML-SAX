use Test::More;

use strict;
use warnings;

use XML::SAX::PurePerl;
use XML::SAX::PurePerl::DebugHandler;
use IO::File;

my $handler = XML::SAX::PurePerl::DebugHandler->new();
isa_ok($handler => 'XML::SAX::PurePerl::DebugHandler');

my $parser = XML::SAX::PurePerl->new(Handler => $handler);
isa_ok($parser => 'XML::SAX::PurePerl');
isa_ok($parser => 'XML::SAX::Base');

my $file = IO::File->new("testfiles/01.xml") || die $!;
ok($file, 'opened test file');

$parser->parse_file($file);
ok($handler->{seen}{start_document}, 'start_document called');
ok($handler->{seen}{end_document}, 'end_document called');

done_testing();

