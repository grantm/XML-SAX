# $Id$

package XML::SAX;

use strict;
use vars qw/$VERSION/;
$VERSION = '0.90';

sub _package_to_pm {
    my $pk = shift;
    $pk =~ s/::/\//g;
    $pk .= ".pm";
    return $pk;
}

sub parser {
    my $class = shift;
    if ($ENV{SAX_PARSER}) {
        require(_package_to_pm($ENV{SAX_PARSER}));
        return $ENV{SAX_PARSER}->new(@_);
    }
    else {
        require XML::SAX::PurePerl;
        return XML::SAX::PurePerl->new(@_);
    }
}

1;
__END__

=head1 NAME

XML::SAX - Simple API for XML

=head1 SYNOPSIS

  use XML::SAX;
  my $parser = XML::SAX->parser();

=head1 DESCRIPTION

XML::SAX is a minimal interface to SAX parsers, that allows you to
request a SAX parser, and be guaranteed to at least get one, 
regardless of whether it is the best one available, or simply the
default (XML::SAX::PurePerl).

This distribution also contains the Perl SAX 2.0 Spec, see
L<XML::SAX::Spec> and L<XML::SAX::AdvancedSpec>.

=head1 USAGE

Usage is minimal and very simple:

  my $parser = XML::SAX->parser(<options>);

Options are always key/value pairs, and are passed to the constructor
of the parser object you happen to be given.

To influence what kind of parser you get, set the environment variable
SAX_PARSER to the package you'd like the parser to be from. For
example you might prefer to use XML::SAX::Expat:

  $ENV{SAX_PARSER} = 'XML::SAX::Expat';
  my $parser = XML::SAX->parser(<options>);

Please do not set this environment variable in your programs though!
Leave that up to the user, or allow it to be set in your configuration
files.

=head1 AUTHOR

Matt Sergeant, matt@sergeant.org

=head1 SEE ALSO

XML::SAX::Spec, XML::SAX::AdvancedSpec, XML::SAX::PurePerl

=cut
