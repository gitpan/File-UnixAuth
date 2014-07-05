package File::UnixAuth;

use 5.010001;
use namespace::autoclean;
use version; our $VERSION = qv( sprintf '0.22.%d', q$Rev: 1 $ =~ /\d+/gmx );

use Moo;
use File::DataClass::Constants;
use File::DataClass::Types  qw( CodeRef Maybe Str );
use File::UnixAuth::Result;

extends q(File::DataClass::Schema);

has 'post_update_hook'    => is => 'ro', isa => Maybe[CodeRef];

has '+result_source_attributes' =>
   default                => sub { {
      group               => {
         attributes       => [ qw( password gid members ) ],
         defaults         => { password => 'x' },
         resultset_attributes => {
            result_class  => 'File::UnixAuth::Result', }, },
      passwd              => {
         attributes       => [ qw( password id pgid gecos homedir shell
                                   first_name last_name location work_phone
                                   home_phone ) ],
         defaults         => { password => 'x' }, },
      shadow              => {
         attributes       => [ qw( password pwlast pwnext pwafter
                                   pwwarn pwexpires pwdisable reserved ) ],
         defaults         => { password => '*',  pwlast    => 0,
                               pwnext   => 0,    pwafter   => 99_999,
                               pwwarn   => 7,    pwexpires => 90,
                               reserved => NUL }, }, } };

has '+storage_attributes' => default => sub { { backup => '.bak', } };

has '+storage_class'      => default => '+File::UnixAuth::Storage';

has 'source_name'         => is => 'ro', isa => Str, required => TRUE;

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

File::UnixAuth - Read and write the Unix authentication files

=head1 Version

Describes version v0.22.$Rev: 1 $ of L<File::UnixAuth>

=head1 Synopsis

   use File::UnixAuth;

   my $unixauth_ref = File::UnixAuth->new( $unixauth_attributes );

=head1 Description

Extends L<File::DataClass::Schema>. Provides for the reading and
writing of the the Unix F</etc/group>, F</etc/passwd>, and
F</etc/shadow> files.

Since these files share a common format they all use the the same
storage class L<File::UnixAuth::Storage>. Defines three result
sources; C<group>, C<passwd>, and C<shadow>

=head1 Configuration and Environment

Defines these attributes;

=over 3

=item C<post_update_hook>

A code reference that is called after an update completes. Defaults to
C<undef>. If set to:

   sub { qx( 'grpconv' ) }

then the file F</etc/gshadow> will be updated

=item C<result_source_attributes>

Defines the result sources and their attributes

=item C<source_name>

A required string. Selects the required result source. Set to one of;
C<group>, C<passwd>, or C<shadow>

=item C<storage_attributes>

Change the defaults to create a backup file with a F<.bak> extension

=back

Modifies these methods;

=over 3

=item C<resultset>

=item C<source>

=back

=head1 Subroutines/Methods

None

=head1 Diagnostics

None

=head1 Dependencies

=over 3

=item L<File::DataClass::Schema>

=item L<File::UnixAuth::Result>

=item L<Moo>

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
