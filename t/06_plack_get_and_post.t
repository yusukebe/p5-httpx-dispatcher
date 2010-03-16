use strict;
use warnings;
use Test::More tests => 2;
use YAML;
use HTTPx::Dispatcher;
use HTTP::Request;
use Test::Requires 'Plack::Request';

{
    package MyDispatcher;
    use HTTPx::Dispatcher;
    get '', { controller => 'Root', action => 'index' };
    post '/comment/{id}', { controller => 'Comment', action => 'post' };
}

do {
    my $req =
      Plack::Request->new( { PATH_INFO => '/', REQUEST_METHOD => 'GET', } );
    my $x = MyDispatcher->match($req);
    is_deeply $x,
      {
        'controller' => 'Root',
        'args'       => {},
        'action'     => 'index'
      };
};

do {
    my $req = Plack::Request->new({PATH_INFO => '/comment/1', REQUEST_METHOD => 'POST' });
    my $x = MyDispatcher->match($req);
    is_deeply $x,
      {
        'controller' => 'Comment',
        'args'  => { id => 1 },
        'action' => 'post'
      };
};

