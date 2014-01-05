use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  PREREQ_PM => {'Mojolicious' => '4.11'},
  PREREQ_PM => {'DBI' => '1.63'},
  PREREQ_PM => {'DBD::mysql' => '1.63'},

);
