package Form::Factory::CRUD;
use Moose;
__PACKAGE__->meta->make_immutable;

=head1 NAME

Form::Factory::CRUD - Adding basic CRUD support to Form::Factory

=head1 SYNOPSIS

For a DBIC class like:

  package MyApp::Schema::Result::Person;
  use strict;
  use warnings;
  use base qw( DBIx::Class::Core );

  __PACKAGE__->table('peeps');
  __PACKAGE__->add_columns(qw( id name favorite_color ))
  __PACKAGE__->set_primary_key('id');

Here's the action class to create new Person objects:

  package MyApp::Schema::Action::Person::Create;
  use Form::Factory::Processor;

  with qw(
      Form::Factory::CRUD::Action::Role::Lookup::New
      Form::Factory::CRUD::Action::Role::Do::Store
      Form::Factory::CRUD::Action::Role::Store::DBIC
  );

  has '+result_name' => ( default => 'Person' );

  has_control name => (
      is        => 'rw',

      control   => 'text',
      traits    => [ 'CRUD::Field' ],

      features  => {
          fill_on_assignment => 1,
          trim               => 1,
          required           => 1,
      },
  );

  has_control favorite_color => (
      is        => 'rw',
      
      control   => 'select_one',
      traits    => [ 'CRUD::Field' ],

      options   => {
          available_choices => [ qw(
              red yellow blue green
          ) ],
      },

      features  => {
          fill_on_assignment => 1,
      },
  );

=head1 DESCRIPTION

This provides the tools for building CRUD (Create-Read-Update-Delete) actions with L<Form::Factory>. You will also need a storage component in order to complete the functionality of a class.

=head1 AUTHOR

Andrew Sterling Hanenkamp, C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2010 Qubling Software LLC.

This library is free software and may be distributed under the same terms as Perl itself.

=cut

1;
