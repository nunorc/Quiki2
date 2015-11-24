package Quiki2;
# ABSTRACT: Quiki2 

use Moo;
use Quiki2::Page;
use Quiki2::Users;
use Path::Tiny;
use File::Spec;

has 'cfg'   => ( is => 'rw');
has 'data'  => ( is => 'lazy', builder => '_set_data' );
has 'users' => ( is => 'lazy', builder => '_set_users' );

sub page {
  my ($self, $id) = @_;

  my $p = Quiki2::Page->new(quiki2 => $self, id => $id);

  return $p;
}

sub _set_data {
  my $self = shift;

  return $self->cfg->{data};
}

sub _set_users {
  my $self = shift;

  my $users = Quiki2::Users->new(quiki2 => $self);

  return $users;; 
}

1;

