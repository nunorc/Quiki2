package Quiki2::CLI::Command::create;
use Quiki2::CLI -command;
use strict;
use warnings;

use File::Spec;
use File::Path qw/mkpath/;
use File::ShareDir 'dist_dir';
use File::Basename;
use File::Copy;
use Try::Tiny;
use File::Find;

my ($ROOT, $SHARE);

sub abstract { "create new instance" }

sub validate_args {
  my ($self, $opt, $args) = @_;

  unless (@$args == 1) {
    $self->usage_error("new dir required");
  }

  return 0;
}

sub execute {
  my ($self, $opt, $args) = @_;

  $ROOT = shift @$args;

  if (-e $ROOT) {
    $self->usage_error("$ROOT already exists.");
    return 0;
  }
  else {
    mkpath($ROOT);
  }

  my $dist = 'share';
  try {
    $dist = dist_dir('Quiki2');
  };
  my $skel = 'default';
  $SHARE = File::Spec->catdir($dist, $skel);

  find(\&_proc_file, $SHARE);
  print "All done: $ROOT\n";
}

sub _proc_file {
  if (-f $File::Find::name) {
    my $curr = $File::Find::name;
    $curr =~ s/^$SHARE//;
    print "Processing $curr\n";

    my $dir = File::Spec->catdir($ROOT, dirname($curr));
    unless (-e $dir) { mkpath($dir); }
    my $dest = File::Spec->catfile($dir, $_);
    copy($_, $dest);
  }
}

1;

