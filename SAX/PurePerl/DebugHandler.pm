# $Id$

package XML::SAX::PurePerl::DebugHandler;

use strict;

sub new {
    my $class = shift;
    my %opts = @_;
    return bless \%opts, $class;
}

# DocumentHandler

sub set_document_locator {
    my $self = shift;
    $self->{seen}{set_document_locator}++;
}

sub start_document {
    my $self = shift;
    $self->{seen}{start_document}++;    
}

sub end_document {
    my $self = shift;
    $self->{seen}{end_document}++;
}

sub start_element {
    my $self = shift;
    $self->{seen}{start_element}++;
}

sub end_element {
    my $self = shift;
    $self->{seen}{end_element}++;
}

sub characters {
    my $self = shift;
#    warn "Char: ", $_[0]->{Data}, "\n";
    $self->{seen}{characters}++;
}

sub processing_instruction {
    my $self = shift;
    $self->{seen}{processing_instruction}++;
}

sub ignorable_whitespace {
    my $self = shift;
    $self->{seen}{ignorable_whitespace}++;
}

# LexHandler

sub comment {
    my $self = shift;
    $self->{seen}{comment}++;
}

# DTDHandler

sub notation_decl {
    my $self = shift;
    $self->{seen}{notation_decl}++;
}

sub unparsed_entity_decl {
    my $self = shift;
    $self->{seen}{entity_decl}++;
}

# EntityResolver

sub resolve_entity {
    my $self = shift;
    $self->{seen}{resolve_entity}++;
    return '';
}

1;
