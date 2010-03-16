use strict;
use warnings;
use Test::More;
use YAML;
use HTTPx::Dispatcher;
use HTTP::Request;
use Test::Requires 'Plack::Request';

{
    package MyDispatcher;
    use HTTPx::Dispatcher;
    get '/comment/:id'  => { controller => 'Comment', action => 'show' };
    post '/comment/:id' => { controller => 'Comment', action => 'post' };
    connect ':controller/:action/:id';
    connect '/edit' => {
        conditions => { method => 'POST', },
        controller => 'user',
        action     => 'post_root',
    };
}

do {
    my $req =
      Plack::Request->new( { PATH_INFO => '/comment/1', REQUEST_METHOD => 'GET', } );
    my $x = MyDispatcher->match($req);
    is_deeply $x,
      {
        'controller' => 'Comment',
        'args'       => { id => 1 },
        'action'     => 'show'
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

# test uri_for in extended
do {
    my $x =
      MyDispatcher->uri_for(
        { controller => 'blog', action => 'show', id => 3 } );
    diag $x;
    ok($x);
};

do {
    my $req =
      Plack::Request->new( { PATH_INFO => '/edit', REQUEST_METHOD => 'POST', } );
    my $x =
      MyDispatcher->match( $req );
    diag $x;
    ok($x);
};

done_testing;
