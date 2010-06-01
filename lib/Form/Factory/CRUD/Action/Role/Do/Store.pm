package Form::Factory::CRUD::Action::Role::Do::Store;
use Moose::Role;

with qw( Form::Factory::CRUD::Action::Role::Do );

requires qw( set_record_field store );

=head1 NAME

Form::Factory::CRUD::Action::Role::Do::Store - store a record from an action

=head1 SYNOPSIS

  package MyApp::Schema::Action::Person::Store;
  use Form::Factory::Processor;

  with qw(
      Form::Factory::CRUD::Action::Role::Do::Store
      ...
  );

=head1 DESCRIPTION

Upon running, this consumes the available C<CRUD::Field> values and causes a new object to be created or an existing object to be updated in the store.

=head1 METHODS

=head2 do

Finds the values of all the C<CRUD::Field> controls and asks teh store to set values for those fields. It then asks the store to store a record from that information. This allows a record to be created, if it is a new object, or an existing object to be updated.

=cut

sub do {
    my $self = shift;
    $self->set_column_fields;
    $self->store;
}

=head1 AUTHOR

Andrew Sterling Hanenkamp, C<< <hanenkamp@cpan.org> >>

=head1 LICENSE

This library is free software and may be distributed under the same terms as Perl itself.

=cut

1;
