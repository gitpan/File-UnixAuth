# @(#)$Ident: 10test_script.t 2013-08-15 18:33 pjf ;

use strict;
use warnings;
use version; our $VERSION = qv( sprintf '0.19.%d', q$Rev: 1 $ =~ /\d+/gmx );
use File::Spec::Functions   qw( catdir catfile updir );
use FindBin                 qw( $Bin );
use lib                 catdir( $Bin, updir, 'lib' );

use Module::Build;
use Test::More;

my $notes = {};

BEGIN {
   my $builder = eval { Module::Build->current };
      $builder and $notes = $builder->notes;
}

use English qw( -no_match_vars );
use File::DataClass::IO;
use Text::Diff;

use_ok 'File::UnixAuth';

my $args   = { path        => catfile( qw( t shadow ) ),
               source_name => 'shadow',
               tempdir     => 't' };
my $schema = File::UnixAuth->new( $args );

isa_ok $schema, 'File::UnixAuth';

my $dumped = catfile( qw( t dumped.shadow ) ); io( $dumped )->unlink;
my $data   = $schema->load;

$schema->dump( { data => $data, path => $dumped } );

my $diff = diff catfile( qw( t shadow ) ), $dumped;

ok !$diff, 'Shadow - load and dump roundtrips'; io( $dumped )->unlink;

$schema->dump( { data => $schema->load, path => $dumped } );

$diff = diff catfile( qw(t shadow) ), $dumped;

ok !$diff, 'Shadow - load and dump roundtrips 2'; io( $dumped )->unlink;

$args   = { path               => catfile( qw( t passwd ) ),
            source_name        => 'passwd',
            storage_attributes => { encoding => 'UTF-8', },
            tempdir            => 't' };
$schema = File::UnixAuth->new( $args );
$dumped = catfile( qw( t dumped.passwd ) ); io( $dumped )->unlink;
$data   = $schema->load;

$schema->dump( { data => $data, path => $dumped } );

$diff   = diff catfile( qw( t passwd ) ), $dumped;

ok !$diff, 'Passwd - load and dump roundtrips'; io( $dumped )->unlink;

$schema->dump( { data => $schema->load, path => $dumped } );

$diff = diff catfile( qw( t passwd ) ), $dumped;

ok !$diff, 'Passwd - load and dump roundtrips 2'; io( $dumped )->unlink;

done_testing;

# Cleanup
io( catfile( qw( t ipc_srlock.lck ) ) )->unlink;
io( catfile( qw( t ipc_srlock.shm ) ) )->unlink;
io( catfile( qw( t file-dataclass-schema.dat ) ) )->unlink;

# Local Variables:
# mode: perl
# tab-width: 3
# End:
