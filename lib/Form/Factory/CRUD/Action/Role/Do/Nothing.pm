package Form::Factory::CRUD::Action::Role::Do::Nothing;
use Moose::Role;

=head1 NAME

Form::Factory::CRUD::Action::Role::Do::Nothing - no-op

=head1 DESCRIPTION

This can be used to perform no action on run. This may be useful if you want to use an action to lookup a record without doing anything to it.

=head1 METHODS

=head2 do

Does nothing.

=cut

sub do { }

=head1 AUTHOR

Andrew Sterling Hanenkamp, C<< <hanenkamp@cpan.org> >>

=head1 LICENSE

This library is free software and may be distributed under the same terms as Perl itself.

=cut

1;
