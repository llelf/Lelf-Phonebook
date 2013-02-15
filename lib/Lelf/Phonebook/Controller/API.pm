package Lelf::Phonebook::Controller::API;

use utf8;
use encoding 'utf-8';
use Moose;
use namespace::autoclean;
use Modern::Perl;

use CatalystX::Controller::Sugar;
use syntax qw{method catalyst_action};

extends 'Catalyst::Controller::REST';

use constant { OK=>1, ERROR=>2, ERROR_INVALID_INPUT=>3 };


after begin => sub {
    my ($self,$ctx) = @_;
    stash book => $ctx->model('Phonebook');
};


action people ($id) :Args(1) :Local {
    stash id => $id;

    my $action;

    given ($ctx->req->{method}) {
	when (/GET/ && $id ~~ '*') { $action = 'people_get_all' }
	when (/GET/) { $action = 'get_person' }
	when (/POST/) { $action = 'create_person' }
	when (/PUT/) { $action = 'update_person' }
	when (/DELETE/) { $action = 'delete_person' }
    }

    my $fun = $ctx->controller->action_for($action);
    report debug => 'action=' . $fun // '<???>';
    #report debug => $ctx->req->{data};
    $ctx->log->_dump($ctx->req->{data});
    
    $ctx->forward('validate', $fun->attributes->{ID})
	or stash status => ERROR_INVALID_INPUT and $ctx->go('end')
	if $fun->attributes->{Validate};

    $ctx->go($fun) if $fun;
}


action validate ($id_known) :Action {
    # ...
    return unless ref($ctx->req->{data}) eq 'HASH';
    stash validated => 1;
};


action people_get_all :Action {
    stash persons => [ stash->{book}->ppl->all ];
}

action get_person :Action :ID { 
    stash person => stash->{book}->find_person(stash->{id});
}

action update_person :Action :Validate :ID {
    stash person => stash->{book}->update_person($ctx->req->{data});
}

action create_person :Action :Validate {
    stash person => stash->{book}->create_person($ctx->req->{data});
}

action delete_person :Action :ID {
    stash status => stash->{book}->delete_person(stash->{id}) ? OK : ERROR;
}


before end => sub {
    my ($self, $c) = @_;

    given ($c->{stash}) {
	when ('person' ~~ $_) {
	    $self->status_ok($c, entity => stash->{person}->to_hashref);
	}

	when ('persons' ~~ $_) {
	    $self->status_ok($c, entity => [ map { $_->to_hashref } @{stash 'persons'} ]);
	}

	when ($_->{status} ~~ OK) {
	    $self->status_ok($c, entity => []);
	}

	default {
	    report info => 'bad news';
	    $c->response->status((400 .. 500)[int rand 19]);
	    $c->stash(rest => { oops => "Error #@{[ int rand 100_000 ]}, status=@{[ $_->{status} // '?' ]}" });
	}
    }
};




__PACKAGE__->meta->make_immutable;

1;
