use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'XML::SAX',
    'VERSION_FROM' => 'SAX.pm', # finds $VERSION
    'PREREQ_PM' => { XML::SAX::PurePerl => 0.81 },
);
