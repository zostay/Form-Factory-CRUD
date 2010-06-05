package Form::Factory::CRUD::Action::Role::Store::DBIC;
use Moose::Role;

use Carp;

with qw(
    Form::Factory::CRUD::Action::Role::Transactional
);

=head1 NAME

Form::Factory::CRUD::Action::Role::Store::DBIC - load/store/query DBIC records

=head1 SYNOPSIS

  package MyApp::Schema::Action::Person::Create;
  use Form::Factory::Processor;

  with qw(
      Form::Factory::CRUD::Action::Role::Store::DBIC
      ...
  );

=head1 DESCRIPTION

This gives your actions the ability to easily store to and from a DBIC database.

=head1 ATTRIBUTES

=head2 schema

This is the L<DBIx::Class::Schema> that will be used to load and store records. This must be set during action class construction.

=cut

has schema => (
    is        => 'ro',
    isa       => 'DBIx::Class::Schema',
    required  => 1,
);

=head2 result_name

This is name of the L<DBIx::Class> result set that may be used to lookup the L<DBIx::Class::ResultSource> via the C<source> method of the L</schema> attribute. This must be set during action class construction or as part of the action class construction.

=cut

has result_name => (
    is        => 'ro',
    isa       => 'Str',
    required  => 1,
);

=head2 result_source

This is a lazily-loaded attribute that contains the L<DBIx::Class::ResultSource>. It is loaded using the L</result_name> and L</schema> attributes.

=cut

has result_source => (
    is        => 'ro',
    isa       => 'DBIx::Class::ResultSource',
    required  => 1,
    lazy      => 1,
    default   => sub { $_[0]->schema->source($_[0]->result_name) },
);

=head2 record

This is the L<DBIx::Class::Row> that is linked to this action. This is not set until L</find> or L</blank> is called. This attribute provides the C<has_record> predicate.

=cut

has record => (
    is        => 'rw',
    isa       => 'DBIx::Class::Row',
    predicate => 'has_record',
);

=head1 METHODS

=head2 need_find

This is a synonym for:

  !$action->has_record

This is the standard method used by L<Form::Factory::CRUD::Action::Role::Do> to determine if we need to run find.

=cut

sub need_find { not shift->has_record };


=head2 get_record_field

Given the name of a column, this returns the value of that column on the L</record>.

=cut

sub _check_record_column {
    my ($self, $verb, $name) = @_;

    croak "cannot $verb $name: no record has been loaded"
        if not $self->has_record;

    my $object        = $self->record;
    my $result_source = $self->result_source;

    if ($result_source->has_column($name)) {
        return $object;
    }
    else {
        my $result_name = $self->result_name;
        croak "$result_name has no column named $name";
    }
}

sub get_record_field {
    my ($self, $name) = @_;
    my $object = $self->_check_record_column(get => $name);
    return $object->$name;
}

=head2 set_record_field

Given the name of a column and the value that column should take, this sets the value of that column on the L</record>.

=cut

sub set_record_field {
    my ($self, $name, $value) = @_;
    my $object = $self->_check_record_column(set => $name);
    $object->$name($value);
}

=head2 blank

This method sets the L</record> to a new, empty record object.

=cut

sub blank {
    my $self = shift;
    $self->record($self->result_source->resultset->new_result({}));
}

=head2 create

This method does the work required to create a new database record from the information stored in an action.

=cut

sub create {
    my $self = shift;

    croak "cannot insert record: no record has been loaded"
        if not $self->has_record;

    $self->record->insert;
}

=head2 find

Given a hash of column names and values, this will load the matching object from the database, if a match can be found.

=cut

sub find {
    my ($self, $query) = @_;

    my $record = $self->result_source->resultset->find($query);
    if ($record) {
        $self->record($record);
    }
    else {
        $self->failure(
            sprintf('cannot find the %s you are looking for',
                $self->result_source->source_name)
        );
    }
}

=head2 remove

This method does the work required to remove the current database record.

=cut

sub remove {
    my $self = shift;

    croak "no record has been loaded" unless $self->has_record;

    $self->record->delete;
}

=head2 store

This method does the work required to create or update a new database record from the information stored in an action.

=cut

sub store {
    my $self = shift;

    croak "cannot store record: no record has been loaded"
        if not $self->has_record;

    $self->record->update_or_insert;
}

=head2 update

This method does the work required to update an existing database record from the information stored in an action.

=cut

sub update {
    my $self = shift;

    croak "cannot update record: no record has been loaded"
        if not $self->has_record;

    $self->record->update;
}

=head2 txn_do

This is all delegated to L</schema>.

=cut

# Do it this stupid way because Moose doesn't count "handles" (or didn't the 
# last time I tried it).
sub txn_do { shift->schema->txn_do(@_) }

=head1 SEE ALSO

L<DBIx::Class>

=head1 AUTHOR

Andrew Sterling Hanenkamp, C<< <hanenkamp@cpan.org> >>

=head1 LICENSE

This library is free software and may be distributed under the same terms as Perl itself.

=cut

1;
