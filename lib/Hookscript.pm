package Hookscript;
use strict;
use warnings;
use feature ();
use autodie qw( open );
use parent qw( Exporter );

our ( $req, $res, $state );
our @EXPORT = qw( $req $res $state );

my $original_state_text;
my $printed_content;
my $new_stdout;

use Mojo::Message::Request;
use Mojo::Message::Response;

BEGIN {
    # build an object representing the HTTP request
    $req = Mojo::Message::Request->new;
    if ( -e 'request' ) {
        open my $request_fh, '<', 'request';
        while ( my $line = <$request_fh> ) {
            $req->parse($line);
        }
        if ( my $err = $req->error ) {
            die "Error parsing HTTP request: " . $err->{message};
        }
        close $request_fh;
    }

    # build an empty HTTP response object for the hook to populate
    $res = Mojo::Message::Response->new;
    $res->code(200);
    $res->headers->server( 'hookscript/perl-' . $^V );

    # read in the current state
    if ( -e 'state' ) {
        open my $state_fh, '<', 'state';
        $original_state_text = do { local $/; <$state_fh> };
        $state = eval $original_state_text;
        close $state_fh;
    }

    # capture STDOUT
    open $new_stdout, '>', \$printed_content;
    select $new_stdout;
}

sub import {
    my ($class) = @_;
    $class->export_to_level(1);

    warnings->import;
    strict->import;
    feature->import(":5.20");
}

END {
    # switch back to original STDOUT
    select STDOUT;
    close $new_stdout;

    # write out the current state, if script uses state
    if ( defined $state ) {
        require Data::Dumper;
        my $current_state_text =
          Data::Dumper->new( [$state] )->Terse(1)->Sortkeys(1)->Dump;
        $original_state_text //= "not $current_state_text";

        # only update file if contents has changed
        if ( $current_state_text ne $original_state_text ) {
            open my $state_fh, '>', 'state';
            print $state_fh $current_state_text;
            close $state_fh;
        }
    }
    elsif ( defined $original_state_text ) {    # truncate state file
        open my $state_fh, '>', 'state';
        close $state_fh;
    }

    # if content is missing, use captured content
    if ( $res->body eq '' ) {
        $res->body($printed_content);
    }

    # if Content-Type header is missing, guess a decent value
    my $content_type = $res->headers->content_type;
    if ( not defined $content_type ) {
        my $content = $res->body;
        if ( $content =~ /<\w+>/ ) {
            $content_type = 'text/html';
        }
        else {
            $content_type = 'text/plain';
        }

        $res->headers->content_type($content_type);
    }

    # output HTTP response
    open my $fh, '>', 'response';
    print $fh $res->to_string;
}

1;
