# $Id$

package XML::SAX::PurePerl::Reader::Stream;

use strict;
use vars qw(@ISA);

use XML::SAX::PurePerl::Reader;
use XML::SAX::Exception;

@ISA = ('XML::SAX::PurePerl::Reader');

sub new {
    my $class = shift;
    my $ioref = shift;
    if ($] >= 5.007002) {
        eval q(binmode($ioref, ':raw');); # start in raw mode
    }
    return bless { fh => $ioref, line => 1, col => 0, buffer => '', eof => 0 }, $class;
}

sub next {
    my $self = shift;
    
    # check for chars in buffer first.
    if (length($self->{buffer})) {
        return $self->{current} = substr($self->{buffer}, 0, 1, ''); # last param truncates buffer
    }
    
#    if ($self->eof) {
#        die "Unable to read past end of file marker (b: $self->{buffer}, c: $self->{current}, m: $self->{matched})";
#    }
    
    my $buff = "\0";
    my $bytesread = read($self->{fh}, $buff, 1); # read 1 "byte" or character?
#    warn("read $bytesread: $buff == ", sprintf("0x%x", ord($buff)), "\n");
    if (defined($bytesread)) {
        if ($bytesread) {
            if ($buff eq "\n") {
                $self->{line}++;
                $self->{column} = 1;
            } else { $self->{column}++ }
                        
            return $self->{current} = $buff;
        }
        else {
            $self->{eof}++;
        }
        return undef;
    }
    
    # read returned undef. This is an error...
    die "Error reading from filehandle: $!";
}

sub set_encoding {
    my $self = shift;
    my ($encoding) = @_;
    # warn("set encoding to: $encoding\n");
    if ($] >= 5.007002) {
        eval q{ binmode($self->{fh}, ":encoding($encoding)") };
        if ($@) {
            throw XML::SAX::Exception::Parse (
                    Message => "Error switching encodings: $@",
                );
        }
    }
    else {
        throw XML::SAX::Exception::Parse (
                Message => "Only ASCII encoding allowed without perl 5.7.2 or higher. You tried: $encoding",
            ) if $encoding !~ /(ASCII|UTF\-?8)/i;
    }
    $self->{encoding} = $encoding;
}

sub bytepos {
    my $self = shift;
    tell($self->{fh});
}

sub eof {
    my $self = shift;
    return $self->{eof};
}

1;

