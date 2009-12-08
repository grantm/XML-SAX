use strict;
use warnings;

use Test;
BEGIN { plan tests => 32 }

use XML::SAX::PurePerl;
 
my $handler = MySAXHandler->new();
ok($handler);
 
my $parser = XML::SAX::PurePerl->new(Handler => $handler);
ok($parser);
 
my $file = "testfiles/50.xml";
 
eval {
    $parser->parse_file($file);
};
print $@;
ok(!$@);

for my $id ( 10 .. 18 ) # 9 tests
{
    ok($handler->profile_id_exists($id), 1);
}

for my $id (
    1000409 .. 1000412,
    4100 .. 4106,
    4151 .. 4154,
    4201 .. 4204,
    5000
)
{ # 20 tests
    ok($handler->subscriber_id_exists($id), 1);
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
