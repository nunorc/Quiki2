#!perl -T

use Test::More;

BEGIN {
  my $tests = 0;

  foreach (qw/Quiki2 Quiki2::Page Quiki2::Users/) {
    use_ok($_) || print "$_ failed to load!\n";
    $tests++;
  }

  done_testing($tests);
}
