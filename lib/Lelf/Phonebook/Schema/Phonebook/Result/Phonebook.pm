use utf8;
package Lelf::Phonebook::Schema::Phonebook::Result::Phonebook;

use Modern::Perl;
use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
use DBIx::Class::MooseColumns;

extends 'DBIx::Class::Core';


__PACKAGE__->table('people');
__PACKAGE__->load_components('InflateColumn::Serializer', 'Core');

has id => (isa => 'Int',
	   is => 'rw',
	   add_column => { data_type => 'int', unique => 1, is_auto_increment => 1 });

__PACKAGE__->set_primary_key('id');


has name => (isa => 'Str',
	     is => 'rw',
	     required => 1,
	     add_column => { data_type => 'text' });

has phones => (isa => 'ArrayRef[HashRef[Str]]',
	       is => 'rw',
	       required => 1,
	       add_column => { data_type => 'text', serializer_class => 'JSON' });


sub to_hashref { +{ $_[0]->get_inflated_columns } }



__PACKAGE__->meta->make_immutable;

1;
