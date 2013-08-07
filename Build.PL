# @(#)$Ident: Build.PL 2013-08-07 00:36 pjf ;

use strict;
use warnings;
use inc::Bob; # Module::Build subclass
use version; our $VERSION = qv( sprintf '0.18.%d', q$Rev: 2 $ =~ /\d+/gmx );

Bob->new( {
   module    => 'File::UnixAuth',
   home_page => 'http://www.roxsoft.co.uk',
   requires  => {
      'perl'                  => 5.010001,
      'namespace::sweep'      => 0.006,
      'Class::Method::ModifiersX::Augment' => 0.001,
      'File::DataClass'       => q(0.22.0),
      'Lingua::EN::NameParse' => 1.28,
      'Moo'                   => 1.002, },
   recommends            => {
      'App::cpanminus'   => 1.6005, },
   configure_requires    => {
      'version'          => 0.88,
      'Module::Build'    => 0.4004, },
   build_requires        => {
      'version'          => 0.88,
      'Module::Build'    => 0.4004, },
} )->create_build_script; # Goal!

# Local Variables:
# mode: perl
# eval: (load-project-state "file-unixauth")
# tab-title: File::UnixAuth
# tab-width: 3
# End:
