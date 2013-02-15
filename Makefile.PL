#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install 1.02;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'Lelf-Phonebook';
all_from 'lib/Lelf/Phonebook.pm';
#perl_version '5.012004';

requires 'Catalyst::Runtime' => '5.90019';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Moose';
requires 'namespace::autoclean';
requires 'Config::General'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats
requires 'Modern::Perl';
requires 'CatalystX::Controller::Sugar';
requires 'Catalyst::Controller::REST';
requires 'Syntax::Feature::CatalystAction';
requires 'Syntax::Feature::Method';
requires 'MooseX::NonMoose';
requires 'MooseX::MarkAsMethods';
requires 'DBIx::Class::MooseColumns';
requires 'DBIx::Class::InflateColumn::Serializer';
requires 'Catalyst::Model::DBIC::Schema';
test_requires 'Test::More' => '0.88';
test_requires 'Furl';
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
