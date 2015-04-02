use Hookscript;
use experimental qw( switch );
use autodie qw( open );

given ( $req->param('resource') ) {
    when ('cpu') {
        1 while 1;
    }
    when ('mem') {
        my $x = 'xxxxxxxxxxxxxxxxxx';
        $x .= $x while 1;
    }
    when ('disk') {
        open my $fh, '>', 'junk';
        while (1) {
            print $fh "junk\n"
              or die "write to disk failed";
        }
    }
    when ('output') {
        my $i = 1_000_000;
        while ( $i-- ) {
            print "junk\n";
        }
    }
}
