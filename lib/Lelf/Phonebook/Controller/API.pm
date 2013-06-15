package Lelf::Phonebook::Controller::API;

use utf8;
use encoding 'utf-8';
use Moose;
use namespace::autoclean;
use Modern::Perl;

use syntax qw{method};
no if $] >= 5.018, warnings => 'experimental::smartmatch';

BEGIN { extends 'Catalyst::Controller::REST' };


use constant { OK=>1, ERROR=>2, ERROR_INVALID_INPUT=>3 };


after begin => sub {
    my ($self, $ctx) = @_;
    $ctx->stash(book => $ctx->model('Phonebook'));
};


method people ($ctx, $id) :Args(1) :Local {
    $ctx->stash(id => $id);

    my $action;

    given ($ctx->req->{method}) {
	when (/GET/ && $id ~~ '*') { $action = 'people_get_all' }
	when (/GET/) { $action = 'get_person' }
	when (/POST/) { $action = 'create_person' }
	when (/PUT/) { $action = 'update_person' }
	when (/DELETE/) { $action = 'delete_person' }
    }

    my $fun = $ctx->controller->action_for($action);
#    report debug => 'action=%s', $fun && $fun->name;
#    report debug => "data=%s", $ctx->req->{data};

    $ctx->forward('validate', $fun->attributes->{ID})
    	or $ctx->stash(status => ERROR_INVALID_INPUT) and $ctx->go('end')
    	if $fun->attributes->{Validate};

    $ctx->go($fun) if $fun;
}


method validate ($ctx, $id_known) :Action {
    # ...
    return unless ref($ctx->req->{data}) eq 'HASH';
    $ctx->stash(validated => 1);
};


method people_get_all ($ctx) :Action {
    $ctx->stash(persons => [ $ctx->stash->{book}->all_people_sorted ]);
}

method get_person ($ctx) :Action :ID {
    $ctx->stash(person => $ctx->stash->{book}->find_person($ctx->stash->{id}));
}

method update_person ($ctx) :Action :Validate :ID {
    $ctx->stash(person => $ctx->stash->{book}->update_person($ctx->req->{data}));
}

method create_person ($ctx) :Action :Validate {
    $ctx->stash(person => $ctx->stash->{book}->create_person($ctx->req->{data}));
}

method delete_person ($ctx) :Action :ID {
    $ctx->stash(status => $ctx->stash->{book}->delete_person($ctx->stash->{id}) ? OK : ERROR);
}


before end => sub {
    my ($self, $ctx) = @_;

    given ($ctx->{stash}) {
	when (not $_->{person} ~~ undef) {
#	    say 'person=', defined stash->{person};
	    $self->status_ok($ctx, entity => $ctx->stash->{person}->to_hashref);
	}

	when ($_->{persons} ~~ undef) {
	    $self->status_ok($ctx, entity => [ map { $_->to_hashref } @{$ctx->stash->{persons}} ]);
	}

	when ($_->{status} ~~ OK) {
	    $self->status_ok($ctx, entity => []);
	}

	default {
#	    report info => 'bad news';
	    $ctx->response->status((400 .. 500)[int rand 19]);
	    $ctx->stash(rest => {
		oops => "Error #@{[ int rand 100_000 ]}, status=@{[ $_->{status} // '?' ]}"
		      });
	}
    }
};




__PACKAGE__->meta->make_immutable;

1;
