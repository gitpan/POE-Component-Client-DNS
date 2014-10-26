#!/usr/bin/perl -w
# $Id: 05_api_4.t 40 2004-10-07 03:04:31Z rcaputo $

# Test the version 3 API.

use strict;
use POE qw(Component::Client::DNS);
use Test::More tests => 4;

my $resolver = POE::Component::Client::DNS->spawn(
  Alias   => 'named',
  Timeout => 5,
);

POE::Session->create(
  inline_states  => {
    _start   => \&start_tests,
    response => \&got_response,
  }
);

POE::Kernel->run();
exit;

sub start_tests {
  my $request = 1;

  # Default IN A.  Override timeout.
  $resolver->resolve(
    event   => "response",
    host    => "localhost",
    context => $request++,
    timeout => 30,
  );

  # Default IN A.  Not found in /etc/hosts.
  $resolver->resolve(
    event   => "response",
    host    => "google.com",
    context => $request++,
    timeout => 30,
  );

  # IN PTR
  $resolver->resolve(
    event   => "response",
    host    => "127.0.0.1",
    class   => "IN",
    type    => "PTR",
    context => $request++,
  );

  # Small timeout.
  $resolver->resolve(
    event   => "response",
    host    => "google.com",
    context => $request++,
    timeout => 0.001,
  );
}

sub got_response {
  my ($request, $response) = @_[ARG0, ARG1];
  ok($request->{context}, "got response $request->{context}");
}
