package XML::SAX::PurePerl::DebugHandler;

use strict;
use warnings;
use Data::Dumper;

sub new {
    my $class = shift;
    my %opts = @_;
    return bless \%opts, $class;
}

sub dumpthem {
	my $self = shift;
	if (defined($self->{seen}{_all})) {
		$self->{seen}{_all} = $self->{seen}{_all}.Dumper(@_)."\n";
	} else {
		$self->{seen}{_all} = Dumper(@_)."\n";
	}
}

# DocumentHandler

sub set_document_locator {
    my $self = shift;
    print "set_document_locator\n" if $ENV{DEBUG_XML};
    $self->{seen}{set_document_locator}++;
	dumpthem($self,'set_document_locator: ', @_);
}

sub start_document {
    my $self = shift;
    print "start_document\n" if $ENV{DEBUG_XML};
    $self->{seen}{start_document}++;   
	dumpthem($self,'start_document: ', @_); 
}

sub end_document {
    my $self = shift;
    print "end_document\n" if $ENV{DEBUG_XML};
    $self->{seen}{end_document}++;
	dumpthem($self,'end_document: ', @_);
}

sub start_element {
    my $self = shift;
    print "start_element\n" if $ENV{DEBUG_XML};
    $self->{seen}{start_element}++;
	dumpthem($self,'start_element: ', @_); 
}

sub end_element {
    my $self = shift;
    print "end_element\n" if $ENV{DEBUG_XML};
    $self->{seen}{end_element}++;
	dumpthem($self,'end_element: ', @_);
}

sub characters {
    my $self = shift;
    print "characters\n" if $ENV{DEBUG_XML};
#    warn "Char: ", $_[0]->{Data}, "\n";
    $self->{seen}{characters}++;
	dumpthem($self,'characters: ', @_);
}

sub processing_instruction {
    my $self = shift;
    print "processing_instruction\n" if $ENV{DEBUG_XML};
    $self->{seen}{processing_instruction}++;
	dumpthem($self,'processing_instruction: ', @_);
}

sub ignorable_whitespace {
    my $self = shift;
    print "ignorable_whitespace\n" if $ENV{DEBUG_XML};
    $self->{seen}{ignorable_whitespace}++;
	dumpthem($self,'ignorable_whitespace: ', @_);
}

# LexHandler

sub comment {
    my $self = shift;
    print "comment\n" if $ENV{DEBUG_XML};
    $self->{seen}{comment}++;
	dumpthem($self,'comment: ', @_);
}

# DTDHandler

sub notation_decl {
    my $self = shift;
    print "notation_decl\n" if $ENV{DEBUG_XML};
    $self->{seen}{notation_decl}++;
	dumpthem($self,'notation_decl: ', @_);
}

sub unparsed_entity_decl {
    my $self = shift;
    print "unparsed_entity_decl\n" if $ENV{DEBUG_XML};
    $self->{seen}{entity_decl}++;
	dumpthem($self,'unparsed_entity_decl: ', @_);
}

# EntityResolver

sub resolve_entity {
    my $self = shift;
    print "resolve_entity\n" if $ENV{DEBUG_XML};
    $self->{seen}{resolve_entity}++;
	dumpthem($self,'resolve entity: ', @_);
    return '';
}

1;
