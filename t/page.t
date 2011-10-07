use strict;
use warnings;

use Test::More;

use_ok ('LaTeX::Beamer::Info::Page');

my $page = LaTeX::Beamer::Info::Page->new(number => 1);
isa_ok( $page, 'LaTeX::Beamer::Info::Page' );

done_testing;

