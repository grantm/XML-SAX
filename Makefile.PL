use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'	=> 'XML::SAX',
    'VERSION_FROM' => 'SAX.pm', # finds $VERSION
    'PREREQ_PM' => { 'File::Temp' => 0 },    
);

sub MY::install {
    package MY;
    my $script = shift->SUPER::install(@_);
    $script =~ s/install :: (.*)$/install :: $1 install_sax_pureperl/m;
    $script .= <<"INSTALL";

install_sax_pureperl :
\t\@\$(PERL) -MXML::SAX -e "XML::SAX->add_parser(q(XML::SAX::PurePerl))->save_parsers()"

INSTALL

    return $script;
}

