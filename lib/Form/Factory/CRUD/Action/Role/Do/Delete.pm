package Form::Factory::CRUD::Action::Role::Do::Delete;
use Moose::Role;

with qw( Form::Factory::CRUD::Action::Role::Do );

requires qw( remove );

=head1 NAME

Form::Factory::CRUD::Action::Role::Do::Delete - delete the record

=head1 SYNOPSIS

  package MyApp::Schema::Action::Person::Delete;
  use Form::Factory::Processor;

  with qw(
      Form::Factory::CRUD::Action::Role::Do::Delete
      ...
  );

=head1 DESCRIPTION

Upon running, this deletes the record currently associated with the action. This implies that you want to lookup a record first.

=head1 METHODS

=head2 do

This deletes the record currently associated with this action object.

=cut

sub do {
    my $self = shift;
    $self->remove;
}

=head1 AUTHOR

Andrew Sterling Hanenkamp, C<< <hanenkamp@cpan.org> >>

=head1 LICENSE

This library is free software and may be distributed under the same terms as Perl itself.

=cut

1;
