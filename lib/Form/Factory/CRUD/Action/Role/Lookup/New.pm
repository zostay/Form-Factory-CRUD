package Form::Factory::CRUD::Action::Role::Lookup::New;
use Moose::Role;

with qw( Form::Factory::CRUD::Action::Role::Lookup );

requires qw( blank );

=head1 NAME

Form::Factory::CRUD::Action::Role::Lookup - work with a new, blank record object

=head1 SYNOPSIS

  package MyApp::Schema::Action::Person::Create;
  use Form::Factory::Processor;

  with qw(
      Form::Factory::CRUD::Action::Role::Lookup::New
      ...
  );

=head1 DESCRIPTION

For actions that need to start from a blank slate, generally in order to create a new record.

=head2 can_find

This always return true.

=cut

sub can_find { 1 }

=head2 find

This calls the C<blank> method to blank out the current record object.

=cut

sub find {
    my $self = shift;
    $self->blank;
}

=head1 AUTHOR

Andrew Sterling Hanenkamp, C<< <hanenkamp@cpan.org> >>

=head1 LICENSE

This library is free software and may be distributed under the same terms as Perl itself.

=cut

1;
