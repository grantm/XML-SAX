# $Id$

package XML::SAX::ParserFactory;

use strict;
use vars qw($VERSION);

$VERSION = '1.00';

use Symbol qw(gensym);
use XML::SAX;

sub new {
    my $class = shift;
    my %params = @_; # TODO : Fix this in spec.
    my $self = bless \%params, $class;
    $self->{KnownParsers} = XML::SAX->load_parsers()->parsers();
    return $self;
}

sub parser {
    my $self = shift;
    my @parser_params = @_;
    if (!ref($self)) {
        $self = $self->new();
    }
    
    my $parser_class = $self->_parser_class();

    {
        my $parser_file = $parser_class;
        $parser_file =~ s/::/\//g;
        $parser_file .= ".pm";
        no strict 'refs';
        if (!keys %{"${parser_class}::"}) {
            require $parser_file;
        }
    }

    return $parser_class->new(@parser_params);
}

sub _parser_class {
    my $self = shift;

    # First try ParserPackage
    if ($XML::SAX::ParserPackage) {
        return $XML::SAX::ParserPackage;
    }

    # Now check if required/preferred is there
    if ($self->{RequiredFeatures}) {
        my %required = %{$self->{RequiredFeatures}};
        # note - we never go onto the next try (SAX.ini),
        # because if we can't provide the requested feature
        # we need to throw an exception.
        PARSER:
        foreach my $parser (reverse @{$self->{KnownParsers}}) {
            foreach my $feature (keys %required) {
                if (!exists $parser->{Features}{$feature}) {
                    next PARSER;
                }
            }
            # got here - all features must exist!
            return $parser->{Name};
        }
        throw XML::SAX::Exception ("Unable to provide required features");
    }

    # Next try SAX.ini
    for my $dir (@INC) {
        my $fh = gensym();
        if (open($fh, "$dir/SAX.ini")) {
            my $params = $self->_parse_ini($fh);
            if ($params->{ParserPackage}) {
                return $params->{ParserPackage};
            }
            else {
            } 
            last;
        }
    }

    return "XML::SAX::PurePerl";
}

1;
__END__

=head1 NAME

XML::SAX::ParserFactory - Obtain a SAX parser

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 AUTHOR

=head1 LICENSE

=cut

