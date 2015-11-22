package Quiki2::Page;
# ABSTRACT: Quiki2 page abstraction

use Moo;
use Path::Tiny;
use File::Spec;
use DR::SunDown;
use POSIX qw(strftime);

has 'quiki2'   => ( is => 'rw' );
has 'id'       => ( is => 'rw' );
has 'meta'     => ( is => 'lazy', builder => '_get_meta' );
has 'content'  => ( is => 'lazy', builder => '_get_content' );
has 'filename' => ( is => 'lazy', builder => '_set_filename' );

sub save {
  my ($self, $user, $raw) = @_;

  $raw =~ s/^\-\-\-/---\nwho: $user->{email}/; # FIXME

  open my $fh, '>', $self->filename;
  print $fh $raw;
  close $fh;

}

sub _get_content {
  my $self = shift;

  my $file = path($self->filename);
  my $markdown = $file->slurp_utf8;
  $markdown =~ s/\-\-\-.*?\-\-\-//s;
  my $content = markdown2html($markdown);

  return $content;
}

sub _get_meta {
  my $self = shift;
  my $meta = { title => ucfirst($self->id), who => 'Anonymous' };

  open my $fh, '<', $self->filename;
  my $first = <$fh>;
  if ($first =~  m/^\s*\-\-\-/) {
    while (my $line = <$fh>) {
      if ($line =~ m/\s*(\w+)\s*\:\s*(.*)/) {
        $meta->{$1} = $2;
      }
      last if ($line =~  m/^\s*\-\-\-/);
    }
  }
  close $fh;

  my @stats = stat($self->filename);
  $meta->{'when'} = strftime "%h %d, %Y", localtime($stats[9]);

  return $meta;
}

sub _set_filename {
  my $self = shift;

  my $data = $self->quiki2->data;
  my $filename = File::Spec->catfile($data, 'content', $self->id);

  return $filename;
}

1;

