use Hookscript;
use experimental qw( switch );

my $value;
my $register = $req->param('register') // '';
given ( $req->method ) {
    when ('POST') {
        $value = $req->param('value') // 'default value';
        die "I am dead" if $register eq 'death';
        $state->{$register} = $value;
    }
    default {
        $value = $state->{$register} // "unknown register: $register";
    }
}
print $value;
