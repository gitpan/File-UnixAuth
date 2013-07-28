# @(#)$Ident: 10test_script.t 2013-04-11 15:52 pjf ;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.17.%d', q$Rev: 1 $ =~ /\d+/gmx );
use File::Spec::Functions;
use FindBin qw( $Bin );
use lib catdir( $Bin, updir, q(lib) );

use English qw(-no_match_vars);
use Module::Build;
use Test::More;

my $reason;

BEGIN {
   my $builder = eval { Module::Build->current };

   $builder and $reason = $builder->notes->{stop_tests};
   $reason  and $reason =~ m{ \A TESTS: }mx and plan skip_all => $reason;
}

use File::DataClass::IO;
use Text::Diff;

use_ok( q(File::UnixAuth ) );

my $args   = { path        => catfile( qw(t shadow) ),
               source_name => q(shadow),
               tempdir     => q(t) };
my $schema = File::UnixAuth->new( $args );

isa_ok $schema, q(File::UnixAuth);

my $dumped = catfile( qw(t dumped.shadow) ); io( $dumped )->unlink;
my $data   = $schema->load;

$schema->dump( { data => $data, path => $dumped } );

my $diff = diff catfile( qw(t shadow) ), $dumped;

ok !$diff, 'Shadow - load and dump roundtrips'; io( $dumped )->unlink;

$schema->dump( { data => $schema->load, path => $dumped } );

$diff = diff catfile( qw(t shadow) ), $dumped;

ok !$diff, 'Shadow - load and dump roundtrips 2'; io( $dumped )->unlink;

$args   = { path               => catfile( qw(t passwd) ),
            source_name        => q(passwd),
            storage_attributes => { encoding => q(UTF-8), },
            tempdir            => q(t) };
$schema = File::UnixAuth->new( $args );
$dumped = catfile( qw(t dumped.passwd) ); io( $dumped )->unlink;
$data   = $schema->load;

$schema->dump( { data => $data, path => $dumped } );

$diff   = diff catfile( qw(t passwd) ), $dumped;

ok !$diff, 'Passwd - load and dump roundtrips'; io( $dumped )->unlink;

$schema->dump( { data => $schema->load, path => $dumped } );

$diff = diff catfile( qw(t passwd) ), $dumped;

ok !$diff, 'Passwd - load and dump roundtrips 2'; io( $dumped )->unlink;

done_testing;

# Cleanup

io( catfile( qw(t ipc_srlock.lck) ) )->unlink;
io( catfile( qw(t ipc_srlock.shm) ) )->unlink;
io( catfile( qw(t file-dataclass-schema.dat) ) )->unlink;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
