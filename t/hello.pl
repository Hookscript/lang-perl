use Hookscript;

my $whom = $req->param('whom') // 'world';
say "Hello, $whom!";
