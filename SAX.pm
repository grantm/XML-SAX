# $Id$

package XML::SAX;

use strict;
use vars qw($VERSION);

$VERSION = '0.01';

use File::Basename qw(dirname);
use File::Spec ();
use Symbol qw(gensym);

use constant PARSER_DETAILS => "ParserDetails.ini";

my $known_parsers = undef;

# load_parsers takes the ParserDetails.ini file out of the same directory
# that XML::SAX is in, and looks at it. Format in POD below

=begin example

[XML::SAX::PurePerl]
http://xml.org/sax/features/namespaces = 1
http://xml.org/sax/features/validation = 0
# a comment

# blank lines ignored

[XML::SAX::AnotherParser]
http://xml.org/sax/features/namespaces = 0
http://xml.org/sax/features/validation = 1

=cut

sub load_parsers {
    my $class = shift;
    
    # reset parsers
    $known_parsers = [];
    
    # get directory from wherever XML::SAX is installed
    my $dir = $INC{'XML/SAX.pm'};
    $dir = dirname($dir);
    
    my $fh = gensym();
    if (!open($fh, File::Spec->catfile($dir, PARSER_DETAILS))) {
        warn("could not find " . PARSER_DETAILS . " in $dir\n");
    }

    $known_parsers = $class->_parse_ini_file($fh);

    return $class;
}

sub _parse_ini_file {
    my $class = shift;
    my ($fh) = @_;

    my @config;
    
    my $lineno = 0;
    while (my $line = <$fh>) {
        $lineno++;
        my $original = $line;
        # strip whitespace
        $line =~ s/\s*$//m;
        $line =~ s/^\s*//m;
        # strip comments
        $line =~ s/[#;].*$//m;
        # ignore blanks
        next if $line =~ /^$/m;
        
        # heading
        if ($line =~ /^\[\s*(.*)\s*\]$/m) {
            push @config, { Name => $1 };
            next;
        }
        
        # instruction
        elsif ($line =~ /^(.*?)\s*?=\s*(.*)$/) {
            die "No heading at line $lineno\n>>> $original\n" unless @config;
            $config[-1]{$1} = $2;
        }

        # not whitespace, comment, or instruction
        else {
            die "Invalid line in ini: $lineno\n>>> $original\n";
        }
    }

    return \@config;
}

sub parsers {
    my $class = shift;
    if (!$known_parsers) {
        $class->load_parsers();
    }
    return $known_parsers;
}

sub add_parser {
    my $class = shift;
    my ($parser_module) = @_;

    if (!$known_parsers) {
        $class->load_parsers();
    }
    
    # first load module, then query features, then push onto known_parsers,
    
    my $parser_file = $parser_module;
    $parser_file =~ s/::/\//g;
    $parser_file .= ".pm";

    require $parser_file;

    my @features = $parser_module->features();
    
    my $new = { Name => $parser_module };
    foreach my $feature (@features) {
        $new->{$feature} = 1;
    }

    my $done = 0;
    for (my $i = 0; $i < @$known_parsers; $i++) {
        my $p = $known_parsers->[$i];
        if ($p->{Name} eq $parser_module) {
            $known_parsers->[$i] = $new;
            $done++;
        }
    }

    if (!$done) {
        push @$known_parsers, $new;
    }
    
    return $class;
}

sub save_parsers {
    my $class = shift;
    
    # get directory from wherever XML::SAX is installed
    my $dir = $INC{'XML/SAX.pm'};
    $dir = dirname($dir);
    
    my $fh = gensym();
    open($fh, ">" . File::Spec->catfile($dir, PARSER_DETAILS)) ||
        die "Cannot write to " . PARSER_DETAILS . " file: $!";

    foreach my $p (@$known_parsers) {
        print $fh "[$p->{Name}]\n";
        foreach my $key (keys %$p) {
            if ($key ne "Name") {
                print $fh "$key = $p->{$key}\n";
            }
        }
    }

    print $fh "\n\n";

    close $fh;

    return $class;
}

1;
__END__

=head1 NAME

XML::SAX - Simple API for XML

=head1 SYNOPSIS

  use XML::SAX;
  
  # get a list of known parsers
  my $parsers = XML::SAX->parsers();
  
  # add/update a parser
  XML::SAX->add_parser(q(XML::SAX::PurePerl));

  # save parsers
  XML::SAX->save_parsers();

=head1 DESCRIPTION

XML::SAX is a SAX parser access API for Perl. It includes classes
and APIs required for implementing SAX drivers, along with a factory
class for returning any SAX parser installed on the user's system.

The factory class is XML::SAX::ParserFactory. Please see the
documentation of that module for how to instantiate a SAX parser. In
order to learn how to use SAX to parse XML, you will need to read
L<XML::SAX::Intro> and for reference, L<XML::SAX::Specification>.

=head1 AUTHOR

Matt Sergeant, matt@sergeant.org

Kip Hampton, khampton@totalcinema.com

Robin Berjon, robin@knowscape.com

Ken MacLeod, kenm@bitsko.slc.ut.us

=head1 LICENSE

This is free software, you may use it and distribute it under
the same terms as Perl itself.

=cut

