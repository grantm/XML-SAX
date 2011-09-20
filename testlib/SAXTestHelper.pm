package SAXTestHelper;

use strict;
use warnings;

require XML::SAX::Base;

my $handler_number = 1;

sub import {
    my $class = shift;

    # Turn on warnings and strict in caller
    strict->import;
    warnings->import;
}


sub next_handler_class {
    return sprintf('SAXTestHelper::Handler%03u', $handler_number++);
}


##############################################################################
# Switch back to the test script's namespace
##############################################################################

package main;

use Test::More;  # imports subs etc into caller

# Ensure unicode characters in test output are properly encoded

my $builder = Test::More->builder;
binmode $builder->output,         ":utf8";
binmode $builder->failure_output, ":utf8";
binmode $builder->todo_output,    ":utf8";

use File::Spec;

use XML::SAX::PurePerl;


sub make_parser {
    my $parser_class = $ENV{SAX_TEST_PARSER} || 'XML::SAX::PurePerl';
    eval "require $parser_class";
    die $@ if $@;
    return $parser_class->new(@_);
}

sub make_handler {
    my($methods) = shift || {};

    my $class = SAXTestHelper::next_handler_class();

    no strict 'refs';
    my $base_class = delete $methods->{_BASE_} || 'XML::SAX::Base';
    @{ $class . '::ISA' } = ( $base_class );

    while(my($name, $code) = each %$methods) {
        die "expected method name, got $name" if ref $name;
        die "expected coderef got $code" unless UNIVERSAL::isa($code, 'CODE');
        *{ $class . '::' . $name } = $code;
    }
    return $class->new( @_ );
}

1;
