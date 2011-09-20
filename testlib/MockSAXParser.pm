package MockSAXParser;

sub new { };

sub supported_features {
    return(
        'http://xml.org/sax/features/namespaces',
        'http://xml.org/sax/features/telepathy',
    );
}

1;
