package Form::Factory::CRUD::Feature::AutomaticLookup;
use Moose;

with qw( 
    Form::Factory::Feature 
    Form::Factory::Feature::Role::Clean
    Form::Factory::Feature::Role::PostProcess
);

=head1 NAME

Form::Factory::CRUD::Feature::AutomaticLookup - a feature to help with lookups

=head1 DESCRIPTION

Generally, you do not need to use this directly. When your action makes use of a L<Form::Factory::CRUD::Action::Role::Lookup> role, your action will be given this feature. The only reason to use this feature explicitly is if you need to set the attributes to something other than the default.

  use_feature automatic_lookup => {
      use_transaction => 0, # we don't need no stinking transactions!
  };

This feature allows the lookup role to try and lookup the information needed as early as possible. With this feature in place, the C<find> method of the lookup class will be called during the C<clean> phase of action processing. 

If the action is able to do so, it will also acquire a transaction before this to try to avoid a race condition. By "able to do so", we mean that action implements the L<Form::Factory::CRUD::Action::Role::Transactional>.

=head1 ATTRIBUTES

=head2 use_transaction

This is a boolean that is true by default. This determines whether the lookup will attempt to grab a transaction as early as possible.

This attribute is meaningless if the action does not implement L<Form::Factory::CRUD::Action::Role::Transactional>.

=cut

has use_transaction => (
    is        => 'ro',
    isa       => 'Bool',
    required  => 1,
    default   => 1,
);

has _in_transaction => (
    is        => 'rw',
    isa       => 'Bool',
    required  => 1,
    default   => 0,
);

has _does_transactions => (
    is        => 'ro',
    isa       => 'Bool',
    required  => 1,
    lazy      => 1,
    default   => sub {
        my $self = shift;
        return $self->action->does('Form::Factory::CRUD::Action::Role::Transactional')
           and $self->use_transaction;
    },
);

=head1 METHODS

=cut

sub _begin_transaction {
    my $self = shift;

    if ($self->_does_transactions and not $self->_in_transaction) {
        $self->action->txn_begin;
        $self->_in_transaction(1);
    }
}

sub _commit_transaction {
    my $self = shift;

    if ($self->_in_transaction) {
        $self->action->txn_commit;
        $self->_in_transaction(0);
    }
}

sub _rollback_transaction {
    my $self = shift;

    if ($self->_in_transaction) {
        $self->action->txn_rollback;
        $self->_in_transaction(0);
    }
}

=head2 clean

A transaction is initated if possible and requested and the lookup role is used
to find a record, if we can.

=cut

sub clean {
    my $self = shift;
    my $action = $self->action;
    $self->_begin_transaction;

    $action->find if $action->can_find;
};

=head2 post_process

The transaction opened previously is closed. If the action succeeded, the
transaction is committed. On failure, the transaction is rolled back.

=cut

sub post_process {
    my $self = shift;

    if ($self->action->is_success) {
        $self->_commit_transaction;
    }

    else {
        $self->_rollback_transaction;
    }
}

=head1 AUTHOR

Andrew Sterling Hanenkamp, C<< <hanenkamp@cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2010 Qubling Software LLC.

This library is free software and may be distributed under the same terms as Perl itself.

=cut

package Form::Factory::Feature::Custom::AutomaticLookup;
sub register_implementation { 'Form::Factory::CRUD::Feature::AutomaticLookup' }

1;
