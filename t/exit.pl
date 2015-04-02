use Hookscript;
use experimental qw(switch);

given ( $req->param('try') ) {
    when (1) {
        die "Try $_";
    }
    when (2) {
        warn "Try $_";
        exit 1;
    }
}
