package Form::Factory::CRUD::Action::Role::Store::KiokuDB;
use Moose::Role;

use Carp;
use Scalar::Util qw( blessed );

with qw(
    Form::Factory::CRUD::Action::Role::Transactional
);

=head1 NAME

Form::Factory::CRUD::Action::Role::Store::KiokuDB - load/store/query KiokuDB

=head1 SYNOPSIS

  package MyApp::Schema::Action::Person::Create;
  use Form::Factory::Processor;

  with qw(
      Form::Factory::CRUD::Action::Role::Store::KiokuDB
      ...
  );

=head1 DESCRIPTION

This gives your actions the ability to easily store to and from a KiokuDB database.

=head1 ATTRIBUTES

=head2 dir

This is the L<KiokuDB> directory object that will be used to load and store records. This must be set during action class construction.

=cut

has dir => (
    is        => 'ro',
    isa       => 'KiokuDB|KiokuX::Model',
    required  => 1,
);

=head2 record_class

This is the name of the L<Moose> object class that will be instantiated for storage. If it is unset, objects will be stored as hashes.

=cut

has record_class => (
    is        => 'ro',
    isa       => 'ClassName',
    predicate => 'has_record_class',
);

=head2 record

This is the object or hash ref that the action is operating upon. This will always be a hash if L</record_class> is not set. This will be a hash or an object if L</record_class> is set (depending on whether we are building on a blank or building upon an existing object from the store.

=cut

has record => (
    is        => 'rw',
    isa       => 'Object|HashRef',
    predicate => 'has_record',
);

=head1 METHODS

=head2 get_record_field

Given the name of an attribute, this return the value of that attribute on the L</record>.

=cut

sub _check_record_attr {
    my ($self, $verb, $name) = @_;

    croak "cannot $verb $name: no record has been loaded"
        if not $self->has_record;

    my $object = $self->record;
    my $sub;

    if (blessed $object and $self->has_record_class) {
        my $attr = $object->meta->find_attribute_by_name($name);
        if ($attr) {
            if ($verb eq 'get') {
                $sub = sub { scalar $attr->get_value($_[0]) };
            }
            else {
                $sub = sub { $attr->set_value($_[0], $_[1]) };
            }
        }
        else {
            croak $self->record_class, " has no attribute named $name";
        }
    }
    else {
        $sub = sub { scalar defined $object->{$name} ? $object->{$name} : undef };
    }

    return ($object, $sub);
}

sub get_record_field {
    my ($self, $name) = @_;
    my ($object, $getter) = $self->_check_record_attr(get => $name);
    return $getter->($object);
}

=head2 set_record_field

Given the name of a attribute and the value that attribute should take, this sets the value of that attribute on the L</record>.

=cut

sub set_record_field {
    my ($self, $name, $value) = @_;
    my ($object, $setter) = $self->_check_record_attr(set => $name);
    return $setter->($object, $value);
}

=head2 blank

This method set the L</record> to a new, empty hash.

=cut

sub blank {
    my $self = shift;
    $self->record({});
}

=head2 create

This method does the work required to create a new database record from the information stored in an action.

=cut

sub _instantiate_record {
    my ($self, $verb) = shift;

    croak "cannot $verb record: no record has been loaded"
        if not $self->has_record;

    my $object = $self->record;
    if ($self->has_record_class) {
        $object = $self->record_class->new($object);
    }

    return $object;
}

sub create {
    my $self = shift;
    my $object = $self->_instantiate_record('insert');
    $self->dir->store($object);
}

=head2 find

Given a hash of column names and values, this will load the matching object from the database, if a match can be found.

Currently, this requires that a L<Search::GIN> index be configured. Only the first record found will be returned.

A future revision may also support simple queries or alternatives.

=cut

sub find {
    my ($self, $query) = @_;

    my $gin_query = Search::GIN::Query::Manual->new(
        values => $query,
    );

    my $stream = $self->dir->search($gin_query);
    my $block = $stream->next;
    if ($block and @$block) {
        $self->record($block->[0]);
    }
    else {
        $self->failure(
            sprintf('cannot find the %s you are looking for',
                $self->record_class)
        );
    }
}

=head2 remove

This method does the work required to remove the current database record.

=cut

sub remove {
    my $self = shift;

    croak "no record has been loaded" 
        unless $self->has_record and blessed $self->record;

    $self->dir->delete($self->record);
}

=head2 store

This method does the work required to create or update a new database record from the information stored in an action.

=cut

sub store {
    my $self = shift;
    my $object = $self->_instantiate_record('store');
    $self->dir->store($object);
}

=head2 update

This method does the work required to update an existing database record from the information stored in an action.

=cut

sub update {
    my $self = shift;
    my $object = $self->_instantiate_record('update');
    $self->dir->update($object);
}

=head2 txn_do

=head2 txn_begin

=head2 txn_commit

=head2 txn_rollback

These are all delegated to L</dir>.

=cut

# Do it this stupid way because Moose doesn't count "handles" (or didn't the 
# last time I tried it).
sub txn_do       { shift->txn_do(@_) }
sub txn_begin    { shift->txn_begin(@_) }
sub txn_commit   { shift->txn_commit(@_) }
sub txn_rollback { shift->txn_rollback(@_) }

=head1 SEE ALSO

L<KiokuDB>

=head1 AUTHOR

Andrew Sterling Hanenkamp, C<< <hanenkamp@cpan.org> >>

=head1 LICENSE

This library is free software and may be distributed under the same terms as Perl itself.

=cut

1;
