package Lelf::Phonebook::Model::Phonebook;

use Modern::Perl;
use base 'Catalyst::Model::DBIC::Schema';

use Moose;
use namespace::autoclean;
use MooseX::NonMoose;


__PACKAGE__->config(
    schema_class => 'Lelf::Phonebook::Schema::Phonebook',
    
    connect_info => {
        dsn => 'dbi:SQLite:phonebook.db',
        user => '',
        password => '',
	sqlite_unicode => 1
    }
);



sub ppl { $_[0]->resultset('Phonebook') }


sub valid_person {
  my ($self, $p) = @_;
  eval { $self->ppl->new($p) };
}

sub people_names {
    my ($self) = @_;
    $self->ppl->search({}, { columns => [qw{id name}] })->all;
}

sub find_person {
    my ($self, $id) = @_;
    eval { $self->ppl->find($id) };
}

sub create_person {
    my ($self, $p) = @_;
    delete $p->{id};
    eval { $self->ppl->create($p) };
}

sub update_person {
    my ($self, $p) = @_;
    eval { $self->ppl->find($p->{id})->update($p) };
}

sub delete_person {
  my ($self, $id) = @_;
  eval { $self->ppl->find($id)->delete };
}



1;
