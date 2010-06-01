package Form::Factory::CRUD::Action::Role::Lookup::Find;
use Moose::Role;

with qw( Form::Factory::CRUD::Action::Role::Lookup );

requires qw( find );

=head1 NAME

Form::Factory::CRUD::Action::Role::Lookup::Find - locate records by a key

=head1 SYNOPSIS

  package MyApp::Schema::Action::Person::Save;
  use Form::Factory::Processor;

  with qw(
      Form::Factory::CRUD::Action::Role::Lookup::Find
      ...
  );

  has_control id => (
      is        => 'ro',
      isa       => 'Int',

      control   => 'value',
      traits    => [ 'CRUD::Field' ],

      options   => {
          value => 0,
      },

      features  => {
          fill_on_assignment => { slot => 'value' },
      },
  );

  ...

=head1 DESCRIPTION

This role will query storage for a record using one or more named fields. This allows for a lookup on a primary key or whatever analog exists in the storage used. This may be enhanced in the future to allow for multiple indexes or to use indexes based upon the storage.

=head1 ATTRIBUTES

=head2 index_field_names

This is the name of the index field or an array of index field names. It defaults to "id".

=cut

has index_field_names => (
    is        => 'ro',
    isa       => 'Str|ArrayRef[Str]',
    required  => 1,
    default   => 'id',
);

=head1 METHODS

=head2 can_find

Returns a true value if we have values in all the fields indicated by L</index_field_names>.

=cut

sub can_find {
    my $self = shift;
    my $has_all_primary_key_values = 1;

    my $names = $self->index_field_names;
       $names = [ $names ] unless ref $names;

    my %field_names = map { $_ => 1 } @$names;

    ATTR: for my $attr ($self->meta->get_all_attributes) {
        next unless $attr->does('Form::Factory::CRUD::Action::Meta::Attribute::Field');
        next unless delete $field_names{ $attr->field_name };
        $self->controls->{ $attr->name }->set_attribute_value($self, $attr);
        $has_all_primary_key_values &&= $attr->has_value($self);
        last ATTR unless $has_all_primary_key_values;
    }

    # We can find if all field names have attributes and if all those
    # attributes have values
    return (!keys %field_names && $has_all_primary_key_values);
}

=head2 find

Perform a record lookup. This will find a record matching the fields listed in L</index_field_names> from the store and load it as the current record.

=cut

sub find {
    my $self = shift;

    my %lookup_values;
    my $names = $self->index_field_names;
       $names = [ $names ] unless ref $names;

    my %field_names = map { $_ => 1 } @$names;

    for my $attr ($self->meta->get_all_attributes) {
        next unless $attr->does('Form::Factory::Action::Meta::Attribute::Field');
        next unless delete $field_names{ $attr->field_name };

        $lookup_values{ $attr->field_name } = $attr->get_value($self);
    }

    if (keys %field_names) {
        my $message = sprintf('unable to lookup a record because process %s does not have a value for field(s) %s', 
            ref $self, 
            join(', ', keys %field_names)
        );
        die $message;
    }

    $self->find(\%lookup_values);
}

=head1 AUTHOR

Andrew Sterling Hanenkamp, C<< <hanenkamp@cpan.org> >>

=head1 LICENSE

This library is free software and may be distributed under the same terms as Perl itself.

=cut

1;
