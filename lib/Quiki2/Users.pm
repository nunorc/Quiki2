package Quiki2::Users;
# ABSTRACT: Quiki2 users interface

use Moo;
use DBI;

has 'quiki2' => ( is => 'ro' );
has 'dbfile' => ( is => 'lazy', builder => '_set_dbfile' );

sub login {
  my ($self, $username, $password) = @_;

  my $dbh = $self->_connect;
  my $sth = $dbh->prepare("SELECT * FROM users WHERE username = ?");
  $sth->execute($username);

  my $row = $sth->fetchrow_hashref;
  $dbh->disconnect;

  if ($row) {
    if ($password eq $row->{password}) {
      my $user = $row;
      delete $user->{password};
      return $user;
    }
  }

  return undef;
}

sub register {
  my ($self, $args) = @_;

  my $dbh = $self->_connect;
  my $sth = $dbh->prepare("INSERT INTO users VALUES (?,?,?,'user');");
  $sth->execute($args->{username}, $args->{password}, $args->{email});
  $dbh->disconnect;
}

sub _connect {
  my ($self) = @_;

  my $dbfile = $self->dbfile;
  unless (-e $dbfile) {
    my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile","","");
    $dbh->do("CREATE TABLE users (username PRIMARY KEY, password, email, perm_group);");
    $dbh->disconnect;
  }
  return DBI->connect("dbi:SQLite:dbname=$dbfile","","");
}

sub _set_dbfile {
  my ($self) = @_;

#use Data::Dumper; print STDERR Dumper($self);

  my $data = $self->quiki2->data;
  my $filename = File::Spec->catfile($data, 'users.sqlite');

  return $filename;
}

1;

