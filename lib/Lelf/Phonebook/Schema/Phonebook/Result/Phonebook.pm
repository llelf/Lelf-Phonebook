use utf8;
package Lelf::Phonebook::Schema::Phonebook::Result::Phonebook;

use Modern::Perl;
use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

use DBIx::Class::MooseColumns;

__PACKAGE__->table('phonebook');


has id => (isa => 'Int', is => 'rw', add_column => { is_auto_increment => 1 });

__PACKAGE__->set_primary_key('id');


has name => (
    isa => 'Str',
    is => 'rw',
    add_column => { data_type => 'text' }
);

has phones => (
    isa => 'ArrayRef[Str]',
    is => 'rw',
    add_column => { data_type => 'text' }
);



sub to_hashref {
  my ($self) = @_;

  say 'REF ', join '|', $self->get_inflated_columns;

  my $r = {id => $self->id, name => $self->name };
  $r->{phones} = $self->phones if defined $self->phones;

  return $r;
}




__PACKAGE__->meta->make_immutable;

1;
