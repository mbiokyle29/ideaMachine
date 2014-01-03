use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'ideaMachine',
  VERSION      => '1.0',
  AUTHOR       => 'Kyle Mc <kgmcchesney@gmail.com>',
  EXE_FILES    => ['ideaMachine'],
  PREREQ_PM    => {'Mojolicious' => '2.0'},
);
