package Quiki2::App;
use Dancer2;

use Quiki2;
use Data::Dumper;

our $VERSION = '0.1';

my $config = config->{quiki2};
my $quiki2 = Quiki2->new(cfg => $config);

get '/' => sub {
  redirect '/p/home';
};

get '/login' => sub {
  template 'login';
};

post '/login' => sub {
  my $params = params;

  my $user = $quiki2->users->login($params->{username}, $params->{password});
  if ($user) {
    session 'user' => $user;
  }

  redirect '/p/home';
};

get '/logout' => sub {
  session 'user' => undef;

  redirect '/p/home';
};

get '/register' => sub {
  template 'register';
};

post '/register' => sub {
  my $params = params;

  if ($params->{password} eq $params->{repeat}) {
    $quiki2->users->register($params);
  }

  redirect 'login';
};

get '/p/:id' => sub {
  my $id = param('id');

  my $p = $quiki2->page($id);

  template 'page' => {
    title => $p->meta->{title},
    content => $p->content,
    when => $p->meta->{when},
    who => $p->meta->{who},
    editme => '/e/'.$p->id
  };
};

get '/e/:id' => sub {
  my $id = param('id');

  my $p = $quiki2->edit($id);

  template 'edit' => {
    id  => $p->{id},
    raw => $p->{raw},
  };
};

post '/e/:id' => sub {
  my $id = param('id');
  my $content = param('content');

  my $p = $quiki2->page($id);
  my $user = session 'user';
  $p->save($user, $content);

  redirect "/p/$id";
};

1;

