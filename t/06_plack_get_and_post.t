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
    connect '/comment',
        get  => { controller => 'Comment', action => 'show' },
            post => { controller => 'Comment', action => 'post' };
}

do {
    my $req =
      Plack::Request->new( { PATH_INFO => '/comment', REQUEST_METHOD => 'GET', } );
    my $x = MyDispatcher->match($req);
    is_deeply $x,
      {
        'controller' => 'Comment',
        'args'       => {},
        'action'     => 'show'
      };
};

do {
    my $req = Plack::Request->new({PATH_INFO => '/comment', REQUEST_METHOD => 'POST' });
    my $x = MyDispatcher->match($req);
    is_deeply $x,
      {
        'controller' => 'Comment',
        'args'  => {},
        'action' => 'post'
      };
};
