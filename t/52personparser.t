#!/usr/bin/perl -w

use Test::More tests => 3;
use Data::Dumper;
use feature qw(switch);

BEGIN{
	use_ok('XML::SAX');
	use_ok('XML::SAX::ParserFactory');}

my $parser = XML::SAX::ParserFactory->parser(
	Handler => MySAXHandler->new
);

$parser->parse_uri("testfiles/parse.xml");
is(Dumper(($parser->{Handler})->{_allPeople}),q[$VAR1 = [
          bless( {
                   '_lastName' => 'Smith',
                   '_phoneNumber' => {
                                       'home' => '04 555 3333',
                                       'mobile' => '022 555 1234'
                                     },
                   '_firstName' => 'Bob'
                 }, 'Person' ),
          bless( {
                   '_lastName' => 'Jones',
                   '_phoneNumber' => {
                                       'home' => '04 555 6666',
                                       'mobile' => '022 555 9876'
                                     },
                   '_firstName' => 'Mary'
                 }, 'Person' )
        ];
],'Successfully parsed parse.xml');

# SAX handler
package MySAXHandler;

use Data::Dumper;
use Data::Dump qw(dump);
use strict;
use warnings;

sub new {
	my $class = shift;
	my $self = {_currentPerson => undef,
				_currentFirstName => undef,
				_currentLastName => undef,
				_currentPhone => undef,
				_allPeople => []};
	bless $self, $class;
	return $self;
}

#push @{$self->{_allPeople}}, $value;
#
#my @list = (1, 2, 3, 4);
#
#$list[0] == 1;
#$list[1] == 2;
#
#my $list = [1, 2, 3, 4];
#$list->[0]
#$list->[1]
#@{$list}[0]
#
#my $data = {
#	name => 'maryn',
#	favourite_numbers => [1 ,2, 3],
#};
#$data->{name}
#$data->{favourite_numbers}[0]
#pop @{$data->{favouri...}};

sub dumpthem {
	print dump(@_), "\n";
}
sub start_document {
	my ($self, @rest) = @_;
	#dumpthem('start_document: ', @rest);
}
sub end_document { 
	my ($self, @rest) = @_;
	#dumpthem('end_document: ', @rest);
}
sub start_element { 
	my ($self, $elem) = @_;
	#dumpthem('start_element: ', $elem);
	given ($elem->{Name}) {
		when ('person') {$self->{_currentPerson} = Person->new();}
		when ('firstname') {$self->{_currentFirstName} = 'Y';}
		when ('lastname') {$self->{_currentLastName} = 'Z';}
		when ('phone') {$self->{_currentPhone} = $elem->{Attributes}{'{}type'}{Value};}
	}
}
our @row;
sub end_element { 
	my ($self, $elem) = @_;
	#dumpthem('end_element: ', $elem);
	given ($elem->{Name}) {
		when ('person') {
							push(@{$self->{_allPeople}}, $self->{_currentPerson});
							#dumpthem($self->{_currentPerson});
							$self->{_currentPerson} = undef;
						}
		when ('firstname') {$self->{_currentFirstName} = undef;}
		when ('lastname') {$self->{_currentLastName} = undef;}
		when ('phone') {$self->{_currentPhone} = undef;}
	}
}
sub characters { 
	my ($self, $elem) = @_;
	#dumpthem('characters: ', $elem);
	if (defined($self->{_currentPerson})) {
		if (defined($self->{_currentFirstName})) {$self->{_currentPerson}->setFirstName($elem->{Data})};
		if (defined($self->{_currentLastName})) {$self->{_currentPerson}->setLastName($elem->{Data})};
		if (defined($self->{_currentPhone})) {$self->{_currentPerson}->setPhoneNumber($elem->{Data}, $self->{_currentPhone})};
	}
}



package Person;

sub new {
	my $class = shift;
	my $self = {_firstName => "X", _lastName => "X", _phoneNumber => {}};
	bless $self, $class;
	return $self;
}

sub setFirstName {
    my ( $self, $firstName ) = @_;
    $self->{_firstName} = $firstName;
    return $self->{_firstName};
}

sub setLastName {
    my ( $self, $lastName ) = @_;
    $self->{_lastName} = $lastName;
    return $self->{_lastName};
}

sub setPhoneNumber {
    my ( $self, $phone, $type) = @_;
    if ($phone =~ m/^\S.*\S$/) {
		$self->{_phoneNumber}{$type} = $phone;
	}
    return $self->{_phoneNumber};
}

