use strict;
use warnings;

use Test;
BEGIN { plan tests => 5 }

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

ok($handler->profile_id_exists(15), 1);

ok($handler->profile_id_exists(14), 1);
exit;


package MySAXHandler;
use base qw(XML::SAX::Base);
use Data::Dumper;

sub start_document { shift->{ProfileIDs} = {}; }

sub start_element {
    my ( $self, $data ) = @_;
    my %attrs = %{$data->{Attributes}};
    return unless $data->{LocalName} eq 'Profile' && $data->{Name} eq 'Profile';
    $self->{ProfileIDs}{$attrs{'{}ID'}{Value}}++;
}

sub profile_id_exists {
    my ( $self, $data ) = @_;
    return exists $self->{ProfileIDs}{$data};
}

1;
