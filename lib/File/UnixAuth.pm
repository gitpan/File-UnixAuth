# @(#)$Ident: UnixAuth.pm 2013-04-14 16:04 pjf ;

package File::UnixAuth;

use strict;
use namespace::autoclean;
use version; our $VERSION = qv( sprintf '0.16.%d', q$Rev: 3 $ =~ /\d+/gmx );

use File::DataClass::Constants;
use File::UnixAuth::Result;
use Moose;

extends qw(File::DataClass::Schema);

has '+result_source_attributes' =>
   default                => sub { return {
      group               => {
         attributes       => [ qw(password gid members) ],
         defaults         => { password => q(x) },
         resultset_attributes => {
            result_class  => q(File::UnixAuth::Result), }, },
      passwd              => {
         attributes       => [ qw(password id pgid gecos homedir shell
                                  first_name last_name location work_phone
                                  home_phone) ],
         defaults         => { password => q(x) }, },
      shadow              => {
         attributes       => [ qw(password pwlast pwnext pwafter
                                  pwwarn pwexpires pwdisable reserved) ],
         defaults         => { password => q(*), pwlast    => 0,
                               pwnext   => 0,    pwafter   => 99_999,
                               pwwarn   => 7,    pwexpires => 90,
                               reserved => NUL }, }, } };
has '+storage_attributes' =>
   default                => sub { return { backup => q(.bak), } };
has '+storage_class'      =>
   default                => q(+File::UnixAuth::Storage);
has 'source_name'         => is => 'ro', isa => 'Str', required => TRUE;

around 'source' => sub {
   my ($orig, $self) = @_; return $self->$orig( $self->source_name );
};

around 'resultset' => sub {
   my ($orig, $self) = @_; return $self->$orig( $self->source_name );
};

1;

__END__

=pod

=head1 Name

File::UnixAuth - Result source definitions for the Unix authentication files

=head1 Version

0.16.$Revision: 3 $

=head1 Synopsis

   use File::UnixAuth;

   my $unixauth_ref = File::UnixAuth->new( $unixauth_attributes );

=head1 Description

Extends L<File::DataClass::Schema>. Provides for the reading and
writing of the the Unix F</etc/group>, F</etc/passwd>, and
F</etc/shadow> files.

=head1 Configuration and Environment

Defines these attributes:

=over 3

=item C<source_name>

A required string. Selects the required result source. Set to one of;
C<group>, C<passwd>, or C<shadow>

=back

=head1 Subroutines/Methods

None

=head1 Diagnostics

None

=head1 Dependencies

=over 3

=item L<File::DataClass::Schema>

=item L<File::UnixAuth::Result>

=item L<Moose>

=back

=head1 Incompatibilities

There are no known incompatibilities in this module

=head1 Bugs and Limitations

There are no known bugs in this module.
Please report problems to the address below.
Patches are welcome

=head1 Author

Peter Flanigan, C<< <pjfl@cpan.org> >>

=head1 License and Copyright

Copyright (c) 2013 Peter Flanigan. All rights reserved

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
