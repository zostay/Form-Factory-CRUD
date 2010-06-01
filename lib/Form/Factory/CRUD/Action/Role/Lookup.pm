package Form::Factory::CRUD::Action::Role::Lookup;
use Form::Factory::Processor::Role;

use Scalar::Util qw( blessed );

use Form::Factory::CRUD::Feature::AutomaticLookup;

use_feature 'automatic_lookup';

requires qw( can_find find get_record_field );

=head1 NAME

Form::Factory::CRUD::Action::Role::Lookup - lookup roles for CRUD actions

=head1 DESCRIPTION

This class is not used directly.

=head1 METHODS

=head2 prefill_from_record

This is a helper method that may be used before rendering.

  my $interface = Form::Factory->new_interface('HTML');
  my $action = $interface->new_action('MyApp::Schema::Action::Person::Update', {
      record => $object,
  });

  $action->prefill_from_form;
  $action->setup_and_render;

In this example, the action would be prefilled from the given record object. You could also pass some other parameters and call C<find> to ask the lookup role to load the record from storage.

=cut

sub prefill_from_record {
    my $self = shift;

    for my $attr ($self->meta->get_all_attributes) {
        next unless $attr->does('Form::Factory::CRUD::Action::Meta::Attribute::Field');

        my $field_name = $attr->field_name;
        my $value = $self->get_record_field;

        if (defined $value) {
            $attr->set_value($self, $value);
        }
        else {
            $attr->clear_value($self, $value);
        }
    }
}

=head1 SEE ALSO

L<Form::Factory::CRUD::Action::Role::Lookup::Find>, L<Form::Factory::CRUD::Action::Role::Lookup::New>

=head1 AUTHOR

Andrew Sterling Hanenkamp, C<< <hanenkamp@cpan.org> >>

=head1 LICENSE

This library is free software and may be distributed under the same terms as Perl itself.

=cut

1;
