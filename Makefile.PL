#!/usr/bin/perl
# $Id: Makefile.PL,v 1.7 2004/10/06 18:06:11 rcaputo Exp $

use ExtUtils::MakeMaker;

# Touch CHANGES so it exists.
open(CHANGES, ">>CHANGES") and close CHANGES;

WriteMakefile(
  NAME         => 'POE::Component::Client::DNS',
  AUTHOR       => 'Rocco Caputo <rcaputo@cpan.org>',
  ABSTRACT     => 'POE component for non-blocking/concurrent DNS queries.',
  VERSION_FROM => 'DNS.pm',

  PM           => { 'DNS.pm' => '$(INST_LIBDIR)/DNS.pm' },
  PREREQ_PM    => {
    POE        => 0.11,
    Net::DNS   => 0.12,
    Test::More => 0,
  },
  dist         => {
    COMPRESS   => 'gzip -9f',
    SUFFIX     => 'gz',
    PREOP      => (
      'cvs-log.perl | tee ./$(DISTNAME)-$(VERSION)/CHANGES > ./CHANGES'
    ),
  },
);
