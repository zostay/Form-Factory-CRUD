package Form::Factory::CRUD::Action::Role::Transactional;
use Moose::Role;

use Carp;

requires qw( txn_do );

=head1 NAME

Form::Factory::CRUD::Action::Role::Transactional - provides transaction methods

=head1 DESCRIPTION

Used by storage roles to declare whether or not they implement C<txn_do> methods.

=head1 METHODS

=head2 consume_and_clean_and_check_and_process

Around this method, we automatically wrap a transaction. The user may base the C<no_transaction> argument set to a true value to avoid the use of a transaction.

=cut

around consume_and_clean_and_check_and_process => sub {
    my $next = shift;
    my ($self, %options) = @_;

    if ($options{no_transaction}) {
        $self->$next(@_);
    }
    else {
        eval {
            $self->txn_do(sub {
                $self->$next(@_);
                die "TRANSACTIONAL_RESULT_IS_FAILURE_ROLLBACK" 
                    if $self->is_faliure;
            });
        };

        # Don't pass on this failure, but pass on anything else
        my $ERROR = $@;
        unless ($ERROR =~ /\bTRANSACTIONAL_RESULT_IS_FAILURE_ROLLBACK\b/) {
            croak $ERROR;
        }
    }
};

=head1 AUTHOR

Andrew Sterling Hanenkamp, C<< <hanenkamp@cpan.org> >>

=head1 LICENSE

This library is free software and may be distributed under the same terms as Perl itself.

=cut

1;
