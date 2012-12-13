use strict;
use warnings;

use File::chdir;
use Try::Tiny;

use Test::More 'no_plan';

#use_ok('LaTeX::Beamer::Info');
ok(1,"check");

local $CWD;
push @CWD, qw/t docs/;

my $latex_error = 0;
try {
  system('pdflatex test.tex');
} catch {
  $latex_error = 1;
};

$latex_error = 1 unless (-e 'test.nav');

SKIP: {
  skip "Could not run LaTeX compiler" if $latex_error;

}

cleanup($CWD, 'test.tex') unless $latex_error;

sub cleanup {
  my ($dir, $tex_file) = @_;
  (my $tex_stem = $tex_file) =~ s/tex$//;
  opendir(my $dh, $dir);
  
  my @files = 
    grep {/$tex_stem/}
    grep {$_ ne $tex_file} 
    grep {! -d} 
    readdir($dh);

  unlink @files;
}

