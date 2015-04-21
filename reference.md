# Perl Reference

See also Hookscript's [general documentation](http://docs.hookscript.com/)

## Hookscript module

Each Perl script should begin with `use Hookscript`.  Importing this module does the following:

  * `use strict`
  * `use warnings`
  * `use feature ":5.20"`
  * exports `$req` representing the incoming HTTP request
  * exports `$res` representing the script's HTTP response
  * exports `$state` whose value is persistend across script invocations

## HTTP Request

An incoming HTTP request is represented by a [Mojo::Message::Request](https://metacpan.org/pod/Mojo::Message::Request) value.
This value is available in the `$req` variable.

## HTTP Response

A script doesn't need an explicit response variable.  Anything sent to the currently selected output stream
becomes the HTTP response body.  However, if you want to modify HTTP response headers, you can call methods
on `$res`.  This is a [Mojo::Message::Response](https://metacpan.org/pod/Mojo::Message::Response) value.
