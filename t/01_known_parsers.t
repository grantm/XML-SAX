#!/usr/bin/perl -w

use strict;
use warnings;

use Test::More;

use XML::SAX;

use File::Basename qw(dirname);
use File::Spec ();

use lib 'testlib';

my $test_lib_dir = 'testlib';

my $config_dir  = File::Spec->catdir(dirname($INC{'XML/SAX.pm'}), 'SAX');
my $config_file = File::Spec->catfile($config_dir, 'ParserDetails.ini');
unlink($config_file) if -e $config_file;

ok(!-e $config_file, 'config file does not exist initially');

# Default parser list should be empty

XML::SAX->do_warn('');
my $parsers = eval{XML::SAX->parsers};
is($@, '', 'got default parser list');
like(XML::SAX->last_warning, qr/could not find ParserDetails.ini/, 'got expected warning');
isa_ok($parsers, 'ARRAY');
is(scalar(@$parsers), 0, 'default list of parsers is empty');

ok(!-e $config_file, 'config file still does not exist');


# Try saving

eval{XML::SAX->save_parsers};
is($@, '', 'parsers saved successfully');

ok(-e $config_file, "config file '$config_file' was created");


# Try adding a parser

eval{XML::SAX->add_parser('MockSAXParser')};
is($@, '', 'parser added successfully');

$parsers = eval{XML::SAX->parsers};
is($@, '', 'got new parser list');
isa_ok($parsers, 'ARRAY');
is(scalar(@$parsers), 1, 'parser list now has one entry');


# Inspect the entry that was returned

my($p) = @$parsers;

isa_ok($p, 'HASH', 'parser definition is a hash');
is($p->{Name}, 'MockSAXParser', "parser name is MockSAXParser");
my $f = $p->{Features};
isa_ok($f, 'HASH', 'feature list is a hash');
ok($f->{'http://xml.org/sax/features/namespaces'}, 'parser supports namespaces');
# These two are made up
ok($f->{'http://xml.org/sax/features/namespaces'}, 'parser supports telepathy');
ok(!$f->{'http://xml.org/sax/features/compression'}, 'parser does not support compression');


# Try adding the same parser again

eval{XML::SAX->add_parser('MockSAXParser')};
is($@, '', 'parser added successfully');

$parsers = eval{XML::SAX->parsers};
is($@, '', 'got new parser list');
is(scalar(@$parsers), 1, 'parser list still only has one entry');


# Try loading from a custom config file

XML::SAX->do_warn('');
eval{XML::SAX->load_parsers($test_lib_dir)};
is($@, '',"loaded $test_lib_dir/ParserDetails.ini");
is(XML::SAX->last_warning, '', 'no warnings resulted from load');

$parsers = eval{XML::SAX->parsers};
is($@, '', 'got new parser list');
is(scalar(@$parsers), 2, 'parser list now has two entries');

is($parsers->[0]->{Name}, 'MockSAXParser',      '1st is MockSAXParser');
is($parsers->[1]->{Name}, 'XML::SAX::PurePerl', '2nd is XML::SAX::PurePerl');


# Try adding our mock parser again

eval{XML::SAX->add_parser('MockSAXParser')};
is($@, '', 'parser added successfully');

$parsers = eval{XML::SAX->parsers};
is($@, '', 'got new parser list');
is(scalar(@$parsers), 2, 'parser list still only has two entries');

is($parsers->[0]->{Name}, 'XML::SAX::PurePerl', '1st is now XML::SAX::PurePerl');
is($parsers->[1]->{Name}, 'MockSAXParser',      '2nd is now MockSAXParser');


# Try removing a parser

eval{XML::SAX->remove_parser('MockSAXParser')};
is($@, '', 'parser removed successfully');
is(scalar(@$parsers), 1, 'parser list now only has one entry');

is($parsers->[0]->{Name}, 'XML::SAX::PurePerl', 'remaining XML::SAX::PurePerl');

done_testing();
exit;

