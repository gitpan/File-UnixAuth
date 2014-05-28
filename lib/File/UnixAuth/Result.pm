package File::UnixAuth::Result;

use namespace::sweep;

use Moo;
use File::DataClass::Constants;
use File::DataClass::Functions qw( is_member );

extends q(File::DataClass::Result);

after 'update' => sub {
   my $self = shift; my $hook = $self->_source->schema->post_update_hook;

   $hook and $hook->( $self );

   return;
};

sub add_user_to_group {
   my ($self, $user) = @_; my $users = $self->members;

   is_member $user, $users and return FALSE;

   $self->members( [ @{ $users }, $user ] );

   return $self->update;
}

sub remove_user_from_group {
   my ($self, $user) = @_; my $users = $self->members;

   is_member $user, $users or return FALSE;

   $self->members( [ grep { $_ ne $user } @{ $users } ] );

   return $self->update;
}

1;

__END__

=pod

=head1 Name

File::UnixAuth::Result - Unix authentication and authorisation file custom results

=head1 Synopsis

   use File::UnixAuth::Result;

=head1 Description

=head1 Configuration and Environment

=head1 Subroutines/Methods

=head2 C<update>

Modifies the C<update> method call. Calls the post update hook if defined

=head2 add_user_to_group

Adds a user to a group

=head2 remove_user_from_group

Removes a user from a group

=head1 Diagnostics

None

=head1 Dependencies

=over 3

=item L<File::DataClass::Result>

=back

=head1 Incompatibilities

There are no known incompatibilities in this module

=head1 Bugs and Limitations

There are no known bugs in this module.
Please report problems to the address below.
Patches are welcome

=head1 Author

Peter Flanigan, C<< <Support at RoxSoft.co.uk> >>

=head1 License and Copyright

Copyright (c) 2014 Peter Flanigan. All rights reserved

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. See L<perlartistic>

This program is distributed in the hope that it will be useful,
but WITHOUT WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE

=cut

# Local Variables:
# mode: perl
# tab-width: 3
# End:
