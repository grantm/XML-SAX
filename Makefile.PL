use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'XML::SAX',
    'VERSION_FROM' => 'SAX.pm', # finds $VERSION
);

sub MY::test {
    package MY;
    my $script = shift->SUPER::test(@_);
    $script =~ s/TEST_FILES = .*$/TEST_FILES = t\/*.t t\/sax\/*.t/m;
    return $script;
}

sub MY::install {
    package MY;
    my $script = shift->SUPER::install(@_);
    $script =~ s/install :: (.*)$/install :: $1 install_sax_pureperl/m;
    $script .= <<"INSTALL";

install_sax_pureperl :
\t\@\$(PERL) -MXML::SAX -e "XML::SAX->add_parser(q(XML::SAX::PurePerl))->save_parsers()"

INSTALL
    warn("$script\n");
    return $script;
}

