use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  PREREQ_PM => {'Mojolicious' => '4.11'},
  PRERWQ_PM => {'DBI' => '1.63'},
);
