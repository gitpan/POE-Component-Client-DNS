#!/usr/bin/perl -w
# $Id: 03_api_3.t 37 2004-10-07 01:23:08Z rcaputo $

# Test the version 3 API.

use strict;
use POE qw(Component::Client::DNS);
use Test::More tests => 4;

POE::Component::Client::DNS->spawn(
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
  $_[KERNEL]->post(
    named => resolve => {
      event   => "response",
      host    => "localhost",
      context => $request++,
      timeout => 30,
    },
  );

  # Default IN A.  Not found in /etc/hosts.
  $_[KERNEL]->post(
    named => resolve => {
      event   => "response",
      host    => "google.com",
      context => $request++,
      timeout => 30,
    },
  );

  # IN PTR
  $_[KERNEL]->post(
    named => resolve => {
      event   => "response",
      host    => "127.0.0.1",
      class   => "IN",
      type    => "PTR",
      context => $request++,
    },
  );

  # Small timeout.
  $_[KERNEL]->post(
    named => resolve => {
      event   => "response",
      host    => "google.com",
      context => $request++,
      timeout => 0.001,
    },
  );
}

sub got_response {
  my ($request, $response) = @_[ARG0, ARG1];
  ok($request->{context}, "got response $request->{context}");
}
