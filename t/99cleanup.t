#!/usr/bin/perl -w

use Test::More;

use File::Basename qw(dirname);
use File::Spec;
use File::Path;

use XML::SAX;

my $sax_dir = File::Spec->catdir(dirname($INC{'XML/SAX.pm'}), 'SAX');

is(unlink(File::Spec->catfile($sax_dir, 'ParserDetails.ini')),
    1,
    'delete ParserDetails.ini'
);

my $temp_lib = File::Spec->catdir(dirname($0), 'temp_lib');
rmtree($temp_lib, 0, 0);

done_testing();

