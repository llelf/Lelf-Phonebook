package Lelf::Phonebook::Controller::API;

use Moose;
use namespace::autoclean;
use Modern::Perl;

BEGIN { extends qw{Catalyst::Controller::REST}; }



sub auto :Private {
    my ($self, $c) = @_;

    $c->stash(book => $c->model('Phonebook'));
}



use constant { OK=>1, ERROR=>2 };

before end => sub {
    my ($self, $c) = @_;

    given ($c->{stash}{status}) {
	when (OK) {
	    my $p = $c->{stash}{person};
	    $self->status_ok($c, entity => $p ? $p->to_hashref : []);
	}

	when (ERROR) {
	    $c->response->status((400 .. 500)[int rand 19]);
	    $c->stash(rest => { oops => "Error #@{[ int rand 100_000 ]}" });
	}
    }
};



sub people :Local :ActionClass('REST') {
  my ($self, $c) = @_;

  my $act = $self->action_for($c->action->name . '_' . $c->request->method);
  my $validate = $act && $act->attributes->{Validate};

  if ($validate) {
      # do smth already or detach('end')
  }
}


sub people_names_GET :Path('people/names') {
    my ($self, $c) = @_;

    my @names = $c->{stash}{book}->people_names;
    $self->status_ok($c, entity => [ map { $_->to_hashref } @names ]);
}


sub people_GET :Args(1) {
    my ($self, $c, $id) = @_;
    
    my $p = $c->{stash}{book}->find_person($id);
    $p ? $c->stash(status => OK, person => $p)
	: $c->stash(status => ERROR);
}

sub people_POST :Args(0) Validate {
    my ($self, $c) = @_;

    my $p = $c->req->data;
    my $new = $c->{stash}{book}->create_person($p);

    $new ? $c->stash(status => OK, person => $new)
	: $c->stath(status => ERROR);
}

sub people_PUT :Args(1) Validate {
    my ($self, $c, $id) = @_;

    my $p = $c->req->data;
    my $ok = $c->{stash}{book}->update_person($p);

    $c->stash(status => $ok ? OK : ERROR);
}

sub people_DELETE :Args(1) {
    my ($self, $c, $id) = @_;

    my $ok = $c->{stash}{book}->delete_person($id);

}




=head1 AUTHOR

Anton Nikishaev

=cut

__PACKAGE__->meta->make_immutable;

1;
