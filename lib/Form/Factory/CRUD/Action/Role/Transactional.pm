package Form::Factory::CRUD::Action::Role::Transactional;
use Moose::Role;

requires qw( txn_do txn_begin txn_commit txn_rollback );

=head1 NAME

Form::Factory::CRUD::Action::Role::Transactional - provides transaction methods

=head1 DESCRIPTION

Used by storage roles to declare whether or not they implement C<txn_do>, C<txn_begin>, C<txn_commit>, and C<txn_rollback> methods.

=head1 AUTHOR

Andrew Sterling Hanenkamp, C<< <hanenkamp@cpan.org> >>

=head1 LICENSE

This library is free software and may be distributed under the same terms as Perl itself.

=cut

1;
