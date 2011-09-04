#!/usr/bin/perl -w

use strict;
use warnings;

use Test::More tests => 32;

use XML::SAX::PurePerl;
 
my $handler = MySAXHandler->new();
isa_ok($handler, 'MySAXHandler');
 
my $parser = XML::SAX::PurePerl->new(Handler => $handler);
isa_ok($parser, 'XML::SAX::PurePerl');
 
my $file = "testfiles/50.xml";
 
eval {
    $parser->parse_file($file);
};
is($@, '');

for my $id ( 10 .. 13 )
{
    is($handler->profile_id_exists($id), 1, "Profile ID $id exists");
}

TODO: {
    local $TODO = 'Fix pending for bug #20126';
    is($handler->profile_id_exists(14), 1, "Profile ID 14 exists");
}

for my $id ( 15 .. 18 )
{
    is($handler->profile_id_exists($id), 1, "Profile ID $id exists");
}

for my $id (
    1000409 .. 1000412,
    4100 .. 4106,
    4151 .. 4154,
    4201 .. 4204,
    5000
)
{ # 20 tests
    is($handler->subscriber_id_exists($id), 1);
}

exit;


package MySAXHandler;
use base qw(XML::SAX::Base);
use Data::Dumper;

sub start_document {
    shift->{ProfileIDs} = {};
    shift->{SubscriberIDs} = {};
}

sub start_element {
    my ( $self, $data ) = @_;
    my %attrs = %{$data->{Attributes}};
    if ( $data->{LocalName} eq 'Profile' && $data->{Name} eq 'Profile' )
    {
        $self->{ProfileIDs}{$attrs{'{}ID'}{Value}}++;
    }
    if ( $data->{LocalName} eq 'Subscriber' && $data->{Name} eq 'Subscriber' )
    {
        $self->{SubscriberIDs}{$attrs{'{}ID'}{Value}}++;
    }
    
}

sub profile_id_exists {
    my ( $self, $data ) = @_;
    return exists $self->{ProfileIDs}{$data};
}

sub subscriber_id_exists {
    my ( $self, $data ) = @_;
    return exists $self->{SubscriberIDs}{$data};
}

1;
