package Form::Factory::CRUD::Action::Role::Do::Update;
use Moose::Role;

requires qw( set_record_field update );

=head1 NAME

Form::Factory::CRUD::Action::Role::Do::Update - update a record from an action

=head1 SYNOPSIS

  package MyApp::Schema::Action::Person::Update;
  use Form::Factory::Processor;

  with qw(
      Form::Factory::CRUD::Action::Role::Do::Update
      ...
  );

=head1 DESCRIPTION

Upon running, this consumes the available C<CRUD::Field> values and causes an exiting object to be updated in the store.

=head1 METHODS

=head2 do

Finds the values of all the C<CRUD::Field> controls and asks the store to set values for those fields. It then asks the store to update an existing record from that information.

=cut

sub do {
    my $self = shift;
    $self->set_column_fields;
    $self->update;
}

=head1 AUTHOR

Andrew Sterling Hanenkamp, C<< <hanenkamp@cpan.org> >>

=head1 LICENSE

This library is free software and may be distributed under the same terms as Perl itself.

=cut

1;
