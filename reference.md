# Perl Reference

See also Hookscript's [general documentation](http://docs.hookscript.com/)

## Hookscript module

Each Perl script should begin with `use Hookscript`.  Importing this module does the following:

  * `use strict`
  * `use warnings`
  * `use feature ":5.20"`
  * exports `$req` representing the incoming HTTP request
  * exports `$res` representing the script's HTTP response
  * exports `$state` whose value is persisted across script invocations

## HTTP Request

An incoming HTTP request is represented by a [Mojo::Message::Request](https://metacpan.org/pod/Mojo::Message::Request) value.
This value is available in the `$req` variable.

## HTTP Response

A script doesn't need an explicit response variable.  Anything sent to the currently selected output stream
becomes the HTTP response body.  However, if you want to modify HTTP response headers, you can call methods
on `$res`.  This is a [Mojo::Message::Response](https://metacpan.org/pod/Mojo::Message::Response) value.

## State

The Hookscript module exports a variable named `$state`.  The value of this variable is retained across script executions.  The first time your script runs, it has the value `undef`.  You can store any value in this variable as long as `Data::Dumper` can serialize it.  It could be an integer, a hashref, a complex object, etc.

## CPAN modules

A script can use any module included in Perl's standard library or listed in our [cpanfile](https://github.com/Hookscript/lang-perl/blob/master/cpanfile).  If you want to use other modules, you can use [App::fatten](https://metacpan.org/pod/App::fatten) to bundle those dependencies as part of your script.  Just paste the fattened script into Hookscript.

## Tips

Here are some tips that you might find useful when working with Perl scripts
on Hookscript.

### File uploads

If the incoming HTTP request contains a file upload, maybe from an HTML form
with `<input type=file>`, how do you access the uploaded file content?

If the uploaded content is small enough to fit into memory, the easiest way is

```perl
my $content = $req->upload('parameter_name')->asset->slurp;
```

The `$req` variable is a [Mojo::Message::Request](https://metacpan.org/pod/Mojo::Message::Request). So you can see that documentation for all the details.  Be sure to check the documentation for parent classes too.

### Request body

To access the raw request body, assuming it fits into memory, you can use:

```perl
my $body = $req->content->asset->slurp;
```

See the documentation for [Mojo::Message::Request](https://metacpan.org/pod/Mojo::Message::Request) for other variations.
