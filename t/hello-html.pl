use Hookscript;

my $whom = $req->param('whom') // "world";
$res->headers->content_type('text/html');

print <<"HTML";
<html>
    <body>
        <h1>Hello, $whom!</h1>

        <form method=GET>
            <input type=submit value="Say Hello to" />
            <input type=text name=whom placeholder="world" />
        </form>
    </body>
</html>
HTML
