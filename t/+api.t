#!/usr/bin/perl

use Modern::Perl;
use JSON;
use Furl;
use Test::More;

$ENV{DB_MODIFY_TESTS} // plan skip_all => 'to run set env var DB_MODIFY_TESTS';



my $furl = Furl->new(agent => '-api.t',
		     headers => [ 'Content-Type' =>'application/json; coding=utf-8' ]);

my $json = JSON->new->allow_nonref;

sub req {
    my ($meth, $path, $data) = @_;

    my $host = 'http://localhost:3000';
    $furl->request(url => $host . $path,
		   method => $meth // 'GET',
		   content => $data);
}

my ($env, $resp);

sub test {
    local $resp;
    local $env = {};

    for (@_) {
	when (ref $_ eq 'ARRAY') {
	    my ($meth, $path, $data) = @$_;
	    $data //= '';
	    s{:id}{$env->{id}} for ($path, $data);

	    diag("$meth $path $data");
	    $resp = req($meth, $path, $data);
	    $env->{data} = eval { $json->decode($resp->content) };
	}

	when (ref $_ eq 'CODE') {
	    ok($_->(), $env->{test});
	    $env->{test} = '';
	}

	default { say 'test invocation error' }
    }
}



sub t { $env->{test} = $_[0] }


sub json_ok {
    t('json-ok'); $resp->{content} eq '' or $env->{data};
}

sub status_ok {
    t('status-ok'); $resp->status == 200;
}

sub get_id {
    t('get-id'); $env->{id} = $env->{data}{id};
}

sub test;

my $p1 = '{"id":0,"name":"mr X","phones":[]}';
my $p2 = '{"id"::id,"name":"dr Y","phones":[{"number":"123-456-789"}]}';

test [ GET => '/api/people/*' ],
    => \&status_ok, \&json_ok
    
    [ GET => '/api/people/!!!' ]
    => \&status_not_ok,

    [ POST => '/api/people/_' => $p1 ],
    => \&status_ok, \&json_ok, \&get_id

    [ GET => '/api/people/:id' ]
    => \&status_ok, \&json_ok, sub { $env->{data}{name} ~~ 'mr X' },
    
    [ PUT => '/api/people/:id' => '{"xxx":[]}' ]
    => \&status_not_ok,

    [ PUT => '/api/people/:id' => $p2 ]
    => \&status_ok, \&json_ok, sub { $env->{data}{name} ~~ 'dr Y' 
					    and $env->{data}{phones}[0]{number} ~~ '123-456-789' },

    [ DELETE => '/api/people/:id' ],
    => \&status_ok,

    [ PUT => '/api/people/:id' => $p2 ]

    [ GET => '/api/people/:id' ],
    => status_not_ok;
    

done_testing;

