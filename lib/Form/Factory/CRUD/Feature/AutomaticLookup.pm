package Form::Factory::CRUD::Feature::AutomaticLookup;
use Moose;

with qw( 
    Form::Factory::Feature 
    Form::Factory::Feature::Role::Clean
);

=head1 NAME

Form::Factory::CRUD::Feature::AutomaticLookup - a feature to help with lookups

=head1 DESCRIPTION

Generally, you do not need to use this directly. When your action makes use of a L<Form::Factory::CRUD::Action::Role::Lookup> role, your action will be given this feature.

This feature allows the lookup role to try and lookup the information needed as early as possible. With this feature in place, the C<find> method of the lookup class will be called during the C<clean> phase of action processing. 

=head1 METHODS

=head2 clean

The lookup role is used to find a record, if we can.

=cut

sub clean {
    my $self = shift;
    my $action = $self->action;

    $action->find if $action->need_find and $action->can_find;
};

=head1 AUTHOR

Andrew Sterling Hanenkamp, C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2010 Qubling Software LLC.

This library is free software and may be distributed under the same terms as Perl itself.

=cut

package Form::Factory::Feature::Custom::AutomaticLookup;
sub register_implementation { 'Form::Factory::CRUD::Feature::AutomaticLookup' }

1;
