package Form::Factory::CRUD::Action::Meta::Attribute::Field;
use Moose::Role;

=head1 NAME

Form::Factory::CRUD::Action::Meta::Attribute::Field - the CRUD::Field attribute trait

=head1 SYNOPSIS

  has_control foo => (
      is         => 'rw',
      traits     => [ 'CRUD::Field' ],
      field_name => 'bar',
  );

=head1 DESCRIPTION

This flags a field as one that should be stored.

=head1 ATTRIBUTES

=head2 field_name

This defaults to the name of the attribute. It may be set to something else, if needed. This is the name of the field the control is mapped into in storage.

For example, if you wanted a control named "message_content" to be mapped to a database column named "content", you might type:

  has_control message_content => (
      is         => 'rw',
      
      control    => 'full_text',
      traits     => [ 'CRUD::Field' ],
      field_name => 'content',

      options    => {
          label => 'Content',
      },

      features   => {
          required => 1,
          trim     => 1,
      },
  );

=cut

has field_name => (
    is        => 'ro',
    isa       => 'Str',
    required  => 1,
    lazy      => 1,
    default   => sub { shift->name },
);

=head1 AUTHOR

Andrew Sterling Hanenkamp, C<< <hanenkamp@cpan.org> >>

=head1 LICENSE

This library is free software and may be distributed under the same terms as Perl itself.

=cut

package Moose::Meta::Attribute::Custom::Trait::CRUD::Field;
sub register_implementation { 'Form::Factory::CRUD::Action::Meta::Attribute::Field' }

1;
