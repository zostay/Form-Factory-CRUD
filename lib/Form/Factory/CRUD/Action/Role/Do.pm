package Form::Factory::CRUD::Action::Role::Do;
use Moose::Role;

use Form::Factory::CRUD::Action::Meta::Attribute::Field;

requires qw( find do txn_do );

=head1 NAME

Form::Factory::CRUD::Action::Role::Do - all CRUD actions must do something

=head1 DESCRIPTION

This class is not used directly.

=head1 METHODS

=head2 run

This provides a run method that causes the action to run within a transaction. The method first calls the C<find> method (provided by a L<Form::Factory::CRUD::Action::Role::Lookup> role or by the class itself) and then calls the C<do> method (provided by a L<Form::Factory::CRUD::Action::Role::Do> role).

=cut

sub run {
    my $self = shift;

    $self->txn_do(sub {
        $self->find;
        $self->do unless $self->is_failure;
    });
}

=head2 set_column_fields

This is a helper method used by some Do-roles to call C<set_record_field> for each of the C<CRUD::Field> values set on the action.

=cut

sub set_column_fields {
    my $self = shift;

    for my $attr ($self->meta->get_all_attributes) {
        if ($attr->does('Form::Factory::CRUD::Action::Meta::Attribute::Field')) {
            my $new_value = $attr->get_value($self);

            my $field_name = $attr->field_name;
            $self->set_record_field($field_name, $new_value);
        }
    }
}

=head1 SEE ALSO

L<Form::Factory::CRUD::Action::Role::Do::Create>, L<Form::Factory::CRUD::Action::Role::Do::Delete>, L<Form::Factory::CRUD::Action::Role::Do::Nothing>, L<Form::Factory::CRUD::Action::Role::Do::Store>, L<Form::Factory::CRUD::Action::Role::Do::Update>

=head1 AUTHOR

Andrew Sterling Hanenkamp, C<< <hanenkamp@cpan.org> >>

=head1 LICENSE

This library is free software and may be distributed under the same terms as Perl itself.

=cut

1;
