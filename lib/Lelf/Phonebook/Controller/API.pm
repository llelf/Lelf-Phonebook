package Lelf::Phonebook::Controller::API;

use Moose;
use namespace::autoclean;
use Modern::Perl;

use CatalystX::Controller::Sugar;
use syntax 'catalyst_action';
use CatalystX::Declare;

BEGIN { extends 'Catalyst::Controller::REST' };

use constant { OK=>1, ERROR=>2 };

action boo :Path('eeee') {
}


sub auto :Private {
    my ($self, $c) = @_;
    stash book => $c->model('Phonebook');
}



chain '/' => 'api/people' => ['id'] => sub {
    my $action;
    
    say 'id=', captured 'id';
    # say req 'method' ~~ 'GET';
    # say '*' ~~ captured 'id';


    given (req->{method}) {
	when (/GET/ && ('*' ~~ '*')) { $action = 'people_get_all' }
	when (/GET/) { $action = 'people_get' }
	when (/POST/) { $action = 'people_create' }
	when (/PUT/) { $action = 'update_person' }
	when (/DELETE/) { $action = 'people_delete' }
	default { say 'M=', req->{method}; $action = 'xxxxxx' }
    }

    say "GO TO $action";
    go $action;
};

chain 'people_ops' => sub {
    
};

sub people_get_all :Action {
    stash persons => [ stash->{book}->ppl->all ]
}

sub get_person { 
    stash person => stash->{book}->ppl->find(captured 'id')
}

sub update_person :Action {
    say 'DATA=', %{req 'data'};
    stash person => stash->{book}->update_person(req->{data});
}

sub create_person {
    stash person => stash->{book}->create_person(req 'data');
}

sub delete_person {
    stash status => stash->{book}->delete_person(captured 'id') ? OK : ERROR;
}



chain 'people:1' => '' => sub { say 'PEND' };





before end => sub {
    my ($self, $c) = @_;

    given ($c->{stash}) {
	when ('person' ~~ $_) {
	    my $p = stash 'person';
	    $self->status_ok($c, entity => $p ? $p->to_hashref : []);
	}

	when ('persons' ~~ $_) {
	    say '+has result';
	    $c->log->_dump(stash->{persons}->[0]->to_hashref);
	    $self->status_ok($c, entity => [ map { $_->to_hashref } @{stash 'persons'} ]);
	}

	when ($_->{status} ~~ OK) {
	    $self->status_ok($c, entity => []);
	}

	default {
	    $c->response->status((400 .. 500)[int rand 19]);
	    $c->stash(rest => { oops => "Error #@{[ int rand 100_000 ]}" });
	}
    }
};




=head1 AUTHOR

Anton Nikishaev

=cut

__PACKAGE__->meta->make_immutable;

1;
