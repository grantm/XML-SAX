#!/usr/bin/perl -w

use Test::More tests => 1;
use File::Spec;
is(unlink(
    File::Spec->catdir(qw(blib lib XML SAX ParserDetails.ini))),
    1,
    'delete ParserDetails.ini'
);
