package Quiki2::Page;
# ABSTRACT: Quiki2 page abstraction

use Moo;
use Path::Tiny;
use File::Spec;
use JSON::XS;
use DR::SunDown;
use POSIX qw(strftime);

has 'quiki2'   => ( is => 'ro' );
has 'id'       => ( is => 'ro' );
has 'meta'     => ( is => 'lazy', builder => '_get_meta' );
has 'content'  => ( is => 'lazy', builder => '_get_content' );

sub filename {
  my ($self, $dir) = @_;

  my $data = $self->quiki2->data;
  my $filename = File::Spec->catfile($data, $dir, $self->id);

  return $filename;
}

sub to_html {
  my ($self) = @_;

  my $html = markdown2html($self->content);

  return $html;
}

sub save {
  my ($self, $user, $args) = @_;

  # update meta
  my $meta = {};
  for (keys %$args) {
    my ($l, $r) = split /\s*\-\s*/, $_;
    if ($l eq 'meta') {
      $meta->{$r} = $args->{$_};
    }
  }
  my $file = path($self->filename('meta'));
  $file->spew_utf8(encode_json $meta);

  # save content
  $file = path($self->filename('content'));
  $file->spew_utf8($args->{content});
}

sub _get_content {
  my $self = shift;

  my $file = path($self->filename('content'));
  my $content = $file->slurp_utf8;

  return $content;
}

sub _get_meta {
  my $self = shift;

  # defaults
  my $meta = { title => ucfirst($self->id), who => 'Anonymous' };

  # get meta from file if available
  my $file = path($self->filename('meta'));
  if ($file->exists) {
	my $json = $file->slurp_utf8;
	my $data = decode_json $json;
	foreach (keys %$data) {
	  $meta->{$_} = $data->{$_};
	}
  }

  unless (exists $meta->{when}) {
    my @stats = stat($self->filename('content'));
    $meta->{'when'} = strftime "%h %d, %Y", localtime($stats[9]);
  }

  return $meta;
}

1;

