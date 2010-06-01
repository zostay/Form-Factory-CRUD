package Form::Factory::CRUD::Action::Role::Do::Create;
use Moose::Role;

requires qw( set_record_field create );

=head1 NAME

Form::Factory::CRUD::Action::Role::Do::Create - create a record from an action

=head1 SYNOPSIS

  package MyApp::Schema::Action::Person::Create;
  use Form::Factory::Processor;

  with qw(
      Form::Factory::CRUD::Action::Role::Do::Create
      ...
  );

=head1 DESCRIPTION

Upon running, this consumes the available C<CRUD::Field> values and causes a new object to be created in the store.

=head1 METHODS

=head2 do

Finds the values of all the C<CRUD::Field> controls and asks the store to set values for those fields. It then asks the store to create a record from that information.

=cut

sub do {
    my $self = shift;
    $self->set_column_fields;
    $self->create;
}

=head1 AUTHOR

Andrew Sterling Hanenkamp, C<< <hanenkamp@cpan.org> >>

=head1 LICENSE

This library is free software and may be distributed under the same terms as Perl itself.

=cut

1;
