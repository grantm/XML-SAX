use Test;
BEGIN { plan tests => 1 }
END { ok($loaded) }
use XML::SAX;
use XML::SAX::Exception;
use XML::SAX::Base;
use XML::SAX::ParserFactory;
use XML::SAX::PurePerl;
$loaded++;
