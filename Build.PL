use strict;
use warnings;

use Module::Build 0.4004;

sub whimper { print {*STDOUT} $_[ 0 ]."\n"; exit 0 }

my $perl_ver = 5.010001;
my $name     = 'File-UnixAuth'; $name =~ s{ - }{::}gmx;
my $prereqs  = {
  'build_requires' => {
    'Module::Build' => '0.4004',
    'version' => '0.88'
  },
  'configure_requires' => {
    'Module::Build' => '0.4004',
    'version' => '0.88'
  },
  'requires' => {
    'Class::Method::ModifiersX::Augment' => '0.001',
    'File::DataClass' => 'v0.40.0',
    'Lingua::EN::NameParse' => '1.28',
    'Moo' => '1.004002',
    'namespace::sweep' => '0.006',
    'perl' => '5.010001'
  },
};

if ($] < $perl_ver) {
   $ENV{AUTOMATED_TESTING}
      or $ENV{PERL_CPAN_REPORTER_CONFIG}
      or $ENV{PERL5_CPANPLUS_IS_VERSION}
      or whimper "Minimum required Perl version is ${perl_ver}";
   $prereqs->{build_requires} = { %{ $prereqs->{configure_requires} } };
   $prereqs->{build_requires}->{ 'Test::Requires' } = 0.06;
   delete $prereqs->{requires};
}

Module::Build->new(
  'module_name' => $name,
  'notes'       => { min_perl_version => $perl_ver },
  %{ $prereqs },

)->create_build_script;

exit 0;
