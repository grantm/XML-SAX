#!/usr/bin/perl -w

use strict;
use warnings;

use Test::More;

my $builder = Test::More->builder;
binmode $builder->output,         ":utf8";
binmode $builder->failure_output, ":utf8";
binmode $builder->todo_output,    ":utf8";

use XML::SAX::PurePerl;

my $parse_exception = 'XML::SAX::Exception::Parse';

my $handler = TestHandler->new(); # see below for the TestHandler class
isa_ok($handler, 'TestHandler');

my $parser = XML::SAX::PurePerl->new(Handler => $handler);
isa_ok($parser, 'XML::SAX::PurePerl');

eval { $parser->parse_string('<?xml') };
isa_ok($@, $parse_exception, 'incomplete xml decl => parse error');

eval { $parser->parse_string(qq{<?xml ?>\n<a />}) };
isa_ok($@, $parse_exception, 'empty xml decl => parse error');
like("$@", qr{version}i, 'error refers to version');

eval { $parser->parse_string(qq{<?xml version="2.0"?>\n<a />}) };
isa_ok($@, $parse_exception, 'bad version => parse error');
like("$@", qr{version}i, 'error refers to version');

eval { $parser->parse_string(qq{<?xml version="1.0"?>\n<a />}) };
is($@, '', 'good version => no parse error');

eval { $parser->parse_string(qq{<?xml version='1.0'?>\n<a />}) };
is($@, '', 'single quotes around version => no parse error');

eval { $parser->parse_string(qq{<?xml version="1.0" ?>\n<a />}) };
is($@, '', 'good version extra whitespace => no parse error');

eval { $parser->parse_string(qq{<?xml version="1.0" ?>\n<a>\xE2\x82\xAC</a>}) };
is($@, '', 'no encoding decl + utf8 => no parse error');

eval { $parser->parse_string(qq{<?xml version="1.0"encoding="UTF-8"?>\n<a>\xE2\x82\xAC</a>}) };
isa_ok($@, $parse_exception, 'no space before encoding => parse error');

eval { $parser->parse_string(qq{<?xml version="1.0" encoding="UTF-8"?>\n<a>\xE2\x82\xAC</a>}) };
is($@, '', 'space before encoding decl + utf8 => no parse error');

eval { $parser->parse_string(qq{<?xml version='1.0' encoding='UTF-8'?>\n<a>\xE2\x82\xAC</a>}) };
is($@, '', 'same again with single quotes => no parse error');

eval { $parser->parse_string(qq{<?xml version="1.0" ?>\n<a>\xE9</a>}) };
ok($@, 'no encoding decl + latin1 => parse error');
like("$@", qr{\b(en|de|uni)cod}i, 'error refers to encoding');

eval { $parser->parse_string(qq{<?xml version="1.0" encoding="iso8859-1"?>\n<a>\xE9</a>}) };
is($@, '', 'latin1 + encoding decl => no parse error');

eval { $parser->parse_string(qq{<?xml version="1.0" standalone="yes"?>\n<a />}) };
is($@, '', 'version + standalone-Y => no parse error');

eval { $parser->parse_string(qq{<?xml version="1.0"standalone="yes"?>\n<a />}) };
isa_ok($@, $parse_exception, 'no space before standalone => parse error');

eval { $parser->parse_string(qq{<?xml version="1.0" standalone="yes" ?>\n<a />}) };
is($@, '', 'version + standalone-Y + extra whitespace => no parse error');

eval { $parser->parse_string(qq{<?xml version="1.0" standalone="no" ?>\n<a />}) };
is($@, '', 'version + standalone-N => no parse error');

eval { $parser->parse_string(qq{<?xml version="1.0" standalone="maybe" ?>\n<a />}) };
isa_ok($@, $parse_exception, 'invalid standalone value => parse error');

eval { $parser->parse_string(qq{<?xml version="1.0" encoding="UTF-8"standalone="yes"?>\n<a />}) };
isa_ok($@, $parse_exception, 'no space after encoding => parse error');

eval { $parser->parse_string(qq{<?xml version="1.0">\n<a />}) };
isa_ok($@, $parse_exception, 'broken PI close => parse error');

done_testing();
exit;

package TestHandler;
use base 'XML::SAX::Base';

1;
