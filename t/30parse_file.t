use Test::More;

use strict;
use warnings;

use XML::SAX::PurePerl;
use XML::SAX::PurePerl::DebugHandler;
use IO::File;

my $handler = XML::SAX::PurePerl::DebugHandler->new();
ok($handler, 'debug handler');

my $parser = XML::SAX::PurePerl->new(Handler => $handler);
ok($parser, 'PurePerl parser');

my $file1 = IO::File->new("testfiles/01.xml");
ok($file1, 'opened xml file');

eval {
    $parser->parse_file($file1);
};
is($@ => '', 'parsed from filehandle without exception');

my $file2 = "testfiles/01.xml";

eval {
    $parser->parse_file($file2);
};
is($@ => '', 'parsed from file name without exception');

done_testing();

