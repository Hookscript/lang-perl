use Hookscript;
use HTTP::Tiny;

my $http     = $req->param('protocol');
my $file     = $req->param('file');
my $url      = "$http://storage.googleapis.com/hookscript/$file";
my $response = HTTP::Tiny->new->get($url);
if ( $response->{status} == 200 ) {
    print $response->{content};
}
else {
    $res->code( $response->{status} );
    print "Request to $url failed";
}
