# $Id$

package XML::SAX::PurePerl::Reader;

use strict;
use XML::SAX::PurePerl::Reader::Stream;
use XML::SAX::PurePerl::Reader::String;
use XML::SAX::PurePerl::Reader::URI;
use XML::SAX::PurePerl::Productions qw( $SingleChar );

if ($] >= 5.007002) {
    require XML::SAX::PurePerl::Reader::UnicodeExt;
}
else {
    require XML::SAX::PurePerl::Reader::NoUnicodeExt;
}

sub new {
    my $class = shift;
    my $thing = shift;
    
    # try to figure if this $thing is a handle of some sort
    if (ref($thing) && UNIVERSAL::isa($thing, 'IO::Handle')) {
        return XML::SAX::PurePerl::Reader::Stream->new($thing)->init;
    }
    my $ioref;
    if (tied($thing)) {
        my $class = ref($thing);
        no strict 'refs';
        $ioref = $thing if defined &{"${class}::TIEHANDLE"};
    }
    else {
        eval {
            $ioref = *{$thing}{IO};
        };
        undef $@;
    }
    if ($ioref) {
        return XML::SAX::PurePerl::Reader::Stream->new($thing)->init;
    }
    
    if ($thing =~ /</) {
        # assume it's a string
        return XML::SAX::PurePerl::Reader::String->new($thing)->init;
    }
    
    # assume it is a uri
    return XML::SAX::PurePerl::Reader::URI->new($thing)->init;
}

sub init {
    my $self = shift;
    $self->{line} = 1;
    $self->{column} = 1;
    $self->nextchar;
    return $self;
}

sub match {
    my $self = shift;
    if ($self->match_nocheck(@_)) {
        if ($self->{matched} =~ $SingleChar) {
            return 1;
        }
        throw XML::SAX::Exception ( Message => "Not a valid XML character: '&#x".sprintf("%X", ord($self->{matched})).";'", reader => $self );
    }
    return 0;
}

sub match_nonext {
    my $self = shift;
    
    return 0 unless defined $self->{current};
    
    foreach my $m (@_) {
        local $^W;
        if (ref($m) eq 'Regexp') {
            if ($self->{current} =~ $m) {
                $self->{matched} = $self->{current};
                return 1;
            }
        }
        elsif ($self->{current} eq $m) {
            $self->{matched} = $self->{current};
            return 1;
        }
    }
    $self->{matched} = '';
    return 0;    
}

sub match_nocheck {
    my $self = shift;
    
    if ($self->match_nonext(@_)) {
        $self->nextchar;

        return 1;
    }
    return 0;
}

sub matched {
    my $self = shift;
    return $self->{matched};
}

my $unpack_type = ($] >= 5.007002) ? 'U*' : 'C*';

sub match_string {
    my $self = shift;
    my ($str) = @_;
    my $matched = '';
    for my $char (map { chr } unpack($unpack_type, $str)) {
        if ($self->match($char)) {
            $matched .= $self->{matched};
        }
        else {
            $self->buffer($matched);
            return 0;
        }
    }
    return 1;
}

sub consume {
    my $self = shift;
    
    $self->{consumed} = '';
    
    while(!$self->eof && $self->match(@_)) {
        $self->{consumed} .= $self->{matched};
    }
    return length($self->{consumed});
}

sub consumed {
    my $self = shift;
    return $self->{consumed};
}

sub current {
    my $self = shift;
    return $self->{current};
}

sub buffer {
    my $self = shift;
    # warn("buffering: '$_[0]' + '$self->{current}' + '$self->{buffer}'\n");
    local $^W;
    my $current = $self->{current};
    if ($] >= 5.006 && $] < 5.007) {
        $current = pack("C0A*", $current);
    }
    $self->{buffer} = $_[0] . $current . $self->{buffer};
    $self->nextchar;
}

sub eof {
    my $self = shift;
    return 1 unless defined $self->{current};
    return 0;
}

sub public_id {
    my ($self, $value) = @_;
    if (defined $value) {
        return $self->{public_id} = $value;
    }
    return $self->{public_id};
}

sub system_id {
    my ($self, $value) = @_;
    if (defined $value) {
        return $self->{system_id} = $value;
    }
    return $self->{system_id};
}

sub line {
    shift->{line};
}

sub column {
    shift->{column};
}

sub get_encoding {
    my $self = shift;
    return $self->{encoding};
}

1;

__END__

=head1 NAME

XML::Parser::PurePerl::Reader - Abstract Reader factory class

=cut
